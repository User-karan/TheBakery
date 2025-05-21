package dao;

import models.Order;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OrderDAO {
	private static final String URL = "jdbc:mysql://localhost:3306/idoughnutcare?useSSL=false&serverTimezone=Asia/Kathmandu&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    // Initialize JDBC driver
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Failed to load JDBC driver", e);
        }
    }

    // Get database connection
    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Get all orders with product and user details
    public List<Order> getAllOrders() throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, u.email, p.product_name, " +
                     "op.quantity, o.order_date, o.total_amount " +
                     "FROM `order` o " +
                     "JOIN order_product op ON o.order_id = op.order_id " +
                     "JOIN product p ON op.product_id = p.product_id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.order_date DESC";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                orders.add(mapOrderFromResultSet(rs));
            }
        }
        return orders;
    }

    // Get orders filtered by date range
    public List<Order> getOrdersByDateRange(Date startDate, Date endDate) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, u.email, p.product_name, " +
                     "op.quantity, o.order_date, o.total_amount " +
                     "FROM `order` o " +
                     "JOIN order_product op ON o.order_id = op.order_id " +
                     "JOIN product p ON op.product_id = p.product_id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.order_date BETWEEN ? AND ? " +
                     "ORDER BY o.order_date DESC";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTimestamp(1, new Timestamp(startDate.getTime()));
            stmt.setTimestamp(2, new Timestamp(endDate.getTime()));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrderFromResultSet(rs));
                }
            }
        }
        return orders;
    }

    // Get recent orders with limit
    public List<Order> getRecentOrders(int limit) throws SQLException {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, u.email, p.product_name, " +
                     "op.quantity, o.order_date, o.total_amount " +
                     "FROM `order` o " +
                     "JOIN order_product op ON o.order_id = op.order_id " +
                     "JOIN product p ON op.product_id = p.product_id " +
                     "JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.order_date DESC LIMIT ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    orders.add(mapOrderFromResultSet(rs));
                }
            }
        }
        return orders;
    }

    // Create a new order with transaction support
    public int createOrder(int userId, List<OrderItem> items) throws SQLException {
        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            // 1. Create order header
            int orderId = insertOrderHeader(conn, userId, items);
            
            // 2. Add order items
            insertOrderItems(conn, orderId, items);
            
            // 3. Update product stock quantities
            updateProductStockQuantities(conn, items);
            
            conn.commit();
            return orderId;
        } catch (SQLException e) {
            if (conn != null) conn.rollback();
            throw new SQLException("Failed to create order: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }

    // Helper method to insert order header
    private int insertOrderHeader(Connection conn, int userId, List<OrderItem> items) throws SQLException {
        String sql = "INSERT INTO `order` (user_id, total_amount, order_date) VALUES (?, ?, NOW())";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, userId);
            stmt.setDouble(2, calculateTotalAmount(items));
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
                throw new SQLException("Creating order failed, no ID obtained");
            }
        }
    }

    // Helper method to insert order items
    private void insertOrderItems(Connection conn, int orderId, List<OrderItem> items) throws SQLException {
        String sql = "INSERT INTO order_product (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (OrderItem item : items) {
                stmt.setInt(1, orderId);
                stmt.setInt(2, item.getProductId());
                stmt.setInt(3, item.getQuantity());
                stmt.setDouble(4, item.getPrice());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }
    
    // Helper method to update product stock quantities
    private void updateProductStockQuantities(Connection conn, List<OrderItem> items) throws SQLException {
        String sql = "UPDATE product SET stock_quantity = stock_quantity - ? WHERE product_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (OrderItem item : items) {
                stmt.setInt(1, item.getQuantity());
                stmt.setInt(2, item.getProductId());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    // Map ResultSet to Order object
    private Order mapOrderFromResultSet(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setEmail(rs.getString("email"));
        order.setProductName(rs.getString("product_name"));
        order.setQuantity(rs.getInt("quantity"));
        order.setOrderDate(new Date(rs.getTimestamp("order_date").getTime()));
        order.setTotalAmount(rs.getDouble("total_amount"));
        return order;
    }

    // Calculate total order amount
    private double calculateTotalAmount(List<OrderItem> items) {
        return items.stream()
                   .mapToDouble(item -> item.getPrice() * item.getQuantity())
                   .sum();
    }

    // OrderItem inner class
    public static class OrderItem {
        private final int productId;
        private final int quantity;
        private final double price;

        public OrderItem(int productId, int quantity, double price) {
            this.productId = productId;
            this.quantity = quantity;
            this.price = price;
        }

        public int getProductId() { return productId; }
        public int getQuantity() { return quantity; }
        public double getPrice() { return price; }
    }
}