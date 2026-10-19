# BÁO CÁO PHÂN TÍCH VÀ TỐI ƯU HÓA COVERING INDEX (SMARTFACTORY DB)

## 1. Lập luận về sự dư thừa của Covering Index trong hệ thống có lưu lượng GHI (Write) cao
- **Bối cảnh:** Bảng `SensorLogs` tiếp nhận hàng chục nghìn bản ghi mỗi giây từ 10,000 cảm biến.
- **Thảm họa của Fat Covering Index (`idx_fat_covering`):** 
  - Việc đưa các cột liên tục biến đổi như `temperature`, `humidity`, và `status` vào Index tạo ra một cấu trúc B-Tree khổng lồ (~35-40 bytes/node).
  - Khi chèn dữ liệu mới (`INSERT`), MySQL không chỉ ghi vào bảng gốc mà phải thực hiện sắp xếp và tái cấu trúc (Page Split) cây B-Tree này.
  - Thao tác GHI bị nghẽn (Write Penalty nghiêm trọng), gây ra tình trạng rớt dữ liệu (Data Loss) do luồng dữ liệu không ghi kịp vào Database.
- **Giải pháp Lean Index (`idx_lean_search`):** 
  - Chỉ giữ lại 2 cột định vị lọc dữ liệu là `sensor_id` và `recorded_at`.
  - Giảm kích thước node xuống còn ~12 bytes/node (tiết kiệm ~70% dung lượng Index), giúp thao tác `INSERT` nhanh hơn gấp 4-5 lần.

---

## 2. Đánh giá Covering Index trong các ngữ cảnh khác (Bảng dữ liệu tĩnh)
- **Đặt vấn đề:** Với các bảng ít thay đổi như `Danh mục quốc gia` (Countries) hay `Danh mục sản phẩm` (Categories):
- **Kết luận:** Covering Index **KHÔNG phải là tội ác mà là một giải pháp tối ưu xuất sắc** trong ngữ cảnh này.
- **Lý do:** Tần suất GHI cực thấp (hoặc bằng 0), nên Write Penalty không xảy ra. Tần suất ĐỌC rất cao, việc lấy dữ liệu trực tiếp từ Covering Index giúp truy vấn đạt tốc độ tối đa mà không tốn chi phí Disk I/O để Lookup về Data Page.

---

## 3. Khái niệm 'Write Penalty' và ảnh hưởng của việc thêm cột vào Index
- **Write Penalty (Hình phạt khi Ghi):** Là chi phí hiệu năng mà hệ thống phải trả cho các thao tác `INSERT`, `UPDATE`, `DELETE` khi bảng có chứa Index.
- **Cơ chế tác động:** Khi thêm 1 cột vào Index:
  1. Dung lượng mỗi nút (node) trên cây B-Tree phình to ra.
  2. Số lượng nút trên một trang bộ nhớ (Data Page) giảm xuống, khiến độ sâu của cây B-Tree tăng lên.
  3. Mọi câu lệnh `INSERT` bắt buộc phải thực hiện Random I/O trên đĩa để cập nhật cây B-Tree, gây nghẽn RAM (`innodb_buffer_pool`) và làm Timeout thao tác GHI.

---

## 4. Phân tích tác động của việc thay đổi kiểu dữ liệu (VARCHAR sang TINYINT)
- **Tình huống:** Thay thế `VARCHAR(20)` của cột `status` thành `TINYINT` (1 byte).
- **Tác động tới Data Length:** Cột `VARCHAR(20)` tốn tối đa 21 bytes (1 byte độ dài + 20 bytes ký tự). Khi đổi sang `TINYINT` (1 byte), tiết kiệm trực tiếp 20 bytes cho mỗi bản ghi trên bảng dữ liệu chính.
- **Tác động tới Index Length (nếu nằm trong Index):**
  - Mật độ lưu trữ nút trên cây B-Tree tăng vọt (mỗi trang bộ nhớ chứa được nhiều node hơn).
  - Chiều cao cây B-Tree giảm xuống, giúp giảm tổng kích thước `Index_length` trên đĩa cứng và giải phóng dung lượng bộ nhớ RAM cache.