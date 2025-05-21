package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Order;

public class DashboardDAO {
	private static final String URL = "jdbc:mysql://localhost:3306/idoughnutcare?useSSL=false&serverTimezone=Asia/Kathmandu&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    // Method to get a database connection
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC Driver not found.", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Method to get the total number of orders
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM `order`";
        return getCount(sql);
    }

    // Method to get the total number of users
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        return getCount(sql);
    }

    // Method to get the total number of products
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM product";
        return getCount(sql);
    }

    // Method to get the total sales amount
    public double getTotalSales() {
        String sql = "SELECT SUM(total_amount) FROM `order`";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] Failed to fetch total sales.");
            e.printStackTrace();
        }
        return 0.0;
    }

    // Helper method to count records for a given query
    private int getCount(String sql) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] Failed to fetch count.");
            e.printStackTrace();
        }
        return 0;
    }

    // Method to get the most recent orders
    public List<Order> getRecentOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, u.email, p.product_name, op.quantity, o.order_date, " +
                     "(op.price * op.quantity) AS total_amount " +
                     "FROM `order` o " +
                     "JOIN users u ON o.user_id = u.id " + // Fixed user_id relation
                     "JOIN order_product op ON o.order_id = op.order_id " +
                     "JOIN product p ON op.product_id = p.product_id " +
                     "ORDER BY o.order_date DESC LIMIT 5"; // Limits to 5 recent orders

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setEmail(rs.getString("email"));
                order.setProductName(rs.getString("product_name"));
                order.setQuantity(rs.getInt("quantity"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                orders.add(order);
            }

        } catch (SQLException e) {
            System.err.println("[ERROR] Failed to fetch recent orders.");
            e.printStackTrace();
        }

        System.out.println("Fetched recent orders count: " + orders.size()); // Debugging line
        return orders;
    }
}
