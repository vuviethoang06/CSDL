-- =============================================================================
-- DỰ ÁN: THỰC HÀNH THAM SỐ IN, OUT, INOUT TRONG STORED PROCEDURE
-- Database: classicmodels
-- Bảng làm việc: customers
-- =============================================================================

USE classicmodels;

-- -----------------------------------------------------------------------------
-- 1. THAM SỐ LOẠI IN (Đầu vào)
-- Tìm thông tin khách hàng theo customerNumber
-- -----------------------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS getCusById //

CREATE PROCEDURE getCusById(IN cusNum INT)
BEGIN
    SELECT * 
    FROM customers 
    WHERE customerNumber = cusNum;
END //

DELIMITER ;

-- Gọi Stored Procedure với tham số IN
CALL getCusById(175);


-- -----------------------------------------------------------------------------
-- 2. THAM SỐ LOẠI OUT (Đầu ra)
-- Đếm số lượng khách hàng theo thành phố và trả về giá trị qua biến OUT
-- -----------------------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS GetCustomersCountByCity //

CREATE PROCEDURE GetCustomersCountByCity(
    IN in_city VARCHAR(50),
    OUT total INT
)
BEGIN
    SELECT COUNT(customerNumber)
    INTO total
    FROM customers
    WHERE city = in_city;
END //

DELIMITER ;

-- Gọi Stored Procedure với tham số OUT và kiểm tra kết quả
CALL GetCustomersCountByCity('Lyon', @total);
SELECT @total AS 'Tổng số khách hàng ở Lyon';


-- -----------------------------------------------------------------------------
-- 3. THAM SỐ LOẠI INOUT (Vừa là đầu vào vừa là đầu ra)
-- Tăng giá trị của biến counter lên giá trị inc
-- -----------------------------------------------------------------------------
DELIMITER //

DROP PROCEDURE IF EXISTS SetCounter //

CREATE PROCEDURE SetCounter(
    INOUT counter INT,
    IN inc INT
)
BEGIN
    SET counter = counter + inc;
END //

DELIMITER ;

-- Gọi Stored Procedure kiểm tra tham số INOUT
SET @counter = 1;

CALL SetCounter(@counter, 1); -- Kết quả biến @counter = 2
CALL SetCounter(@counter, 1); -- Kết quả biến @counter = 3
CALL SetCounter(@counter, 5); -- Kết quả biến @counter = 8

SELECT @counter AS 'Giá trị counter sau cùng';