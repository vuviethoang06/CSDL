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
# THỰC HÀNH TẠO BẢNG (TABLE) TRÊN MYSQL WORKBENCH

## Bài tập: Tạo bảng `Class` và `Teacher` trong Schema `student-management`

---

## 1. Tạo bảng `Class` bằng giao diện đồ họa (GUI)

Các bước thực hiện:
- **Bước 1:** Khởi động MySQL Workbench, mở kết nối. Tại cột **SCHEMAS** bên trái, click chuột phải vào schema `student-management` và chọn **Create Table...**
- **Bước 2:** Đặt tên cho bảng là `Class`. Tiến hành điền tên các trường (Columns), kiểu dữ liệu (Data Type) và thiết lập thuộc tính (PK, NN, AI,...).
- **Bước 3:** Nhấn nút **Apply**, kiểm tra câu lệnh DDL tự động sinh ra và tiếp tục nhấn **Apply** -> **Finish** để hoàn tất tạo bảng `Class`.

### Hình ảnh minh chứng tạo bảng Class:
![Minh chứng tạo bảng Class](./tao_bang_class_gui.png)

---

## 2. Tạo bảng `Teacher` bằng giao diện đồ họa (GUI)

Các bước thực hiện tương tự:
- **Bước 1:** Click chuột phải vào schema `student-management` (hoặc thư mục Tables bên trong schema) chọn **Create Table...**
- **Bước 2:** Đặt tên cho bảng là `Teacher` và điền các trường dữ liệu tương ứng cho giáo viên.
- **Bước 3:** Nhấn **Apply** hai lần để hoàn thành tạo bảng `Teacher`.

### Hình ảnh minh chứng tạo bảng Teacher:
![Minh chứng tạo bảng Teacher](./tao_bang_teacher_gui.png)

---

## 3. Tạo bảng bằng câu lệnh SQL (Dành cho phần Script)

```sql
USE `student-management`;

-- Tạo bảng Class
CREATE TABLE IF NOT EXISTS `Class` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`id`)
);

-- Tạo bảng Teacher
CREATE TABLE IF NOT EXISTS `Teacher` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `age` INT NULL,
  `country` VARCHAR(45) NULL,
  PRIMARY KEY (`id`)
);
