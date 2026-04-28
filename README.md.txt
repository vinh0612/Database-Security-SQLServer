# Demo: Database Security in SQL Server (RBAC & AES-256)

Dự án này là minh chứng kỹ thuật cho Chương 5: Tìm hiểu chuyên sâu công nghệ (Báo cáo giữa kỳ). Kịch bản mô phỏng một hệ thống Quản lý Sinh viên, tập trung vào việc bảo vệ dữ liệu nhạy cảm ngay tại tầng Cơ sở dữ liệu (Database Layer).

## 🛡️ Kiến trúc & Công nghệ áp dụng
1. **Mã hóa AES-256 (TDE/Column-Level Encryption):** Bảo vệ trường dữ liệu Căn cước công dân (CCCD). Dữ liệu được lưu dưới dạng `VARBINARY(MAX)`.
2. **Role-Based Access Control (RBAC):** Cấp quyền dựa trên vai trò.
3. **Stored Procedures Proxy:** Chặn (DENY) quyền truy cập trực tiếp vào Data Tables. Mọi thao tác Thêm/Đọc đều phải thông qua Stored Procedures để đảm bảo tính toàn vẹn và kiểm soát luồng giải mã.

## ⚙️ Yêu cầu hệ thống
* Microsoft SQL Server 2016 trở lên.
* SQL Server Management Studio (SSMS) hoặc Azure Data Studio.

## 🚀 Hướng dẫn cài đặt và chạy thử

Vui lòng thực thi các file script trong thư mục `sql/` theo thứ tự sau:

1. **`Init_Database_Schema.sql`**: Tạo Database `DemoDB_Security` và bảng `SinhVien`.
2. **`Config_Encryption_Keys.sql`**: Khởi tạo Master Key, Certificate và Symmetric Key (AES_256).
3. **`Deploy_Secure_Procedures.sql`**: Tạo các thủ tục thêm sinh viên (kèm mã hóa) và lấy danh sách (kèm giải mã).
4. **`Apply_RBAC_Policies.sql`**: Tạo Role `Role_QuanLyDaoTao`, phân quyền `EXECUTE` và chặn quyền `SELECT/INSERT` trực tiếp vào bảng.

## 📸 Demo kết quả

*Chèn ảnh chụp màn hình SSMS tại đây*
- **Hình 1:** Ảnh chạy câu lệnh `SELECT * FROM SinhVien` (với tư cách là sysadmin) để cho thấy cột CCCD lưu dưới dạng mã hóa không thể đọc được.
![Hình 1: Dữ liệu mã hóa](images/demo_encrypted_data.png)
- **Hình 2:** Ảnh thực thi `EXEC sp_GetDanhSachSinhVien` trả về cột đã giải mã hợp lệ.
![Hình 1: Dữ liệu mã hóa](images/demo_decrypted_data.png)
- **Hình 3:** Ảnh báo lỗi (Permission Denied) khi một user thuộc `Role_QuanLyDaoTao` cố gắng `SELECT` trực tiếp từ bảng `SinhVien`.
![Hình 1: Dữ liệu mã hóa](images/demo_permission_denied.png)

## ⚖️ Phân tích Ưu - Nhược điểm

**Ưu điểm:**
* **Bảo mật tuyệt đối ở tầng Data:** Kể cả khi hacker khai thác được SQL Injection để `SELECT * FROM SinhVien` hoặc trộm được file `.bak` (database backup), họ cũng chỉ nhận lại chuỗi Hex Vô nghĩa (Varbinary).
* **Kiểm soát truy cập chặt chẽ:** User ứng dụng không thể thao tác sai lệch dữ liệu do bị khóa quyền trực tiếp vào Table.

**Nhược điểm (Trade-off):**
* **Hiệu suất (Performance):** Việc liên tục Mở/Đóng Symmetric Key và tính toán mã hóa/giải mã sẽ tiêu tốn tài nguyên CPU của Database Server, đặc biệt khi query hàng triệu dòng.
* **Bảo trì & Quản lý Key:** Cần quy trình backup Master Key và Certificate nghiêm ngặt. Nếu mất Certificate, dữ liệu mã hóa sẽ vĩnh viễn không thể khôi phục.