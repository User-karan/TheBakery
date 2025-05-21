<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.User" %>

<!DOCTYPE html>
<html>
<head>
    <title>Delete Account</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        .container {
            width: 80%;
            max-width: 600px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .header {
            background-color: #f44336;
            color: white;
            padding: 20px;
            text-align: center;
        }
        
        .content {
            padding: 30px;
            text-align: center;
        }
        
        .warning-icon {
            font-size: 64px;
            color: #f44336;
            margin-bottom: 20px;
        }
        
        .warning-message {
            font-size: 18px;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .customer-info {
            background-color: #f9f9f9;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 30px;
            text-align: left;
        }
        
        .info-item {
            margin-bottom: 10px;
        }
        
        .info-label {
            font-weight: 600;
            color: #555;
        }
        
        .actions {
            display: flex;
            justify-content: center;
            gap: 20px;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 25px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
            border: none;
            font-size: 16px;
        }
        
        .btn-delete {
            background-color: #f44336;
            color: white;
        }
        
        .btn-delete:hover {
            background-color: #d32f2f;
        }
        
        .btn-cancel {
            background-color: #607D8B;
            color: white;
        }
        
        .btn-cancel:hover {
            background-color: #546E7A;
        }
        
        .notice {
            background-color: #fff3cd;
            color: #856404;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-exclamation-triangle"></i> Delete Account</h1>
        </div>
        
        <div class="content">
            <%
                User customer = (User) request.getAttribute("customer");
                if (customer == null) {
            %>
                <p class="notice">Customer information not found.</p>
            <%
                } else {
            %>
                <div class="warning-icon">
                    <i class="fas fa-exclamation-circle"></i>
                </div>
                
                <div class="warning-message">
                    <p>Are you sure you want to delete your account? This action cannot be undone.</p>
                    <p>All your personal information and order history will be permanently removed from our system.</p>
                </div>
                
                <div class="customer-info">
                    <div class="info-item">
                        <span class="info-label">Name:</span> <%= customer.getFirstName() %> <%= customer.getLastName() %>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Email:</span> <%= customer.getEmail() %>
                    </div>
                </div>
                
                <form action="<%= request.getContextPath() %>/profile" method="post">
                    <input type="hidden" name="action" value="delete" />
                    <input type="hidden" name="email" value="<%= customer.getEmail() %>" />
                    
                    <div class="actions">
                        <button type="submit" class="btn btn-delete">Confirm Delete</button>
                        <a href="<%= request.getContextPath() %>/profile?action=view" class="btn btn-cancel">Cancel</a>
                    </div>
                </form>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>