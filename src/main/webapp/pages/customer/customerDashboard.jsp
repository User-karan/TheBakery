<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    if (session.getAttribute("email") == null || !"customer".equals(session.getAttribute("role"))) {
    	response.sendRedirect(request.getContextPath() + "/login");;
        return;
    }

    User customer = (User) request.getAttribute("customer");
%>


<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>My Profile | I Doughnut Care</title>
  <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/customer.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</head>
<body>
  <div class="container">
    <!-- Sidebar -->
    <aside class="sidebar">
      <h2><i class="fas fa-donut"></i> I Doughnut Care</h2>
      <nav>
        <ul>
          <li class="active"><i class="fas fa-user"></i> <a href="<%= request.getContextPath() %>/profile">Profile</a></li>
          <li><i class="fas fa-shopping-cart"></i> <a href="<%= request.getContextPath() %>/cart?action=view">My Cart</a></li>
          <li><i class="fas fa-cookie-bite"></i> <a href="<%= request.getContextPath() %>/UserProductServlet">Shop Products</a></li>
          <li><i class="fas fa-sign-out-alt"></i> <a href="<%= request.getContextPath() %>/logout">Logout</a></li>
        </ul>
      </nav>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
      <h1>Welcome back, <%= session.getAttribute("firstName") %>!</h1>

      <% String successMessage = request.getParameter("success");
         String errorMessage = request.getParameter("error");
         if (successMessage != null && !successMessage.isEmpty()) { %>
          <div class="success-message">
            <i class="fas fa-check-circle"></i>
            <span><%= successMessage.replace("+", " ") %></span>
          </div>
      <% } else if (errorMessage != null && !errorMessage.isEmpty()) { %>
          <div class="notice">
            <i class="fas fa-exclamation-circle"></i>
            <span><%= errorMessage.replace("+", " ") %></span>
          </div>
      <% } %>

      <section class="profile">
        <h2><i class="fas fa-id-card"></i> My Profile</h2>

        <% if (customer == null) { %>
          <div class="notice">
            <i class="fas fa-exclamation-triangle"></i>
            <span>Customer information not found. Please try again or contact support.</span>
          </div>
        <% } else { %>
          <div class="profile-details">
			  <div class="profile-row"><span class="label">Full Name:</span> <span><%= customer.getFirstName() %> <%= customer.getLastName() %></span></div>
			  <div class="profile-row"><span class="label">Email:</span> <span><%= customer.getEmail() %></span></div>
			  <div class="profile-row"><span class="label">Phone:</span> <span><%= customer.getPhoneNumber() %></span></div>
			  <div class="profile-row"><span class="label">Gender:</span> <span><%= customer.getGender() %></span></div>
			  <div class="profile-row"><span class="label">Date of Birth:</span> <span><%= customer.getDob() %></span></div>
			  <div class="profile-row"><span class="label">Address:</span> <span><%= customer.getAddress() %></span></div>
			</div>

          <div class="actions">
            <a href="<%= request.getContextPath() %>/profile?action=showEditForm&email=<%= customer.getEmail() %>" class="btn btn-secondary">
              <i class="fas fa-edit"></i> Edit Profile
            </a>
            <a href="<%= request.getContextPath() %>/profile?action=showDeleteForm&email=<%= customer.getEmail() %>" class="btn btn-danger">
              <i class="fas fa-trash-alt"></i> Delete Account
            </a>
            <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline">
              <i class="fas fa-arrow-left"></i> Back to Home
            </a>
          </div>
        <% } %>
      </section>
    </main>
  </div>
</body>
</html>
