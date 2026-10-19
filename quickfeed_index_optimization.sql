-- =============================================================================
-- BÀI THỰC HÀNH: TỐI ƯU HÓA INDEX VÀ TÀI NGUYÊN LƯU TRỮ (QUICKFEED DB)
-- Tác giả: Database Administrator (DBA)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- BƯỚC 1: KHỞI TẠO CSDL VÀ BẢNG MẪU (LEGACY SCRIPT)
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS quickfeed_db;
USE quickfeed_db;

DROP TABLE IF EXISTS Posts;

CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    post_type VARCHAR(10),       -- Chỉ chứa 3 giá trị: 'TEXT', 'IMAGE', 'VIDEO'
    is_visible BOOLEAN DEFAULT 1, -- Chỉ chứa 1 (Hiện) hoặc 0 (Ẩn)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tạo 5 Index ban đầu (Trạng thái Over-indexing gây cạn kiệt tài nguyên)
CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255));
CREATE INDEX idx_post_type ON Posts(post_type);
CREATE INDEX idx_is_visible ON Posts(is_visible);
CREATE INDEX idx_created_at ON Posts(created_at);

-- -----------------------------------------------------------------------------
-- BƯỚC 2: KIỂM TRA DUNG LƯỢNG DATA VÀ INDEX TRƯỚC KHI TỐI ƯU HÓA
-- -----------------------------------------------------------------------------
-- Cách 1: Sử dụng SHOW TABLE STATUS
SHOW TABLE STATUS LIKE 'Posts';

-- Cách 2: Truy vấn bảng information_schema.TABLES để tính chính xác kích thước theo MB
SELECT 
    table_name AS 'Table Name',
    ROUND(data_length / 1024 / 1024, 2) AS 'Data Size (MB)',
    ROUND(index_length / 1024 / 1024, 2) AS 'Index Size (MB)',
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS 'Total Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';


-- -----------------------------------------------------------------------------
-- BƯỚC 3: THỰC HIỆN "PHẪU THUẬT" CẮT BỎ CÁC INDEX DƯ THỪA / VÔ GIÁ TRỊ
-- -----------------------------------------------------------------------------
-- 1. Xóa idx_content: Do cột TEXT dài gây phình cây B-Tree (Cần dùng FULLTEXT Index nếu search văn bản)
ALTER TABLE Posts DROP INDEX idx_content;

-- 2. Xóa idx_post_type: Cardinality cực thấp (chỉ có 3 giá trị), Query Optimizer thường bỏ qua
ALTER TABLE Posts DROP INDEX idx_post_type;

-- 3. Xóa idx_is_visible: Cardinality cực thấp (chỉ có 2 giá trị 0 và 1), không hiệu quả cho B-Tree
ALTER TABLE Posts DROP INDEX idx_is_visible;

-- Giữ lại idx_user_id (Load trang cá nhân) và idx_created_at (Sắp xếp Newsfeed theo thời gian)


-- -----------------------------------------------------------------------------
-- BƯỚC 4: ĐỐI CHIẾU VÀ XÁC NHẬN KẾT QUẢ SẢN PHẨM TRÊN HỆ THỐNG
-- -----------------------------------------------------------------------------
-- Kiểm tra lại dung lượng Index sau khi đã cắt bỏ 3 Index vô dụng
SELECT 
    table_name AS 'Table Name',
    ROUND(data_length / 1024 / 1024, 2) AS 'Data Size (MB)',
    ROUND(index_length / 1024 / 1024, 2) AS 'Index Size (MB)',
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS 'Total Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';