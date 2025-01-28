package dao;
import dto.User;
import connection.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDao {
    public User userLogin(String email, String password) {
        User user = null;
        String query = "SELECT * FROM users WHERE email=? AND password=?";
        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pst = con.prepareStatement(query)
        ) {
            pst.setString(1, email);
            pst.setString(2, password);
            try (ResultSet rs = pst.executeQuery()) { 
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("userid"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return user;
    }
    
    public void registerUser(User user) throws SQLException, ClassNotFoundException {
        String query = "INSERT INTO users (name, email, password) VALUES (?, ?, ?)";
        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement pst = con.prepareStatement(query)
        ) {
            pst.setString(1, user.getName());
            pst.setString(2, user.getEmail());
            pst.setString(3, user.getPassword());
            
            pst.executeUpdate();
        }
    }
}