package servlets;

import com.google.gson.Gson;
import dao.ProductDao;
import dto.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductDao productDAO = new ProductDao();
        List<Product> products = productDAO.getAllProducts();

        // Set content type for JSON response
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Convert the list of products to JSON and write it to the response
        Gson gson = new Gson();
        String json = gson.toJson(products);
        response.getWriter().write(json);
    }
}
