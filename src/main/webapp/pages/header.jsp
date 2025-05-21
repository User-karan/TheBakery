<%@ page session="true" %> 
 
<!DOCTYPE html> 
<html lang="en"> 
<head> 
  <meta charset="UTF-8" /> 
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/> 
  <title>I Doughnut Care</title> 
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/header.css" /> 
  <style> 
    .nav-right { 
      display: flex; 
      align-items: center; 
      gap: 1rem; 
    } 

    .nav-center { 
      display: flex; 
      gap: 20px; 
      align-items: center; 
    } 

    .nav-center a { 
      text-decoration: none; 
      color: #6b2b06; 
      font-weight: 600; 
      font-size: 16px; 
      transition: color 0.3s ease; 
    } 

    .nav-center a:hover { 
      color: #d97706; 
    } 

    .profile-icon { 
      background-color: #f28b82; 
      color: white; 
      border-radius: 50%; 
      width: 40px; 
      height: 40px; 
      display: flex; 
      justify-content: center; 
      align-items: center; 
      font-weight: bold; 
      font-size: 16px; 
      text-transform: uppercase; 
    } 
    
    .profile-icon a {
      text-decoration: none;
      color: white;
      display: flex;
      justify-content: center;
      align-items: center;
      width: 100%;
      height: 100%;
    }

    .logout-btn, 
    .login-btn { 
      background-color: #ff6f61; 
      color: white; 
      border: none; 
      padding: 8px 12px; 
      border-radius: 5px; 
      cursor: pointer; 
    } 

    .logout-btn:hover, 
    .login-btn:hover { 
      background-color: #e65b50; 
    } 

    .navbar { 
      background-color: #ffe8c9; 
      padding: 15px 30px; 
      display: flex; 
      justify-content: space-between; 
      align-items: center; 
      border-radius: 0 0 12px 12px; 
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1); 
    } 

    .nav-left { 
      display: flex; 
      align-items: center; 
      gap: 12px; 
    } 

    .nav-logo { 
      width: 80px; 
      height: 80px; 
      border-radius: 50%; 
      object-fit: cover; 
    } 

    .navbar h2 { 
      color: #6b2b06; 
      font-weight: 700; 
    } 
  </style> 
</head> 
<body> 

  <!-- Navbar --> 
  <div class="navbar"> 
    <div class="nav-left"> 
      <img src="../resources/logo1.png" alt="Logo" class="nav-logo" /> 
      <h2>I Doughnut Care</h2> 
    </div> 
	     
	<div class="nav-center"> 
	  <a href="<%= request.getContextPath() %>/pages/index.jsp">Home</a> 
	  <a href="<%= request.getContextPath() %>/UserProductServlet">Products</a> 
	  <a href="<%= request.getContextPath() %>/pages/blog.jsp">Blog</a> 
	  <a href="<%= request.getContextPath() %>/pages/about-us.jsp">About Us</a> 
	  <a href="<%= request.getContextPath() %>/pages/contact-us.jsp">Contact Us</a> 
	</div> 


    <div class="nav-right"> 
      <% 
        String firstName = (String) session.getAttribute("firstName"); 
        String lastName = (String) session.getAttribute("lastName"); 

        if (firstName != null && lastName != null) { 
          String initials = firstName.substring(0, 1).toUpperCase() + lastName.substring(0, 1).toUpperCase(); 
      %> 
        <div class="profile-icon"><a href="<%= request.getContextPath() %>/profile"><%= initials %></a></div> 
        <form action="<%= request.getContextPath() %>/logout" method="get" style="margin: 0;"> 
          <button type="submit" class="logout-btn">Logout</button> 
        </form> 
      <% 
        } else { 
      %> 
        <a href="<%= request.getContextPath() %>/pages/login.jsp"> 
          <button class="login-btn">Login</button> 
        </a> 
      <% 
        } 
      %> 
    </div> 
  </div> 

</body> 
</html> 