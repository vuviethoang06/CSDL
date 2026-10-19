<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:choose><c:when test="${product.id > 0}">Sửa sản phẩm</c:when><c:otherwise>Thêm sản phẩm</c:otherwise></c:choose></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="container narrow">
    <h1>
        <c:choose>
            <c:when test="${product.id > 0}">Sửa sản phẩm</c:when>
            <c:otherwise>Thêm sản phẩm mới</c:otherwise>
        </c:choose>
    </h1>

    <c:if test="${not empty error}">
        <div class="alert"><c:out value="${error}"/></div>
    </c:if>

    <form action="${pageContext.request.contextPath}/products" method="post">
        <c:choose>
            <c:when test="${product.id > 0}">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${product.id}">
            </c:when>
            <c:otherwise>
                <input type="hidden" name="action" value="insert">
            </c:otherwise>
        </c:choose>

        <label for="name">Tên sản phẩm</label>
        <input type="text" id="name" name="name" required maxlength="255"
               value="<c:out value='${product.name}'/>">

        <label for="price">Giá</label>
        <input type="number" id="price" name="price" required min="0" step="0.01"
               value="${product.price}">

        <label for="quantity">Số lượng</label>
        <input type="number" id="quantity" name="quantity" required min="0" step="1"
               value="${product.quantity}">

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">Lưu</button>
            <a class="btn btn-secondary" href="${pageContext.request.contextPath}/products">Hủy</a>
        </div>
    </form>
</div>
</body>
</html>
