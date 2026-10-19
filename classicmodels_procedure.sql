-- =============================================================================
-- DỰ ÁN: THỰC HÀNH TẠO VÀ SỬ DỤNG STORED PROCEDURE TRÊN CSDL CLASSICMODELS
-- Database: classicmodels
-- Bảng làm việc: customers
-- =============================================================================

USE classicmodels;

-- -----------------------------------------------------------------------------
-- 1. TẠO STORED PROCEDURE ĐẦU TIÊN (findAllCustomers)
-- Lấy ra toàn bộ danh sách khách hàng
-- -----------------------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS findAllCustomers //

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers;
END //

DELIMITER ;

-- Gọi Stored Procedure vừa tạo
CALL findAllCustomers();


-- -----------------------------------------------------------------------------
-- 2. SỬA STORED PROCEDURE (DROP VÀ RE-CREATE)
-- Thay đổi yêu cầu: Chỉ lấy thông tin khách hàng có customerNumber = 175
-- -----------------------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS findAllCustomers //

CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers WHERE customerNumber = 175;
END //

DELIMITER ;

-- Gọi lại Stored Procedure để kiểm tra kết quả sau khi sửa
CALL findAllCustomers();