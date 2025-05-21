package controllers;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.UserCartDAO;
import models.CartItem;

@WebServlet("/cart/*")
public class UserCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(UserCartServlet.class.getName());
    private final UserCartDAO cartDAO = new UserCartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("Debug: Cart doGet method called");
        HttpSession session = request.getSession(false);
        int userId = 0;
        if (session != null && session.getAttribute("userId") != null) {
            userId = (int) session.getAttribute("userId");
        }

        System.out.println("Debug: UserId from session: " + userId);
        
        try {
            List<CartItem> cartItems = cartDAO.getCartItems(userId);
            System.out.println("Debug: Retrieved " + cartItems.size() + " cart items");
            request.setAttribute("cartItems", cartItems);
            
            double total = cartItems.stream()
                .mapToDouble(CartItem::getTotalPrice)
                .sum();
            System.out.println("Debug: Cart total: " + total);
            request.setAttribute("cartTotal", total);
            
            request.getRequestDispatcher("/pages/customer/cart.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Debug: Error in doGet: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Error retrieving cart items", e);
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("Debug: Cart doPost method called");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            System.out.println("Debug: No valid session found in doPost");
            response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");
        System.out.println("Debug: Action: " + action + ", UserId: " + userId);

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            boolean success = false;
            String message = "";

            switch (action) {
                case "add":
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    System.out.println("Debug: Adding product " + productId + " with quantity " + quantity);
                    if (quantity <= 0) {
                        message = "Invalid quantity";
                        break;
                    }
                    success = cartDAO.addToCart(userId, productId, quantity);
                    message = success ? "Item added to cart" : "Failed to add item to cart";
                    break;

                case "remove":
                    System.out.println("Debug: Removing product " + productId);
                    success = cartDAO.removeFromCart(userId, productId);
                    message = success ? "Item removed from cart" : "Failed to remove item from cart";
                    break;

                case "update":
                    quantity = Integer.parseInt(request.getParameter("quantity"));
                    System.out.println("Debug: Updating product " + productId + " to quantity " + quantity);
                    if (quantity <= 0) {
                        message = "Invalid quantity";
                        break;
                    }
                    success = cartDAO.updateCartItemQuantity(userId, productId, quantity);
                    message = success ? "Cart updated" : "Failed to update cart";
                    break;

                default:
                    message = "Invalid action";
                    System.out.println("Debug: Invalid action received: " + action);
            }

            if (request.getHeader("X-Requested-With") != null) {
                // AJAX request
                response.setContentType("application/json");
                response.getWriter().write(String.format("{\"success\": %b, \"message\": \"%s\"}", 
                    success, message));
            } else {
                // Regular form submission
                if (success) {
                    response.sendRedirect(request.getContextPath() + "/cart");
                } else {
                    request.setAttribute("error", message);
                    request.getRequestDispatcher("/pages/customer/cart.jsp").forward(request, response);
                }
            }
        } catch (NumberFormatException e) {
            System.out.println("Debug: Number format error: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Invalid number format in request parameters", e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid number format");
        } catch (Exception e) {
            System.out.println("Debug: Error in doPost: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Error processing cart action", e);
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}