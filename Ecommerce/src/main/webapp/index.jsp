<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home</title>
    <%@ include file="includes/header.jsp" %>
    <link rel="stylesheet" href="includes/home_styles.css">
    <script>
        function toggleDetails(cardId, event) {
            if (!event.target.classList.contains('add-to-cart') && 
                !event.target.classList.contains('buy')) {
                const details = document.getElementById(cardId);
                details.style.display = details.style.display === "block" ? "none" : "block";
            }
        }

        function addToCart(productId, event) {
            event.stopPropagation(); 
            const auth = <%= session.getAttribute("auth") != null %>;
            
            if (!auth) {
                window.location.href = 'login.jsp';
                return;
            }
            
            fetch('CartServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=add&productId=${productId}`
            })
            .then(response => {
                if (response.ok) {
                    alert('Product added to cart!');
                } else if (response.status === 401) {
                    window.location.href = 'login.jsp';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error adding product to cart');
            });
        }

        function loadProducts() {
            fetch('ProductServlet')
                .then(response => response.json())  
                .then(products => {
                    const cardContainer = document.querySelector('.card-container');
                    if (products && products.length > 0) {
                        products.forEach(product => {
                            const card = document.createElement('div');
                            card.classList.add('card');
                            card.setAttribute('onclick', `toggleDetails('details-${product.id}', event)`);

                            card.innerHTML = `
                                <img src="images/${product.image}" alt="${product.name}">
                                <div class="card-content">
                                    <h4>${product.name}</h4>
                                    <p>Category: ${product.category}</p>
                                    <span>Price: $${product.price}</span>
                                </div>
                                <div class="card-details" id="details-${product.id}">
                                    <p>${product.description}</p>
                                    <button class="add-to-cart" onclick="addToCart(${product.id}, event)">
                                        Add to Cart
                                    </button>
                                    <button class="buy" onclick="window.location.href='order.jsp?productId=${product.id}'; event.stopPropagation();">
                                        Buy Now
                                    </button>
                                </div>
                            `;
                            cardContainer.appendChild(card);
                        });
                    } else {
                        cardContainer.innerHTML = '<p>No products available at the moment.</p>';
                    }
                })
                .catch(error => {
                    console.error('Error fetching products:', error);
                    document.querySelector('.card-container').innerHTML = '<p>Error loading products.</p>';
                });
        }

        window.onload = loadProducts;
    </script>
</head>
<body>
    <div class="card-container">
        <!-- Products will be dynamically loaded here -->
    </div>
</body>
</html>