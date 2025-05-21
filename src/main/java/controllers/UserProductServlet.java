package controllers;

import dao.UserProductDAO;
import models.Product;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * Servlet implementation class UserProductServlet
 * Handles product listing, searching, filtering, and viewing
 */
@WebServlet("/UserProductServlet")
public class UserProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserProductDAO productDAO;

    public UserProductServlet() {
        super();
        productDAO = new UserProductDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "view":
                viewProduct(request, response);
                break;
            case "search":
                searchProducts(request, response);
                break;
            case "filter":
                filterProducts(request, response);
                break;
            case "list":
            default:
                listProducts(request, response);
                break;
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Product> products = productDAO.getAllProducts();
            request.setAttribute("products", products);
            request.getRequestDispatcher("/pages/products.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("[ERROR] Error listing products: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving products");
        }
    }

    private void viewProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(productId);

            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/product-detail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
        } catch (Exception e) {
            System.err.println("[ERROR] Error viewing product: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving product details");
        }
    }

    private void searchProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String query = request.getParameter("query");
            List<Product> filteredProducts;

            if (query != null && !query.trim().isEmpty()) {
                filteredProducts = productDAO.searchProducts(query);
                request.setAttribute("searchQuery", query);
            } else {
                filteredProducts = productDAO.getAllProducts();
            }

            request.setAttribute("products", filteredProducts);
            request.getRequestDispatcher("/pages/products.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("[ERROR] Error searching products: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error searching products");
        }
    }

    private void filterProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String category = request.getParameter("category");
            List<Product> allProducts = productDAO.getAllProducts();
            List<Product> filteredProducts;

            if (category != null && !category.equalsIgnoreCase("all")) {
                filteredProducts = allProducts.stream()
                        .filter(p -> p.getCategory().equalsIgnoreCase(category))
                        .collect(Collectors.toList());

                request.setAttribute("selectedCategory", category);
            } else {
                filteredProducts = allProducts;
            }

            request.setAttribute("products", filteredProducts);
            request.getRequestDispatcher("/pages/products.jsp").forward(request, response);
        } catch (Exception e) {
            System.err.println("[ERROR] Error filtering products: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error filtering products");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "POST method not supported for this endpoint.");
    }
}
