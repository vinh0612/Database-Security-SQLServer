USE DemoDB_Security;
GO

-- 1. Tạo Master Key để bảo vệ chứng chỉ (Certificate)
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'StrongComplexPassword123!@#';
GO

-- 2. Tạo Certificate
CREATE CERTIFICATE Cert_QuanLySinhVien 
WITH SUBJECT = 'Chứng chỉ bảo mật dữ liệu Sinh Viên';
GO

-- 3. Tạo Symmetric Key sử dụng chuẩn AES 256, được bảo vệ bởi Certificate
CREATE SYMMETRIC KEY SymKey_AES256_SinhVien
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE Cert_QuanLySinhVien;
GO