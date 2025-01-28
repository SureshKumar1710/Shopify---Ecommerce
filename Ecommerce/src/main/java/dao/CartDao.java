package dao;

import connection.DBConnection;
import dto.CartItem;
import dto.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDao {
    
    public void addToCart(int userId, int productId) {
        String checkQuery = "SELECT * FROM cart_details WHERE user_id = ? AND product_id = ?";
        String insertQuery = "INSERT INTO cart_details (user_id, product_id, quantity) VALUES (?, ?, 1)";
        String updateQuery = "UPDATE cart_details SET quantity = quantity + 1 WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            // Check if item exists
            try (PreparedStatement ps = conn.prepareStatement(checkQuery)) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    // Update quantity
                    try (PreparedStatement updatePs = conn.prepareStatement(updateQuery)) {
                        updatePs.setInt(1, userId);
                        updatePs.setInt(2, productId);
                        updatePs.executeUpdate();
                    }
                } else {
                    // Insert new item
                    try (PreparedStatement insertPs = conn.prepareStatement(insertQuery)) {
                        insertPs.setInt(1, userId);
                        insertPs.setInt(2, productId);
                        insertPs.executeUpdate();
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    public void updateQuantity(int userId, int productId, int quantity) {
        String query = "UPDATE cart_details SET quantity = ? WHERE user_id = ? AND product_id = ?";
        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(query)
        ) {
            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setInt(3, productId);
            ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    public void removeFromCart(int userId, int productId) {
        String query = "DELETE FROM cart_details WHERE user_id = ? AND product_id = ?";
        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(query)
        ) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
    
    public List<CartItem> getCartItems(int userId) {
        List<CartItem> cartItems = new ArrayList<>();
        String query = "SELECT cd.*, p.* FROM cart_details cd JOIN products p ON cd.product_id = p.product_id WHERE cd.user_id = ?";
        
        try (
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(query)
        ) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                
                // Set product details
                Product product = new Product(
                    rs.getInt("product_id"),
                    rs.getString("name"),
                    rs.getString("category"),
                    rs.getDouble("price"),
                    rs.getString("description"),
                    rs.getString("image_path")
                );
                item.setProduct(product);
                
                cartItems.add(item);
            }
        } 
        catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return cartItems;
    }
    
    public void clearCart(int userId) {
        String query = "DELETE FROM cart_details WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            pst.setInt(1, userId);
            pst.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}