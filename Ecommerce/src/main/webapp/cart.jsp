
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dto.User"%>
<%@ page import="dto.CartItem"%>
<%@ page import="java.util.List"%>
<%@ page import="dao.CartDao"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shopping Cart</title>
    <%@include file="includes/header.jsp"%>
    <link rel="stylesheet" href="includes/cart_styles.css">
    <script>
            
        function updateQuantity(productId, change) {
            const quantityInput = document.getElementById(`quantity-${productId}`);
            let newQuantity = parseInt(quantityInput.value) + change;
            
            if (newQuantity < 1) newQuantity = 1;
            
            fetch('CartServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=update&productId=${productId}&quantity=${newQuantity}`
            })
            .then(response => response.json())
            .then(() => {
                quantityInput.value = newQuantity;
                updateTotal();
            })
            .catch(error => console.error('Error:', error));
        }

        function removeItem(productId) {
            fetch('CartServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=remove&productId=${productId}`
            })
            .then(response => response.json())
            .then(() => {
                location.reload();
            })
            .catch(error => console.error('Error:', error));
        }

        function updateTotal() {
            let total = 0;
            document.querySelectorAll('.cart-item').forEach(item => {
                const price = parseFloat(item.querySelector('.item-price').dataset.price);
                const quantity = parseInt(item.querySelector('.quantity-input').value);
                total += price * quantity;
            });
            document.getElementById('cart-total').textContent = total.toFixed(2);
        }

        window.onload = updateTotal;
        
    </script>
</head>
<body>
    <div class="cart-container">
        <h2>Shopping Cart</h2>
        
        <%
        User auth = (User) request.getSession().getAttribute("auth");
        if (auth != null) {
            CartDao cartDao = new CartDao();
            List<CartItem> cartItems = cartDao.getCartItems(auth.getId());
            
            if (cartItems != null && !cartItems.isEmpty()) {
                for (CartItem item : cartItems) {
        %>
        <div class="cart-item">
            <img src="images/<%= item.getProduct().getImage() %>" alt="<%= item.getProduct().getName() %>">
            <div class="item-details">
                <h3><%= item.getProduct().getName() %></h3>
                <p class="item-price" data-price="<%= item.getProduct().getPrice() %>">
                    Price: $<%= item.getProduct().getPrice() %>
                </p>
            </div>
            <div class="quantity-controls">
                <button class="quantity-btn" onclick="updateQuantity(<%= item.getProductId() %>, -1)">-</button>
                <input type="number" id="quantity-<%= item.getProductId() %>" 
                       class="quantity-input" value="<%= item.getQuantity() %>" readonly>
                <button class="quantity-btn" onclick="updateQuantity(<%= item.getProductId() %>, 1)">+</button>
            </div>
            <button class="buy-btn" onclick="window.location.href='order.jsp?productId=<%= item.getProductId() %>'">
                Buy Now
            </button>
            <button onclick="removeItem(<%= item.getProductId() %>)" style="margin-left: 10px;">
                Remove
            </button>
        </div>
        <%
                }
        %>
        <div style="text-align: right; margin-top: 20px;">
            <h3>Total: $<span id="cart-total">0.00</span></h3>
        </div>
        <button class="buy-all-btn" onclick="window.location.href='order.jsp?all=true'">
            Buy All Items
        </button>
        <%
            } else {
        %>
        <div class="empty-cart">
            <h3>Your cart is empty</h3>
            <p>Add some products to your cart!</p>
        </div>
        <%
            }
        } else {
        %>
        <div class="empty-cart">
            <h3>Please login to view your cart</h3>
        </div>
        <%
        }
        %>
    </div>
</body>
</html>