package controllers;

import dao.OrderDAO;
import dao.ProductDAO;
import models.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            // User is not logged in, redirect to login page
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?redirect=checkout");
            return;
        }

        // Get user ID from session
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            // User ID not found in session
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp?error=Please+login+again");
            return;
        }

        try {
            // Check if checkout is from cart or individual product
            String fromCart = request.getParameter("fromCart");
            List<OrderDAO.OrderItem> items = new ArrayList<>();

            if ("true".equals(fromCart)) {
                // Handle checkout from cart - loop through cart items
                List<Integer> cartProductIds = (List<Integer>) session.getAttribute("cartProductIds");
                List<Integer> cartQuantities = (List<Integer>) session.getAttribute("cartQuantities");

                if (cartProductIds != null && cartQuantities != null) {
                    for (int i = 0; i < cartProductIds.size(); i++) {
                        int productId = cartProductIds.get(i);
                        int quantity = cartQuantities.get(i);
                        Product product = productDAO.getProductById(productId);

                        if (product != null) {
                            items.add(new OrderDAO.OrderItem(productId, quantity, product.getPrice()));
                        } else {
                            request.setAttribute("errorMessage", "One or more products not found.");
                            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
                            return;
                        }
                    }
                }
            } else {
                // Handle checkout from single product (product page)
                String productIdStr = request.getParameter("productId");
                String quantityStr = request.getParameter("quantity");

                if (productIdStr != null && quantityStr != null) {
                    int productId = Integer.parseInt(productIdStr);
                    int quantity = Integer.parseInt(quantityStr);

                    Product product = productDAO.getProductById(productId);
                    if (product != null) {
                        items.add(new OrderDAO.OrderItem(productId, quantity, product.getPrice()));
                    } else {
                        response.sendRedirect(request.getContextPath() + "/UserProductServlet?error=Product+not+found");
                        return;
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/UserProductServlet?error=Invalid+parameters");
                    return;
                }
            }

            // Create the order
            int orderId = orderDAO.createOrder(userId, items);

            // Clear cart if checkout was from cart
            if ("true".equals(fromCart)) {
                session.removeAttribute("cartProductIds");
                session.removeAttribute("cartQuantities");
            }

            // Redirect to order confirmation page
            response.sendRedirect(request.getContextPath() + "/pages/order-confirmation.jsp?orderId=" + orderId);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/UserProductServlet?error=Invalid+parameters");
        } catch (SQLException e) {
            request.setAttribute("errorMessage", "Error creating order: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // For direct checkout from product page, we use GET method
        // This method would be used for checkout from cart or other forms
        doGet(request, response);
    }
}
