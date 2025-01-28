package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import connection.DBConnection;
import dao.UserDao;
import dto.User;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		
		PrintWriter out = response.getWriter();
		String email = request.getParameter("email");
		String password = request.getParameter("password");

		UserDao udao = new UserDao();
		User user = udao.userLogin(email, password);
		
		if (user != null) {
			request.getSession().setAttribute("auth", user);
			response.sendRedirect("index.jsp");
		} 
		else {
			request.getSession().setAttribute("loginMessage", "Incorrect User Credentials");
	        response.sendRedirect("login.jsp");
		}
	}

}
