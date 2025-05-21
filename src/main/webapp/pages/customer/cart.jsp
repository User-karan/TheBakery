<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    // Ensure user is logged in
    Object userId = session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Your Cart | I Doughnut Care</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/customer.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        .cart-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .cart-table th, .cart-table td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        .cart-table th {
            background-color: #f4f4f4;
        }

        .product-image-small {
            max-width: 60px;
            height: auto;
        }

        .quantity-input-small {
            width: 60px;
        }

        .btn-update, .btn-delete, .btn-buy, .btn-secondary {
            margin: 5px;
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-update {
            background-color: #28a745;
            color: white;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn-buy {
            background-color: #007bff;
            color: white;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
            text-decoration: none;
        }

        .success-message {
            background-color: #28a745;
            color: white;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
            text-align: center;
        }

        .success-message i {
            margin-right: 10px;
        }

        .error-message {
            background-color: #dc3545;
            color: white;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
            text-align: center;
        }

        .error-message i {
            margin-right: 10px;
        }
    </style>
</head>
<body>
  <div class="container">
    <!-- Sidebar -->
    <aside class="sidebar">
      <h2><i class="fas fa-donut"></i> I Doughnut Care</h2>
      <nav>
        <ul>
          <li><i class="fas fa-user"></i> <a href="<%= request.getContextPath() %>/profile">Profile</a></li>
          <li class="active"><i class="fas fa-shopping-cart"></i> <a href="<%= request.getContextPath() %>/cart?action=view">My Cart</a></li>
          <li><i class="fas fa-cookie-bite"></i> <a href="<%= request.getContextPath() %>/UserProductServlet">Shop Products</a></li>
          <li><i class="fas fa-sign-out-alt"></i> <a href="<%= request.getContextPath() %>/logout">Logout</a></li>
        </ul>
      </nav>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
      <h1>Your Shopping Cart</h1>

      <!-- Display Success Message if Available -->
      <c:if test="${not empty successMessage}">
        <div class="success-message">
            <i class="fas fa-check-circle"></i> ${successMessage}
        </div>
        <c:remove var="successMessage"/> 
      </c:if>

      <c:if test="${not empty error}">
        <div class="error-message">
          <i class="fas fa-exclamation-circle"></i> ${error}
        </div>
      </c:if>

      <c:choose>
        <c:when test="${empty cartItems}">
          <div class="notice">
            <i class="fas fa-info-circle"></i> Your cart is empty. Start shopping!
            <p><a href="<%= request.getContextPath() %>/UserProductServlet" class="btn btn-primary">Browse Products</a></p>
          </div>
        </c:when>
        <c:otherwise>
          <table class="cart-table">
            <thead>
              <tr>
                <th>Image</th>
                <th>Product</th>
                <th>Price (Rs.)</th>
                <th>Quantity</th>
                <th>Subtotal (Rs.)</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:set var="total" value="0" />
              <c:forEach var="item" items="${cartItems}">
                <c:set var="subtotal" value="${item.product.price * item.quantity}" />
                <c:set var="total" value="${total + subtotal}" />

                <tr>
                  <td>
                    <c:if test="${not empty item.product.productImage}">
                      <img src="${item.product.productImage}" alt="${item.product.productName}" class="product-image-small" />
                    </c:if>
                  </td>
                  <td>${item.product.productName}</td>
                  <td><fmt:formatNumber value="${item.product.price}" pattern="###,###.##" /></td>
                  <td>
                    <form action="${pageContext.request.contextPath}/cart" method="post" class="quantity-form">
                      <input type="hidden" name="action" value="update" />
                      <input type="hidden" name="productId" value="${item.product.productId}" />
                      <input type="number" 
                             name="quantity" 
                             value="${item.quantity}" 
                             min="1" 
                             max="99" 
                             class="quantity-input-small" />
                      <button type="submit" class="btn-update">Update</button>
                    </form>
                  </td>
                  <td><fmt:formatNumber value="${subtotal}" pattern="###,###.##" /></td>
                  <td>
					  <form method="post" action="${pageContext.request.contextPath}/cart">
					    <input type="hidden" name="action" value="remove" />
					    <input type="hidden" name="productId" value="${item.productId}" />
					    <button type="submit" class="btn-delete">Remove</button>
					</form>

					  <form action="${pageContext.request.contextPath}/checkout" method="post" style="display:inline-block; margin-top: 5px;">
					    <input type="hidden" name="productId" value="${item.product.productId}" />
					    <input type="hidden" name="quantity" value="${item.quantity}" />
					    <button type="submit" class="btn-buy" title="Checkout this item">Buy Now</button>
					  </form>
					</td>
                </tr>
              </c:forEach>
            </tbody>
            <tfoot>
              <tr>
                <td colspan="4" style="text-align: right;"><strong>Total:</strong></td>
                <td colspan="2"><strong>Rs. <fmt:formatNumber value="${total}" pattern="###,###.##" /></strong></td>
              </tr>
            </tfoot>
          </table>

          <a href="${pageContext.request.contextPath}/UserProductServlet" class="btn-secondary">
            <i class="fas fa-arrow-left"></i> Continue Shopping
          </a>
        </c:otherwise>
      </c:choose>
    </main>
  </div>
</body>
</html>
