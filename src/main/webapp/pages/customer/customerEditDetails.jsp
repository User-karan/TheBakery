<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
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
            max-width: 800px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .header {
            background-color: #2196F3;
            color: white;
            padding: 20px;
            text-align: center;
        }
        
        .content {
            padding: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #555;
        }
        
        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 16px;
        }
        
        input:focus, select:focus {
            border-color: #2196F3;
            outline: none;
            box-shadow: 0 0 5px rgba(33, 150, 243, 0.3);
        }
        
        .actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 20px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
            border: none;
            font-size: 16px;
        }
        
        .btn-save {
            background-color: #4CAF50;
            color: white;
        }
        
        .btn-save:hover {
            background-color: #45a049;
        }
        
        .btn-cancel {
            background-color: #f44336;
            color: white;
        }
        
        .btn-cancel:hover {
            background-color: #d32f2f;
        }
        
        .error-message {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            margin-bottom: 20px;
            border-radius: 4px;
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
            <h1><i class="fas fa-user-edit"></i> Edit Profile</h1>
        </div>
        
        <div class="content">
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <c:if test="${empty customer}">
                <p class="notice">Customer information not found.</p>
            </c:if>
            
            <c:if test="${not empty customer}">
                <form action="<%= request.getContextPath() %>/profile" method="post">
                    <input type="hidden" name="action" value="update" />
                    <input type="hidden" name="email" value="${customer.email}" />
                    
                    <div class="form-group">
                        <label for="firstName">First Name</label>
                        <input type="text" id="firstName" name="firstName" value="${customer.firstName}" required />
                    </div>
                    
                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <input type="text" id="lastName" name="lastName" value="${customer.lastName}" required />
                    </div>
                    
                    <div class="form-group">
                        <label for="email-display">Email (cannot be changed)</label>
                        <input type="email" id="email-display" value="${customer.email}" disabled />
                    </div>
                    
                    <div class="form-group">
                        <label for="phoneNumber">Phone Number</label>
                        <input type="tel" id="phoneNumber" name="phoneNumber" value="${customer.phoneNumber}" required />
                    </div>
                    
                    <div class="form-group">
                        <label for="address">Address</label>
                        <input type="text" id="address" name="address" value="${customer.address}" required />
                    </div>
                    
                    <div class="form-group">
                        <label for="dob">Date of Birth</label>
                        <input type="date" id="dob" name="dob" value="${customer.dob}" required />
                    </div>
                    
                    <div class="form-group">
                        <label for="gender">Gender</label>
                        <select id="gender" name="gender" required>
                            <option value="Male" ${customer.gender == 'Male' ? 'selected' : ''}>Male</option>
                            <option value="Female" ${customer.gender == 'Female' ? 'selected' : ''}>Female</option>
                            <option value="Other" ${customer.gender == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">New Password (leave blank to keep current)</label>
                        <input type="password" id="password" name="password" />
                    </div>
                    
                    <div class="actions">
                        <button type="submit" class="btn btn-save">Save Changes</button>
                        <a href="<%= request.getContextPath() %>/profile?action=view" class="btn btn-cancel">Cancel</a>
                    </div>
                </form>
            </c:if>
        </div>
    </div>
</body>
</html>