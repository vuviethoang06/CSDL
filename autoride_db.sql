-- =============================================================================
-- DỰ ÁN: AUTORIDE DATABASE OPTIMIZATION
-- File: autoride_db.sql
-- Mô tả: Khôi phục và tái cấu trúc CSDL khớp 100% với UML Activity Diagram
-- =============================================================================

CREATE DATABASE IF NOT EXISTS autoride_db;
USE autoride_db;

-- Dọn dẹp các bảng cũ nếu đã tồn tại
DROP TABLE IF EXISTS Inspections;
DROP TABLE IF EXISTS Rentals;
DROP TABLE IF EXISTS Cars;

-- 1. BẢNG CARS (Danh mục xe)
CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. BẢNG RENTALS (Quản lý hợp đồng thuê xe)
CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME DEFAULT NULL,
    
    -- Khóa chặt các trạng thái vòng đời hợp đồng
    status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') NOT NULL DEFAULT 'BOOKED',
    
    -- Quản lý tài chính chuẩn xác bằng kiểu DECIMAL(10, 2)
    security_deposit DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    late_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    damage_fee DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    
    FOREIGN KEY (car_id) REFERENCES Cars(car_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. BẢNG INSPECTIONS (Tạo mới: Biên bản kiểm tra xe)
CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT DEFAULT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================================================
-- TRIGGER CHẶN TẠO BIÊN BẢN KIỂM TRA KHI CHƯA NHẬN XE (BOOKED)
-- =============================================================================
DELIMITER //
CREATE TRIGGER chk_inspection_rental_status
BEFORE INSERT ON Inspections
FOR EACH ROW
BEGIN
    DECLARE current_status VARCHAR(20);
    
    SELECT status INTO current_status
    FROM Rentals
    WHERE rental_id = NEW.rental_id;
    
    IF current_status = 'BOOKED' OR current_status = 'CANCELLED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lỗi nghiệp vụ: Không được phép tạo Biên bản kiểm tra cho hợp đồng đang ở trạng thái BOOKED hoặc CANCELLED!';
    END IF;
END;
//
DELIMITER ;

-- =============================================================================
-- MÔ PHỎNG KỊCH BẢN DỮ LIỆU THỰC TẾ (DML)
-- =============================================================================

-- Khởi tạo dữ liệu Xe
INSERT INTO Cars (car_id, model_name, license_plate) VALUES 
(1, 'Toyota Camry 2023', '30H-123.45'),
(2, 'Hyundai Tucson 2024', '30K-888.99');

-- KỊCH BẢN: Bệnh nhân/Khách hàng "Nguyen Van A" thuê xe
-- Bước 1: Khách đặt và nhận xe (Cọc 10.000.000 VNĐ, trạng thái ACTIVE)
INSERT INTO Rentals (rental_id, car_id, customer_name, rent_date, status, security_deposit) 
VALUES (101, 1, 'Nguyen Van A', '2026-10-15 08:00:00', 'ACTIVE', 10000000.00);

-- Bước 2: Khách trả xe. Nhân viên kiểm tra phát hiện vỡ đèn pha trái
INSERT INTO Inspections (rental_id, damage_description, inspector_name) 
VALUES (101, 'Vỡ đèn pha phía trước bên trái, trầy xước cản trước', 'Nhân viên Nguyễn Văn B');

-- Bước 3: Cập nhật hợp đồng (COMPLETED, phạt tiền hư hỏng 2.000.000 VNĐ, không phạt trễ)
UPDATE Rentals 
SET status = 'COMPLETED',
    return_date = '2026-10-18 17:00:00',
    late_fee = 0.00,
    damage_fee = 2000000.00
WHERE rental_id = 101;

-- =============================================================================
-- TRUY VẤN TÍNH TOÀN VẸN DÒNG TIỀN HOÀN TRẢ
-- =============================================================================
SELECT 
    r.rental_id,
    r.customer_name,
    c.model_name,
    c.license_plate,
    r.status,
    r.security_deposit,
    r.late_fee,
    r.damage_fee,
    (r.security_deposit - r.late_fee - r.damage_fee) AS refund_amount,
    i.damage_description,
    i.inspector_name
FROM Rentals r
JOIN Cars c ON r.car_id = c.car_id
LEFT JOIN Inspections i ON r.rental_id = i.rental_id
WHERE r.rental_id = 101;