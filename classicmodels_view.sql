-- =============================================================================
-- DỰ ÁN: THỰC HÀNH TẠO, CẬP NHẬT VÀ XÓA VIEW TRÊN CSDL CLASSICMODELS
-- Database: classicmodels
-- Bảng làm việc: customers
-- =============================================================================

USE classicmodels;

-- -----------------------------------------------------------------------------
-- 1. TẠO VIEW (customer_views)
-- Tạo view lấy thông tin customerNumber, customerName, phone
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

-- Truy vấn dữ liệu từ bảng ảo customer_views vừa tạo
SELECT * FROM customer_views;


-- -----------------------------------------------------------------------------
-- 2. CẬP NHẬT VIEW (CREATE OR REPLACE VIEW)
-- Thay đổi định nghĩa view: bổ sung contactFirstName, contactLastName và điều kiện city = 'Nantes'
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, contactFirstName, contactLastName, phone
FROM customers
WHERE city = 'Nantes';

-- Truy vấn lại dữ liệu từ view sau khi đã cập nhật
SELECT * FROM customer_views;


-- -----------------------------------------------------------------------------
-- 3. XÓA VIEW (DROP VIEW)
-- Xóa view customer_views khi không còn sử dụng
-- -----------------------------------------------------------------------------
DROP VIEW IF EXISTS customer_views;