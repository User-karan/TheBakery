package filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter(urlPatterns = { "/pages/dashboard.jsp", "/pages/admin/*" }) // Protects admin resources
public class AuthenticationFilter implements Filter {

    private static final String LOGIN_PAGE = "/pages/login.jsp";
    private static final String HOME_PAGE = "/pages/index.jsp";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("AuthenticationFilter initialized");
    }

    @Override
    public void destroy() {
        System.out.println("AuthenticationFilter destroyed");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        HttpSession session = req.getSession(false);

        boolean loggedIn = session != null && session.getAttribute("email") != null;
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        // Allow access to static resources (optional)
        if (uri.contains("/css/") || uri.contains("/js/") || uri.contains("/images/")) {
            chain.doFilter(request, response);
            return;
        }

        // Allow public access to login and registration pages
        if (!loggedIn && (uri.endsWith("login.jsp") || uri.endsWith("LoginServlet") || uri.endsWith("register.jsp"))) {
            chain.doFilter(request, response);
            return;
        }

        // If not logged in, redirect to login page with timeout flag
        if (!loggedIn) {
            System.out.println("Access denied: User not logged in. Redirecting to login.");
            res.sendRedirect(req.getContextPath() + LOGIN_PAGE + "?timeout=true");
            return;
        }

        // If logged in but not an admin, redirect to homepage
        if (!"admin".equalsIgnoreCase(role)) {
            System.out.println("Access denied: User is not admin. Redirecting to home.");
            res.sendRedirect(req.getContextPath() + HOME_PAGE);
            return;
        }

        // User is authenticated and authorized (admin)
        chain.doFilter(request, response);
    }
}
