<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Contact Us | I Doughnut Care</title>
 <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/contact-us.css" />
   <%@ include file="header.jsp" %>
</head>
<body>


  <main>
    <section class="contact-section">
      <h2>Contact Us</h2>

      <div class="contact-grid">
        <!-- Left box: Contact Info -->
        <div class="contact-info-box">
          <h3>📍 Visit Us</h3>
          <p>123 Sprinkle Street<br>Donutville, DC 45678</p>

          <h3>📞 Call</h3>
          <p>+1 (555) 123-4567</p>

          <h3>📧 Email</h3>
          <p>hello@idoughnutcare.com</p>
        </div>

        <!-- Right box: Contact Form -->
        <div class="contact-form-box">
          <form class="contact-form">
            <input type="text" name="name" placeholder="Your Name" required>
            <input type="email" name="email" placeholder="Your Email" required>
            <textarea name="message" placeholder="Your Message" required></textarea>
            <button type="submit">Send Message</button>
          </form>
        </div>
      </div>

      <!-- Map Section -->
      <div class="map-box">
        <img src="https://via.placeholder.com/1000x300?text=Map+Location+Here" alt="Map showing bakery location">
      </div>
    </section>
  </main>
</body>
  <%@ include file="footer.jsp" %>
</html>