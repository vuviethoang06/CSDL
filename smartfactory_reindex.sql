-- =============================================================================
-- BÀI THỰC HÀNH: TỐI ƯU HÓA COVERING INDEX VÀ CÂN BẰNG HIỆU NĂNG READ/WRITE
-- Hệ thống: SmartFactory IoT Sensor Logs
-- Vai trò: Database Optimization Expert
-- =============================================================================

-- -----------------------------------------------------------------------------
-- BƯỚC 1: KHỞI TẠO CSDL VÀ BẢNG MẪU (LEGACY SCRIPT)
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS smartfactory_db;
USE smartfactory_db;

DROP TABLE IF EXISTS SensorLogs;

CREATE TABLE SensorLogs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    sensor_id INT NOT NULL,
    recorded_at DATETIME NOT NULL,
    temperature DECIMAL(5,2),
    humidity DECIMAL(5,2),
    status VARCHAR(20) -- 'NORMAL', 'WARNING', 'CRITICAL'
);

-- "FAT COVERING INDEX" BAN ĐẦU (Nhét tất cả các cột vào Index)
CREATE INDEX idx_fat_covering ON SensorLogs(sensor_id, recorded_at, temperature, humidity, status);


-- -----------------------------------------------------------------------------
-- BƯỚC 2: KHẢO SÁT KẾ HOẠCH THỰC THI (EXPLAIN) VÀ DUNG LƯỢNG KHI DÙNG FAT INDEX
-- -----------------------------------------------------------------------------
-- Truy vấn Dashboard khi còn dùng Covering Index (Extra sẽ có "Using index")
EXPLAIN SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20';

-- Kiểm tra dung lượng Data và Index ban đầu
SELECT 
    table_name AS 'Table Name',
    ROUND(data_length / 1024 / 1024, 2) AS 'Data Size (MB)',
    ROUND(index_length / 1024 / 1024, 2) AS 'Index Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'smartfactory_db' AND table_name = 'SensorLogs';


-- -----------------------------------------------------------------------------
-- BƯỚC 3: THỰC HIỆN CHUYỂN ĐỔI SANG LEAN INDEX (TÍNH GỌN)
-- -----------------------------------------------------------------------------
-- 1. Xóa "Fat Index" phình to gây thắt cổ chai luồng GHI (INSERT)
ALTER TABLE SensorLogs DROP INDEX idx_fat_covering;

-- 2. Tạo "Lean Index" chỉ chứa 2 cột định vị để lọc và sắp xếp (sensor_id, recorded_at)
CREATE INDEX idx_lean_search ON SensorLogs(sensor_id, recorded_at);


-- -----------------------------------------------------------------------------
-- BƯỚC 4: VẬN HÀNH VÀ CHỨNG MINH KẾT QUẢ VỚI LỆNH EXPLAIN
-- -----------------------------------------------------------------------------
-- Kiểm tra lại EXPLAIN sau khi thay thế bằng Lean Index
-- (Kết quả: key = idx_lean_search, type = range, Extra không còn "Using index" vì phải Lookup Table)
EXPLAIN SELECT temperature, humidity, status 
FROM SensorLogs 
WHERE sensor_id = 105 AND recorded_at >= '2026-06-20';

-- Kiểm tra lại dung lượng Index đã được tối ưu giảm đáng kể
SELECT 
    table_name AS 'Table Name',
    ROUND(data_length / 1024 / 1024, 2) AS 'Data Size (MB)',
    ROUND(index_length / 1024 / 1024, 2) AS 'Index Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'smartfactory_db' AND table_name = 'SensorLogs';