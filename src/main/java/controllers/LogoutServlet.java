package controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String role = null;
        if (session != null) {
            role = (String) session.getAttribute("role");
            session.invalidate();
        }
        
        // Prevent caching
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        
        // Redirect based on role with context path
        String contextPath = request.getContextPath();
        if ("customer".equalsIgnoreCase(role)) {
            response.sendRedirect(contextPath + "/pages/index.jsp");
        } else {
            response.sendRedirect(contextPath + "/pages/login.jsp");
        }
    }
}
