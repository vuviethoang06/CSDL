-- =============================================================================
-- DỰ ÁN: THỰC HÀNH TẠO VÀ ĐÁNH GIÁ HIỆU NĂNG INDEX TRÊN CSDL CLASSICMODELS
-- Database: classicmodels
-- Bảng làm việc: customers
-- =============================================================================

USE classicmodels;

-- -----------------------------------------------------------------------------
-- 1. TRUY VẤN VÀ KHẢO SÁT KHI CHƯA TẠO INDEX (Full Table Scan)
-- -----------------------------------------------------------------------------
-- Kiểm tra kế hoạch thực thi khi tìm kiếm theo customerName
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';


-- -----------------------------------------------------------------------------
-- 2. TẠO INDEX ĐƠN TRÊN CỘT customerName VÀ KIỂM TRA LẠI EXPLAIN
-- -----------------------------------------------------------------------------
-- Thêm chỉ mục đơn idx_customerName
ALTER TABLE customers ADD INDEX idx_customerName(customerName);

-- Kiểm tra lại kế hoạch thực thi sau khi đánh Index (type chuyển từ ALL sang ref, rows giảm)
EXPLAIN SELECT * FROM customers WHERE customerName = 'Land of Toys Inc.';


-- -----------------------------------------------------------------------------
-- 3. TẠO COMPOSITE INDEX (INDEX KẾT HỢP) VÀ KIỂM TRA EXPLAIN
-- -----------------------------------------------------------------------------
-- Thêm chỉ mục kết hợp trên cặp cột contactFirstName và contactLastName
ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);

-- Kiểm tra kế hoạch thực thi khi tìm kiếm với điều kiện trên contactFirstName
EXPLAIN SELECT * FROM customers WHERE contactFirstName = 'Jean' OR contactFirstName = 'King';


-- -----------------------------------------------------------------------------
-- 4. HƯỚNG DẪN XÓA INDEX KHI KHÔNG SỬ DỤNG
-- -----------------------------------------------------------------------------
-- Xóa chỉ mục idx_full_name
ALTER TABLE customers DROP INDEX idx_full_name;

-- Xóa chỉ mục idx_customerName (Dọn dẹp môi trường)
ALTER TABLE customers DROP INDEX idx_customerName;