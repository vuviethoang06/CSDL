# BÁO CÁO GIẢI TRÌNH KỸ THUẬT VỀ TỐI ƯU TRUY VẤN (JOIN ANALYSIS)
**Dự án:** Hệ thống báo cáo Siêu Sale FlashMart  
**Vai trò:** Data Engineer  

---

### 1. Phân tích nguyên nhân lỗi ở Legacy Script
Lập trình viên tập sự đã lạm dụng `INNER JOIN` (viết tắt là `JOIN`), loại JOIN này chỉ trả về giao điểm (Intersection) của hai tập hợp dữ liệu.
- **Báo cáo Marketing:** Khách hàng Charlie chưa có bản ghi tương ứng trong `Orders` nên bị loại bỏ hoàn toàn khỏi kết quả.
- **Báo cáo Kho vận:** `INNER JOIN` loại bỏ sản phẩm Keyboard vì nó chưa xuất hiện trong `Orders`. Sau đó điều kiện `WHERE o.order_id IS NULL` lọc ra dữ liệu NULL trên tập rỗng, dẫn đến kết quả trống trơn.

---

### 2. Lý do bắt buộc dùng `COUNT(o.order_id)` thay vì `COUNT(*)` khi `LEFT JOIN`
Khi thực hiện `LEFT JOIN`, dòng dữ liệu của khách hàng chưa từng mua hàng (như Charlie) vẫn được giữ lại, nhưng tất cả các cột từ bảng phụ `Orders` sẽ mang giá trị `NULL`.
- **Dùng `COUNT(*)`:** Hàm đếm tất cả các dòng dữ liệu được trả về. Do dòng của Charlie tồn tại trong bảng kết quả tạm nên `COUNT(*)` sẽ đếm dòng này và trả về **1** (Sai lệch nghiệp vụ nghiêm trọng).
- **Dùng `COUNT(o.order_id)`:** Hàm đếm chỉ tính các giá trị **NON-NULL** trên cột `o.order_id`. Vì dòng của Charlie có `o.order_id IS NULL`, kết quả đếm sẽ trả về đúng **0** đơn hàng.