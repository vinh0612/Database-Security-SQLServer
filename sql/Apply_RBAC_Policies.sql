USE DemoDB_Security;
GO

-- 1. Tạo một Role đại diện cho người dùng có quyền Quản lý
CREATE ROLE Role_QuanLyDaoTao;
GO

-- 2. Cấp quyền EXECUTE trên các Stored Procedures cho Role này
GRANT EXECUTE ON sp_InsertSinhVien TO Role_QuanLyDaoTao;
GRANT EXECUTE ON sp_GetDanhSachSinhVien TO Role_QuanLyDaoTao;

-- 3. BẢO MẬT CỐT LÕI: Chặn toàn bộ quyền truy cập trực tiếp vào bảng SinhVien
DENY SELECT, INSERT, UPDATE, DELETE ON SinhVien TO Role_QuanLyDaoTao;
GO

-- 4. Tạo một User test và gán vào Role (Giả định Login đã được tạo)
CREATE LOGIN TestUser WITH PASSWORD = 'UserPassword123!';
CREATE USER TestUser FOR LOGIN TestUser;
ALTER ROLE Role_QuanLyDaoTao ADD MEMBER TestUser;
GO

EXECUTE AS USER = 'TestUser';
GO
SELECT * FROM SinhVien;
REVERT;
GO