<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Login</title>
<%@include file="includes/header.jsp"%>
<link rel="stylesheet" href="includes/header_styles.css">
<link rel="stylesheet" href="includes/login_styles.css">
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
	<div class="login-container">
		<form action="LoginServlet" method="post" class="login-form">
			<h2>Login</h2>
			<div class="input-group">
				<label for="email">Email:</label> <input type="email" id="email"
					name="email" required>
			</div>
			<div class="input-group">
				<label for="password">Password:</label> <input type="password"
					id="password" name="password" required>
			</div>
			<button type="submit" class="login-button">Login</button>
			<div class="new-user-container">
				<hr>
				<p class="new-user-text">
					New user? <a href="register.jsp">Sign up</a>
				</p>
			</div>

		</form>
	</div>
</body>

</html>
