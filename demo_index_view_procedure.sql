-- =============================================================================
-- BÀI THỰC HÀNH TỔNG HỢP: INDEX, VIEW, STORED PROCEDURE TRONG MYSQL
-- Database: demo
-- Bảng làm việc: Products
-- =============================================================================

-- -----------------------------------------------------------------------------
-- BƯỚC 1 & 2: TẠO CSDL VÀ BẢNG Products CÙNG DỮ LIỆU MẪU
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

DROP TABLE IF EXISTS Products;

CREATE TABLE Products (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    productCode VARCHAR(20) NOT NULL,
    productName VARCHAR(100) NOT NULL,
    productPrice DECIMAL(10,2) NOT NULL,
    productAmount INT NOT NULL,
    productDescription TEXT,
    productStatus BIT DEFAULT 1
);

-- Chèn dữ liệu mẫu
INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
VALUES 
    ('P001', 'iPhone 15 Pro', 999.99, 50, 'Điện thoại Apple cao cấp', 1),
    ('P002', 'Samsung Galaxy S24', 899.99, 40, 'Điện thoại Samsung flagship', 1),
    ('P003', 'MacBook Pro M3', 1999.99, 20, 'Laptop Apple cấu hình mạnh', 1),
    ('P004', 'Dell XPS 15', 1499.99, 15, 'Laptop Dell mỏng nhẹ', 1),
    ('P005', 'iPad Air 5', 599.99, 30, 'Máy tính bảng Apple', 0);


-- -----------------------------------------------------------------------------
-- BƯỚC 3: TẠO VÀ ĐÁNH GIÁ HIỆU NĂNG CỦA INDEX
-- -----------------------------------------------------------------------------
-- Kiểm tra EXPLAIN trước khi tạo Index (Full Table Scan - type: ALL)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P001';
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15 Pro' AND productPrice = 999.99;

-- 1. Tạo Unique Index trên cột productCode
ALTER TABLE Products ADD UNIQUE INDEX idx_productCode(productCode);

-- 2. Tạo Composite Index trên 2 cột productName và productPrice
ALTER TABLE Products ADD INDEX idx_name_price(productName, productPrice);

-- Kiểm tra lại EXPLAIN sau khi tạo Index (type đổi sang const / ref, rows giảm mạnh)
EXPLAIN SELECT * FROM Products WHERE productCode = 'P001';
EXPLAIN SELECT * FROM Products WHERE productName = 'iPhone 15 Pro' AND productPrice = 999.99;


-- -----------------------------------------------------------------------------
-- BƯỚC 4: THỰC HÀNH TẠO, SỬA VÀ XÓA VIEW
-- -----------------------------------------------------------------------------
-- 1. Tạo View lấy các thông tin: productCode, productName, productPrice, productStatus
CREATE VIEW view_products AS
SELECT productCode, productName, productPrice, productStatus
FROM Products;

-- Truy vấn từ View vừa tạo
SELECT * FROM view_products;

-- 2. Tiến hành sửa đổi View (Bổ sung thêm cột productAmount)
CREATE OR REPLACE VIEW view_products AS
SELECT productCode, productName, productPrice, productAmount, productStatus
FROM Products;

SELECT * FROM view_products;

-- 3. Tiến hành xóa View
DROP VIEW IF EXISTS view_products;


-- -----------------------------------------------------------------------------
-- BƯỚC 5: THỰC HÀNH TẠO CÁC STORED PROCEDURE (CRUD)
-- -----------------------------------------------------------------------------

-- 1. Stored Procedure lấy tất cả thông tin của tất cả sản phẩm
DELIMITER //
DROP PROCEDURE IF EXISTS getAllProducts //
CREATE PROCEDURE getAllProducts()
BEGIN
    SELECT * FROM Products;
END //
DELIMITER ;

-- Gọi thủ tục
CALL getAllProducts();


-- 2. Stored Procedure thêm một sản phẩm mới
DELIMITER //
DROP PROCEDURE IF EXISTS addProduct //
CREATE PROCEDURE addProduct(
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10,2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status BIT
)
BEGIN
    INSERT INTO Products (productCode, productName, productPrice, productAmount, productDescription, productStatus)
    VALUES (p_code, p_name, p_price, p_amount, p_desc, p_status);
END //
DELIMITER ;

-- Gọi thủ tục thêm sản phẩm
CALL addProduct('P006', 'AirPods Pro 2', 249.99, 100, 'Tai nghe chống ồn Apple', 1);


-- 3. Stored Procedure sửa thông tin sản phẩm theo Id
DELIMITER //
DROP PROCEDURE IF EXISTS updateProductById //
CREATE PROCEDURE updateProductById(
    IN p_id INT,
    IN p_code VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_price DECIMAL(10,2),
    IN p_amount INT,
    IN p_desc TEXT,
    IN p_status BIT
)
BEGIN
    UPDATE Products
    SET productCode = p_code,
        productName = p_name,
        productPrice = p_price,
        productAmount = p_amount,
        productDescription = p_desc,
        productStatus = p_status
    WHERE Id = p_id;
END //
DELIMITER ;

-- Gọi thủ tục sửa sản phẩm
CALL updateProductById(1, 'P001', 'iPhone 15 Pro Max', 1199.99, 45, 'Điện thoại Apple cao cấp nhất', 1);


-- 4. Stored Procedure xóa sản phẩm theo Id
DELIMITER //
DROP PROCEDURE IF EXISTS deleteProductById //
CREATE PROCEDURE deleteProductById(
    IN p_id INT
)
BEGIN
    DELETE FROM Products WHERE Id = p_id;
END //
DELIMITER ;

-- Gọi thủ tục xóa sản phẩm có Id = 6
CALL deleteProductById(6);

-- Kiểm tra lại danh sách sản phẩm sau các thao tác CRUD
CALL getAllProducts();