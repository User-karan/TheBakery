<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${param.timeout eq 'true'}">
  <div style="color: red; font-weight: bold; margin: 10px;">
      Your session has expired. Please log in again.
  </div>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>I Doughnut Care</title>
  <link rel="stylesheet" href="../css/index.css" />
  <%@ include file="header.jsp" %>
</head>
<body>

  <!-- Homepage Intro -->
  <div class="homepage-intro">
    <div class="intro-text">
      <h1>Welcome to I Doughnut Care - Bakery</h1>
      <p>Freshly baked goods delivered with love!</p>
      <div class="intro-buttons">
        <a href="<%= request.getContextPath() %>/UserProductServlet"><button class="submit-btn outline">View Menu</button></a>
      </div>
    </div>
    <div class="intro-image">
      <img src="../resources/hungryMan1.jpeg" alt="Bakery illustration" />
    </div>
  </div>


  <c:if test="${not empty errorMessage}">
    <div class="error-message" style="color: red; font-weight: bold;">
      ${errorMessage}
    </div>
  </c:if>

</body>

<%@ include file="footer.jsp" %>

</html>
