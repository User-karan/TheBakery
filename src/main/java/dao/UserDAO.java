package dao;

import models.User;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    // Database connection parameters
	private static final String URL = "jdbc:mysql://localhost:3306/idoughnutcare?useSSL=false&serverTimezone=Asia/Kathmandu&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    // SQL queries
    private static final String SELECT_ALL_USERS = "SELECT * FROM users ORDER BY email ASC";
    private static final String SELECT_USER_BY_EMAIL = "SELECT * FROM users WHERE email = ?";
    private static final String CHECK_EMAIL_EXISTS = "SELECT 1 FROM users WHERE email = ?";
    private static final String INSERT_USER = 
        "INSERT INTO users (first_name, last_name, email, phone, address, dob, gender, role, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_USER = 
        "UPDATE users SET first_name = ?, last_name = ?, phone = ?, address = ?, dob = ?, gender = ?, role = ? WHERE email = ?";
    private static final String UPDATE_USER_PASSWORD = 
        "UPDATE users SET password = ? WHERE email = ?";
    private static final String DELETE_USER = "DELETE FROM users WHERE email = ?";

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

    // Password hashing utility
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hashBytes) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            System.err.println("[ERROR] Password hashing failed.");
            e.printStackTrace();
            return null;
        }
    }

    // User authentication
    public User login(String email, String password) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_USER_BY_EMAIL)) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password");
                    String inputHash = hashPassword(password);
                    
                    if (inputHash != null && inputHash.equals(storedHash)) {
                        return mapResultSetToUser(rs);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] Login failed for email: " + email);
            e.printStackTrace();
        }
        return null;
    }

    // User management methods
    public boolean isEmailRegistered(String email) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(CHECK_EMAIL_EXISTS)) {
            stmt.setString(1, email);
            return stmt.executeQuery().next();
        } catch (SQLException e) {
            System.err.println("[ERROR] Checking email registration failed.");
            e.printStackTrace();
        }
        return false;
    }

    public boolean registerUser(User user) {
        if (isEmailRegistered(user.getEmail())) {
            System.err.println("[WARN] Email already registered: " + user.getEmail());
            return false;
        }

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_USER)) {

            String hashedPassword = hashPassword(user.getPassword());
            if (hashedPassword == null) {
                return false;
            }

            stmt.setString(1, user.getFirstName());
            stmt.setString(2, user.getLastName());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getPhoneNumber());
            stmt.setString(5, user.getAddress());
            stmt.setDate(6, Date.valueOf(user.getDob()));
            stmt.setString(7, user.getGender());
            stmt.setString(8, user.getRole());
            stmt.setString(9, hashedPassword);

            int result = stmt.executeUpdate();
            System.out.println("[DEBUG] Registration result for " + user.getEmail() + ": " + (result > 0 ? "Success" : "Failed"));
            return result > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Registration failed for user: " + user.getEmail());
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_USERS);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            System.out.println("[DEBUG] Fetched " + users.size() + " users.");
        } catch (SQLException e) {
            System.err.println("[ERROR] Fetching all users failed.");
            e.printStackTrace();
        }
        return users;
    }

    public User getUserByEmail(String email) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_USER_BY_EMAIL)) {

            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] Fetching user by email failed: " + email);
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUser(User user) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_USER)) {

            stmt.setString(1, user.getFirstName());
            stmt.setString(2, user.getLastName());
            stmt.setString(3, user.getPhoneNumber());
            stmt.setString(4, user.getAddress());
            stmt.setDate(5, Date.valueOf(user.getDob()));
            stmt.setString(6, user.getGender());
            stmt.setString(7, user.getRole());
            stmt.setString(8, user.getEmail());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Updating user failed: " + user.getEmail());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateUserPassword(String email, String newPassword) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_USER_PASSWORD)) {

            String hashedPassword = hashPassword(newPassword);
            if (hashedPassword == null) {
                return false;
            }

            stmt.setString(1, hashedPassword);
            stmt.setString(2, email);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Updating password failed for: " + email);
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteUser(String email) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_USER)) {

            stmt.setString(1, email);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Deleting user failed: " + email);
            e.printStackTrace();
            return false;
        }
    }


    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        return new User(
        	rs.getInt("id"),
            rs.getString("first_name"),
            rs.getString("last_name"),
            rs.getString("email"),
            rs.getString("phone"),
            rs.getString("address"),
            rs.getString("dob"),
            rs.getString("gender"),
            rs.getString("role"),
            null // Never return password hash
        );
    }
}