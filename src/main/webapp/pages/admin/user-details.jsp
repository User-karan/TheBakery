<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="models.User" %> <!-- Replace with your actual User class package -->

<!DOCTYPE html>
<html>
<head>
    <title>User Details</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        .user-details {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
        }
        
        .detail-item {
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .detail-label {
            font-weight: 600;
            color: #555;
            margin-bottom: 5px;
            display: block;
        }
        
        .detail-value {
            font-size: 16px;
        }
        
        .actions {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }
        
        .btn-edit, .btn-back {
            display: inline-block;
            padding: 10px 15px;
            border-radius: 4px;
            color: white;
            text-decoration: none;
            font-size: 16px;
        }
        
        .btn-edit {
            background-color: #4CAF50;
        }
        
        .btn-edit:hover {
            background-color: #45a049;
        }
        
        .btn-back {
            background-color: #607D8B;
        }
        
        .btn-back:hover {
            background-color: #546E7A;
        }
    </style>
</head>
<body>
    <div class="container">
        <aside class="sidebar">
            <h2><i class="fas fa-donut"></i> I Doughnut Care</h2>
            <nav>
                <ul>
                    <li>
                        <i class="fas fa-home"></i> <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
                    </li>
                    <li>
                        <i class="fas fa-cookie-bite"></i> <a href="<%= request.getContextPath() %>/product">Product</a>
                    </li>
                    <li class="active"><i class="fas fa-users"></i> <a href="<%= request.getContextPath() %>/user">Users</a></li>
                    <li><i class="fas fa-shopping-cart"></i> Orders</li>
                    <li><i class="fas fa-user-circle"></i> Profile</li>
                    <li><i class="fas fa-sign-out-alt"></i> <a href="<%= request.getContextPath() %>/logout">Logout</a></li>
                </ul>
            </nav>
        </aside>

        <div class="main-content">
            <h2>User Details</h2>
            
            <%
                User user = (User) request.getAttribute("user");
                if (user == null) {
            %>
                <p class="notice">User not found or the user was not passed.</p>
            <%
                } else {
            %>
                <div class="user-details">
                    <div class="detail-item">
                        <span class="detail-label">Full Name</span>
                        <span class="detail-value"><%= user.getFirstName() %> <%= user.getLastName() %></span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Email</span>
                        <span class="detail-value"><%= user.getEmail() %></span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Phone Number</span>
                        <span class="detail-value"><%= user.getPhoneNumber() %></span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Address</span>
                        <span class="detail-value"><%= user.getAddress() %></span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Date of Birth</span>
                        <span class="detail-value"><%= user.getDob() %></span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Gender</span>
                        <span class="detail-value"><%= user.getGender() %></span>
                    </div>
                    
                    <div class="detail-item">
                        <span class="detail-label">Role</span>
                        <span class="detail-value"><%= user.getRole() %></span>
                    </div>
                    
                    <div class="actions">
                        <a href="<%= request.getContextPath() %>/user?action=edit&email=<%= user.getEmail() %>" class="btn-edit">Edit User</a>
                        <a href="<%= request.getContextPath() %>/user" class="btn-back">Back to Users</a>
                    </div>
                </div>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>