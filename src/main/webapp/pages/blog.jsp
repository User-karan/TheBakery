<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bakery Blog</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/blog.css">
</head>
<body>
<%@ include file="header.jsp" %>

<main class="blog-container">
    <article class="blog-entry">
        <div class="blog-image">
            <img src="../resources/doughnuts.jpeg" alt="Delicious Donuts">
        </div>
        <div class="blog-content">
            <h2>Donuts</h2>
            <p>Donuts are at the heart of our bakery, and making them is an art. From mixing the dough just right to the golden deep-fry, each donut is a masterpiece waiting to be devoured.</p>
        </div>
    </article>

    <article class="blog-entry reverse">
        <div class="blog-image">
            <img src="../resources/sweets.jpeg" alt="Tasty Cupcakes">
        </div>
        <div class="blog-content">
            <h2>Cupcakes</h2>
            <p>Cupcakes may be small, but they pack a punch of flavor and joy. Whether you’re treating yourself or gifting a box, they bring smiles with every bite.</p>
        </div>
    </article>

    <article class="blog-entry">
        <div class="blog-image">
            <img src="../resources/cake.jpeg" alt="Beautiful Cakes">
        </div>
        <div class="blog-content">
            <h2>Cakes</h2>
            <p>Cakes are more than dessert; they’re part of every celebration. From birthdays to anniversaries, we bake with purpose and passion to make your moments sweet.</p>
        </div>
    </article>

    <article class="blog-entry reverse">
        <div class="blog-image">
            <img src="../resources/croissant.jpeg" alt="Fresh Croissants">
        </div>
        <div class="blog-content">
            <h2>Croissants</h2>
            <p>Our croissants are buttery, golden, and baked fresh every morning. Made using traditional techniques, each croissant has the perfect flaky texture you crave.</p>
        </div>
    </article>
</main>

<%@ include file="footer.jsp" %>
</body>
</html>