<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Edit User</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        .form-container {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: 600;
        }
        
        input, select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        
        .btn-submit {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        
        .btn-submit:hover {
            background-color: #45a049;
        }
        
        .btn-cancel {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            margin-left: 10px;
        }
        
        .btn-cancel:hover {
            background-color: #d32f2f;
        }
        
        .error-message {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
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
                    <li><i class="fas fa-shopping-cart"></i><a href="<%= request.getContextPath() %>/orders">Orders</a></li>
        			<li><i class="fas fa-user-circle"></i> <a href="${pageContext.request.contextPath}/profile">Profile</a></li>
                    <li><i class="fas fa-sign-out-alt"></i> <a href="<%= request.getContextPath() %>/logout">Logout</a></li>
                </ul>
            </nav>
        </aside>

        <div class="main-content">
            <h2>Edit User</h2>
            
            <c:if test="${not empty error}">
                <div class="error-message">${error}</div>
            </c:if>
            
            <c:if test="${empty user}">
                <p class="notice">User not found or the user was not passed.</p>
            </c:if>
            
            <c:if test="${not empty user}">
                <div class="form-container">
                    <form action="<%= request.getContextPath() %>/user" method="post">
                        <input type="hidden" name="action" value="update" />
                        <input type="hidden" name="email" value="${user.email}" />
                        
                        <div class="form-group">
                            <label for="firstName">First Name</label>
                            <input type="text" id="firstName" name="firstName" value="${user.firstName}" required />
                        </div>
                        
                        <div class="form-group">
                            <label for="lastName">Last Name</label>
                            <input type="text" id="lastName" name="lastName" value="${user.lastName}" required />
                        </div>
                        
                        <div class="form-group">
                            <label for="email-display">Email (cannot be changed)</label>
                            <input type="email" id="email-display" value="${user.email}" disabled />
                        </div>
                        
                        <div class="form-group">
                            <label for="phoneNumber">Phone Number</label>
                            <input type="tel" id="phoneNumber" name="phoneNumber" value="${user.phoneNumber}" required />
                        </div>
                        
                        <div class="form-group">
                            <label for="address">Address</label>
                            <input type="text" id="address" name="address" value="${user.address}" required />
                        </div>
                        
                        <div class="form-group">
                            <label for="dob">Date of Birth</label>
                            <input type="date" id="dob" name="dob" value="${user.dob}" required />
                        </div>
                        
                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select id="gender" name="gender" required>
                                <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                                <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                                <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="role">Role</label>
                            <select id="role" name="role" required>
                                <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>Admin</option>
                                <option value="user" ${user.role == 'customer' ? 'selected' : ''}>Customer</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="password">Password (leave blank to keep current)</label>
                            <input type="password" id="password" name="password" />
                        </div>
                        
                        <div class="form-actions">
                            <button type="submit" class="btn-submit">Update User</button>
                            <a href="<%= request.getContextPath() %>/user" class="btn-cancel">Cancel</a>
                        </div>
                    </form>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>
