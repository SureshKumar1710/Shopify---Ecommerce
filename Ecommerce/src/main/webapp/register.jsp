<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <%@include file="includes/header.jsp"%>
    <link rel="stylesheet" href="includes/header_styles.css">
    <link rel="stylesheet" href="includes/register_styles.css">
    <script>
    window.onload = function() {
        const loginMessage = '<%=session.getAttribute("loginMessage") != null ? session.getAttribute("loginMessage") : ""%>';
        if (loginMessage) {
            alert(loginMessage);
            <%session.removeAttribute("loginMessage");%>
        }
    }
    </script>
</head>

<body>
    <div class="register-container">
        <form action="RegisterServlet" method="post" class="register-form">
            <h2>Register</h2>
            <div class="input-group">
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="input-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="input-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="input-group">
                <label for="confirm-password">Confirm Password:</label>
                <input type="password" id="confirm-password" name="confirmPassword" required>
            </div>
            <button type="submit" class="register-button">Register</button>
        </form>
    </div>
</body>

</html>
