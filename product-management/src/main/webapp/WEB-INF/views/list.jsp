<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Danh sách sản phẩm</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container">
    <h1>Quản lý sản phẩm</h1>

    <a class="btn btn-primary" href="${pageContext.request.contextPath}/products?action=new">+ Thêm sản phẩm</a>

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Tên sản phẩm</th>
            <th class="num">Giá (VNĐ)</th>
            <th class="num">Số lượng</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${products}">
            <tr>
                <td>${p.id}</td>
                <td><c:out value="${p.name}"/></td>
                <td class="num"><fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/></td>
                <td class="num">${p.quantity}</td>
                <td class="actions">
                    <a class="btn btn-edit"
                       href="${pageContext.request.contextPath}/products?action=edit&id=${p.id}">Sửa</a>

                    <form action="${pageContext.request.contextPath}/products" method="post"
                          data-name="<c:out value='${p.name}'/>"
                          onsubmit="return confirm('Bạn có chắc chắn muốn xóa sản phẩm &quot;' + this.dataset.name + '&quot;?');">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${p.id}">
                        <button type="submit" class="btn btn-delete">Xóa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty products}">
            <tr><td colspan="5" class="empty">Chưa có sản phẩm nào.</td></tr>
        </c:if>
        </tbody>
    </table>
</div>
</body>
</html>
