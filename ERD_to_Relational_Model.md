# BÀI TẬP: CHUYỂN ĐỔI MÔ HÌNH ERD SANG MÔ HÌNH DỮ LIỆU QUAN HỆ

## Bước 1: Xác định các thực thể có trong mô hình ERD
*(Danh sách các thực thể được xác định từ sơ đồ ERD)*
- **Thực thể 1:** [Tên thực thể 1, ví dụ: NHANVIEN]
- **Thực thể 2:** [Tên thực thể 2, ví dụ: PHONGBAN]
- **Thực thể 3:** [Tên thực thể 3, ví dụ: DACSAN]

---

## Bước 2: Phân tích các mối quan hệ (1-1, 1-N, N-M)
1. **Mối quan hệ 1 - N:**
   - Đưa khóa chính của bên `1` sang làm khóa ngoại (Foreign Key) ở bên `N`.
   - *Ví dụ:* Mối quan hệ giữa [Thực thể A] và [Thực thể B].

2. **Mối quan hệ N - M:**
   - Tạo thêm một bảng trung gian mới chứa khóa chính của cả 2 thực thể làm khóa ngoại (đồng thời tạo thành khóa chính hợp thành).
   - *Ví dụ:* Mối quan hệ giữa [Thực thể B] và [Thực thể C] sinh ra bảng trung gian [Tên_Bảng_Trung_Gian].

3. **Mối quan hệ 1 - 1 (nếu có):**
   - Đưa khóa chính của một trong hai thực thể sang làm khóa ngoại ở thực thể còn lại.

---

## Bước 3: Xác định thuộc tính đa trị (Multivalued Attributes)
- Tách thuộc tính đa trị thành một bảng riêng biệt.
- Bảng mới bao gồm: Khóa chính của thực thể gốc (làm khóa ngoại) + Thuộc tính đa trị.

---

## Bước 4: Danh sách các bảng hoàn chỉnh sau khi chuyển đổi

### 1. Bảng [TÊN_BẢNG_1]
- `ma_thuc_the_1` (Primary Key)
- `ten_thuoc_tinh_1`
- `ten_thuoc_tinh_2`

### 2. Bảng [TÊN_BẢNG_2]
- `ma_thuc_the_2` (Primary Key)
- `ten_thuoc_tinh`
- `ma_thuc_the_1` (Foreign Key - Trỏ đến Bảng 1)

### 3. Bảng trung gian [TÊN_BẢNG_TRUNG_GIAN]
- `ma_thuc_the_1` (Primary Key, Foreign Key)
- `ma_thuc_the_2` (Primary Key, Foreign Key)
- `thuoc_tinh_rieng_cua_quan_he` (nếu có)