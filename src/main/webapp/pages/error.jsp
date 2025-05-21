<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Error - Something Went Wrong</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8d7da;
            color: #721c24;
            margin: 0;
            padding: 0;
        }
        .container {
            margin: 50px auto;
            padding: 30px;
            max-width: 600px;
            background-color: #f1b0b7;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
        }
        h1 {
            font-size: 24px;
        }
        p {
            font-size: 16px;
        }
        a {
            color: #721c24;
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Oops! An error occurred.</h1>
    <p>
        <c:choose>
            <c:when test="${not empty errorMessage}">
                ${errorMessage}
            </c:when>
            <c:otherwise>
                An unexpected error occurred. Please try again later.
            </c:otherwise>
        </c:choose>
    </p>
    <p>
        <a href="<c:url value='/pages/index.jsp' />">Return to Home</a>
    </p>
</div>
</body>
</html>
