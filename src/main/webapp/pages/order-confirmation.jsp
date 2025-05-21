<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Order Confirmation - I Doughnut Care</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff8f0;
            margin: 0;
            padding: 0;
        }
        
        .container {
            max-width: 800px;
            margin: 50px auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
            text-align: center;
        }
        
        .success-icon {
            font-size: 60px;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        
        h1 {
            color: #663300;
            margin-bottom: 20px;
        }
        
        p {
            color: #555;
            font-size: 18px;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        
        .order-number {
            font-weight: bold;
            color: #ff9933;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background-color: #ff9933;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
            transition: background-color 0.3s;
            margin: 10px;
        }
        
        .btn:hover {
            background-color: #e68a00;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    
    <div class="container">
        <div class="success-icon">✓</div>
        <h1>Order Confirmed!</h1>
        <p>Thank you for your purchase. Your order has been successfully placed.</p>
        <p>Your order number is: <span class="order-number">#<%= request.getParameter("orderId") %></span></p>
        <p>We'll process your order right away and notify you when it's ready.</p>
        
        <div>
            <a href="${pageContext.request.contextPath}/UserProductServlet" class="btn">Continue Shopping</a>
            <a href="${pageContext.request.contextPath}/pages/customer/dashboard.jsp" class="btn">My Account</a>
        </div>
    </div>
</body>
</html>