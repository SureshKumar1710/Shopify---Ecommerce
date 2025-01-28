<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dto.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Orders</title>
    <%@include file="includes/header.jsp"%>
    <link rel="stylesheet" href="includes/header_styles.css">
    <style>
        .orders-container {
            max-width: 1000px;
            margin: 20px auto;
            padding: 20px;
        }
        .order-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            padding: 20px;
        }
        .order-header {
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
            margin-bottom: 15px;
        }
        .order-items {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }
        .order-item {
            display: flex;
            align-items: center;
            padding: 10px;
            border: 1px solid #eee;
            border-radius: 4px;
            width: 100%;
        }
        .order-item img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            margin-right: 15px;
            border-radius: 4px;
        }
        .order-status {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9em;
            background-color: #e8f5e9;
            color: #2e7d32;
        }
        .order-total {
            text-align: right;
            margin-top: 15px;
            font-weight: bold;
            font-size: 1.1em;
        }
        .no-orders {
            text-align: center;
            padding: 40px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <%
    User auth = (User) session.getAttribute("auth");
    if (auth == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    OrderDao orderDao = new OrderDao();
    List<Order> orders = orderDao.getOrdersByUser(auth.getId());
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");
    sdf.setTimeZone(TimeZone.getTimeZone("Asia/Kolkata")); 
    %>

    <div class="orders-container">
        <h2>My Orders</h2>
        
        <% if (orders != null && !orders.isEmpty()) { %>
            <% for (Order order : orders) { %>
                <div class="order-card">
                    <div class="order-header">
                        <div>
                            <h3>Order #<%= order.getOrderId() %></h3>
                            <p>Placed on: <%= sdf.format(order.getOrderDate()) %></p>
                        </div>
                        <span class="order-status"><%= order.getStatus() %></span>
                    </div>
                    
                    <div class="order-items">
                        <% for (OrderItem item : order.getOrderItems()) { %>
                            <div class="order-item">
                                <img src="images/<%= item.getProduct().getImage() %>" 
                                     alt="<%= item.getProduct().getName() %>">
                                <div>
                                    <h4><%= item.getProduct().getName() %></h4>
                                    <p>Quantity: <%= item.getQuantity() %></p>
                                    <p>Price: $<%= String.format("%.2f", item.getPriceAtTime()) %></p>
                                </div>
                            </div>
                        <% } %>
                    </div>
                    
                    <div class="order-total">
                        Total Amount: $<%= String.format("%.2f", order.getTotalAmount()) %>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="no-orders">
                <h3>No orders found</h3>
                <p>You haven't placed any orders yet.</p>
            </div>
        <% } %>
    </div>
</body>
</html>