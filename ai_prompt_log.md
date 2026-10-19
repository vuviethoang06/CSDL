# NHẬT KÝ TƯƠNG TÁC AI (AI PROMPT LOG)
**Học viên:** Data Architect Trainee  
**Dự án:** AutoRide Database Optimization  

---

### Prompt 1: Chọn kiểu dữ liệu tài chính tối ưu
* **Nội dung Prompt:**  
  > "Khi lưu trữ các khoản tiền cọc, phí phạt trễ, phí hư hỏng trong MySQL, tại sao nên dùng kiểu `DECIMAL(10, 2)` thay vì `FLOAT` hay `DOUBLE`? Sự khác biệt về mặt lưu trữ số thực giữa chúng là gì?"
* **Kết quả nhận được & Ứng dụng:**  
  AI giải thích kiểu `DECIMAL` lưu số thực dạng chuỗi cố định (Fixed-point representation) giúp tránh hoàn toàn lỗi làm tròn số của IEEE 754 trên `FLOAT/DOUBLE`. Áp dụng `DECIMAL(10, 2)` cho các cột `security_deposit`, `late_fee`, `damage_fee`.

---

### Prompt 2: Lựa chọn Cardinality cho bảng Kiểm tra xe
* **Nội dung Prompt:**  
  > "Bảng `Inspections` kiểm tra xe nên liên kết với `Rentals` theo quan hệ 1-1 hay 1-N? Nếu một hợp đồng có thể kiểm tra xe nhiều lần (lúc giao và lúc nhận) thì thiết kế khóa ngoại như thế nào?"
* **Kết quả nhận được & Ứng dụng:**  
  AI phân tích nên chọn quan hệ **1-N** (`Rentals` 1 --- N `Inspections`) để mở rộng quy mô (cho phép kiểm tra xe ở cả đầu vào lẫn đầu ra). Khóa ngoại `rental_id` được đặt trong bảng `Inspections` với thuộc tính `ON DELETE RESTRICT` để đảm bảo toàn vẹn dữ liệu.

---

### Prompt 3: Thiết lập Trigger ràng buộc trạng thái nghiệp vụ
* **Nội dung Prompt:**  
  > "Viết giúp tôi cú pháp MySQL Trigger `BEFORE INSERT` trên bảng `Inspections` để chặn hành động tạo biên bản kiểm tra nếu `Rentals.status` đang ở trạng thái `BOOKED`."
* **Kết quả nhận được & Ứng dụng:**  
  Ứng dụng cú pháp `SIGNAL SQLSTATE '45000'` để quăng lỗi ngay từ tầng CSDL nếu ứng dụng Backend cố tình gọi API tạo biên bản kiểm tra sai thời điểm.