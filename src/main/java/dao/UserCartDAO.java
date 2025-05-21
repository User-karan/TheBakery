package dao;

import java.sql.*;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.CartItem;
import models.Product;

public class UserCartDAO {
	private static final String URL = "jdbc:mysql://localhost:3306/idoughnutcare?useSSL=false&serverTimezone=Asia/Kathmandu&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    private static final Logger LOGGER = Logger.getLogger(UserCartDAO.class.getName());

    public boolean addToCart(int userId, int productId, int quantity) {
        System.out.println("Debug: Adding to cart - userId: " + userId + ", productId: " + productId);
        
        // SQL query with 'id' column (assuming 'id' is the correct column name in the cart table)
        String checkSql = "SELECT cart_id, quantity FROM cart WHERE user_id = ? AND product_id = ?";
        String insertSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
        String updateSql = "UPDATE cart SET quantity = quantity + ? WHERE cart_id = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD)) {
            conn.setAutoCommit(false);
            System.out.println("Debug: Database connection established");

            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, userId);
                checkStmt.setInt(2, productId);

                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    int cartId = rs.getInt("cart_id");
                    System.out.println("Debug: Updating existing cart item, cartId: " + cartId);
                    
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setInt(1, quantity);
                        updateStmt.setInt(2, cartId);
                        updateStmt.executeUpdate();
                    }
                } else {
                    System.out.println("Debug: Inserting new cart item");
                    try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                        insertStmt.setInt(1, userId);  
                        insertStmt.setInt(2, productId);
                        insertStmt.setInt(3, quantity);
                        insertStmt.executeUpdate();
                    }
                }

                conn.commit();
                System.out.println("Debug: Transaction committed successfully");
                return true;
            } catch (SQLException e) {
                conn.rollback();
                System.out.println("Debug: SQL Error: " + e.getMessage());
                LOGGER.log(Level.SEVERE, "Error adding item to cart", e);
                return false;
            }
        } catch (SQLException e) {
            System.out.println("Debug: Database connection error: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Database connection error", e);
            return false;
        }
    }

    public List<CartItem> getCartItems(int userId) {
        System.out.println("Debug: Fetching cart items for userId: " + userId);
        List<CartItem> cartItems = new ArrayList<>();

        String query = """
            SELECT c.cart_id, p.product_id, p.product_name AS productName, p.price, p.product_image AS productImage, 
                   p.stock_quantity, c.quantity
            FROM cart c
            JOIN product p ON c.product_id = p.product_id
            WHERE c.user_id = ?
        """;

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userId);
            System.out.println("Debug: Executing query: " + stmt.toString());
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Product product = new Product();
                product.setProductId(rs.getInt("product_id"));
                product.setProductName(rs.getString("productName"));
                product.setPrice(rs.getDouble("price"));
                product.setProductImage(rs.getString("productImage"));
                product.setStockQuantity(rs.getInt("stock_quantity"));

                CartItem item = new CartItem(product, rs.getInt("quantity"), userId);
                item.setCartId(rs.getInt("cart_id"));
                cartItems.add(item);
                System.out.println("Debug: Added cart item - productId: " + product.getProductId());
            }

            System.out.println("Debug: Total cart items found: " + cartItems.size());

        } catch (SQLException e) {
            System.out.println("Debug: SQL Error in getCartItems: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Error retrieving cart items", e);
        }

        return cartItems;
    }

    public boolean removeFromCart(int userId, int productId) {
        System.out.println("Debug: Removing from cart - userId: " + userId + ", productId: " + productId);
        String query = "DELETE FROM cart WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            int result = stmt.executeUpdate();
            System.out.println("Debug: Remove result: " + result + " rows affected");
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Debug: SQL Error in removeFromCart: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Error removing item from cart", e);
            return false;
        }
    }

    public boolean updateCartItemQuantity(int userId, int productId, int quantity) {
        System.out.println("Debug: Updating quantity - userId: " + userId + ", productId: " + productId + ", quantity: " + quantity);
        String query = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(query)) {
            
            stmt.setInt(1, quantity);
            stmt.setInt(2, userId);
            stmt.setInt(3, productId);
            int result = stmt.executeUpdate();
            System.out.println("Debug: Update result: " + result + " rows affected");
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Debug: SQL Error in updateCartItemQuantity: " + e.getMessage());
            LOGGER.log(Level.SEVERE, "Error updating cart item quantity", e);
            return false;
        }
    }
    
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    
    public List<CartItem> checkout(int userId) throws SQLException {
        return getCartItems(userId);
    }

}
