# THỰC HÀNH XÓA CƠ SỞ DỮ LIỆU (DROP DATABASE)

## Cách 1: Xóa CSDL bằng giao diện đồ họa MySQL Workbench (GUI)
Các bước thực hiện:
1. Mở MySQL Workbench, chọn mục **SCHEMAS** ở cột bên trái.
2. Click chuột phải vào Cơ sở dữ liệu cần xóa -> Chọn **Drop Schema...**
3. Trong hộp thoại xác nhận, nhấn **Drop Now** để xóa CSDL.

![Minh chứng xóa CSDL bằng GUI](./xoa_csdl_gui.png)

---

## Cách 2: Xóa CSDL bằng câu lệnh SQL
Lệnh SQL xóa CSDL:
```sql
DROP DATABASE `my_database1`;
