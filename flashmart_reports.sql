-- =============================================================================
-- DỰ ÁN: FLASHMART DATABASE OPTIMIZATION & REPORTING
-- File: flashmart_reports.sql
-- Mô tả: Khôi phục CSDL và viết lại truy vấn báo cáo chính xác 100%
-- =============================================================================

CREATE DATABASE IF NOT EXISTS flashmart_db;
USE flashmart_db;

-- Dọn dẹp bảng cũ nếu đã tồn tại
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- 1. TẠO BẢNG DỮ LIỆU
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY, 
    name VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Products (
    product_id INT PRIMARY KEY, 
    product_name VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Orders (
    order_id INT PRIMARY KEY, 
    customer_id INT, 
    product_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. CHÈN DỮ LIỆU MẪU
INSERT INTO Customers VALUES (1, 'Alice'), (2, 'Bob'), (3, 'Charlie'); 
-- Note: Charlie (ID 3) chưa từng mua hàng

INSERT INTO Products VALUES (101, 'Laptop'), (102, 'Mouse'), (103, 'Keyboard'); 
-- Note: Keyboard (ID 103) chưa từng được mua

INSERT INTO Orders VALUES (1001, 1, 101), (1002, 1, 102), (1003, 2, 101);

-- =============================================================================
-- YÊU CẦU 1: BÁO CÁO CHO MARKETING (Lấy tất cả khách hàng + số lượng đơn hàng)
-- Bảng gốc (Driving table): Customers (Bên trái)
-- Loại JOIN: LEFT JOIN
-- =============================================================================
SELECT 
    c.customer_id, 
    c.name, 
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY c.customer_id;

-- =============================================================================
-- YÊU CẦU 2: BÁO CÁO CHO KHO VẬN (Lấy các sản phẩm chưa từng được bán ra)
-- Kỹ thuật: Anti-Join (LEFT JOIN ... WHERE IS NULL)
-- Bảng gốc (Driving table): Products (Bên trái)
-- =============================================================================
SELECT 
    p.product_id, 
    p.product_name
FROM Products p
LEFT JOIN Orders o ON p.product_id = o.product_id
WHERE o.order_id IS NULL;