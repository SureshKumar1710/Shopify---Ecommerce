package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import com.google.gson.JsonObject;

import dao.CartDao;
import dao.OrderDao;
import dto.*;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private OrderDao orderDao;
    private CartDao cartDao;

    public void init() {
        orderDao = new OrderDao();
        cartDao = new CartDao();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User auth = (User) session.getAttribute("auth");
        
        if (auth == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String address = request.getParameter("address");
//        if (address == null || address.trim().isEmpty()) {
//            sendJsonResponse(response, false, "Shipping address is required!");
//            return;
//        }

        try {
            List<OrderItem> orderItems = new ArrayList<>();
            double totalAmount = 0;

            // Check if ordering from cart or single product
            String productId = request.getParameter("productId");
            if (productId != null) {
                // Single product order
                OrderItem item = new OrderItem();
                item.setProductId(Integer.parseInt(productId));
                item.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                item.setPriceAtTime(Double.parseDouble(request.getParameter("price")));
                orderItems.add(item);
                totalAmount += item.getQuantity() * item.getPriceAtTime();
            } else {
                // Cart order
                List<CartItem> cartItems = cartDao.getCartItems(auth.getId());
                for (CartItem cartItem : cartItems) {
                    OrderItem item = new OrderItem();
                    item.setProductId(cartItem.getProductId());
                    item.setQuantity(cartItem.getQuantity());
                    item.setPriceAtTime(cartItem.getProduct().getPrice());
                    orderItems.add(item);
                    totalAmount += item.getQuantity() * item.getPriceAtTime();
                }
            }

            int orderId = orderDao.createOrder(auth.getId(), totalAmount, address, orderItems);
            
            if (orderId > 0) {
                // Clear cart if ordering from cart
                if (productId == null) {
                    cartDao.clearCart(auth.getId());
                }
                sendJsonResponse(response, true, "Order placed successfully! Redirecting to My Orders...");
            } else {
                sendJsonResponse(response, false, "Failed to place order. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            sendJsonResponse(response, false, "Error placing order: " + e.getMessage());
        }
    }

    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) 
            throws IOException {
        JsonObject json = new JsonObject();
        json.addProperty("success", success);
        json.addProperty("message", message);
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(json.toString());
    }
}