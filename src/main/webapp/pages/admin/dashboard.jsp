<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Use the built-in session object directly, no need to redeclare
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");  // Redirect to login if not admin
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Admin Dashboard - I Doughnut Care</title>

  <!-- Link to external CSS file -->
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/admin.css" />

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>
  <div class="container">
  <aside class="sidebar">
	  <h2><i class="fas fa-donut"></i> I Doughnut Care</h2>
	  <nav>
	    <ul>
	      <li class="active">
	        <i class="fas fa-home"></i> <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
	      </li>
	      <li>
	        <i class="fas fa-cookie-bite"></i> <a href="<%= request.getContextPath() %>/product">Product</a>
	      </li>
	      <li><i class="fas fa-users"></i> <a href="<%= request.getContextPath() %>/user">Users</a></li>
	      <li><i class="fas fa-shopping-cart"></i><a href="<%= request.getContextPath() %>/orders">Orders</a></li>
	      <li><i class="fas fa-user-circle"></i> <a href="${pageContext.request.contextPath}/profile">Profile</a></li>
	      <li><i class="fas fa-sign-out-alt"></i> <a href="<%= request.getContextPath() %>/logout">Logout</a></li>
	    </ul>
	  </nav>
	</aside>
    <main class="main-content">
      <h1>Welcome back, <%= session.getAttribute("firstName") %>!</h1>

      <div class="stats">
		  <div class="stat-box"><i class="fas fa-shopping-cart"></i><p>${totalOrders}<br><span>Orders</span></p></div>
		  <div class="stat-box"><i class="fas fa-user"></i><p>${totalUsers}<br><span>Users</span></p></div>
		  <div class="stat-box"><i class="fas fa-box"></i><p>${totalProducts}<br><span>Products</span></p></div>
		  <div class="stat-box"><i class="fas fa-chart-bar"></i><p>Rs. ${totalSales}<br><span>Total Sales</span></p></div>
	  </div>
      <section class="orders">
        <h2>Recent Orders</h2>
        <table>
          <thead>
            <tr>
              <th>Order ID</th>
              <th>Email</th>
              <th>Product Name</th>
              <th>Qty</th>
              <th>Order Date</th>
              <th>Total Amount</th>
            </tr>
          </thead>
          <tbody>
			  <c:forEach var="order" items="${recentOrders}">
			    <tr>
			      <td>${order.orderId}</td>
			      <td>${order.email}</td>
			      <td>${order.productName}</td>
			      <td>${order.quantity}</td>
			      <td>${order.orderDate}</td>
			      <td>${order.totalAmount}</td>
			    </tr>
			  </c:forEach>
		</tbody>
        </table>
      </section>
    </main>
  </div>
</body>
</html>
