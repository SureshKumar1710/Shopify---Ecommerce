<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dto.*" %>
<%@ page import="dao.*" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order</title>
    <%@include file="includes/header.jsp"%>
    <link rel="stylesheet" href="includes/header_styles.css">
    <style>
        .order-container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            background: #fff;
        }
        .order-item {
            display: flex;
            margin: 10px 0;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .order-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            margin-right: 20px;
            border-radius: 5px;
        }
        .item-details {
            flex-grow: 1;
        }
        .address-form {
            margin-top: 20px;
        }
        .address-form textarea {
            width: 100%;
            min-height: 100px;
            margin: 10px 0;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            resize: vertical;
        }
        .submit-btn {
            background-color: #4CAF50;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            font-size: 16px;
            margin-top: 20px;
        }
        .submit-btn:hover {
            background-color: #45a049;
        }
        .error-message {
            color: #dc3545;
            padding: 10px;
            margin: 10px 0;
            background-color: #ffe6e6;
            border-radius: 5px;
            text-align: center;
        }
        .order-summary {
            margin-top: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
        .total-amount {
            font-size: 1.2em;
            font-weight: bold;
            text-align: right;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 2px solid #ddd;
        }
        .quantity-input {
            width: 60px;
            padding: 5px;
            margin: 5px 0;
            border: 1px solid #ddd;
            border-radius: 3px;
        }
    </style>
    <script>
    function validateForm() {
        const address = document.getElementById('shipping-address').value.trim();
        
        const form = document.querySelector('.order-form');
        const formData = new FormData(form);
        
        fetch('OrderServlet', {
            method: 'POST',
            body: new URLSearchParams(formData)
        })
        .then(response => response.json())
        .then(data => {
            alert(data.message);
            if (data.success) {
                window.location.href = 'MyOrders.jsp';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error placing order. Please try again.');
        });
        
        return false; // Prevent form submission
    }
    
    function updateTotal(quantity,productPrice) {
    	let quan=parseInt(quantity);
        let total=quantity*productPrice;
        document.getElementById('total-amount').textContent = total.toFixed(2);
    }
</script></head>
<body>
    <%
    User auth = (User) session.getAttribute("auth");
    if (auth == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String orderMessage = (String) session.getAttribute("orderMessage");
    if (orderMessage != null) {
        out.println("<div class='error-message'>" + orderMessage + "</div>");
        session.removeAttribute("orderMessage");
    }
    %>

    <div class="order-container">
        <h2>Order Summary</h2>
        
        <form action="OrderServlet" method="post" class="order-form" onsubmit="return validateForm()">
            <%
            double total = 0;
            String productId = request.getParameter("productId");
            String allItems = request.getParameter("all");
            
            if (productId != null) {
                // Single product order
                ProductDao productDao = new ProductDao();
                Product product = productDao.getProduct(Integer.parseInt(productId));
                if (product != null) {
                    total = product.getPrice();
            %>
                <div class="order-item">
                    <img src="images/<%= product.getImage() %>" alt="<%= product.getName() %>">
                    <div class="item-details">
                        <h3><%= product.getName() %></h3>
                        <p>Price: $<%= product.getPrice() %></p>
                        <input type="hidden" name="productId" value="<%= product.getId() %>">
                        <input type="hidden" name="price" value="<%= product.getPrice() %>">
                        <div>
                            <label for="quantity-<%= product.getId() %>">Quantity:</label>
                            <input type="number" 
                                   id="quantity-<%= product.getId() %>"
                                   name="quantity" 
                                   value="1" 
                                   min="1" 
                                   class="quantity-input"
                                   onchange="updateTotal(value, <%= product.getPrice() %>)">
                        </div>
                    </div>
                </div>
            <%
                }
            } else if (allItems != null && allItems.equals("true")) {
                // Cart items order
                CartDao cartDao = new CartDao();
                List<CartItem> cartItems = cartDao.getCartItems(auth.getId());
                
                if (cartItems != null && !cartItems.isEmpty()) {
                    for (CartItem item : cartItems) {
                        total += item.getProduct().getPrice() * item.getQuantity();
            %>
                <div class="order-item">
                    <img src="images/<%= item.getProduct().getImage() %>" 
                         alt="<%= item.getProduct().getName() %>">
                    <div class="item-details">
                        <h3><%= item.getProduct().getName() %></h3>
                        <p>Price: $<%= item.getProduct().getPrice() %></p>
                        <p>Quantity: <%= item.getQuantity() %></p>
                        <p>Subtotal: $<%= item.getProduct().getPrice() * item.getQuantity() %></p>
                    </div>
                </div>
            <%
                    }
                }
            }
            %>

            <div class="order-summary">
                <div class="total-amount">
                    Total Amount: $<span id="total-amount"><%= String.format("%.2f", total) %></span>
                </div>
            </div>

            <div class="address-form">
                <h3>Shipping Information</h3>
                <textarea id="shipping-address" 
                          name="address" 
                          placeholder="Enter your complete shipping address"
                          required></textarea>
            </div>

            <button type="submit" class="submit-btn">Place Order</button>
        </form>
    </div>
</body>
</html>