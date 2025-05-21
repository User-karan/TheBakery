<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>Products - I Doughnut Care</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/products.css" />
    <style>
        /* CSS styles trimmed for brevity (same as your original styling) */
        body {
            font-family: Arial, sans-serif;
            background-color: #fff8f0;
            margin: 0;
        }

        .container { padding: 20px; max-width: 1200px; margin: auto; }
        h2 { text-align: center; color: #663300; margin-bottom: 30px; }
        .search-bar { text-align: center; margin-bottom: 30px; }
        .search-bar input[type="text"] {
            width: 50%; padding: 10px; border-radius: 8px; border: 1px solid #ccc;
        }
        .search-bar button {
            padding: 10px 20px; border: none; background-color: #ff9933;
            color: white; border-radius: 8px; cursor: pointer;
        }

        .product-grid {
            display: flex; flex-wrap: wrap; gap: 20px; justify-content: center;
        }

        .product-card {
            background-color: white; width: 250px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px; overflow: hidden; transition: 0.2s;
            cursor: pointer;
        }

        .product-card img {
            width: 100%; height: 200px; object-fit: cover;
        }

        .product-card .info { padding: 15px; }
        .product-card h3 { margin: 0 0 10px 0; }
        .product-card .price { color: #ff9933; font-weight: bold; margin-bottom: 10px; }

        .btn-cart, .btn-buy {
            flex: 1; padding: 8px; border: none; border-radius: 4px;
            color: white; font-size: 14px; cursor: pointer; text-align: center; text-decoration: none; 
        }

        .btn-cart { background-color: #ff9933; }
        .btn-buy { background-color: #663300; }
        .btn-cart:hover { background-color: #e68a00; }
        .btn-buy:hover { background-color: #4d2600; }

        .no-products { text-align: center; margin-top: 50px; color: #888; }

        .product-modal {
            display: none; position: fixed; z-index: 9999; left: 0; top: 0;
            width: 100%; height: 100%; overflow: auto;
            background-color: rgba(0,0,0,0.7);
            justify-content: center; align-items: center;
        }

        .product-modal-content {
            background-color: #fff; padding: 30px;
            border-radius: 10px; width: 80%; max-width: 700px; position: relative;
        }

        .close-modal {
            position: absolute; top: 15px; right: 20px; font-size: 28px;
            font-weight: bold; color: #555; cursor: pointer;
        }

        .modal-product-image {
            width: 100%; height: 300px; object-fit: cover; border-radius: 10px;
        }

        .modal-product-name { margin-top: 15px; font-size: 24px; color: #333; }
        .modal-product-price { color: #ff9933; font-size: 20px; font-weight: bold; margin-top: 10px; }
        .modal-product-details { margin-top: 20px; }
        .modal-product-details p { margin: 5px 0; color: #555; }

        .modal-actions {
            display: flex; gap: 10px; margin-top: 20px;
        }

        .modal-actions form, .modal-actions a { flex: 1; }
        .modal-actions button, .modal-actions a {
            width: 100%; padding: 10px; border-radius: 5px;
            color: white; text-align: center; text-decoration: none;
            font-weight: bold;
        }

        .modal-actions .btn-cart { background-color: #ff9933; }
        .modal-actions .btn-buy { background-color: #663300; }
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="container">
    <h2>Explore Our Products</h2>

    <div class="search-bar">
        <form method="get" action="${pageContext.request.contextPath}/UserProductServlet">
            <input type="text" name="query" placeholder="Search by product name..." value="${searchQuery}" />
            <input type="hidden" name="action" value="search" />
            <button type="submit">Search</button>
        </form>
    </div>
    <c:choose>
        <c:when test="${empty products}">
            <div class="no-products">No products found. Try a different search.</div>
        </c:when>
        <c:otherwise>
            <div class="product-grid">
                <c:forEach var="product" items="${products}">
                    <div class="product-card" data-id="${product.productId}">
                        <img src="${empty product.productImage ? pageContext.request.contextPath + '/images/default-product.jpg' : product.productImage}" alt="${product.productName}" />
                        <div class="info">
                            <h3>${product.productName}</h3>
                            <div class="price">Rs. ${product.price}</div>
                            <c:choose>
                                <c:when test="${product.stockQuantity > 0}">
                                    <div class="product-buttons">
                                        <a class="btn-buy" href="${pageContext.request.contextPath}/checkout?productId=${product.productId}&quantity=1">Buy Now</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p style="color: red;">Out of Stock</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Modal -->
<div id="productModal" class="product-modal">
    <div class="product-modal-content">
        <button class="close-modal">&times;</button>
        <img id="modalProductImage" class="modal-product-image" src="" alt="Product Image" />
        <h2 id="modalProductName" class="modal-product-name"></h2>
        <div id="modalProductPrice" class="modal-product-price"></div>
        <div class="modal-product-details">
            <p id="modalProductDescription"></p>
            <p><strong>Category:</strong> <span id="modalProductCategory"></span></p>
            <p><strong>Stock:</strong> <span id="modalProductStock"></span></p>
            <p><strong>Product ID:</strong> <span id="modalProductId"></span></p>
        </div>
        <div class="modal-actions">
            <form action="${pageContext.request.contextPath}/cart" method="post">
                <input type="hidden" name="action" value="add" />
                <input type="hidden" name="productId" id="modalHiddenProductId" />
                <input type="number" name="quantity" value="1" min="1" id="modalQuantity" />
                <button type="submit" class="btn-cart">Add to Cart</button>
            </form>
            <a class="btn-buy" id="modalBuyNowLink">Buy Now</a>
        </div>
    </div>
</div>


<script>
    const contextPath = "<%= request.getContextPath() %>";
    const defaultImage = contextPath + "/images/default-product.jpg";

    const products = [
        <c:forEach var="product" items="${products}" varStatus="loop">
            {
                id: "${product.productId}",
                name: "${product.productName}",
                description: "${fn:escapeXml(product.productDescription)}",
                price: "${product.price}",
                category: "${product.category}",
                stock: "${product.stockQuantity}",
                image: "${empty product.productImage ? '' : product.productImage}"
            }<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    document.querySelectorAll('.product-card').forEach(card => {
        card.addEventListener('click', () => {
            const productId = card.getAttribute('data-id');
            const product = products.find(p => p.id === productId);

            if (product) {
                document.getElementById('modalProductName').textContent = product.name;
                document.getElementById('modalProductDescription').textContent = product.description;
                document.getElementById('modalProductPrice').textContent = 'Rs. ' + product.price;
                document.getElementById('modalProductCategory').textContent = product.category;
                document.getElementById('modalProductStock').textContent = product.stock;
                document.getElementById('modalProductId').textContent = product.id;
                document.getElementById('modalHiddenProductId').value = product.id;
                document.getElementById('modalQuantity').max = product.stock;
                document.getElementById('modalBuyNowLink').href = `${contextPath}/checkout?productId=${product.id}&quantity=1`;

                const imageSrc = product.image && product.image.trim() !== "" ? product.image : defaultImage;
                document.getElementById('modalProductImage').src = imageSrc;

                document.getElementById('productModal').style.display = 'flex';
            }
        });
    });

    document.querySelector('.close-modal').addEventListener('click', () => {
        document.getElementById('productModal').style.display = 'none';
    });

    window.addEventListener('click', e => {
        const modal = document.getElementById('productModal');
        if (e.target === modal) {
            modal.style.display = 'none';
        }
    });
</script>

</body>
</html>
