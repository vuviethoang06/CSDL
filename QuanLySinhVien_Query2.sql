-- =============================================================================
-- DỰ ÁN: CÁC CÂU LỆNH TRUY VẤN NÂNG CAO (CSDL QUẢN LÝ SINH VIÊN)
-- Database: QuanLySinhVien
-- =============================================================================

USE QuanLySinhVien;

-- -----------------------------------------------------------------------------
-- 1. Hiển thị tất cả các sinh viên có tên bắt đầu bằng ký tự 'h' / 'H'
-- -----------------------------------------------------------------------------
SELECT *
FROM Student
WHERE StudentName LIKE 'h%';

-- -----------------------------------------------------------------------------
-- 2. Hiển thị các thông tin lớp học có thời gian bắt đầu vào tháng 12
-- -----------------------------------------------------------------------------
SELECT *
FROM Class
WHERE MONTH(StartDate) = 12;

-- -----------------------------------------------------------------------------
-- 3. Hiển thị tất cả các thông tin môn học có credit trong khoảng từ 3 đến 5
-- -----------------------------------------------------------------------------
SELECT *
FROM Subject
WHERE Credit BETWEEN 3 AND 5;

-- -----------------------------------------------------------------------------
-- 4. Thay đổi mã lớp (ClassID) của sinh viên có tên 'Hung' thành 2
-- -----------------------------------------------------------------------------
SET SQL_SAFE_UPDATES = 0; -- Tắt safe update mode nếu cần

UPDATE Student
SET ClassId = 2
WHERE StudentName = 'Hung';

SET SQL_SAFE_UPDATES = 1; -- Bật lại safe update mode

-- -----------------------------------------------------------------------------
-- 5. Hiển thị StudentName, SubName, Mark. Sắp xếp điểm giảm dần, nếu trùng sắp xếp tên tăng dần
-- -----------------------------------------------------------------------------
SELECT 
    S.StudentName, 
    Sub.SubName, 
    M.Mark
FROM Student S
JOIN Mark M ON S.StudentId = M.StudentId
JOIN Subject Sub ON M.SubId = Sub.SubId
ORDER BY M.Mark DESC, S.StudentName ASC;