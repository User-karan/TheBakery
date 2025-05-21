<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="models.User" %> 

<!DOCTYPE html>
<html>
<head>
    <title>Admin User List</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
        }

        thead {
            background-color: #f5f5f5;
        }

        th, td {
            padding: 12px 16px;
            text-align: left;
            border-bottom: 1px solid #eee;
            font-size: 15px;
        }

        .flash-message {
            margin: 20px 0;
            padding: 15px;
            border-radius: 5px;
            text-align: center;
        }

        .flash-message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .flash-message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .btn-edit, .btn-delete, .btn-add {
            padding: 8px 12px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 14px;
            border: none;
            cursor: pointer;
        }
        
        .btn-edit {
            background-color: #4CAF50;
            color: white;
        }
        
        .btn-delete {
            background-color: #f44336;
            color: white;
        }
        
        .btn-add {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 15px;
            background-color: #2196F3;
            color: white;
            border-radius: 4px;
            text-decoration: none;
        }
        
        .actions {
            margin-top: 20px;
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
                    <li><i class="fas fa-cookie-bite"></i> <a href="<%= request.getContextPath() %>/product">Product</a></li>
                    <li class="active"><i class="fas fa-users"></i> <a href="<%= request.getContextPath() %>/user">Users</a></li>
                    <li><i class="fas fa-shopping-cart"></i><a href="<%= request.getContextPath() %>/orders">Orders</a></li>
          			<li><i class="fas fa-user-circle"></i> <a href="${pageContext.request.contextPath}/profile">Profile</a></li>
                    <li><i class="fas fa-sign-out-alt"></i> <a href="<%= request.getContextPath() %>/logout">Logout</a></li>
                </ul>
            </nav>
        </aside>

        <div class="main-content">
            <h2>Admin User List</h2>

            <%
                String success = request.getParameter("success");
                String error = request.getParameter("error");
                
                if (success != null && !success.isEmpty()) {
            %>
                <p class="flash-message success"><%= success %></p>
            <%
                }
                if (error != null && !error.isEmpty()) {
            %>
                <p class="flash-message error"><%= error %></p>
            <%
                }
            %>

            <%
                ArrayList<User> users = (ArrayList<User>) request.getAttribute("users");
                if (users == null || users.isEmpty()) {
            %>
                <p class="notice">No users found or the user list was not passed.</p>
            <%
                } else {
            %>
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Phone Number</th>
                            <th>Role</th>
                            <th>Gender</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (User user : users) {
                        %>
                            <tr>
                                <td><%= user.getFirstName() %> <%= user.getLastName() %></td>
                                <td><%= user.getEmail() %></td>
                                <td><%= user.getPhoneNumber() %></td>
                                <td><%= user.getRole() %></td>
                                <td><%= user.getGender() %></td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/user?action=edit&email=<%= user.getEmail() %>" class="btn-edit">Edit</a>
                                    <form action="user" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="email" value="<%= user.getEmail() %>" />
                                        <button type="submit" onclick="return confirm('Are you sure you want to delete this user?');" class="btn-delete">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>

                <div class="actions">
                    <a href="<%= request.getContextPath() %>/pages/admin/add-user.jsp" class="btn-add">Add User</a>
                </div>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>