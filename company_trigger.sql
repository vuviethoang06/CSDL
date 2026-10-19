-- =============================================================================
-- DỰ ÁN: THỰC HÀNH TẠO VÀ SỬ DỤNG TRIGGER TRONG MYSQL
-- Database: company
-- Bảng làm việc: employees
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Bước 1: Tạo Cơ sở dữ liệu và Bảng employees
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS company;
USE company;

DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

-- -----------------------------------------------------------------------------
-- Bước 2: Tạo Trigger tự động cập nhật department theo salary trước khi INSERT
-- -----------------------------------------------------------------------------
DELIMITER //

DROP TRIGGER IF EXISTS update_department //

CREATE TRIGGER update_department
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 5000 THEN
        SET NEW.department = 'Management';
    ELSEIF NEW.salary >= 3000 THEN
        SET NEW.department = 'Sales';
    ELSE
        SET NEW.department = 'Support';
    END IF;
END //

DELIMITER ;

-- -----------------------------------------------------------------------------
-- Bước 3: Thêm dữ liệu thử nghiệm để kiểm tra hoạt động của Trigger
-- -----------------------------------------------------------------------------
INSERT INTO employees (name, department, salary)
VALUES 
    ('John Doe', 'A', 3500),
    ('Jane Smith', 'A', 2000),
    ('David Johnson', 'A', 6000);

-- Kiểm tra lại bảng employees để thấy trường department đã được Trigger tự động cập nhật
SELECT * FROM employees;