package dao;

import models.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
	private static final String URL = "jdbc:mysql://localhost:3306/idoughnutcare?useSSL=false&serverTimezone=Asia/Kathmandu&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";
    
    private static final String SELECT_ALL_CATEGORIES = "SELECT * FROM category ORDER BY category_name";
    
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
    
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_CATEGORIES);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Category category = new Category();
                category.setCategoryName(rs.getString("category_name"));
                category.setCategoryDescription(rs.getString("category_description"));
                categories.add(category);
            }

            System.out.println("[DEBUG] Fetched " + categories.size() + " categories.");
        } catch (SQLException e) {
            System.err.println("[ERROR] Fetching all categories failed.");
            e.printStackTrace();
        }
        return categories;
    }
}