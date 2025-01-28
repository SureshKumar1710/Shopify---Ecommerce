<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dto.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="includes/header_styles.css">
    <script>
        // Display logout success message if it exists in the session
        window.onload = function() {
            const logoutMessage = '<%= session.getAttribute("logoutMessage") != null ? session.getAttribute("logoutMessage") : "" %>';
            if (logoutMessage) {
                alert(logoutMessage);
                // Clear the message after showing the alert
                <% session.removeAttribute("logoutMessage");%> <!-- Remove attribute outside JS -->
            }
        }
    </script>
</head>
<body>
    <header class="header">
        <div class="logo">Shopify</div>
        <nav class="nav">
            <a href="index.jsp">Home</a>
            <a href="cart.jsp">Cart</a>
            
            <% 
                Object user = session.getAttribute("auth");
                if (user != null) { // If user is logged in
                    User u = (User) user;
                    String name = u.getName();
            %>
                <a href="MyOrders.jsp">Order</a>
                <a href="LogoutServlet">Logout</a>
                <span id="name" style="font-weight: bold; color: yellow; padding-left:8px">Hi, <%= name %></span>
            <% 
                } else { // If user is not logged in
            %>
                <a href="login.jsp">Login</a>
            <% 
                }
            %>
        </nav>
    </header>
</body>
</html>
