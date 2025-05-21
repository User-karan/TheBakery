package dao;

import models.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserProductDAO {
	private static final String URL = "jdbc:mysql://localhost:3306/idoughnutcare?useSSL=false&serverTimezone=Asia/Kathmandu&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    
    public Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("JDBC Driver not found.", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    private static final String SELECT_ALL_PRODUCTS = "SELECT * FROM product";
    private static final String SELECT_PRODUCT_BY_ID = "SELECT * FROM product WHERE product_id = ?";
    private static final String SEARCH_PRODUCTS = "SELECT * FROM product WHERE product_name LIKE ? OR product_description LIKE ? OR category LIKE ?";
    private static final String INSERT_PRODUCT = 
        "INSERT INTO product (product_name, product_description, price, category, stock_quantity, product_image) " +
        "VALUES (?, ?, ?, ?, ?, ?)";

    // Load MySQL JDBC driver
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("[ERROR] MySQL JDBC driver not found.");
            e.printStackTrace();
        }
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_PRODUCTS);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                products.add(extractProductFromResultSet(rs));
            }

            System.out.println("[DEBUG] Fetched " + products.size() + " products.");

        } catch (SQLException e) {
            System.err.println("[ERROR] SQL exception occurred while fetching products.");
            e.printStackTrace();
        }

        return products;
    }

    /**
     * Search for products by name, description, or category
     * @param query The search term
     * @return List of matching products
     */
    public List<Product> searchProducts(String query) {
        List<Product> products = new ArrayList<>();

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SEARCH_PRODUCTS)) {

            String searchParam = "%" + query + "%";
            stmt.setString(1, searchParam);
            stmt.setString(2, searchParam);
            stmt.setString(3, searchParam);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(extractProductFromResultSet(rs));
                }
            }

            System.out.println("[DEBUG] Found " + products.size() + " products for search: " + query);

        } catch (SQLException e) {
            System.err.println("[ERROR] SQL exception occurred while searching products.");
            e.printStackTrace();
        }

        return products;
    }

    public Product getProductById(int id) {
        Product product = null;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_PRODUCT_BY_ID)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    product = extractProductFromResultSet(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("[ERROR] Failed to fetch product by ID.");
            e.printStackTrace();
        }

        return product;
    }

    public boolean addProduct(Product product) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_PRODUCT)) {

            stmt.setString(1, product.getProductName());
            stmt.setString(2, product.getProductDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setString(4, product.getCategory());
            stmt.setInt(5, product.getStockQuantity());
            stmt.setString(6, product.getProductImage());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            System.err.println("[ERROR] Failed to add product.");
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteProduct(int id) {
        String query = "DELETE FROM product WHERE product_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateProduct(Product product) {
        String sql = "UPDATE product SET product_name = ?, product_description = ?, price = ?, " +
                     "category = ?, stock_quantity = ?, product_image = ? WHERE product_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, product.getProductName());
            stmt.setString(2, product.getProductDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setString(4, product.getCategory());
            stmt.setInt(5, product.getStockQuantity());
            stmt.setString(6, product.getProductImage());
            stmt.setInt(7, product.getProductId());

            int rowsUpdated = stmt.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            System.err.println("[ERROR] Failed to update product.");
            e.printStackTrace();
            return false;
        }
    }

    // Helper method to extract a product from ResultSet
    private Product extractProductFromResultSet(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setProductId(rs.getInt("product_id"));
        product.setProductName(rs.getString("product_name"));
        product.setProductDescription(rs.getString("product_description"));
        product.setPrice(rs.getDouble("price"));
        product.setEntryDate(rs.getTimestamp("entry_date"));
        product.setCategory(rs.getString("category"));
        product.setStockQuantity(rs.getInt("stock_quantity"));
        product.setProductImage(rs.getString("product_image"));
        return product;
    }
}