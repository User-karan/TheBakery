package controllers;

import dao.CategoryDAO;
import dao.ProductDAO;
import models.Category;
import models.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.util.List;

@WebServlet(name = "ProductServlet", value = "/product/*")
@MultipartConfig
public class ProductServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "list":
                listProducts(request, response);
                break;
            case "view":
                viewProduct(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            case "edit":
                editProductForm(request, response);
                break;
            case "add":
                showAddProductForm(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {
            addProduct(request, response);
        } else if ("delete".equalsIgnoreCase(action)) {
            deleteProduct(request, response);
        } else if ("update".equalsIgnoreCase(action)) {
            updateProduct(request, response);
        } else {
            doGet(request, response); // Default action if no match
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> products = productDAO.getAllProducts();
        request.setAttribute("products", products);
        request.getRequestDispatcher("/pages/admin/adminproduct.jsp").forward(request, response);
    }

    private void viewProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(id);

            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/pages/admin/product-details.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/product?action=list");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/product?action=list");
        }
    }

    private void addProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get product details from the form
            String productName = request.getParameter("productName");
            String productDescription = request.getParameter("productDescription");
            double price = Double.parseDouble(request.getParameter("price"));
            String category = request.getParameter("category");
            int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
            Timestamp entryDate = new Timestamp(System.currentTimeMillis()); // Default to current timestamp

            // Handle file upload
            Part filePart = request.getPart("productImage");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String relativePath = "photos/products"; // Directory to store the uploaded image
            String absoluteUploadPath = getServletContext().getRealPath("") + File.separator + relativePath;

            // Ensure the upload directory exists
            File uploadDir = new File(absoluteUploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs(); // Create the directory if it doesn't exist
            }

            // Construct file path for storing the image
            String filePath = relativePath + File.separator + fileName;
            filePart.write(absoluteUploadPath + File.separator + fileName); // Save the image to the directory

            // Create a Product object
            Product product = new Product();
            product.setProductName(productName);
            product.setProductDescription(productDescription);
            product.setPrice(price);
            product.setCategory(category);
            product.setStockQuantity(stockQuantity);
            product.setEntryDate(entryDate);
            product.setProductImage(filePath); // Store image path

            // Add the product to the database
            boolean added = productDAO.addProduct(product);

            if (added) {
                // Redirect with a success message
                response.sendRedirect(request.getContextPath() + "/product?action=list&success=Product+added+successfully");
            } else {
                // If product couldn't be added, set error message and forward to the admin page
                request.setAttribute("error", "Product could not be added.");
                request.getRequestDispatcher("/pages/admin/adminproduct.jsp").forward(request, response);
            }

        } catch (Exception e) {
            // Handle errors and forward with the error message
            e.printStackTrace();
            request.setAttribute("error", "Error adding product: " + e.getMessage());
            request.getRequestDispatcher("/pages/admin/adminproduct.jsp").forward(request, response);
        }
    }
    
    private void showAddProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Fetch all categories to populate the dropdown
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/pages/admin/add-product.jsp").forward(request, response);
    }
    
    private void editProductForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = productDAO.getProductById(id);

            if (product != null) {
                request.setAttribute("product", product);
                request.getRequestDispatcher("/pages/admin/edit-product.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/product?action=list&error=Product+not+found");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/product?action=list&error=Invalid+product+ID");
        }
    }
    
    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("productId"));
            Product existingProduct = productDAO.getProductById(id);

            if (existingProduct == null) {
                response.sendRedirect(request.getContextPath() + "/product?action=list&error=Product+not+found");
                return;
            }

            // Only update fields if they are not null or empty
            String name = request.getParameter("productName");
            if (name != null && !name.trim().isEmpty()) {
                existingProduct.setProductName(name);
            }

            String desc = request.getParameter("productDescription");
            if (desc != null && !desc.trim().isEmpty()) {
                existingProduct.setProductDescription(desc);
            }

            String priceStr = request.getParameter("price");
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                existingProduct.setPrice(Double.parseDouble(priceStr));
            }

            String category = request.getParameter("category");
            if (category != null && !category.trim().isEmpty()) {
                existingProduct.setCategory(category);
            }

            String stockStr = request.getParameter("stockQuantity");
            if (stockStr != null && !stockStr.trim().isEmpty()) {
                existingProduct.setStockQuantity(Integer.parseInt(stockStr));
            }

            // Handle image upload
            Part filePart = request.getPart("productImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String relativePath = "photos/products";
                String absolutePath = getServletContext().getRealPath("") + File.separator + relativePath;

                File dir = new File(absolutePath);
                if (!dir.exists()) dir.mkdirs();

                String imagePath = relativePath + File.separator + fileName;
                filePart.write(absolutePath + File.separator + fileName);
                existingProduct.setProductImage(imagePath);
            }

            // Update in DB
            boolean updated = productDAO.updateProduct(existingProduct);

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/product?action=list&success=Product+updated+successfully");
            } else {
                request.setAttribute("error", "Failed to update product.");
                request.setAttribute("product", existingProduct);
                request.getRequestDispatcher("/pages/admin/edit-product.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating product: " + e.getMessage());
            request.getRequestDispatcher("/pages/admin/edit-product.jsp").forward(request, response);
        }
    }

    
    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean deleted = productDAO.deleteProduct(id);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/product?action=list&success=Product+deleted+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/product?action=list&error=Failed+to+delete+product");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/product?action=list");
        }
    }
}