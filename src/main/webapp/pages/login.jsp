<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String role = (String) session.getAttribute("role");
    if (role != null) {
        if ("admin".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
        }
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - I Doughnut Care</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #fdf2e9;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            padding: 10px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: bold;
            text-align: center;
            width: 350px;
        }
        .login-container {
            background-color: #fff;
            padding: 30px 40px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            width: 350px;
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #d35400;
        }
        label {
            display: block;
            margin-top: 15px;
            color: #333;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        .error {
            color: red;
            margin-top: 10px;
            text-align: center;
        }
        .btn {
            width: 100%;
            padding: 12px;
            margin-top: 20px;
            background-color: #e67e22;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #d35400;
        }
        p {
            text-align: center;
            margin-top: 10px;
        }
        a {
            color: #e67e22;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        .password-wrapper {
            position: relative;
        }
        .toggle-btn {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            cursor: pointer;
            font-size: 14px;
            color: #e67e22;
        }
    </style>
</head>
<body>

    <!-- ✅ Success message -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert-success">
            ${sessionScope.successMessage}
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <div class="login-container">
        <h2>Login</h2>

        <c:if test="${not empty errorMessage}">
            <div class="error">
                <c:out value="${errorMessage}" />
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <label for="email">Email:</label>
            <input type="text" name="email" id="email" required />

            <label for="password">Password:</label>
            <div class="password-wrapper">
                <input type="password" name="password" id="password" required />
                <button type="button" class="toggle-btn" onclick="togglePassword()">Show</button>
            </div>

            <button type="submit" class="btn">Login</button>
            <p>Don't have an account? <a href="${pageContext.request.contextPath}/pages/register.jsp">Register</a></p>
        </form>
    </div>

    <script>
        function togglePassword() {
            const passwordInput = document.getElementById("password");
            const toggleBtn = event.target;

            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                toggleBtn.textContent = "Hide";
            } else {
                passwordInput.type = "password";
                toggleBtn.textContent = "Show";
            }
        }
    </script>
</body>
</html>
