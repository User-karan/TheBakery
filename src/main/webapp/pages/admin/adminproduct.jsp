<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="models.Product" %> 

<%
    // Authentication check
    if (!"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get products from request attribute
    ArrayList<Product> products = (ArrayList<Product>) request.getAttribute("products");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Product List</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        /* Only product list specific styles kept */
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
                    <li class="active">
                        <i class="fas fa-cookie-bite"></i> <a href="<%= request.getContextPath() %>/product">Product</a>
                    </li>
                    <li><i class="fas fa-users"></i> <a href="<%= request.getContextPath() %>/user">Users</a></li>
                    <li><i class="fas fa-shopping-cart"></i><a href="<%= request.getContextPath() %>/orders">Orders</a></li>
          			<li><i class="fas fa-user-circle"></i> <a href="${pageContext.request.contextPath}/profile">Profile</a></li>
                    <li><i class="fas fa-sign-out-alt"></i> <a href="<%= request.getContextPath() %>/logout">Logout</a></li>
                </ul>
            </nav>
        </aside>

        <div class="main-content">
            <h2>Admin Product List</h2>

            <% if (request.getParameter("success") != null) { %>
                <p class="flash-message success"><%= request.getParameter("success") %></p>
            <% } %>
            <% if (request.getParameter("error") != null) { %>
                <p class="flash-message error"><%= request.getParameter("error") %></p>
            <% } %>

            <% if (products == null || products.isEmpty()) { %>
                <p class="notice">No products found or the product list was not passed.</p>
            <% } %>

            <table>
                <thead>
                    <tr>
                        <th>Product Image</th>
                        <th>Product Name</th>
                        <th>Price</th>
                        <th>Stock Quantity</th>
                        <th>Added On</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (products != null) { 
                        for (Product product : products) { %>
                        <tr>
                            <td>
                                <% if (product.getProductImage() != null && !product.getProductImage().isEmpty()) { %>
                                    <img src="<%= product.getProductImage() %>" alt="<%= product.getProductName() %>" style="max-width: 100px; height: auto; border-radius: 8px;" />
                                <% } %>
                            </td>
                            <td><%= product.getProductName() %></td>
                            <td>Rs. <%= product.getPrice() %></td>
                            <td><%= product.getStockQuantity() %></td>
                            <td><%= product.getEntryDate().toString().substring(0, 10) %></td>
                            <td>
                                <a href="<%= request.getContextPath() %>/product?action=edit&id=<%= product.getProductId() %>" class="btn-edit">Edit</a>
                                <form action="product" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete" />
                                    <input type="hidden" name="id" value="<%= product.getProductId() %>" />
                                    <button type="submit" onclick="return confirm('Are you sure you want to delete this product?');" class="btn-delete">Delete</button>
                                </form>
                            </td>
                        </tr>
                    <%   }
                       } %>
                </tbody>
            </table>

            <div class="actions">
                <a href="<%= request.getContextPath() %>/product?action=add" class="btn-add">Add Product</a>
            </div>
        </div>
    </div>
</body>
</html>