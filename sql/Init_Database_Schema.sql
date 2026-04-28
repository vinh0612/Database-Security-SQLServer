CREATE DATABASE DemoDB_Security;
GO
USE DemoDB_Security;
GO

-- Tạo bảng SinhVien với trường CCCD được lưu dưới dạng VARBINARY để chứa dữ liệu mã hóa
CREATE TABLE SinhVien (
    MSSV VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    CCCD_Encrypted VARBINARY(MAX) -- Dữ liệu nhạy cảm đã mã hóa
);
GO

SELECT * FROM SinhVien;