# CHUYỂN ĐỔI MÔ HÌNH ERD SANG MÔ HÌNH DỮ LIỆU QUAN HỆ

## Bước 1: Xác định các thực thể có trong mô hình ERD
Dựa vào sơ đồ ERD, hệ thống gồm có 5 thực thể chính:
1. **PHIEUXUAT** (Phiếu xuất): Lưu trữ thông tin về các phiếu xuất kho.
2. **VATTU** (Vật tư): Lưu trữ thông tin về các mặt hàng/vật tư trong kho.
3. **PHIEUNHAP** (Phiếu nhập): Lưu trữ thông tin về các phiếu nhập kho.
4. **DONDH** (Đơn đặt hàng): Lưu trữ thông tin các đơn đặt hàng với nhà cung cấp.
5. **NHACC** (Nhà cung cấp): Lưu trữ thông tin về nhà cung cấp.

---

## Bước 2: Xác định các mối quan hệ (1-1, 1-N, N-M) giữa các thực thể
Phân tích các mối quan hệ và cách chuyển đổi sang mô hình quan hệ:

1. **Mối quan hệ N-M: (1) Chi tiết phiếu xuất giữa `PHIEUXUAT` và `VATTU`**
   - Loại quan hệ: Nhiều - Nhiều (N - N).
   - Xử lý: Sinh ra bảng trung gian **`CHITIETPHIEUXUAT`** chứa khóa chính của 2 thực thể (`SoPX`, `MaVTU`) làm khóa chính hợp thành và khóa ngoại, kết hợp với các thuộc tính của mối quan hệ (`DGXuat`, `SLXuat`).

2. **Mối quan hệ N-M: (2) Chi tiết phiếu nhập giữa `VATTU` và `PHIEUNHAP`**
   - Loại quan hệ: Nhiều - Nhiều (N - N).
   - Xử lý: Sinh ra bảng trung gian **`CHITIETPHIEUNHAP`** chứa khóa chính của 2 thực thể (`SoPN`, `MaVTU`) làm khóa chính hợp thành và khóa ngoại, kết hợp với các thuộc tính của mối quan hệ (`DGNhap`, `SLNhap`).

3. **Mối quan hệ N-M: (3) Chi tiết đơn đặt hàng giữa `VATTU` và `DONDH`**
   - Loại quan hệ: Nhiều - Nhiều (N - N).
   - Xử lý: Sinh ra bảng trung gian **`CHITIETDONDATHANG`** chứa khóa chính của 2 thực thể (`SoDH`, `MaVTU`) làm khóa chính hợp thành và khóa ngoại.

4. **Mối quan hệ 1-N: (4) Cung cấp giữa `NHACC` và `DONDH`**
   - Loại quan hệ: 1 - Nhiều (1 nhà cung cấp có thể có N đơn đặt hàng).
   - Xử lý: Chuyển khóa chính `MaNCC` từ bảng bên 1 (`NHACC`) sang làm khóa ngoại trong bảng bên N (`DONDH`).

---

## Bước 3: Xác định các thuộc tính đa trị và tạo thành 1 bảng mới
- Trong mô hình ERD, thực thể `NHACC` có thuộc tính đa trị **`SĐT`** (Số điện thoại) được ký hiệu bằng hình elip viền kép.
- **Xử lý:** Tách thuộc tính đa trị này thành một bảng riêng biệt tên là **`NHACC_SDT`**.
- Bảng mới bao gồm: `MaNCC` (Khóa ngoại trỏ về bảng `NHACC`) và `SDT` (Số điện thoại). Cặp (`MaNCC`, `SDT`) đóng vai trò là khóa chính hợp thành.

---

## Bước 4: Liệt kê lại danh sách các bảng sau khi chuyển đổi xong

### 1. Bảng `PHIEUXUAT` (Phiếu xuất)
- **SoPX** (Primary Key)
- NgayXuat

### 2. Bảng `VATTU` (Vật tư)
- **MaVTU** (Primary Key)
- TenVTU

### 3. Bảng `PHIEUNHAP` (Phiếu nhập)
- **SoPN** (Primary Key)
- NgayNhap

### 4. Bảng `NHACC` (Nhà cung cấp)
- **MaNCC** (Primary Key)
- TenNCC
- DiaChi

### 5. Bảng `DONDH` (Đơn đặt hàng)
- **SoDH** (Primary Key)
- NgayDH
- *MaNCC* (Foreign Key - trỏ đến `NHACC.MaNCC`)

### 6. Bảng `CHITIETPHIEUXUAT` (Chi tiết phiếu xuất)
- **SoPX** (Primary Key, Foreign Key - trỏ đến `PHIEUXUAT.SoPX`)
- **MaVTU** (Primary Key, Foreign Key - trỏ đến `VATTU.MaVTU`)
- DGXuat
- SLXuat

### 7. Bảng `CHITIETPHIEUNHAP` (Chi tiết phiếu nhập)
- **SoPN** (Primary Key, Foreign Key - trỏ đến `PHIEUNHAP.SoPN`)
- **MaVTU** (Primary Key, Foreign Key - trỏ đến `VATTU.MaVTU`)
- DGNhap
- SLNhap

### 8. Bảng `CHITIETDONDATHANG` (Chi tiết đơn đặt hàng)
- **SoDH** (Primary Key, Foreign Key - trỏ đến `DONDH.SoDH`)
- **MaVTU** (Primary Key, Foreign Key - trỏ đến `VATTU.MaVTU`)

### 9. Bảng `NHACC_SDT` (Số điện thoại Nhà cung cấp - Thuộc tính đa trị)
- **MaNCC** (Primary Key, Foreign Key - trỏ đến `NHACC.MaNCC`)
- **SDT** (Primary Key)