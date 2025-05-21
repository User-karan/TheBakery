package controllers;

import dao.DashboardDAO;
import models.Order;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "DashboardServlet", value = "/dashboard/*")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DashboardDAO dao = new DashboardDAO();

        int totalOrders = dao.getTotalOrders();
        int totalUsers = dao.getTotalUsers();
        int totalProducts = dao.getTotalProducts();
        double totalSales = dao.getTotalSales();
        List<Order> recentOrders = dao.getRecentOrders();  // <-- Get recent orders

        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalSales", totalSales);
        request.setAttribute("recentOrders", recentOrders); // <-- Add to request

        RequestDispatcher dispatcher = request.getRequestDispatcher("/pages/admin/dashboard.jsp");
        dispatcher.forward(request, response);
    }
}
