package com.example.product.controller;

import com.example.product.dao.ProductDAO;
import com.example.product.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Controller cho chức năng quản lý sản phẩm.
 *   GET  /products                  -> danh sách
 *   GET  /products?action=new       -> form thêm
 *   GET  /products?action=edit&id=1 -> form sửa
 *   POST /products?action=insert | update | delete
 */
@WebServlet(name = "ProductServlet", urlPatterns = "/products")
public class ProductServlet extends HttpServlet {

    private static final String LIST_VIEW = "/WEB-INF/views/list.jsp";
    private static final String FORM_VIEW = "/WEB-INF/views/form.jsp";

    private final ProductDAO dao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
                    break;
                case "edit":
                    showEditForm(req, resp);
                    break;
                default:
                    listProducts(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException("Lỗi cơ sở dữ liệu", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "";

        try {
            switch (action) {
                case "insert":
                    saveProduct(req, resp, false);
                    break;
                case "update":
                    saveProduct(req, resp, true);
                    break;
                case "delete":
                    deleteProduct(req, resp);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/products");
            }
        } catch (SQLException e) {
            throw new ServletException("Lỗi cơ sở dữ liệu", e);
        }
    }

    private void listProducts(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        List<Product> products = dao.findAll();
        req.setAttribute("products", products);
        req.getRequestDispatcher(LIST_VIEW).forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, ServletException, IOException {
        Integer id = parseInt(req.getParameter("id"));
        Product product = id == null ? null : dao.findById(id);
        if (product == null) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }
        req.setAttribute("product", product);
        req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
    }

    private void saveProduct(HttpServletRequest req, HttpServletResponse resp, boolean isUpdate)
            throws SQLException, ServletException, IOException {
        String name = req.getParameter("name");
        String priceStr = req.getParameter("price");
        String qtyStr = req.getParameter("quantity");
        Integer id = parseInt(req.getParameter("id"));

        Product product = new Product();
        if (id != null) product.setId(id);
        product.setName(name == null ? "" : name.trim());

        String error = null;
        try {
            product.setPrice(new BigDecimal(priceStr.trim()));
            product.setQuantity(Integer.parseInt(qtyStr.trim()));
        } catch (NumberFormatException | NullPointerException e) {
            error = "Giá và số lượng phải là số hợp lệ.";
        }

        if (error == null) {
            if (product.getName().isEmpty()) {
                error = "Tên sản phẩm không được để trống.";
            } else if (product.getPrice().compareTo(BigDecimal.ZERO) < 0) {
                error = "Giá không được âm.";
            } else if (product.getQuantity() < 0) {
                error = "Số lượng không được âm.";
            }
        }

        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("product", product);
            req.getRequestDispatcher(FORM_VIEW).forward(req, resp);
            return;
        }

        if (isUpdate) dao.update(product);
        else dao.insert(product);

        // Post/Redirect/Get để tránh submit lại form khi F5
        resp.sendRedirect(req.getContextPath() + "/products");
    }

    private void deleteProduct(HttpServletRequest req, HttpServletResponse resp)
            throws SQLException, IOException {
        Integer id = parseInt(req.getParameter("id"));
        if (id != null) dao.delete(id);
        resp.sendRedirect(req.getContextPath() + "/products");
    }

    private Integer parseInt(String s) {
        try {
            return s == null ? null : Integer.valueOf(s.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
