# BÁO CÁO PHÂN TÍCH VỆNH DỮ LIỆU & BẢO VỆ TÍNH TOÀN VẸN (GAP ANALYSIS REPORT)
**Dự án:** Hệ thống quản lý cho thuê xe tự lái AutoRide  
**Vai trò:** Data Architect  

---

### 1. Phân tích các khoảng trống dữ liệu (Data Gaps) giữa Activity Diagram và Legacy Schema

| STT | Luồng nghiệp vụ (UML Activity Diagram) | Hạn chế của Legacy Schema | Hậu quả thực tế & Rủi ro tài chính |
| :--- | :--- | :--- | :--- |
| **1** | Vòng đời hợp đồng 4 bước: `BOOKED` -> `ACTIVE` -> `COMPLETED` / `CANCELLED`. | Cột `status VARCHAR(50)` không kiểm soát được tập giá trị nhập vào. | Nhân viên gõ sai chính tả trạng thái, gây sai lệch báo cáo và lọt lưới quy trình. |
| **2** | Nhánh rẽ tính phạt: Phí phạt trễ (`late_fee`) & Phí sửa chữa hư hỏng (`damage_fee`). | Thiếu hoàn toàn các cột lưu tiền cọc (`security_deposit`), `late_fee`, `damage_fee`. | Kế toán không có căn cứ tính Tiền hoàn lại ($Refund = Deposit - LateFee - DamageFee$), gây thất thoát doanh thu nghiêm trọng. |
| **3** | Kiểm tra tình trạng xe (Inspection) khi trả xe. | Vắng bóng bảng `Inspections` ghi nhận chi tiết hỏng hóc/trầy xước. | Không lưu vết lịch sử hư hỏng của xe, không thể quy trách nhiệm minh bạch cho khách hàng. |

---

### 2. Lý do cột `damage_fee` là bắt buộc để hệ thống toàn vẹn
Cột `damage_fee` là điểm chốt chặn tài chính khi xe gặp sự cố. Nếu không có cột này, hệ thống sẽ rơi vào tình trạng **bất đồng bộ giữa nghiệp vụ thực tế và dữ liệu**. Nhân viên buộc phải xử lý ngoại hối ngoài hệ thống (ghi sổ tay/chuyển khoản riêng), dẫn đến mất dấu vết dòng tiền (Audit Trail), kế toán không thể đối soát doanh thu cuối tháng và gây lỗ hỏng nghiêm trọng trong quản trị tài chính doanh nghiệp.