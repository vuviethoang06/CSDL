package com.codegym;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Khi gửi request tới "/translate", Servlet này sẽ được kích hoạt
@WebServlet(name = "DictionaryServlet", urlPatterns = {"/translate"})
public class DictionaryServlet extends HttpServlet {

    // Từ điển cho sẵn, dùng chung cho mọi request
    private static final Map<String, String> DICTIONARY = new HashMap<>();

    static {
        DICTIONARY.put("hello", "Xin chào");
        DICTIONARY.put("how", "Thế nào");
        DICTIONARY.put("book", "Quyển sách");
        DICTIONARY.put("computer", "Máy tính");
        DICTIONARY.put("student", "Sinh viên");
    }

    // Thoát ký tự HTML để tránh chèn mã độc từ dữ liệu người dùng nhập
    private static String escape(String s) {
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String searchWord = request.getParameter("word");

        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head><meta charset='UTF-8'><title>Kết quả tra cứu</title></head>");
            out.println("<body style='font-family: Arial, sans-serif; text-align: center; margin-top: 100px;'>");

            if (searchWord != null && !searchWord.trim().isEmpty()) {
                String word = searchWord.trim();
                // Chuyển về chữ thường để tìm không phân biệt hoa thường
                String result = DICTIONARY.get(word.toLowerCase());

                if (result != null) {
                    out.println("<h2 style='color: #1b2a7a;'>Từ khóa: " + escape(word) + "</h2>");
                    out.println("<h3 style='color: #27ae60;'>Nghĩa tiếng Việt: " + result + "</h3>");
                } else {
                    out.println("<h2 style='color: red;'>Không tìm thấy từ: " + escape(word) + "</h2>");
                }
            } else {
                out.println("<h2 style='color: orange;'>Vui lòng nhập từ khóa hợp lệ!</h2>");
            }

            out.println("<br><a href='index.jsp' style='text-decoration: none; padding: 10px 20px; background-color: #1b2a7a; color: white; border-radius: 4px;'>Quay lại</a>");
            out.println("</body>");
            out.println("</html>");
        }
    }
}
