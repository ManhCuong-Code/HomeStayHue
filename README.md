# 🌿 HomeStay Huế — Nền Tảng Đặt Phòng Nhà Vườn Kim Long

Hệ thống đặt phòng trực tuyến dành cho mô hình Homestay Nhà Vườn sinh thái tại Kim Long, TP. Huế. Dự án được xây dựng theo kiến trúc **Clean Architecture 4 tầng** trên nền tảng **.NET 10 LTS**, **Blazor Web App** và cơ sở dữ liệu quan hệ **Microsoft SQL Server**.

---

## 🏛️ Cấu Trúc Mã Nguồn (Clean Architecture 4 Tầng)

Solution chính nằm tại: `project/HomeStayHue/HomeStayHue.slnx`

```text
project/HomeStayHue/
├── HomeStayHue.CoreBusiness/              # Tầng 1: Domain Entities & Business Rules (Độc lập)
│   ├── Models/                           # Room, RoomType, Booking, BookingNight, Guest, RatePlan
│   └── Services/                         # BookingService (Luật 1: Chống Overbooking & Luật 2: Pricing)
├── HomeStayHue.UseCases/                  # Tầng 2: Application Use Cases & Repository Interfaces
│   ├── PluginInterfaces/                 # IRoomRepository, IBookingRepository, IShoppingCart...
│   ├── SearchRoomScreen/                 # ISearchRoomUseCase, SearchRoomUseCase
│   ├── ViewRoomScreen/                   # IViewRoomUseCase, ViewRoomUseCase
│   └── BookingScreen/                    # IPlaceBookingUseCase, PlaceBookingUseCase
├── Plugins/                              # Tầng 3: Hạ tầng & CSDL (Infrastructure)
│   ├── HomeStayHue.DataStore.SQL.Dapper/ # Dapper ORM kết nối SQL Server (Giao dịch Header-Line)
│   ├── HomeStayHue.DataStore.HandCoded/  # Dữ liệu phòng mẫu thực tế tại Huế
│   ├── HomeStayHue.ShoppingCart.LocalStorage/
│   └── HomeStayHue.StateStore.DI/        # Scoped State Store
└── HomeStayHue.Web/                      # Tầng 4: Presentation Web Host
    ├── HomeStayHue.Web.Modules/
    │   ├── HomeStayHue.Web.CustomerPortal/ # Giao diện khách: Xem phòng, chọn ngày, đặt phòng
    │   ├── HomeStayHue.Web.AdminPortal/    # Giao diện lễ tân: Nhận phòng (14h), trả phòng (12h)
    │   └── HomeStayHue.Web.Common/         # Component dùng chung (Search Bar...)
    └── Program.cs                        # Composition Root & DI Registration
```

---

## 🗄️ Cơ Sở Dữ Liệu SQL Server

Toàn bộ kịch bản khởi tạo CSDL, ràng buộc toàn vẹn 3NF và dữ liệu khởi tạo nằm tại:
* **File kịch bản:** `database/schema.sql`

### Các Bảng Nghiệp Vụ Chuẩn Hóa 3NF:
1. `RoomTypes`: Danh mục hạng phòng (Nhà Rường Cổ, Gác Mái Sông Hương, Villa Gia Đình).
2. `Rooms`: Buồng phòng vật lý cụ thể (`NR-101`, `GM-201`...).
3. `RatePlans`: Bảng giá linh hoạt theo thứ trong tuần và phụ thu lễ hội.
4. `Guests`: Hồ sơ khách hàng (tách biệt để đạt chuẩn 3NF).
5. `Bookings`: **Header Entity** lưu mã đơn, ngày lưu trú, tổng tiền và cọc 50%.
6. `BookingNights`: **LineItem Entity** chi tiết từng đêm phòng (Chống Overbooking & chốt giá).
7. `AppUsers`: Tài khoản Host và Lễ tân quản trị hệ thống.

---

## 🚀 Hướng Dẫn Cài Đặt & Khởi Chạy

### 1. Khởi tạo Cơ sở Dữ liệu:
Chạy tệp `database/schema.sql` trên SQL Server Management Studio (SSMS) hoặc qua command line:
```bash
sqlcmd -S ".\SQLEXPRESS" -E -C -i "database/schema.sql"
```

### 2. Biên dịch & Chạy Ứng Dụng:
```bash
cd project/HomeStayHue
dotnet build HomeStayHue.slnx
dotnet run --project HomeStayHue.Web/HomeStayHue.Web.csproj
```