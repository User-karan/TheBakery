package controllers;

import dao.UserDAO;
import models.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ProfileServlet", value = "/profile/*")
public class UserProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "view"; // Default action is to view profile
        }

        // First check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        String email = (String) session.getAttribute("email");

        // Handle admin and customer profiles differently
        if ("admin".equalsIgnoreCase(role)) {
            handleAdminProfile(request, response, email, action);
        } else {
            handleCustomerProfile(request, response, email, action);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // First check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        String email = (String) session.getAttribute("email");

        if ("update".equalsIgnoreCase(action)) {
            if ("admin".equalsIgnoreCase(role)) {
                updateAdminProfile(request, response, email);
            } else {
                updateCustomerProfile(request, response, email);
            }
        } else if ("delete".equalsIgnoreCase(action)) {
            deleteProfile(request, response, email, role);
        } else {
            doGet(request, response);
        }
    }

    private void handleAdminProfile(HttpServletRequest request, HttpServletResponse response, 
                                  String email, String action) 
            throws ServletException, IOException {
        
        try {
            User admin = userDAO.getUserByEmail(email);
            
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=User+not+found");
                return;
            }

            switch (action) {
                case "view":
                    request.setAttribute("admin", admin);
                    request.getRequestDispatcher("/pages/admin/adminProfile.jsp").forward(request, response);
                    break;
                case "showEditForm":
                    request.setAttribute("admin", admin);
                    request.getRequestDispatcher("/pages/admin/adminEditProfile.jsp").forward(request, response);
                    break;
                default:
                    request.setAttribute("admin", admin);
                    request.getRequestDispatcher("/pages/admin/adminProfile.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Error+loading+admin+profile");
        }
    }

    private void handleCustomerProfile(HttpServletRequest request, HttpServletResponse response, 
                                     String email, String action) 
            throws ServletException, IOException {
        
        try {
            User customer = userDAO.getUserByEmail(email);
            
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=User+not+found");
                return;
            }

            switch (action) {
                case "view":
                    request.setAttribute("customer", customer);
                    request.getRequestDispatcher("/pages/customer/customerDashboard.jsp").forward(request, response);
                    break;
                case "showEditForm":
                    request.setAttribute("customer", customer);
                    request.getRequestDispatcher("/pages/customer/customerEditDetails.jsp").forward(request, response);
                    break;
                case "showDeleteForm":
                    request.setAttribute("customer", customer);
                    request.getRequestDispatcher("/pages/customer/customerDelete.jsp").forward(request, response);
                    break;
                default:
                    request.setAttribute("customer", customer);
                    request.getRequestDispatcher("/pages/customer/customerDashboard.jsp").forward(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/dashboard?error=Error+loading+customer+profile");
        }
    }

    private void updateAdminProfile(HttpServletRequest request, HttpServletResponse response, 
                                  String email) 
            throws ServletException, IOException {
        
        try {
            User admin = userDAO.getUserByEmail(email);
            
            if (admin == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=User+not+found");
                return;
            }

            // Update admin fields
            updateUserFromRequest(request, admin);
            
            // Ensure role remains admin
            admin.setRole("admin");

            boolean updated = userDAO.updateUser(admin);
            
            // Update password if provided
            String password = request.getParameter("password");
            if (password != null && !password.trim().isEmpty()) {
                userDAO.updateUserPassword(email, password);
            }

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/profile?action=view&success=Profile+updated+successfully");
            } else {
                request.setAttribute("error", "Failed to update profile.");
                request.setAttribute("admin", admin);
                request.getRequestDispatcher("/pages/admin/adminEditProfile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating profile: " + e.getMessage());
            request.getRequestDispatcher("/pages/admin/adminEditProfile.jsp").forward(request, response);
        }
    }

    private void updateCustomerProfile(HttpServletRequest request, HttpServletResponse response, 
                                     String email) 
            throws ServletException, IOException {
        
        try {
            User customer = userDAO.getUserByEmail(email);
            
            if (customer == null) {
                response.sendRedirect(request.getContextPath() + "/login?error=User+not+found");
                return;
            }

            // Update customer fields
            updateUserFromRequest(request, customer);
            
            // Ensure role remains customer
            customer.setRole("customer");

            boolean updated = userDAO.updateUser(customer);
            
            // Update password if provided
            String password = request.getParameter("password");
            if (password != null && !password.trim().isEmpty()) {
                userDAO.updateUserPassword(email, password);
            }

            if (updated) {
                response.sendRedirect(request.getContextPath() + "/profile?action=view&success=Profile+updated+successfully");
            } else {
                request.setAttribute("error", "Failed to update profile.");
                request.setAttribute("customer", customer);
                request.getRequestDispatcher("/pages/customer/customerEditDetails.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating profile: " + e.getMessage());
            request.getRequestDispatcher("/pages/customer/customerEditDetails.jsp").forward(request, response);
        }
    }

    private void deleteProfile(HttpServletRequest request, HttpServletResponse response, 
                             String email, String role) 
            throws ServletException, IOException {
        
        try {
            boolean deleted = userDAO.deleteUser(email);
            
            if (deleted) {
                // Invalidate session after account deletion
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                
                if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect(request.getContextPath() + "/login?success=Admin+account+deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/login?success=Account+deleted+successfully");
                }
            } else {
                if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect(request.getContextPath() + "/profile?action=view&error=Failed+to+delete+admin+account");
                } else {
                    response.sendRedirect(request.getContextPath() + "/profile?action=view&error=Failed+to+delete+account");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/profile?action=view&error=Error+deleting+account");
        }
    }

    // Helper method to update user fields from request parameters
    private void updateUserFromRequest(HttpServletRequest request, User user) {
        if (request.getParameter("firstName") != null) {
            user.setFirstName(request.getParameter("firstName"));
        }
        if (request.getParameter("lastName") != null) {
            user.setLastName(request.getParameter("lastName"));
        }
        if (request.getParameter("phoneNumber") != null) {
            user.setPhoneNumber(request.getParameter("phoneNumber"));
        }
        if (request.getParameter("address") != null) {
            user.setAddress(request.getParameter("address"));
        }
        if (request.getParameter("dob") != null) {
            user.setDob(request.getParameter("dob"));
        }
        if (request.getParameter("gender") != null) {
            user.setGender(request.getParameter("gender"));
        }
    }
}