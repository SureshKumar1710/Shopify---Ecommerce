package dao;

import connection.DBConnection;
import dto.Order;
import dto.OrderItem;
import dto.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDao {
    
    public List<Order> getOrdersByUser(int userId) {
        List<Order> orders = new ArrayList<>();
        String orderQuery = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(orderQuery)) {
            
            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();
            
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setShippingAddress(rs.getString("shipping_address"));
                
                // Get order items for this order
                order.setOrderItems(getOrderItems(order.getOrderId()));
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    private List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String query = "SELECT oi.*, p.name, p.image_path FROM order_items oi " +
                      "JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {
            
            pst.setInt(1, orderId);
            ResultSet rs = pst.executeQuery();
            
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("order_item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPriceAtTime(rs.getDouble("price_at_time"));
                
                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setName(rs.getString("name"));
                product.setPrice(rs.getDouble("price_at_time"));
                product.setImage(rs.getString("image_path"));
                item.setProduct(product);
                
                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public int createOrder(int userId, double totalAmount, String shippingAddress, List<OrderItem> items) {
        String orderQuery = "INSERT INTO orders (user_id, total_amount, shipping_address, status) VALUES (?, ?, ?, 'PENDING')";
        String itemQuery = "INSERT INTO order_items (order_id, product_id, quantity, price_at_time) VALUES (?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            
            try (PreparedStatement pst = con.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS)) {
                pst.setInt(1, userId);
                pst.setDouble(2, totalAmount);
                pst.setString(3, shippingAddress);
                pst.executeUpdate();
                
                int orderId;
                try (ResultSet rs = pst.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    } else {
                        throw new SQLException("Creating order failed, no ID obtained.");
                    }
                }
                
                // Insert order items
                try (PreparedStatement itemPst = con.prepareStatement(itemQuery)) {
                    for (OrderItem item : items) {
                        itemPst.setInt(1, orderId);
                        itemPst.setInt(2, item.getProductId());
                        itemPst.setInt(3, item.getQuantity());
                        itemPst.setDouble(4, item.getPriceAtTime());
                        itemPst.executeUpdate();
                    }
                }
                
                con.commit();
                return orderId;
            } catch (Exception e) {
                con.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }
}