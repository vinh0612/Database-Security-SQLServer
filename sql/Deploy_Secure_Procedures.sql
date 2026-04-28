USE DemoDB_Security;
GO

-- Stored Procedure để Thêm sinh viên (Mã hóa dữ liệu đầu vào)
CREATE PROCEDURE sp_InsertSinhVien
    @MSSV VARCHAR(10),
    @HoTen NVARCHAR(100),
    @NgaySinh DATE,
    @CCCD_ClearText VARCHAR(20)
AS
BEGIN
    -- Mở Key để sử dụng
    OPEN SYMMETRIC KEY SymKey_AES256_SinhVien DECRYPTION BY CERTIFICATE Cert_QuanLySinhVien;

    -- Thực hiện Insert, hàm EncryptByKey sẽ mã hóa CCCD
    INSERT INTO SinhVien (MSSV, HoTen, NgaySinh, CCCD_Encrypted)
    VALUES (
        @MSSV, 
        @HoTen, 
        @NgaySinh, 
        EncryptByKey(Key_GUID('SymKey_AES256_SinhVien'), @CCCD_ClearText)
    );

    -- Đóng Key
    CLOSE SYMMETRIC KEY SymKey_AES256_SinhVien;
END;
GO

-- Stored Procedure để Xem danh sách sinh viên (Giải mã dữ liệu)
CREATE PROCEDURE sp_GetDanhSachSinhVien
AS
BEGIN
    -- Mở Key để giải mã
    OPEN SYMMETRIC KEY SymKey_AES256_SinhVien DECRYPTION BY CERTIFICATE Cert_QuanLySinhVien;

    -- Select và dùng DecryptByKey để giải mã, sau đó CONVERT lại thành VARCHAR
    SELECT 
        MSSV, 
        HoTen, 
        NgaySinh, 
        CCCD_Encrypted AS [DuLieuMaHoa_TrongDB], -- Hiển thị cục binary để demo
        CONVERT(VARCHAR(20), DecryptByKey(CCCD_Encrypted)) AS [CCCD_DaGiaiMa]
    FROM SinhVien;

    -- Đóng Key
    CLOSE SYMMETRIC KEY SymKey_AES256_SinhVien;
END;
GO

-- Thêm dữ liệu mẫu thông qua Stored Procedure
EXEC sp_InsertSinhVien 'SV001', N'Nguyễn Văn A', '2004-01-01', '079012345678';
EXEC sp_InsertSinhVien 'SV002', N'Trần Thị B', '2004-05-15', '079098765432';
GO

EXEC sp_GetDanhSachSinhVien;