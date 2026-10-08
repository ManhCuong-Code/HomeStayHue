-- HỆ THỐNG CƠ SỞ DỮ LIỆU: HOMESTAY HUẾ (HỆ THỐNG ĐẶT PHÒNG TRỰC TUYẾN)
-- CHUẨN ĐÁNH GIÁ (K2.1, K2.2, K2.3) | CHUẨN HÓA: 3NF | HEADER-LINE: Bookings - BookingNights
-- Hệ Quản Trị CSDL: Microsoft SQL Server 2019 / 2022 / Azure SQL

USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'HomeStayHueDB')
BEGIN
    CREATE DATABASE HomeStayHueDB COLLATE Vietnamese_CI_AS;
END
GO

USE HomeStayHueDB;
GO

-- ==========================================================================================
-- 0. XÓA BẢNG CŨ NẾU TỒN TẠI (THEO THỨ TỰ PHỤ THUỘ KHÓA NGOẠI)
-- ==========================================================================================
IF OBJECT_ID(N'dbo.BookingNights', N'U') IS NOT NULL DROP TABLE dbo.BookingNights;
IF OBJECT_ID(N'dbo.Bookings', N'U') IS NOT NULL DROP TABLE dbo.Bookings;
IF OBJECT_ID(N'dbo.RatePlans', N'U') IS NOT NULL DROP TABLE dbo.RatePlans;
IF OBJECT_ID(N'dbo.Rooms', N'U') IS NOT NULL DROP TABLE dbo.Rooms;
IF OBJECT_ID(N'dbo.RoomTypes', N'U') IS NOT NULL DROP TABLE dbo.RoomTypes;
IF OBJECT_ID(N'dbo.Guests', N'U') IS NOT NULL DROP TABLE dbo.Guests;
IF OBJECT_ID(N'dbo.AppUsers', N'U') IS NOT NULL DROP TABLE dbo.AppUsers;
GO

-- ==========================================================================================
-- 1. BẢNG TÀI KHOẢN QUẢN TRỊ (Phục vụ K4.1, K4.2: Phân quyền Host / Lễ tân [Authorize])
-- ==========================================================================================
CREATE TABLE dbo.AppUsers (
    Id INT IDENTITY(1,1) CONSTRAINT PK_AppUsers PRIMARY KEY,
    Username VARCHAR(50) NOT NULL CONSTRAINT UQ_AppUsers_Username UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) NULL,
    Role VARCHAR(20) NOT NULL CONSTRAINT CK_AppUsers_Role CHECK (Role IN ('Admin', 'Host', 'Staff', 'Customer')),
    IsActive BIT NOT NULL CONSTRAINT DF_AppUsers_IsActive DEFAULT (1),
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_AppUsers_CreatedAt DEFAULT (SYSUTCDATETIME())
);
GO

-- ==========================================================================================
-- 2. BẢNG KHÁCH HÀNG (Guests) - Chuẩn 3NF (Tách riêng khỏi đơn đặt phòng)
-- ==========================================================================================
CREATE TABLE dbo.Guests (
    Id INT IDENTITY(1,1) CONSTRAINT PK_Guests PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NULL,
    IdentityCard VARCHAR(30) NULL, -- CCCD / Passport (dùng khi làm thủ tục check-in)
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Guests_CreatedAt DEFAULT (SYSUTCDATETIME())
);
GO

CREATE INDEX IX_Guests_PhoneNumber ON dbo.Guests (PhoneNumber);
GO

-- ==========================================================================================
-- 3. BẢNG LOẠI PHÒNG (RoomTypes)
-- ==========================================================================================
CREATE TABLE dbo.RoomTypes (
    Id INT IDENTITY(1,1) CONSTRAINT PK_RoomTypes PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL CONSTRAINT UQ_RoomTypes_TypeName UNIQUE,
    Description NVARCHAR(MAX) NULL,
    MaxGuests INT NOT NULL CONSTRAINT CK_RoomTypes_MaxGuests CHECK (MaxGuests > 0),
    BasePrice DECIMAL(18,2) NOT NULL CONSTRAINT CK_RoomTypes_BasePrice CHECK (BasePrice >= 0),
    Amenities NVARCHAR(MAX) NULL, -- Danh sách tiện nghi (Điều hòa, Bồn tắm sỏi, Trà cung đình...)
    ImageUrl NVARCHAR(500) NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_RoomTypes_IsActive DEFAULT (1)
);
GO

-- ==========================================================================================
-- 4. BẢNG PHÒNG CỤ THỂ (Rooms) - Khóa ngoại liên kết RoomTypes
-- ==========================================================================================
CREATE TABLE dbo.Rooms (
    Id INT IDENTITY(1,1) CONSTRAINT PK_Rooms PRIMARY KEY,
    RoomNumber VARCHAR(20) NOT NULL CONSTRAINT UQ_Rooms_RoomNumber UNIQUE, -- Ví dụ: KL-101, KL-102
    RoomTypeId INT NOT NULL,
    Status VARCHAR(20) NOT NULL CONSTRAINT DF_Rooms_Status DEFAULT ('AVAILABLE')
        CONSTRAINT CK_Rooms_Status CHECK (Status IN ('AVAILABLE', 'OCCUPIED', 'CLEANING', 'MAINTENANCE')),
    IsActive BIT NOT NULL CONSTRAINT DF_Rooms_IsActive DEFAULT (1),
    CONSTRAINT FK_Rooms_RoomTypes FOREIGN KEY (RoomTypeId) 
        REFERENCES dbo.RoomTypes(Id) ON DELETE NO ACTION
);
GO

CREATE INDEX IX_Rooms_RoomTypeId ON dbo.Rooms (RoomTypeId);
GO

-- ==========================================================================================
-- 5. BẢNG CHÍNH SÁCH GIÁ THEO NGÀY (RatePlans) - Phục vụ Luật nghiệp vụ 2 (Dynamic Pricing)
-- Phân bổ giá theo Thứ trong tuần (0: CN, 1: T2, ..., 6: T7), phụ thu ngày lễ
-- ==========================================================================================
CREATE TABLE dbo.RatePlans (
    Id INT IDENTITY(1,1) CONSTRAINT PK_RatePlans PRIMARY KEY,
    RoomTypeId INT NOT NULL,
    DayOfWeek TINYINT NOT NULL CONSTRAINT CK_RatePlans_DayOfWeek CHECK (DayOfWeek BETWEEN 0 AND 6),
    Price DECIMAL(18,2) NOT NULL CONSTRAINT CK_RatePlans_Price CHECK (Price >= 0),
    IsWeekend BIT NOT NULL CONSTRAINT DF_RatePlans_IsWeekend DEFAULT (0),
    HolidaySurcharge DECIMAL(18,2) NOT NULL CONSTRAINT DF_RatePlans_HolidaySurcharge DEFAULT (0),
    CONSTRAINT FK_RatePlans_RoomTypes FOREIGN KEY (RoomTypeId) 
        REFERENCES dbo.RoomTypes(Id) ON DELETE CASCADE,
    CONSTRAINT UQ_RatePlans_RoomType_DayOfWeek UNIQUE (RoomTypeId, DayOfWeek)
);
GO

CREATE INDEX IX_RatePlans_RoomTypeId ON dbo.RatePlans (RoomTypeId);
GO

-- ==========================================================================================
-- 6. BẢNG ĐƠN ĐẶT PHÒNG - HEADER ENTITY (Bookings) - Tiêu chí K2.1 & K2.2
-- Đại diện Header cho toàn bộ giao dịch đặt phòng
-- ==========================================================================================
CREATE TABLE dbo.Bookings (
    Id INT IDENTITY(1,1) CONSTRAINT PK_Bookings PRIMARY KEY,
    BookingCode VARCHAR(20) NOT NULL CONSTRAINT UQ_Bookings_BookingCode UNIQUE, -- Ví dụ: BK2026100801
    GuestId INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    TotalGuests INT NOT NULL CONSTRAINT CK_Bookings_TotalGuests CHECK (TotalGuests > 0),
    TotalAmount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Bookings_TotalAmount DEFAULT (0) 
        CONSTRAINT CK_Bookings_TotalAmount CHECK (TotalAmount >= 0),
    DepositAmount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Bookings_DepositAmount DEFAULT (0)
        CONSTRAINT CK_Bookings_DepositAmount CHECK (DepositAmount >= 0),
    Status VARCHAR(30) NOT NULL CONSTRAINT DF_Bookings_Status DEFAULT ('PENDING_DEPOSIT')
        CONSTRAINT CK_Bookings_Status CHECK (Status IN ('PENDING_DEPOSIT', 'CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT', 'CANCELLED')),
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Bookings_CreatedAt DEFAULT (SYSUTCDATETIME()),
    CancelledAt DATETIME2(0) NULL,
    CancellationFee DECIMAL(18,2) NULL CONSTRAINT CK_Bookings_CancellationFee CHECK (CancellationFee IS NULL OR CancellationFee >= 0),
    Notes NVARCHAR(500) NULL,
    CONSTRAINT CK_Bookings_Dates CHECK (CheckOutDate > CheckInDate),
    CONSTRAINT FK_Bookings_Guests FOREIGN KEY (GuestId) 
        REFERENCES dbo.Guests(Id) ON DELETE NO ACTION
);
GO

CREATE INDEX IX_Bookings_GuestId ON dbo.Bookings (GuestId);
CREATE INDEX IX_Bookings_Dates ON dbo.Bookings (CheckInDate, CheckOutDate);
CREATE INDEX IX_Bookings_Status ON dbo.Bookings (Status);
GO

-- ==========================================================================================
-- 7. BẢNG CHI TIẾT ĐÊM LƯU TRÚ - LINEITEM ENTITY (BookingNights) - Tiêu chí K2.1 & K2.2
-- Đại diện LineItem: Mỗi đêm phòng là 1 dòng độc lập
-- Thực thi LUẬT 1 (Chống Overbooking) & LUẬT 2 (Tính tiền chính xác từng đêm)
-- ==========================================================================================
CREATE TABLE dbo.BookingNights (
    Id INT IDENTITY(1,1) CONSTRAINT PK_BookingNights PRIMARY KEY,
    BookingId INT NOT NULL,
    RoomId INT NOT NULL,
    NightDate DATE NOT NULL,
    Price DECIMAL(18,2) NOT NULL CONSTRAINT CK_BookingNights_Price CHECK (Price >= 0),
    CONSTRAINT FK_BookingNights_Bookings FOREIGN KEY (BookingId) 
        REFERENCES dbo.Bookings(Id) ON DELETE CASCADE,
    CONSTRAINT FK_BookingNights_Rooms FOREIGN KEY (RoomId) 
        REFERENCES dbo.Rooms(Id) ON DELETE NO ACTION
);
GO

-- Chỉ mục tối ưu hóa truy vấn chống Overbooking (Luật 1 - Tiêu chí K1.3 & K2.3)
CREATE INDEX IX_BookingNights_Room_Date ON dbo.BookingNights (RoomId, NightDate);
CREATE INDEX IX_BookingNights_BookingId ON dbo.BookingNights (BookingId);
GO

-- ==========================================================================================
-- 8. THÊM DỮ LIỆU KHỞI TẠO (SEED DATA) CHO HOMESTAY HUẾ
-- ==========================================================================================

-- 8.1. Tài khoản Phân Quyền Hệ Thống (Admin, Lễ Tân / Nhân Viên, Khách Hàng)
INSERT INTO dbo.AppUsers (Username, PasswordHash, FullName, Email, Role)
VALUES 
('admin', '123456', N'Quản Trị Viên Homestay Huế', 'admin@homestayhue.vn', 'Admin'),
('letan', '123456', N'Lễ Tân Homestay Huế (Nhân Viên)', 'letan@homestayhue.vn', 'Staff'),
('khachhang', '123456', N'Nguyễn Văn An (Khách Hàng)', 'an.nguyen@gmail.com', 'Customer');

-- 8.2. Khách hàng mẫu
INSERT INTO dbo.Guests (FullName, PhoneNumber, Email, IdentityCard)
VALUES 
(N'Nguyễn Văn An', '0905123456', 'an.nguyen@gmail.com', '046098001234'),
(N'Trần Thị Mai', '0914654321', 'mai.tran@gmail.com', '046199005678'),
(N'Lê Hoàng Nam', '0988776655', 'nam.le@gmail.com', '046095009988');

-- 8.3. Danh mục Loại phòng đặc trưng Huế
INSERT INTO dbo.RoomTypes (TypeName, Description, MaxGuests, BasePrice, Amenities, ImageUrl)
VALUES 
(N'Phòng Nhà Rường Cổ Điển', N'Không gian gỗ mít truyền thống Huế, view sân vườn hoa Cố Đô thanh tịnh.', 2, 700000, N'Điều hòa, Trà Cung Đình, Bồn tắm ngâm sỏi, Wifi', '/images/rooms/nha-ruong.jpg'),
(N'Phòng Gác Mái Sông Hương', N'Thiết kế gác lửng thoáng đãng, ngắm hoàng hôn ngã ba Tuần và bờ sông Hương.', 3, 900000, N'Điều hòa, Ban công view sông, Máy pha cà phê, Smart TV', '/images/rooms/gac-mai.jpg'),
(N'Villa Gia Đình Hương Giang', N'Biệt thự mini biệt lập dành cho gia đình hoặc nhóm bạn, có bếp nấu và sân BBQ ngoài trời.', 6, 1800000, N'Bếp đầy đủ tiện nghi, Sân BBQ riêng, 2 phòng tắm, Máy giặt', '/images/rooms/villa-huong-giang.jpg');

-- 8.4. Danh mục Phòng cụ thể
INSERT INTO dbo.Rooms (RoomNumber, RoomTypeId, Status)
VALUES 
('HH-101', 1, 'AVAILABLE'),
('HH-102', 1, 'AVAILABLE'),
('HH-201', 2, 'AVAILABLE'),
('HH-202', 2, 'AVAILABLE'),
('HH-301', 3, 'AVAILABLE');

-- 8.5. Thiết lập Bảng giá theo ngày trong tuần (RatePlan: Thứ 2-Thứ 5 ngày thường, Thứ 6-CN cuối tuần)
-- Loại 1: Nhà Rường (Base: 700k, Cuối tuần: 850k)
INSERT INTO dbo.RatePlans (RoomTypeId, DayOfWeek, Price, IsWeekend, HolidaySurcharge)
VALUES
(1, 0, 850000, 1, 0), -- Chủ Nhật
(1, 1, 700000, 0, 0), -- Thứ Hai
(1, 2, 700000, 0, 0), -- Thứ Ba
(1, 3, 700000, 0, 0), -- Thứ Tư
(1, 4, 700000, 0, 0), -- Thứ Năm
(1, 5, 850000, 1, 0), -- Thứ Sáu
(1, 6, 850000, 1, 0); -- Thứ Bảy

-- Loại 2: Gác Mái (Base: 900k, Cuối tuần: 1.100k)
INSERT INTO dbo.RatePlans (RoomTypeId, DayOfWeek, Price, IsWeekend, HolidaySurcharge)
VALUES
(2, 0, 1100000, 1, 0),
(2, 1, 900000, 0, 0),
(2, 2, 900000, 0, 0),
(2, 3, 900000, 0, 0),
(2, 4, 900000, 0, 0),
(2, 5, 1100000, 1, 0),
(2, 6, 1100000, 1, 0);

-- Loại 3: Villa Hương Giang (Base: 1.800k, Cuối tuần: 2.200k)
INSERT INTO dbo.RatePlans (RoomTypeId, DayOfWeek, Price, IsWeekend, HolidaySurcharge)
VALUES
(3, 0, 2200000, 1, 0),
(3, 1, 1800000, 0, 0),
(3, 2, 1800000, 0, 0),
(3, 3, 1800000, 0, 0),
(3, 4, 1800000, 0, 0),
(3, 5, 2200000, 1, 0),
(3, 6, 2200000, 1, 0);

-- 8.6. Mẫu Giao dịch Đặt phòng Header - LineItem (Đáp ứng Tiêu chí K2.2)
-- Đơn #BK20261015-01: Khách Nguyễn Văn An đặt phòng HH-101 (2 đêm: 15/10 và 16/10/2026)
INSERT INTO dbo.Bookings (BookingCode, GuestId, CheckInDate, CheckOutDate, TotalGuests, TotalAmount, DepositAmount, Status, Notes)
VALUES ('BK20261015-01', 1, '2026-10-15', '2026-10-17', 2, 1550000, 775000, 'CONFIRMED', N'Khách đến lúc 15h00');

DECLARE @NewBookingId INT = SCOPE_IDENTITY();

-- Đêm 1: Thứ Năm (15/10) giá 700.000đ; Đêm 2: Thứ Sáu (16/10) giá 850.000đ -> Tổng 1.550.000đ
INSERT INTO dbo.BookingNights (BookingId, RoomId, NightDate, Price)
VALUES 
(@NewBookingId, 1, '2026-10-15', 700000),
(@NewBookingId, 1, '2026-10-16', 850000);
GO

-- ==========================================================================================
-- 9. THỦ TỤC LƯU GIAO DỊCH ĐẶT PHÒNG TRONG 1 TRANSACTION (Minh họa tiêu chí K2.2)
-- ==========================================================================================
CREATE OR ALTER PROCEDURE dbo.sp_CreateBookingTransaction
    @BookingCode VARCHAR(20),
    @GuestId INT,
    @CheckInDate DATE,
    @CheckOutDate DATE,
    @TotalGuests INT,
    @TotalAmount DECIMAL(18,2),
    @DepositAmount DECIMAL(18,2),
    @Notes NVARCHAR(500) = NULL,
    @RoomId INT,
    @NewBookingId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Kiểm tra Luật 1: Chống Overbooking (Không có đêm nào bị trùng lặp)
        IF EXISTS (
            SELECT 1 
            FROM dbo.BookingNights bn
            JOIN dbo.Bookings b ON bn.BookingId = b.Id
            WHERE bn.RoomId = @RoomId
              AND bn.NightDate >= @CheckInDate
              AND bn.NightDate < @CheckOutDate
              AND b.Status IN ('PENDING_DEPOSIT', 'CONFIRMED', 'CHECKED_IN')
        )
        BEGIN
            RAISERROR(N'Phòng đã có khách đặt trong khoảng ngày đã chọn (Vi phạm Luật Overbooking)!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Ghi bản ghi Header (Bookings)
        INSERT INTO dbo.Bookings (BookingCode, GuestId, CheckInDate, CheckOutDate, TotalGuests, TotalAmount, DepositAmount, Status, Notes)
        VALUES (@BookingCode, @GuestId, @CheckInDate, @CheckOutDate, @TotalGuests, @TotalAmount, @DepositAmount, 'PENDING_DEPOSIT', @Notes);

        SET @NewBookingId = SCOPE_IDENTITY();

        -- 3. Tạo các LineItem (BookingNights) cho từng đêm lưu trú
        DECLARE @CurrentNight DATE = @CheckInDate;
        WHILE @CurrentNight < @CheckOutDate
        BEGIN
            DECLARE @DayOfWeek TINYINT = DATEPART(WEEKDAY, @CurrentNight) - 1; -- 0: Sunday ... 6: Saturday
            DECLARE @RoomTypeId INT = (SELECT RoomTypeId FROM dbo.Rooms WHERE Id = @RoomId);
            DECLARE @NightPrice DECIMAL(18,2);

            SELECT TOP 1 @NightPrice = Price
            FROM dbo.RatePlans
            WHERE RoomTypeId = @RoomTypeId AND DayOfWeek = @DayOfWeek;

            IF @NightPrice IS NULL
                SET @NightPrice = (SELECT BasePrice FROM dbo.RoomTypes WHERE Id = @RoomTypeId);

            INSERT INTO dbo.BookingNights (BookingId, RoomId, NightDate, Price)
            VALUES (@NewBookingId, @RoomId, @CurrentNight, @NightPrice);

            SET @CurrentNight = DATEADD(DAY, 1, @CurrentNight);
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
