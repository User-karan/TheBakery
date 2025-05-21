<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    if (!("admin").equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/pages/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Admin Profile - I Doughnut Care</title>
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/admin.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
  <style>
    .profile-container {
      background-color: #fff;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      padding: 20px;
      margin-bottom: 20px;
    }
    .profile-header {
      display: flex;
      align-items: center;
      margin-bottom: 30px;
      padding-bottom: 20px;
      border-bottom: 1px solid #eee;
    }
    .profile-avatar {
      margin-right: 30px;
      color: #5c6bc0;
    }
    .profile-info h2 {
      margin-top: 0;
      margin-bottom: 15px;
      color: #333;
    }
    .profile-info p {
      margin: 8px 0;
      color: #666;
    }
    .profile-info i {
      width: 20px;
      margin-right: 10px;
      color: #5c6bc0;
    }
    .profile-table {
      width: 100%;
      border-collapse: collapse;
    }
    .profile-table td {
      padding: 10px 0;
      border-bottom: 1px solid #eee;
    }
    .profile-table td:first-child {
      width: 40%;
      font-weight: 500;
    }
    .profile-actions {
      margin-top: 30px;
      display: flex;
      gap: 15px;
    }
    .btn-edit, .btn-manage {
      display: inline-block;
      padding: 10px 20px;
      border-radius: 4px;
      text-decoration: none;
      font-weight: 500;
      transition: background-color 0.3s;
    }
    .btn-edit {
      background-color: #5c6bc0;
      color: white;
    }
    .btn-manage {
      background-color: #26a69a;
      color: white;
    }
    .btn-edit:hover, .btn-manage:hover {
      opacity: 0.9;
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
          <li><i class="fas fa-shopping-cart"></i><a href="<%= request.getContextPath() %>/orders">Orders</a></li>
          <li class="active"><i class="fas fa-user-circle"></i> <a href="${pageContext.request.contextPath}/profile">Profile</a></li>
          <li><i class="fas fa-sign-out-alt"></i> <a href="<%= request.getContextPath() %>/logout">Logout</a></li>
        </ul>
      </nav>
    </aside>

    <main class="main-content">
      <h1>Admin Profile</h1>

      <div class="profile-container">
        <div class="profile-header">
          <div class="profile-avatar">
            <i class="fas fa-user-circle fa-5x"></i>
          </div>
          <div class="profile-info">
            <h2><%= session.getAttribute("firstName") %> <%= session.getAttribute("lastName") %></h2>
            <p><i class="fas fa-envelope"></i> <%= session.getAttribute("email") %></p>
            <p><i class="fas fa-phone"></i> ${admin.phoneNumber}</p>
            <p><i class="fas fa-map-marker-alt"></i> ${admin.address}</p>
          </div>
        </div>

        <div class="profile-details">
          <div class="detail-section">
            <h3>Personal Information</h3>
            <table class="profile-table">
              <tr>
                <td><strong>Date of Birth:</strong></td>
                <td>${admin.dob}</td>
              </tr>
              <tr>
                <td><strong>Gender:</strong></td>
                <td>${admin.gender}</td>
              </tr>
              <tr>
                <td><strong>Role:</strong></td>
                <td><%= session.getAttribute("role") %></td>
              </tr>
            </table>
          </div>
        </div>

        <div class="profile-actions">
          <a href="${pageContext.request.contextPath}/user?action=edit&email=<%= session.getAttribute("email") %>" class="btn-edit">
            <i class="fas fa-edit"></i> Edit Profile
          </a>
          <a href="${pageContext.request.contextPath}/user?action=list" class="btn-manage">
            <i class="fas fa-users"></i> Manage Users
          </a>
        </div>
      </div>
    </main>
  </div>
</body>
</html>
