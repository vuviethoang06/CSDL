package com.example.product.dao;

import com.example.product.model.Product;
import com.example.product.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    private static final String SELECT_ALL = "SELECT id, name, price, quantity FROM products ORDER BY id";
    private static final String SELECT_BY_ID = "SELECT id, name, price, quantity FROM products WHERE id = ?";
    private static final String INSERT = "INSERT INTO products (name, price, quantity) VALUES (?, ?, ?)";
    private static final String UPDATE = "UPDATE products SET name = ?, price = ?, quantity = ? WHERE id = ?";
    private static final String DELETE = "DELETE FROM products WHERE id = ?";

    public List<Product> findAll() throws SQLException {
        List<Product> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public Product findById(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public boolean insert(Product p) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT)) {
            ps.setString(1, p.getName());
            ps.setBigDecimal(2, p.getPrice());
            ps.setInt(3, p.getQuantity());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(Product p) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE)) {
            ps.setString(1, p.getName());
            ps.setBigDecimal(2, p.getPrice());
            ps.setInt(3, p.getQuantity());
            ps.setInt(4, p.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int id) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Product map(ResultSet rs) throws SQLException {
        return new Product(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getBigDecimal("price"),
                rs.getInt("quantity"));
    }
}
