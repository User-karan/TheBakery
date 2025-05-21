package controllers;

import dao.UserDAO;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserServlet", value = "/user/*")
public class UserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        switch (action) {
            case "list":
                listUsers(request, response);
                break;
            case "view":
                viewUser(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            case "edit":
                editUserForm(request, response);
                break;
            case "profile":
                viewAdminProfile(request, response);
                break;
            default:
                listUsers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equalsIgnoreCase(action)) {
            registerUser(request, response);
        } else if ("delete".equalsIgnoreCase(action)) {
            deleteUser(request, response);
        } else if ("update".equalsIgnoreCase(action)) {
            updateUser(request, response);
        } else {
            doGet(request, response); // Default action if no match
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/pages/admin/adminuser.jsp").forward(request, response);
    }

    private void viewUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            User user = userDAO.getUserByEmail(email);

            if (user != null) {
                request.setAttribute("user", user);
                request.getRequestDispatcher("/pages/admin/user-details.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/user?action=list");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        }
    }

    private void registerUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get user details from the form
            String firstName = request.getParameter("firstName");
            String lastName = request.getParameter("lastName");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");
            String address = request.getParameter("address");
            String dob = request.getParameter("dob");
            String gender = request.getParameter("gender");
            String role = request.getParameter("role");
            String password = request.getParameter("password");

            // Create a User object
            User user = new User(firstName, lastName, email, phoneNumber, address, dob, gender, role, password);

            // Check if user already exists
            if (userDAO.getUserByEmail(email) != null) {
                request.setAttribute("error", "User with email " + email + " already exists.");
                request.getRequestDispatcher("/pages/admin/add-user.jsp").forward(request, response);
                return;
            }

            // Add the user to the database using register
            boolean added = userDAO.registerUser(user);

            if (added) {
                // Redirect with a success message
                response.sendRedirect(request.getContextPath() + "/user?action=list&success=User+added+successfully");
            } else {
                // If user couldn't be added, set error message and forward to the admin page
                request.setAttribute("error", "User could not be added.");
                request.getRequestDispatcher("/pages/admin/add-user.jsp").forward(request, response);
            }

        } catch (Exception e) {
            // Handle errors and forward with the error message
            e.printStackTrace();
            request.setAttribute("error", "Error adding user: " + e.getMessage());
            request.getRequestDispatcher("/pages/admin/add-user.jsp").forward(request, response);
        }
    }
    
    private void editUserForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            User user = userDAO.getUserByEmail(email);

            if (user != null) {
                request.setAttribute("user", user);
                request.getRequestDispatcher("/pages/admin/edit-user.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/user?action=list&error=User+not+found");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/user?action=list&error=Invalid+user+email");
        }
    }
    
    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            User existingUser = userDAO.getUserByEmail(email);

            if (existingUser == null) {
                response.sendRedirect(request.getContextPath() + "/user?action=list&error=User+not+found");
                return;
            }

            // Update user fields
            String firstName = request.getParameter("firstName");
            if (firstName != null && !firstName.trim().isEmpty()) {
                existingUser.setFirstName(firstName);
            }

            String lastName = request.getParameter("lastName");
            if (lastName != null && !lastName.trim().isEmpty()) {
                existingUser.setLastName(lastName);
            }

            String phoneNumber = request.getParameter("phoneNumber");
            if (phoneNumber != null && !phoneNumber.trim().isEmpty()) {
                existingUser.setPhoneNumber(phoneNumber);
            }

            String address = request.getParameter("address");
            if (address != null && !address.trim().isEmpty()) {
                existingUser.setAddress(address);
            }

            String dob = request.getParameter("dob");
            if (dob != null && !dob.trim().isEmpty()) {
                existingUser.setDob(dob);
            }

            String gender = request.getParameter("gender");
            if (gender != null && !gender.trim().isEmpty()) {
                existingUser.setGender(gender);
            }

            String role = request.getParameter("role");
            if (role != null && !role.trim().isEmpty()) {
                existingUser.setRole(role);
            }

            // Update password if provided
            String password = request.getParameter("password");
            if (password != null && !password.trim().isEmpty()) {
                existingUser.setPassword(password);
            }

            // Update in DB
            boolean updated = userDAO.updateUser(existingUser);
            
            // If password was changed, update it separately
            if (password != null && !password.trim().isEmpty()) {
                userDAO.updateUserPassword(email, password);
            }

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/user?action=list&success=User+updated+successfully");
            } else {
                request.setAttribute("error", "Failed to update user.");
                request.setAttribute("user", existingUser);
                request.getRequestDispatcher("/pages/admin/edit-user.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating user: " + e.getMessage());
            request.getRequestDispatcher("/pages/admin/edit-user.jsp").forward(request, response);
        }
    }
    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            boolean deleted = userDAO.deleteUser(email);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/user?action=list&success=User+deleted+successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/user?action=list&error=Failed+to+delete+user");
            }
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/user?action=list");
        }
    }
    
    private void viewAdminProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the current user from session
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user != null && "admin".equals(user.getRole())) {
            // Forward to admin profile page
        	 request.getRequestDispatcher("/pages/admin/adminProfile.jsp").forward(request, response);
        } else {
            // Redirect to login page or show error if not admin
            response.sendRedirect(request.getContextPath() + "/login?error=Unauthorized+access");
        }
    }
}