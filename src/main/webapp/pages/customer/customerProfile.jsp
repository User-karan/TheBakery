<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Profile | My Account</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4CAF50;
            --primary-dark: #388E3C;
            --secondary-color: #2196F3;
            --accent-color: #FFC107;
            --danger-color: #f44336;
            --text-color: #333;
            --text-light: #757575;
            --bg-color: #f5f5f5;
            --card-color: #fff;
            --border-radius: 8px;
            --box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Roboto', Arial, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            line-height: 1.6;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        
        .container {
            width: 90%;
            max-width: 900px;
            background-color: var(--card-color);
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            overflow: hidden;
            transition: var(--transition);
        }
        
        .header {
            background-color: var(--primary-color);
            color: white;
            padding: 25px;
            text-align: center;
            position: relative;
        }
        
        .header h1 {
            font-size: 28px;
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .header p {
            opacity: 0.9;
            font-size: 16px;
        }
        
        .profile-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            border: 4px solid rgba(255, 255, 255, 0.3);
            overflow: hidden;
        }
        
        .profile-image i {
            font-size: 60px;
            color: var(--primary-color);
        }
        
        .content {
            padding: 30px;
        }
        
        .profile-section {
            margin-bottom: 20px;
        }
        
        .section-title {
            font-size: 18px;
            margin-bottom: 12px;
            color: var(--primary-color);
            border-bottom: 2px solid var(--primary-color);
            padding-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .profile-details {
            background-color: #f9f9f9;
            border-radius: var(--border-radius);
            padding: 12px;
        }
        
        .detail-item {
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
        }
        
        .detail-item:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }
        
        .detail-icon {
            width: 32px;
            height: 32px;
            background-color: rgba(76, 175, 80, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            color: var(--primary-color);
        }
        
        .detail-icon i {
            font-size: 14px;
        }
        
        .detail-content {
            flex: 1;
        }
        
        .detail-label {
            font-weight: 500;
            color: var(--text-light);
            font-size: 12px;
            margin-bottom: 2px;
        }
        
        .detail-value {
            font-weight: 500;
            font-size: 14px;
        }
        
        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 25px;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 20px;
            border-radius: var(--border-radius);
            text-decoration: none;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 16px;
            flex: 1;
            min-width: 120px;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--primary-dark);
        }
        
        .btn-secondary {
            background-color: var(--secondary-color);
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #1976D2;
        }
        
        .btn-danger {
            background-color: var(--danger-color);
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #d32f2f;
        }
        
        .btn-outline {
            background-color: transparent;
            border: 1px solid var(--text-light);
            color: var(--text-color);
        }
        
        .btn-outline:hover {
            background-color: #f0f0f0;
        }
        
        .notice {
            background-color: #fff3cd;
            color: #856404;
            padding: 15px;
            border-radius: var(--border-radius);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .notice i {
            font-size: 24px;
        }
        
        .success-message {
            background-color: rgba(76, 175, 80, 0.1);
            color: var(--primary-color);
            padding: 15px;
            border-radius: var(--border-radius);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .success-message i {
            font-size: 24px;
        }
        
        @media (max-width: 768px) {
            .container {
                width: 95%;
            }
            
            .content {
                padding: 20px;
            }
            
            .actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            .detail-item {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .detail-icon {
                margin-bottom: 8px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="profile-image">
                <i class="fas fa-user"></i>
            </div>
            <h1><i class="fas fa-user-circle"></i> My Profile</h1>
            <p>Manage your account information</p>
        </div>
        
        <div class="content">
            <% 
                // Display success message if present
                String successMessage = request.getParameter("success");
                if (successMessage != null && !successMessage.isEmpty()) {
            %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    <span><%= successMessage.replace("+", " ") %></span>
                </div>
            <% } %>
            
            <% 
                // Display error message if present
                String errorMessage = request.getParameter("error");
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
                <div class="notice">
                    <i class="fas fa-exclamation-circle"></i>
                    <span><%= errorMessage.replace("+", " ") %></span>
                </div>
            <% } %>
            
            <%
                User customer = (User) request.getAttribute("customer");
                if (customer == null) {
            %>
                <div class="notice">
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>Customer information not found. Please try again or contact support.</span>
                </div>
            <%
                } else {
            %>
                <div class="profile-section">
                    <h2 class="section-title"><i class="fas fa-id-card"></i> Personal Information</h2>
                    <div class="profile-details">
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <div class="detail-content">
                                <div class="detail-label">Full Name</div>
                                <div class="detail-value"><%= customer.getFirstName() %> <%= customer.getLastName() %></div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="fas fa-envelope"></i>
                            </div>
                            <div class="detail-content">
                                <div class="detail-label">Email Address</div>
                                <div class="detail-value"><%= customer.getEmail() %></div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="fas fa-phone"></i>
                            </div>
                            <div class="detail-content">
                                <div class="detail-label">Phone Number</div>
                                <div class="detail-value"><%= customer.getPhoneNumber() %></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="profile-section">
                    <h2 class="section-title"><i class="fas fa-map-marker-alt"></i> Address & Additional Details</h2>
                    <div class="profile-details">
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="fas fa-home"></i>
                            </div>
                            <div class="detail-content">
                                <div class="detail-label">Address</div>
                                <div class="detail-value"><%= customer.getAddress() %></div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="fas fa-birthday-cake"></i>
                            </div>
                            <div class="detail-content">
                                <div class="detail-label">Date of Birth</div>
                                <div class="detail-value"><%= customer.getDob() %></div>
                            </div>
                        </div>
                        
                        <div class="detail-item">
                            <div class="detail-icon">
                                <i class="fas fa-venus-mars"></i>
                            </div>
                            <div class="detail-content">
                                <div class="detail-label">Gender</div>
                                <div class="detail-value"><%= customer.getGender() %></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="actions">
                    <a href="<%= request.getContextPath() %>/profile?action=showEditForm&email=<%= customer.getEmail() %>" class="btn btn-secondary">
                        <i class="fas fa-edit"></i> Edit Profile
                    </a>
                    <a href="<%= request.getContextPath() %>/profile?action=showDeleteForm&email=<%= customer.getEmail() %>" class="btn btn-danger">
                        <i class="fas fa-trash-alt"></i> Delete Account
                    </a>
                    <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-outline">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                </div>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>