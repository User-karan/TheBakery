<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sign up for I Doughnut Care</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #fdf2e9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: auto;
            margin: 0;
            padding: 40px 0;
        }
        .signup-container {
            background-color: #fff;
            padding: 30px 40px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            max-width: 700px;
            width: 90%;
        }
        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #d35400;
        }
        .form-group {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .input-box {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        label {
            margin-bottom: 5px;
            color: #333;
        }
        input[type="text"],
        input[type="email"],
        input[type="password"],
        input[type="date"],
        input[type="file"],
        select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
        }
        .signup-btn {
            width: 100%;
            padding: 12px;
            margin-top: 20px;
            background-color: #e67e22;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            font-size: 16px;
        }
        .signup-btn:hover {
            background-color: #d35400;
        }
        .signin-text {
            text-align: center;
            margin-top: 15px;
        }
        .signin-text a {
            color: #e67e22;
            text-decoration: none;
        }
        .signin-text a:hover {
            text-decoration: underline;
        }
        span {
            font-size: 13px;
            margin-top: 5px;
        }
        p {
            margin: 10px 0;
        }
    </style>
</head>
<body>

    <div class="signup-container">
        <h2>Sign up for I Doughnut Care</h2>
        
        	<c:if test="${not empty errorMessage}">
        <div style="color:red; font-size: 18px; font-weight: bold; margin-bottom: 20px;">
            ${errorMessage}
        </div>
    </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post" enctype="multipart/form-data">
            <!-- First Name and Last Name Fields -->
            <div class="form-group">
                <div class="input-box">
                    <label for="first_name">First Name</label>
                    <input type="text" id="first_name" name="first_name" placeholder="Your First Name" required 
                           value="<%= request.getParameter("first_name") != null ? request.getParameter("first_name") : "" %>" />
                </div>
                <div class="input-box">
                    <label for="last_name">Last Name</label>
                    <input type="text" id="last_name" name="last_name" placeholder="Your Last Name" required 
                           value="<%= request.getParameter("last_name") != null ? request.getParameter("last_name") : "" %>" />
                </div>
            </div>

            <!-- Email and Phone Number Fields -->
            <div class="form-group">
                <div class="input-box">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="you@example.com" required 
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" />
                    <span style="color:red;">
                        <%= request.getAttribute("emailError") != null ? request.getAttribute("emailError") : "" %>
                    </span>
                </div>
                <div class="input-box">
                    <label for="phone_number">Mobile Number</label>
                    <input type="text" id="phone_number" name="phone_number" placeholder="+977 xxxxxxxxxx" required 
                           value="<%= request.getParameter("phone_number") != null ? request.getParameter("phone_number") : "" %>" />
                    <span style="color:red;">
                        <%= request.getAttribute("phoneError") != null ? request.getAttribute("phoneError") : "" %>
                    </span>
                </div>
            </div>

            <!-- Address and Date of Birth Fields -->
            <div class="form-group">
                <div class="input-box">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address" placeholder="Your Delivery Address" required 
                           value="<%= request.getParameter("address") != null ? request.getParameter("address") : "" %>" />
                </div>
                <div class="input-box">
                    <label for="dob">Date of Birth</label>
                    <input type="date" id="dob" name="dob" required 
                           value="<%= request.getParameter("dob") != null ? request.getParameter("dob") : "" %>" />
                    <span style="color:red;">
                        <%= request.getAttribute("dobError") != null ? request.getAttribute("dobError") : "" %>
                    </span>
                </div>
            </div>

            <!-- Password and Confirm Password Fields -->
            <div class="form-group">
                <div class="input-box">
                    <label for="password">Choose a Password</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required />
                    <span style="color:red;">
                        <%= request.getAttribute("passwordError") != null ? request.getAttribute("passwordError") : "" %>
                    </span>
                </div>
                <div class="input-box">
                    <label for="confirm_password">Confirm Password</label>
                    <input type="password" id="confirm_password" name="confirm_password" placeholder="••••••••" required />
                    <span style="color:red;">
                        <%= request.getAttribute("confirmPasswordError") != null ? request.getAttribute("confirmPasswordError") : "" %>
                    </span>
                </div>
            </div>

            <!-- Gender Field -->
            <div class="form-group">
                <div class="input-box">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender">
                        <option value="male" <%= "male".equals(request.getParameter("gender")) ? "selected" : "" %>>Male</option>
                        <option value="female" <%= "female".equals(request.getParameter("gender")) ? "selected" : "" %>>Female</option>
                        <option value="other" <%= "other".equals(request.getParameter("gender")) ? "selected" : "" %>>Other</option>
                    </select>
                </div>
            </div>


            <!-- Submit Button -->
            <button type="submit" class="signup-btn">Register</button>

            <!-- Sign In Link -->
            <p class="signin-text">Already have an account? <a href="${pageContext.request.contextPath}/pages/login.jsp">Login</a></p>
        </form>
    </div>
</body>
</html>