-- =============================================================================
-- DỰ ÁN: XÂY DỰNG CƠ SỞ DỮ LIỆU QUẢN LÝ BÁN HÀNG (QuanLyBanHang)
-- =============================================================================

-- 1. Tạo cơ sở dữ liệu QuanLyBanHang
CREATE DATABASE IF NOT EXISTS QuanLyBanHang;
USE QuanLyBanHang;

-- Xóa các bảng cũ nếu đã tồn tại (theo đúng thứ tự khóa ngoại)
DROP TABLE IF EXISTS OrderDetail;
DROP TABLE IF EXISTS `Order`;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Customer;

-- =============================================================================
-- 2. TẠO BẢNG DỮ LIỆU VỚI CÁC RÀNG BUỘC (CONSTRAINTS)
-- =============================================================================

-- 2.1. Bảng Customer (Khách hàng)
CREATE TABLE Customer (
    cID INT AUTO_INCREMENT PRIMARY KEY,
    cName VARCHAR(50) NOT NULL,
    cAge TINYINT CHECK (cAge > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.2. Bảng Product (Sản phẩm)
CREATE TABLE Product (
    pID INT AUTO_INCREMENT PRIMARY KEY,
    pName VARCHAR(100) NOT NULL,
    pPrice DECIMAL(12, 2) NOT NULL CHECK (pPrice >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.3. Bảng Order (Hóa đơn mua hàng)
CREATE TABLE `Order` (
    oID INT AUTO_INCREMENT PRIMARY KEY,
    cID INT NOT NULL,
    oDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    oTotalPrice DECIMAL(12, 2) DEFAULT NULL,
    FOREIGN KEY (cID) REFERENCES Customer(cID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.4. Bảng OrderDetail (Chi tiết hóa đơn)
CREATE TABLE OrderDetail (
    oID INT NOT NULL,
    pID INT NOT NULL,
    odQTY INT NOT NULL CHECK (odQTY > 0),
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES `Order`(oID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pID) REFERENCES Product(pID) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================================================
-- 3. CHÈN DỮ LIỆU MẪU (DML) ĐỂ MÔ PHỎNG VẬN HÀNH
-- =============================================================================

-- Chèn danh sách Khách hàng
INSERT INTO Customer (cID, cName, cAge) VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

-- Chèn danh sách Sản phẩm
INSERT INTO Product (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

-- Chèn Hóa đơn
INSERT INTO `Order` (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

-- Chèn Chi tiết hóa đơn
INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);