<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders - I Doughnut Care</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <div class="container">
        <h1>My Orders</h1>
        
        <c:if test="${empty orders}">
            <div class="empty-orders">
                <p>You haven't placed any orders yet.</p>
                <a href="${pageContext.request.contextPath}/UserProductServlet" class="btn">Start Shopping</a>
            </div>
        </c:if>
        
        <c:if test="${not empty orders}">
            <div class="orders-list">
                <c:forEach var="order" items="${orders}">
                    <div class="order-item">
                        <div class="order-header">
                            <h3>Order #${order.orderId}</h3>
                            <span class="order-date">
                                <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy HH:mm" />
                            </span>
                        </div>
                        <div class="order-details">
                            <p>Product: ${order.productName}</p>
                            <p>Quantity: ${order.quantity}</p>
                            <p>Total Amount: $<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></p>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/UserProductServlet" class="btn">Continue Shopping</a>
        </div>
    </div>
</body>
</html>