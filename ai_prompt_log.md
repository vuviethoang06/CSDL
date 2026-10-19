# NHẬT KÝ TƯƠNG TÁC AI (AI PROMPT LOG)

## Prompt 1: Tìm hiểu Covering Index và ảnh hưởng tới Read/Write
- **User:** "Trong MySQL InnoDB, Covering Index là gì? Tại sao việc nhét tất cả các cột vào Index lại giúp câu lệnh SELECT chạy siêu nhanh nhưng lại gây thảm họa sụp đổ tốc độ GHI (INSERT) cho hệ thống IoT lưu trữ dữ liệu thời gian thực?"
- **AI Response Summary:** AI giải thích Covering Index giúp câu lệnh SELECT lấy dữ liệu trực tiếp trên cây Index B-Tree mà không cần thực hiện Bookmark Lookup về Data Page (Clustered Index). Tuy nhiên, với hệ thống GHI liên tục, mỗi bản ghi mới bắt buộc phải cập nhật cây B-Tree cồng kềnh, gây ra xung đột Random I/O, tách trang (Page Split) và tăng Write Penalty.

---

## Prompt 2: Tìm hiểu phân bổ dữ liệu Clustered Index và Secondary Index
- **User:** "Hãy giải thích sự khác biệt trong cách MySQL InnoDB lưu trữ dữ liệu giữa Clustered Index (Primary Key) và Secondary Index. Tại sao Secondary Index lại chứa giá trị của Primary Key?"
- **AI Response Summary:** Clustered Index lưu trữ toàn bộ dòng dữ liệu thực tế tại các lá của cây B-Tree (sắp xếp theo Primary Key). Secondary Index chỉ lưu các cột được đánh index cùng với giá trị Primary Key tương ứng. Khi truy vấn không phải Covering Index, MySQL phải dùng Primary Key từ Secondary Index để "nhảy" sang Clustered Index lấy đầy đủ thông tin (Lookup Table).

---

## Prompt 3: Tính toán dung lượng Byte của các kiểu dữ liệu trong MySQL
- **User:** "Hãy cho tôi bảng tính toán chi tiết dung lượng lưu trữ tính bằng Byte của các kiểu dữ liệu trong MySQL: INT, BIGINT, DATETIME, DECIMAL(5,2), VARCHAR(20) và TINYINT. Nếu 1 dòng trong Index giảm được 20 bytes thì với 10 triệu dòng sẽ tiết kiệm được bao nhiêu MB?"
- **AI Response Summary:** 
  - INT: 4 bytes | BIGINT: 8 bytes | DATETIME: 5 bytes | DECIMAL(5,2): 3 bytes | TINYINT: 1 byte | VARCHAR(20): 1 + N bytes (tối đa 21 bytes).
  - Tính toán: 20 bytes x 10,000,000 dòng = 200,000,000 bytes ≈ 190.73 MB dung lượng RAM/Disk được giải phóng.

---

## Prompt 4: Phân biệt các giá trị trong cột Extra của lệnh EXPLAIN
- **User:** "Phân biệt ý nghĩa của các giá trị 'Using index', 'Using index condition', và 'Using where' trong cột Extra khi chạy lệnh EXPLAIN trong MySQL."
- **AI Response Summary:** 'Using index' nghĩa là câu truy vấn dùng Covering Index (không cần đọc Table gốc). 'Using index condition' (Index Condition Pushdown) nghĩa là dùng Index để lọc dữ liệu trước khi Lookup về Table. 'Using where' nghĩa là MySQL phải lọc dữ liệu sau khi đã lấy dữ liệu từ Table gốc.