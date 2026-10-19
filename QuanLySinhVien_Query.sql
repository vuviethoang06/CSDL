-- =============================================================================
-- DỰ ÁN: THỰC HÀNH CÁC CÂU LỆNH TRUY VẤN CƠ BẢN CSDL QUẢN LÝ SINH VIÊN
-- Cơ sở dữ liệu: QuanLySinhVien
-- =============================================================================

-- Bước 1: Khởi tạo và sử dụng Cơ sở dữ liệu QuanLySinhVien
CREATE DATABASE IF NOT EXISTS QuanLySinhVien;
USE QuanLySinhVien;

-- Xóa các bảng cũ nếu đã tồn tại (theo đúng thứ tự ràng buộc khóa ngoại)
DROP TABLE IF EXISTS Mark;
DROP TABLE IF EXISTS Subject;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Class;

-- -----------------------------------------------------------------------------
-- BẢNG DỮ LIỆU & RÀNG BUỘC (DDL)
-- -----------------------------------------------------------------------------

CREATE TABLE Class (
    ClassID INT AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(255) NOT NULL,
    StartDate DATETIME NOT NULL,
    Status BIT
);

CREATE TABLE Student (
    StudentId INT AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address VARCHAR(50),
    Phone VARCHAR(20),
    Status BIT,
    ClassId INT NOT NULL,
    FOREIGN KEY (ClassId) REFERENCES Class (ClassID)
);

CREATE TABLE Subject (
    SubId INT AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit TINYINT DEFAULT 1 CHECK (Credit >= 1),
    Status BIT DEFAULT 1
);

CREATE TABLE Mark (
    MarkId INT AUTO_INCREMENT PRIMARY KEY,
    SubId INT NOT NULL,
    StudentId INT NOT NULL,
    Mark FLOAT DEFAULT 0 CHECK (Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT 1,
    UNIQUE (SubId, StudentId),
    FOREIGN KEY (SubId) REFERENCES Subject (SubId),
    FOREIGN KEY (StudentId) REFERENCES Student (StudentId)
);

-- -----------------------------------------------------------------------------
-- CHÈN DỮ LIỆU MẪU (DML)
-- -----------------------------------------------------------------------------

INSERT INTO Class (ClassID, ClassName, StartDate, Status) VALUES
(1, 'A1', '2008-12-20', 1),
(2, 'A2', '2008-12-22', 1),
(3, 'B3', '2011-05-04', 0);

INSERT INTO Student (StudentName, Address, Phone, Status, ClassId) VALUES
('Hung', 'Ha Noi', '0912113113', 1, 1),
('Hoa', 'Hai Phong', NULL, 1, 1),
('Manh', 'HCM', '0931231234', 0, 2);

INSERT INTO Subject (SubId, SubName, Credit, Status) VALUES
(1, 'CF', 5, 1),
(2, 'C', 6, 1),
(3, 'HDJ', 5, 1),
(4, 'RDBMS', 10, 1);

INSERT INTO Mark (SubId, StudentId, Mark, ExamTimes) VALUES
(1, 1, 8, 1),
(1, 2, 10, 2),
(2, 1, 12, 1);

-- =============================================================================
-- TRUY VẤN DỮ LIỆU THỰC HÀNH (DQL)
-- =============================================================================

-- Bước 2: Hiển thị danh sách tất cả các học viên
SELECT *
FROM Student;

-- Bước 3: Hiển thị danh sách các học viên đang theo học (Status = true/1)
SELECT *
FROM Student
WHERE Status = true;

-- Bước 4: Hiển thị danh sách các môn học có thời gian học (Credit) nhỏ hơn 10 giờ
SELECT *
FROM Subject
WHERE Credit < 10;

-- Bước 5: Hiển thị danh sách học viên lớp A1
SELECT S.StudentId, S.StudentName, C.ClassName
FROM Student S 
JOIN Class C ON S.ClassId = C.ClassID
WHERE C.ClassName = 'A1';

-- Bước 6: Hiển thị điểm môn CF của các học viên
SELECT S.StudentId, S.StudentName, Sub.SubName, M.Mark
FROM Student S 
JOIN Mark M ON S.StudentId = M.StudentId 
JOIN Subject Sub ON M.SubId = Sub.SubId
WHERE Sub.SubName = 'CF';