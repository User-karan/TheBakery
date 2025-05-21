<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Edit Product</title>
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

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #555;
        }

        input[type="text"],
        input[type="number"],
        textarea,
        input[type="file"] {
            width: 100%;
            padding: 8px 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        textarea {
            resize: vertical;
            min-height: 80px;
        }

        img {
            margin-top: 10px;
            border-radius: 6px;
            border: 1px solid #ddd;
            max-width: 100px;
            display: block;
        }

        button {
            margin-top: 20px;
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            border: none;
            border-radius: 6px;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #45a049;
        }

    </style>
</head>
<body>
    <div class="container">
        <h2>Edit Product</h2>
        <form action="${pageContext.request.contextPath}/product" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update" />
            <input type="hidden" name="productId" value="${product.productId}" />

            <label for="productName">Name:</label>
            <input type="text" name="productName" value="${product.productName}" />

            <label for="productDescription">Description:</label>
            <textarea name="productDescription" value="${product.productDescription}"></textarea>

            <label for="price">Price:</label>
            <input type="number" step="0.01" name="price" value="${product.price}" />

            <label for="category">Category:</label>
            <input type="text" name="category" value="${product.category}" />

            <label for="stockQuantity">Stock:</label>
            <input type="number" name="stockQuantity" value="${product.stockQuantity}" />

            <label for="productImage">Image:</label>
            <input type="file" name="productImage" />
            <c:if test="${not empty product.productImage}">
                <img src="${pageContext.request.contextPath}/${product.productImage}" alt="Current Image" />
            </c:if>

            <button type="submit">Update Product</button>

<a href="${pageContext.request.contextPath}/product?action=list" style="text-decoration: none;">
    <button type="button" style="background-color: #ccc; color: #333; margin-top: 10px;">Back</button>
</a>

        </form>
    </div>
</body>
</html>
