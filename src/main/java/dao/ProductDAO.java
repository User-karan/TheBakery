package dao;

import models.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
	private static final String URL = "jdbc:mysql://localhost:3306/idoughnutcare?useSSL=false&serverTimezone=Asia/Kathmandu&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    private static final String SELECT_ALL_PRODUCTS = "SELECT * FROM product ORDER BY entry_date DESC";
    private static final String SELECT_PRODUCT_BY_ID = "SELECT * FROM product WHERE product_id = ?";
    private static final String INSERT_PRODUCT = 
        "INSERT INTO product (product_name, product_description, price, category, stock_quantity, product_image) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_PRODUCT_WITH_IMAGE = 
        "UPDATE product SET product_name = ?, product_description = ?, price = ?, category = ?, stock_quantity = ?, product_image = ? WHERE product_id = ?";
    private static final String UPDATE_PRODUCT_NO_IMAGE = 
        "UPDATE product SET product_name = ?, product_description = ?, price = ?, category = ?, stock_quantity = ? WHERE product_id = ?";
    private static final String DELETE_PRODUCT = "DELETE FROM product WHERE product_id = ?";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("[ERROR] MySQL JDBC driver not found.");
            e.printStackTrace();
        }
    }

    private Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_PRODUCTS);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Product product = mapResultSetToProduct(rs);
                products.add(product);
            }

            System.out.println("[DEBUG] Fetched " + products.size() + " products.");
        } catch (SQLException e) {
            System.err.println("[ERROR] Fetching all products failed.");
            e.printStackTrace();
        }
        return products;
    }

    public Product getProductById(int id) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_PRODUCT_BY_ID)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToProduct(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] Fetching product by ID failed.");
            e.printStackTrace();
        }
        return null;
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

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Adding product failed.");
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateProduct(Product product) {
        String sql = (product.getProductImage() != null && !product.getProductImage().isEmpty()) ?
                UPDATE_PRODUCT_WITH_IMAGE : UPDATE_PRODUCT_NO_IMAGE;

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, product.getProductName());
            stmt.setString(2, product.getProductDescription());
            stmt.setDouble(3, product.getPrice());
            stmt.setString(4, product.getCategory());
            stmt.setInt(5, product.getStockQuantity());

            if (sql.equals(UPDATE_PRODUCT_WITH_IMAGE)) {
                stmt.setString(6, product.getProductImage());
                stmt.setInt(7, product.getProductId());
            } else {
                stmt.setInt(6, product.getProductId());
            }

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Updating product failed.");
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProduct(int id) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_PRODUCT)) {

            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Deleting product failed.");
            e.printStackTrace();
            return false;
        }
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
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
