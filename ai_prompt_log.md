```markdown
# NHẬT KÝ TƯƠNG TÁC AI (AI PROMPT LOG)
**Học viên:** Database Performance Engineer Trainee  
**Dự án:** PayFlow Query Performance Optimization  

---

### Prompt 1: Tìm hiểu ý nghĩa thuật ngữ SARGable
* **Nội dung Prompt:**  
  > "Thuật ngữ 'SARGable' trong SQL là gì? Tại sao việc sử dụng các hàm như YEAR(col), MONTH(col) hay SUBSTRING(col) trong mệnh đề WHERE lại khiến MySQL từ chối sử dụng Index và dẫn đến Full Table Scan?"
* **Kết quả nhận được & Ứng dụng:**  
  AI giải thích SARGable (*Search Argument Able*) nghĩa là câu lệnh cho phép CSDL tận dụng cấu trúc cây B-Tree của Index để tra cứu nhanh. Việc bọc hàm quanh cột làm mất cấu trúc sắp xếp của B-Tree, buộc CSDL phải chạy hàm đó trên từng bản ghi. Áp dụng chuyển sang điều kiện so sánh dải thời gian `created_at >= ... AND created_at < ...`.

---

### Prompt 2: Thứ tự các cột trong Composite Index
* **Nội dung Prompt:**  
  > "Khi thiết kế một Composite Index trong MySQL cho cột (`transaction_type`, `created_at`), thứ tự các cột trong Index có quan trọng không? Tôi nên đặt cột nào đứng trước để có hiệu suất lọc dữ liệu (Selectivity) tốt nhất?"
* **Kết quả nhận được & Ứng dụng:**  
  AI phân tích quy tắc *Leftmost Prefix*: Đặt cột có phép so sánh bằng (`transaction_type = 'DEPOSIT'`) lên trước, cột có phép so sánh khoảng/range (`created_at >= ...`) lên sau. Do đó thứ tự chuẩn là `(transaction_type, created_at)`.

---

### Prompt 3: Phân biệt các giá trị trong cột Extra của EXPLAIN
* **Nội dung Prompt:**  
  > "Trong kết quả EXPLAIN, cột 'Extra' hiển thị chữ 'Using index condition' khác gì với 'Using index' (Covering Index)?"
* **Kết quả nhận được & Ứng dụng:**  
  `Using index` xảy ra khi tất cả các cột trong SELECT đều nằm trong Index (Covering Index - không cần đọc lại bảng gốc). `Using index condition` áp dụng cơ chế *Index Condition Pushdown (ICP)*, cho phép MySQL lọc dữ liệu ngay tại tầng Storage Engine bằng Index trước khi quay lại đọc dữ liệu từ Clustered Index (Primary Key).