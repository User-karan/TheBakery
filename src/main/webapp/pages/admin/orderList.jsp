<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="models.Order" %> 
<%
    // Use the built-in session object directly, no need to redeclare
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("pages/login.jsp");  // Redirect to login if not admin
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Admin Dashboard - I Doughnut Care</title>

  <!-- Link to external stylesheets and fonts -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <!-- Adding Google Fonts for a better design -->
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
  
  <style>
    body {
      font-family: 'Roboto', sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f4f4f4;
    }

    .main-content {
      flex-grow: 1;
      padding: 30px;
    }

    .header h1 {
      font-size: 32px;
      margin-bottom: 20px;
      color: #333;
    }

    .card {
      background-color: #fff;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      padding: 20px;
    }

    .card-header h2 {
      font-size: 24px;
      margin-bottom: 20px;
      color: #333;
    }

    .card-header form {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 10px;
    }

    .card-header input[type="date"] {
      padding: 8px;
      font-size: 16px;
      border: 1px solid #ccc;
      border-radius: 5px;
    }

    .card-header button {
      padding: 10px 20px;
      background-color: #007bff;
      color: #fff;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }

    .card-header button:hover {
      background-color: #0056b3;
    }

    .table-responsive {
      margin-top: 20px;
    }

    .table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }

    .table th, .table td {
      padding: 12px;
      text-align: left;
      border-bottom: 1px solid #ddd;
    }

    .table th {
      background-color: #f7f7f7;
    }

    .table tbody tr:hover {
      background-color: #f1f1f1;
    }

    .error-message {
      color: red;
      font-size: 16px;
      text-align: center;
    }
  </style>
</head>
<body>

<div class="container">
  <aside class="sidebar">
    <h2><i class="fas fa-donut"></i> I Doughnut Care</h2>
    <nav>
      <ul>
        <li><i class="fas fa-home"></i> <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a></li>
        <li><i class="fas fa-cookie-bite"></i> <a href="<%= request.getContextPath() %>/product">Product</a></li>
        <li><i class="fas fa-users"></i> <a href="<%= request.getContextPath() %>/user">Users</a></li>
        <li class="active"><i class="fas fa-shopping-cart"></i><a href="<%= request.getContextPath() %>/orders">Orders</a></li>
        <li><i class="fas fa-user-circle"></i> <a href="${pageContext.request.contextPath}/profile">Profile</a></li>
        <li><i class="fas fa-sign-out-alt"></i> <a href="<%= request.getContextPath() %>/logout">Logout</a></li>
      </ul>
    </nav>
  </aside>

  <div class="main-content">
    <header class="header">
      <h1>Order Management</h1>
    </header>

    <div class="card">
      <div class="card-header">
        <h2>All Orders</h2>

        <!-- Date Filter Form -->
        <form method="get" action="<%= request.getContextPath() %>/orders/filter">
          <div>
            <label>Start Date: <input type="date" name="startDate" required></label>
            <label>End Date: <input type="date" name="endDate" required></label>
            <button type="submit">Filter</button>
          </div>
        </form>

        <!-- Error Message -->
        <%
            String error = (String) request.getAttribute("error");
            if (error != null && !error.isEmpty()) {
        %>
          <p class="error-message"><%= error %></p>
        <%
            }
        %>
      </div>

      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>Order ID</th>
                <th>User Email</th>
                <th>Product</th>
                <th>Quantity</th>
                <th>Order Date</th>
                <th>Total Amount</th>
              </tr>
            </thead>
            <tbody>
              <%
                  ArrayList<Order> orderList = (ArrayList<Order>) request.getAttribute("orderList");
                  if (orderList != null && !orderList.isEmpty()) {
                      for (Order order : orderList) {
              %>
                    <tr>
                      <td><%= order.getOrderId() %></td>
                      <td><%= order.getEmail() %></td>
                      <td><%= order.getProductName() %></td>
                      <td><%= order.getQuantity() %></td>
                      <td><%= order.getOrderDate() %></td>
                      <td><%= order.getTotalAmount() %></td>
                    </tr>
              <%
                      }
                  } else {
              %>
                    <tr>
                      <td colspan="6" style="text-align:center;">No orders found for selected date range.</td>
                    </tr>
              <%
                  }
              %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>

</body>
</html>