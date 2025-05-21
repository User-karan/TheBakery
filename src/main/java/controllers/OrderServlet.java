package controllers;

import dao.OrderDAO;
import dao.OrderDAO.OrderItem;
import models.Order;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/orders/*")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        try {
            if (path == null || path.equals("/")) {
                listOrders(request, response);
            } else if (path.equals("/filter")) {
                filterOrdersByDate(request, response);
            } else if (path.equals("/recent")) {
                listRecentOrders(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException("Error processing GET request", e);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        List<Order> orders = orderDAO.getAllOrders();
        request.setAttribute("orderList", orders);
        request.getRequestDispatcher("/pages/admin/orderList.jsp").forward(request, response);
    }

    private void filterOrdersByDate(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        String start = request.getParameter("startDate");
        String end = request.getParameter("endDate");

        if (start == null || end == null || start.isEmpty() || end.isEmpty()) {
            request.setAttribute("error", "Please provide both start and end dates.");
            listOrders(request, response); // fallback to all
            return;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date startDate = sdf.parse(start);
        Date endDate = sdf.parse(end);

        List<Order> orders = orderDAO.getOrdersByDateRange(startDate, endDate);
        request.setAttribute("orderList", orders);
        request.getRequestDispatcher("/pages/admin/orderList.jsp").forward(request, response);
    }

    private void listRecentOrders(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        int limit = 5; // default value
        String limitParam = request.getParameter("limit");
        if (limitParam != null) {
            try {
                limit = Integer.parseInt(limitParam);
            } catch (NumberFormatException ignored) {
            }
        }

        List<Order> orders = orderDAO.getRecentOrders(limit);
        request.setAttribute("orderList", orders);
        request.getRequestDispatcher("/pages/admin/recentOrders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();
        try {
            if (path != null && path.equals("/create")) {
                createOrder(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException("Error processing POST request", e);
        }
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");

        // Validate input
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String[] prices = request.getParameterValues("price");

        if (productIds == null || quantities == null || prices == null ||
                productIds.length != quantities.length || quantities.length != prices.length) {
            request.setAttribute("error", "Invalid order items");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }

        List<OrderItem> items = new ArrayList<>();
        try {
            for (int i = 0; i < productIds.length; i++) {
                int productId = Integer.parseInt(productIds[i]);
                int quantity = Integer.parseInt(quantities[i]);
                double price = Double.parseDouble(prices[i]);
                items.add(new OrderItem(productId, quantity, price));
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid product data format");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            return;
        }

        try {
            int orderId = orderDAO.createOrder(currentUser.getId(), items);
            response.sendRedirect(request.getContextPath() + "/orders/" + orderId + "?success=true");
        } catch (SQLException e) {
            request.setAttribute("error", "Failed to create order: " + e.getMessage());
            request.getRequestDispatcher("/pages/order/error.jsp").forward(request, response);
        }
    }
}