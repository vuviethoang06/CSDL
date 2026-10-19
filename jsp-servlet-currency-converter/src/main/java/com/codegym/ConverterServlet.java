package com.codegym;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Khi gửi request tới "/convert", Servlet này sẽ được kích hoạt
@WebServlet(name = "ConverterServlet", urlPatterns = {"/convert"})
public class ConverterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            try {
                // Nhận tham số từ form và ép kiểu sang số thực
                double rate = Double.parseDouble(request.getParameter("rate"));
                double usd = Double.parseDouble(request.getParameter("usd"));

                // VND = USD * Rate
                double vnd = rate * usd;

                // Định dạng số cho dễ đọc, tránh dạng khoa học như 2.5E7
                DecimalFormat df = new DecimalFormat("#,##0.##");

                out.println("<!DOCTYPE html>");
                out.println("<html>");
                out.println("<head><meta charset='UTF-8'><title>Result</title></head>");
                out.println("<body style='font-family: Arial, sans-serif; text-align: center; margin-top: 100px;'>");
                out.println("<h2 style='color: #1b2a7a;'>KẾT QUẢ CHUYỂN ĐỔI</h2>");
                out.println("<p style='font-size: 18px;'>Tỉ giá: " + df.format(rate) + " VND/USD</p>");
                out.println("<p style='font-size: 18px;'>Số tiền USD: $" + df.format(usd) + "</p>");
                out.println("<h3 style='color: #27ae60; font-size: 24px;'>Thành tiền VNĐ: " + df.format(vnd) + " VNĐ</h3>");
                out.println("<br><a href='index.jsp' style='text-decoration: none; padding: 10px 20px; background-color: #1b2a7a; color: white; border-radius: 4px;'>Quay lại</a>");
                out.println("</body>");
                out.println("</html>");

            } catch (NumberFormatException | NullPointerException e) {
                // Người dùng nhập không phải số
                out.println("<!DOCTYPE html>");
                out.println("<html><head><meta charset='UTF-8'></head><body>");
                out.println("<h2 style='color: red; text-align: center; margin-top: 100px;'>Lỗi: Vui lòng nhập số hợp lệ!</h2>");
                out.println("<div style='text-align: center;'><a href='index.jsp'>Quay lại</a></div>");
                out.println("</body></html>");
            }
        }
    }
}
