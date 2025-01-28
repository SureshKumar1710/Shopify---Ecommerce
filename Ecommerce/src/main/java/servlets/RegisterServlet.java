package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLIntegrityConstraintViolationException;

import dao.UserDao;
import dto.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDao userDao;

    public RegisterServlet() {
        userDao = new UserDao();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        HttpSession session = request.getSession();
        
        if (!password.equals(confirmPassword)) {
            session.setAttribute("loginMessage", "Passwords do not match!");
            response.sendRedirect("register.jsp");
            return;
        }
        
        User newUser = new User();
        newUser.setName(name);
        newUser.setEmail(email);
        newUser.setPassword(password);
        
        try {
            userDao.registerUser(newUser);

            session.setAttribute("loginMessage", "Registration successful! Please login.");
            response.sendRedirect("login.jsp");
        } 
        catch (SQLIntegrityConstraintViolationException e) {
        	session.setAttribute("loginMessage", "Registration failed. Email might already exist.");
            response.sendRedirect("register.jsp");
            e.printStackTrace();
        }
        catch (Exception e) {
            session.setAttribute("loginMessage", "An error occurred during registration.");
            response.sendRedirect("register.jsp");
            e.printStackTrace();
        }
    }
}