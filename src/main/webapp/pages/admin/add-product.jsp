<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Add Product</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f2f2f2;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 500px;
            margin: 50px auto;
            background-color: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        input[type="text"],
        input[type="number"],
        textarea,
        input[type="file"],
        select {
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        button, .back-button {
            padding: 10px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button {
            background-color: #4CAF50;
            color: white;
            margin-top: 10px;
        }

        button:hover {
            background-color: #45a049;
        }

        .back-button {
            margin-top: 20px;
            background-color: #2196F3;
            color: white;
            text-decoration: none;
            text-align: center;
        }

        .back-button:hover {
            background-color: #1976D2;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Add Product</h2>
        <form action="${pageContext.request.contextPath}/product" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="add" />
            <input type="text" name="productName" placeholder="Product Name" required />
            <textarea name="productDescription" placeholder="Description"></textarea>
            <input type="number" step="0.01" name="price" placeholder="Price" required />
            
            <select name="category" required>
                <option value="" disabled selected>Select Category</option>
                <c:forEach items="${categories}" var="category">
                    <option value="${category.categoryName}">${category.categoryName}</option>
                </c:forEach>
            </select>
            
            <input type="number" name="stockQuantity" placeholder="Stock Quantity" />
            <input type="file" name="productImage" />

            <button type="submit">Add Product</button>
        </form>

        <a href="${pageContext.request.contextPath}/product" class="back-button">Back</a>
    </div>
</body>
</html>