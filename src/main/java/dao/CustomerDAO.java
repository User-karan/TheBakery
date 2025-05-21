package dao;

import models.User;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    // Database connection parameters
	private static final String URL = "jdbc:mysql://localhost:3306/idoughnutcare?useSSL=false&serverTimezone=Asia/Kathmandu&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    // SQL queries
    private static final String SELECT_ALL_CUSTOMERS = "SELECT * FROM customers ORDER BY email ASC";
    private static final String SELECT_CUSTOMER_BY_EMAIL = "SELECT * FROM customers WHERE email = ?";
    private static final String CHECK_EMAIL_EXISTS = "SELECT 1 FROM customers WHERE email = ?";
    private static final String INSERT_CUSTOMER = 
        "INSERT INTO customers (first_name, last_name, email, phone, address, dob, gender, role, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_CUSTOMER = 
        "UPDATE customers SET first_name = ?, last_name = ?, phone = ?, address = ?, dob = ?, gender = ?, role = ? WHERE email = ?";
    private static final String UPDATE_CUSTOMER_PASSWORD = 
        "UPDATE customers SET password = ? WHERE email = ?";
    private static final String DELETE_CUSTOMER = "DELETE FROM customers WHERE email = ?";

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

    // Customer authentication
    public User login(String email, String password) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_CUSTOMER_BY_EMAIL)) {
            
            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password");
                    String inputHash = hashPassword(password);
                    
                    if (inputHash != null && inputHash.equals(storedHash)) {
                        return mapResultSetToCustomer(rs);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] Login failed for email: " + email);
            e.printStackTrace();
        }
        return null;
    }

    // Customer management methods
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

    public boolean registerCustomer(User customer) {
        if (isEmailRegistered(customer.getEmail())) {
            System.err.println("[WARN] Email already registered: " + customer.getEmail());
            return false;
        }

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(INSERT_CUSTOMER)) {

            String hashedPassword = hashPassword(customer.getPassword());
            if (hashedPassword == null) {
                return false;
            }

            stmt.setString(1, customer.getFirstName());
            stmt.setString(2, customer.getLastName());
            stmt.setString(3, customer.getEmail());
            stmt.setString(4, customer.getPhoneNumber());
            stmt.setString(5, customer.getAddress());
            stmt.setDate(6, Date.valueOf(customer.getDob()));
            stmt.setString(7, customer.getGender());
            stmt.setString(8, customer.getRole());
            stmt.setString(9, hashedPassword);

            int result = stmt.executeUpdate();
            System.out.println("[DEBUG] Registration result for " + customer.getEmail() + ": " + (result > 0 ? "Success" : "Failed"));
            return result > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Registration failed for customer: " + customer.getEmail());
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAllCustomers() {
        List<User> customers = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_ALL_CUSTOMERS);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                customers.add(mapResultSetToCustomer(rs));
            }
            System.out.println("[DEBUG] Fetched " + customers.size() + " customers.");
        } catch (SQLException e) {
            System.err.println("[ERROR] Fetching all customers failed.");
            e.printStackTrace();
        }
        return customers;
    }

    public User getCustomerByEmail(String email) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(SELECT_CUSTOMER_BY_EMAIL)) {

            stmt.setString(1, email);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCustomer(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("[ERROR] Fetching customer by email failed: " + email);
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCustomer(User customer) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_CUSTOMER)) {

            stmt.setString(1, customer.getFirstName());
            stmt.setString(2, customer.getLastName());
            stmt.setString(3, customer.getPhoneNumber());
            stmt.setString(4, customer.getAddress());
            stmt.setDate(5, Date.valueOf(customer.getDob()));
            stmt.setString(6, customer.getGender());
            stmt.setString(7, customer.getRole());
            stmt.setString(8, customer.getEmail());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Updating customer failed: " + customer.getEmail());
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateCustomerPassword(String email, String newPassword) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(UPDATE_CUSTOMER_PASSWORD)) {

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

    public boolean deleteCustomer(String email) {
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(DELETE_CUSTOMER)) {
            
            stmt.setString(1, email);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[ERROR] Deleting customer failed: " + email);
            e.printStackTrace();
            return false;
        }
    }

    // Helper method to map ResultSet to User object
    private User mapResultSetToCustomer(ResultSet rs) throws SQLException {
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
            rs.getString("password")
        );
    }
}