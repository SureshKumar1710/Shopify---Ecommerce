package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.google.gson.Gson;
import dao.CartDao;
import dto.User;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CartDao cartDao = new CartDao();
    private final Gson gson = new Gson();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User auth = (User) request.getSession().getAttribute("auth");
        if (auth == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");
        int productId = Integer.parseInt(request.getParameter("productId"));
        
        switch (action) {
            case "add":
                cartDao.addToCart(auth.getId(), productId);
                break;
            case "update":
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                cartDao.updateQuantity(auth.getId(), productId, quantity);
                break;
            case "remove":
                cartDao.removeFromCart(auth.getId(), productId);
                break;
        }
        
        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(cartDao.getCartItems(auth.getId())));
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User auth = (User) request.getSession().getAttribute("auth");
        if (auth == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        response.setContentType("application/json");
        response.getWriter().write(gson.toJson(cartDao.getCartItems(auth.getId())));
    }
}