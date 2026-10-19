# Quản lý sản phẩm - JSP & Servlet

## Yêu cầu
- JDK 11+, Maven 3.6+, Apache Tomcat 9, MySQL 8

## Cài đặt
1. Chạy `sql/products.sql` trong MySQL để tạo database `product_db`, bảng `products` và dữ liệu mẫu.
2. Sửa USER / PASSWORD trong `src/main/java/com/example/product/util/DBConnection.java`.
3. Build: `mvn clean package` -> file `target/product-management.war`.
4. Copy file .war vào thư mục `webapps` của Tomcat (hoặc deploy bằng IntelliJ/Eclipse), khởi động Tomcat.
5. Truy cập: http://localhost:8080/product-management/

## Cấu trúc
- `model/Product`             : entity
- `util/DBConnection`         : kết nối JDBC
- `dao/ProductDAO`            : CRUD với PreparedStatement
- `controller/ProductServlet` : xử lý list / new / edit / insert / update / delete
- `WEB-INF/views/*.jsp`       : giao diện (JSTL)

## Dùng Tomcat 10+
Đổi `javax.servlet` -> `jakarta.servlet` trong code Java, dùng jakarta.servlet-api 5/6 và
jakarta.servlet.jsp.jstl trong pom.xml, taglib URI đổi thành `jakarta.tags.core` / `jakarta.tags.fmt`.
