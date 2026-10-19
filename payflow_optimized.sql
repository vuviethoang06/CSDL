-- =============================================================================
-- DỰ ÁN: PAYFLOW DATABASE OPTIMIZATION
-- File: payflow_optimized.sql
-- Mô tả: Khởi tạo CSDL, tạo Composite Index SARGable và refactor truy vấn
-- =============================================================================

CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

-- 1. TẠO BẢNG TRANSACTIONS (Nếu chưa có)
CREATE TABLE IF NOT EXISTS Transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    amount DECIMAL(15,2),
    transaction_type VARCHAR(20), -- 'DEPOSIT', 'WITHDRAW', 'TRANSFER'
    created_at DATETIME
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =============================================================================
-- 2. TẠO COMPOSITE INDEX TỐI ƯU (DDL)
-- Thứ tự: Cột lọc chính xác (transaction_type) đứng trước, cột lọc khoảng (created_at) đứng sau
-- =============================================================================
CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);

-- =============================================================================
-- 3. TRUY VẤN TỐI ƯU CHUẨN SARGABLE KÈM EXPLAIN (DQL)
-- Chuyển đổi YEAR() & MONTH() thành truy vấn theo khoảng (Range Condition)
-- =============================================================================
EXPLAIN 
SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT' 
  AND created_at >= '2026-06-01 00:00:00' 
  AND created_at < '2026-07-01 00:00:00';