package controllers;

import java.io.*;
import java.sql.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.regex.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "RegisterServlet", value = "/register")
@MultipartConfig(maxFileSize = 16177215) // 16MB
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String URL = "jdbc:mysql://localhost:3306/idoughnutcare";
    private static final String USER = "root";
    private static final String PASSWORD = "";

    private String hashPassword(String password) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = md.digest(password.getBytes());
        StringBuilder hexString = new StringBuilder();
        for (byte b : hashBytes) {
            hexString.append(String.format("%02x", b));
        }
        return hexString.toString();
    }

    // Method to validate phone number (must be 10 digits)
    private boolean isValidPhoneNumber(String phone) {
        String regex = "^[0-9]{10}$";  // Only 10 digits allowed
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(phone);
        return matcher.matches();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone_number");
        String address = request.getParameter("address");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String role = request.getParameter("role");
        if (role == null || role.trim().isEmpty()) {
            role = "customer";
        }

        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        Part imagePart = request.getPart("image");


        // Validate phone number
        if (!isValidPhoneNumber(phone)) {
            request.setAttribute("errorMessage", "Phone number must be 10 digits.");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        // Validate password confirmation
        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match.");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        String hashedPassword;
        try {
            hashedPassword = hashPassword(password);
        } catch (NoSuchAlgorithmException e) {
            request.setAttribute("errorMessage", "Password hashing failed.");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            request.setAttribute("errorMessage", "JDBC Driver not found.");
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD)) {
            // Check if the email already exists in the database
            String checkEmailSql = "SELECT COUNT(*) FROM users WHERE email = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkEmailSql)) {
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    request.setAttribute("errorMessage", "Email already exists. Please use a different email.");
                    request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
                    return;
                }
            }

            String sql = "INSERT INTO users (first_name, last_name, email, phone, address, dob, gender, role, password, image) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, firstName);
                stmt.setString(2, lastName);
                stmt.setString(3, email);
                stmt.setString(4, phone);
                stmt.setString(5, address);
                stmt.setDate(6, Date.valueOf(dob));
                stmt.setString(7, gender);
                stmt.setString(8, role);
                stmt.setString(9, hashedPassword);

                if (imagePart != null && imagePart.getSize() > 0) {
                    stmt.setBlob(10, imagePart.getInputStream());
                } else {
                    stmt.setNull(10, Types.BLOB);
                }

                int rows = stmt.executeUpdate();

                if (rows > 0) {
                    request.getSession().setAttribute("successMessage", "Registration Successful! Please log in.");
                    response.sendRedirect("pages/login.jsp");
                } else {
                    request.setAttribute("errorMessage", "Registration failed. Please try again.");
                    request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
                }
            }
        } catch (SQLException e) {
            if (e instanceof SQLIntegrityConstraintViolationException) {
                request.setAttribute("errorMessage", "Database error: Duplicate entry. Please check your email.");
            } else {
                request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            }
            request.getRequestDispatcher("/pages/register.jsp").forward(request, response);
        }
    }
}
