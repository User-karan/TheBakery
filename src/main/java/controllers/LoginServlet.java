package controllers;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import dao.UserDAO;
import models.User;

@WebServlet("/login/*")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if the user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            // User is already logged in, redirect to dashboard or homepage
            String context = request.getContextPath();
            response.sendRedirect(context + "/dashboard");
            return; // Don't process login if already logged in
        }

        // Continue with login logic if not logged in
        String email = request.getParameter("email").trim();
        String password = request.getParameter("password").trim();

        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(email, password);

        if (user != null) {
            // Invalidate old session
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            // Start new session
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("userId", user.getId());
            newSession.setAttribute("email", user.getEmail());
            newSession.setAttribute("firstName", user.getFirstName());
            newSession.setAttribute("lastName", user.getLastName());
            newSession.setAttribute("role", user.getRole());
            newSession.setMaxInactiveInterval(30 * 60); // 30 minutes

            System.out.println("Login successful. Session userId set to: " + user.getId());
            String context = request.getContextPath();
            if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(context + "/dashboard");
            } else {
                response.sendRedirect(context + "/pages/index.jsp");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }
}
