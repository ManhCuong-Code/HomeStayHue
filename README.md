# 🌿 HỆ THỐNG ĐẶT PHÒNG TRỰC TUYẾN HOMESTAY HUẾ

---

## 🎓 THÔNG TIN HỌC VIÊN & ĐỀ TÀI

* **Họ và tên sinh viên:** **Trần Viết Mạnh Cường**
* **Mã sinh viên (MSV):** **23K4080003**
* **Ngành đào tạo:** **Tin học kinh tế**
* **Khoa:** **Hệ thống thông tin kinh tế**
* **Học phần:** **Lập trình ứng dụng Web**
* **Tên đề tài:** **Nền tảng đặt phòng trực tuyến Homestay Huế (Hệ thống Quản lý & Đặt phòng Homestay Cố Đô Huế)**
* **Repository GitHub:** [https://github.com/ManhCuong-Code/HomeStayHue](https://github.com/ManhCuong-Code/HomeStayHue)

---

## 📖 1. TỔNG QUAN ĐỀ TÀI

### 1.1. Bối cảnh & Vấn đề thực tế
Cố Đô Huế là điểm đến du lịch văn hóa, di sản hàng đầu với mô hình lưu trú homestay ngày càng phát triển mạnh mẽ. Hiện nay, đa số các chủ cơ sở homestay tại Huế đều phụ thuộc hoàn toàn vào các sàn đại lý du lịch trực tuyến (OTA) như Booking.com hay Agoda, dẫn tới nhiều bất cập:
* **Chi phí hoa hồng cao:** Bị cắt phế từ **15% đến 25%** tổng doanh thu mỗi tháng.
* **Giam giữ dòng tiền:** Tiền phòng bị sàn trung gian giữ từ 15 đến 30 ngày mới giải ngân.
* **Mất dữ liệu khách hàng:** Không có thông tin liên hệ trực tiếp để tư vấn và chăm sóc khách quen.

### 1.2. Mục tiêu dự án
Xây dựng một nền tảng Web đặt phòng trực tuyến độc lập giúp các cơ sở Homestay Huế:
1. **Tự chủ kinh doanh:** Giữ trọn 100% doanh thu, tiền cọc 50% thanh toán trực tiếp qua mã **VietQR** vào tài khoản ngân hàng.
2. **Kiểm soát buồng phòng tuyệt đối:** Loại bỏ 100% rủi ro trùng phòng (Overbooking) nhờ thuật toán quản lý theo từng đêm lưu trú (`NightDate`).
3. **Chính sách giá & hủy cọc linh hoạt:** Áp dụng giá theo ngày trong tuần (Dynamic Pricing) và luật hủy phòng trước 48 giờ minh bạch.

---

## 🛠️ 2. KIẾN TRÚC & CÔNG NGHỆ ÁP DỤNG

Hệ thống được thiết kế theo chuẩn **Clean Architecture 4 tầng** (Onion Architecture), tách biệt hoàn toàn giữa Core Nghiệp Vụ, Use Cases, Hạ tầng CSDL và Giao diện người dùng:

| Tầng Kiến Trúc | Dự án trong Solution | Công Nghệ & Vai Trò |
|---|---|---|
| **1. Core Business** | `HomeStayHue.CoreBusiness` | Domain Entities (`Room`, `Booking`, `Guest`, `RatePlan`...) & Business Rules (Độc lập, 0 tham chiếu). |
| **2. Use Cases** | `HomeStayHue.UseCases` | Chứa Application Services & Plugin Interfaces (`IRoomRepository`, `IBookingRepository`...). |
| **3. Infrastructure / Plugins** | `Plugins/HomeStayHue.DataStore.SQL.Dapper`<br>`Plugins/HomeStayHue.ShoppingCart.LocalStorage`<br>`Plugins/HomeStayHue.StateStore.DI` | Cài đặt truy xuất CSDL SQL Server với **Dapper ORM**, lưu giao dịch Header-Line trong 1 Transaction, quản lý State giỏ hàng. |
| **4. Presentation / Web Host** | `HomeStayHue.Web`<br>`HomeStayHue.Web.CustomerPortal`<br>`HomeStayHue.Web.AdminPortal`<br>`HomeStayHue.Web.Common` | Giao diện **Blazor Web App (.NET 10 LTS)** với tương tác Server Interactive SPA, Cookie Authentication & Authorization. |

---

## 📊 3. MÔ HÌNH HÓA HỆ THỐNG BẰNG UML (UNIFIED MODELING LANGUAGE)

### 3.1. Sơ Đồ Ca Sử Dụng Tổng Thể (Use Case Diagram)

```mermaid
flowchart LR
    subgraph Actors["Tác Nhân Hệ Thống"]
        Guest(("Khách Hàng<br>(Guest)"))
        Host(("Chủ Homestay / Lễ Tân<br>(Host/Admin)"))
        Bank(("Hệ Thống VietQR<br>(External)"))
    end

    subgraph ClientPortal["Phân Hệ Khách Hàng (Customer Portal)"]
        UC01(["UC01: Tìm kiếm buồng phòng theo ngày"])
        UC02(["UC02: Xem chi tiết phòng & giá từng đêm"])
        UC03(["UC03: Chọn phòng vào Giỏ tạm (BookingCartState)"])
        UC04(["UC04: Đặt phòng trực tuyến (Place Booking)"])
        UC05(["UC05: Kiểm tra phòng trống [LUẬT 1: Overbooking]"])
        UC06(["UC06: Tự động tính tiền = Σ giá đêm [LUẬT 2]"])
        UC07(["UC07: Thanh toán cọc 50% qua VietQR"])
    end

    subgraph AdminPortal["Phân Hệ Quản Trị & Vận Hành (Host Portal)"]
        UC08(["UC08: Đăng nhập hệ thống (Cookie Auth)"])
        UC09(["UC09: Quản lý buồng phòng (Room & RoomType)"])
        UC10(["UC10: Quản lý bảng giá linh hoạt (RatePlan)"])
        UC11(["UC11: Tiếp đón khách nhận phòng (Check-in 14h)"])
        UC12(["UC12: Xử lý khách trả phòng (Check-out 12h)"])
        UC13(["UC13: Quản lý danh sách đơn & xác nhận cọc"])
    end

    Guest --> UC01
    Guest --> UC02
    Guest --> UC03
    Guest --> UC04

    UC04 -.->|include| UC05
    UC04 -.->|include| UC06
    UC04 -.->|include| UC07
    UC07 --> Bank

    Host --> UC08
    Host --> UC09
    Host --> UC10
    Host --> UC11
    Host --> UC12
    Host --> UC13
```

---

### 3.2. Sơ Đồ Lớp 4 Tầng (Class Diagram - Clean Architecture)

```mermaid
classDiagram
    direction TB

    namespace CoreBusiness {
        class RoomType {
            +int Id
            +string TypeName
            +string Description
            +int MaxGuests
            +decimal BasePrice
            +string Amenities
            +string ImageUrl
        }

        class Room {
            +int Id
            +string RoomNumber
            +int RoomTypeId
            +RoomStatus Status
            +bool IsActive
            +CanCheckIn(date) bool
            +CanCheckOut(date) bool
        }

        class RatePlan {
            +int Id
            +int RoomTypeId
            +DayOfWeek DayOfWeek
            +decimal Price
            +bool IsWeekend
            +decimal HolidaySurcharge
        }

        class Guest {
            +int Id
            +string FullName
            +string PhoneNumber
            +string Email
            +string IdentityCard
        }

        class Booking {
            +int Id
            +string BookingCode
            +int GuestId
            +DateTime CheckInDate
            +DateTime CheckOutDate
            +int TotalGuests
            +decimal TotalAmount
            +decimal DepositAmount
            +BookingStatus Status
            +DateTime CreatedAt
            +DateTime? CancelledAt
            +decimal? CancellationFee
        }

        class BookingNight {
            +int Id
            +int BookingId
            +int RoomId
            +DateTime NightDate
            +decimal Price
        }

        class BookingService {
            +ValidateBooking(Booking booking) bool
            +ValidateOverbooking(int roomId, DateTime in, DateTime out) bool
        }
    }

    namespace UseCases {
        class IRoomRepository {
            <<Interface>>
            +GetProduct(int id) Product
            +GetProducts(string filter) IEnumerable~Product~
            +GetAvailableRooms(int typeId, DateTime in, DateTime out) IEnumerable~Room~
        }

        class IBookingRepository {
            <<Interface>>
            +CreateOrder(Order order) int
            +GetBookingByCode(string code) Booking
        }

        class ISearchRoomUseCase {
            <<Interface>>
            +Execute(string filter) IEnumerable~Product~
        }

        class IPlaceBookingUseCase {
            <<Interface>>
            +Execute(Order order) Task~string~
        }
    }

    namespace Infrastructure_Dapper {
        class DapperRoomRepository {
            -IDataAccess _dataAccess
            +GetProduct(int id) Product
            +GetProducts(string filter) IEnumerable~Product~
        }

        class DapperBookingRepository {
            -IDataAccess _dataAccess
            +CreateOrder(Order order) int
            +GetBookingByCode(string code) Booking
        }
    }

    RoomType "1" *-- "0..*" Room : Contains
    RoomType "1" *-- "0..*" RatePlan : Prices
    Guest "1" o-- "0..*" Booking : Places
    Booking "1" *-- "1..*" BookingNight : Header-LineItem
    Room "1" o-- "0..*" BookingNight : Assigned

    BookingService ..> Booking : Validates
    DapperRoomRepository ..|> IRoomRepository : Implements
    DapperBookingRepository ..|> IBookingRepository : Implements
    IPlaceBookingUseCase ..> IBookingRepository : Depends
```

---

### 3.3. Sơ Đồ Tuần Tự Luồng Giao Dịch Chính (Sequence Diagram - End to End Booking)

Minh họa quy trình đặt phòng, kiểm tra 2 luật nghiệp vụ và lưu giao dịch Header - LineItem trong **cùng 1 Transaction**:

```mermaid
sequenceDiagram
    autonumber
    actor User as Khách Hàng (Guest)
    participant UI as CheckoutComponent (Blazor)
    participant Cart as BookingCartState (Scoped)
    participant UC as PlaceBookingUseCase (UseCases)
    participant Rule as BookingService (Core Rules)
    participant Repo as DapperBookingRepository (Plugin SQL)
    participant DB as SQL Server (HomeStayHueDB)

    User->>UI: Điền thông tin (Họ tên, SĐT) & Nhấn "Xác Nhận Đặt Phòng"
    UI->>Cart: Lấy thông tin phòng & ngày lưu trú đã chọn
    Cart-->>UI: Trả về: Phòng HH-101, Check-in: 15/10, Check-out: 17/10 (2 đêm)

    UI->>UC: Execute(bookingOrder)
    
    Note over UC,Rule: 1. Kiểm tra Luật 1 (Chống Overbooking)
    UC->>Rule: ValidateOverbooking(roomId=101, 15/10, 17/10)
    Rule-->>UC: Hợp lệ (Không có khách ở trùng đêm)

    Note over UC,Rule: 2. Kiểm tra Luật 2 (Tính tiền từng đêm: Đêm 1: 700k + Đêm 2: 850k = 1.550.000đ)
    UC->>Rule: ValidateCreateOrder(order)
    Rule-->>UC: Dữ liệu đơn & tiền cọc 50% (775.000đ) hợp lệ

    Note over UC,DB: 3. Ghi Header - LineItem trong 1 Transaction (K2.2)
    UC->>Repo: CreateOrder(bookingOrder)
    Repo->>DB: BEGIN TRANSACTION
    Repo->>DB: INSERT INTO Bookings (Header: Mã đơn, Khách, Tổng tiền, Cọc...)
    DB-->>Repo: Sinh mới BookingId = #102
    
    loop Từng đêm lưu trú (LineItems)
        Repo->>DB: INSERT INTO BookingNights (LineItem: BookingId, RoomId, NightDate, Price)
    end
    
    Repo->>DB: COMMIT TRANSACTION
    DB-->>Repo: Xác nhận lưu thành công
    Repo-->>UC: Trả về Mã đơn #BK20261015-01
    UC-->>UI: Trả về kết quả thành công
    UI->>Cart: EmptyAsync() (Xóa giỏ chọn tạm)
    UI-->>User: Hiển thị màn hình thành công kèm Mã VietQR chuyển cọc 50%!
```

---

### 3.4. Sơ Đồ Chuyển Trạng Thái Đơn Đặt & Buồng Phòng (State Machine Diagram)

```mermaid
stateDiagram-v2
    [*] --> PENDING_DEPOSIT : Khách tạo yêu cầu đặt phòng (Giữ chỗ 30 phút)
    
    PENDING_DEPOSIT --> CANCELLED_EXPIRED : Quá 30 phút không nhận được tiền cọc
    CANCELLED_EXPIRED --> [*]

    PENDING_DEPOSIT --> CONFIRMED : Khách thanh toán cọc 50% qua VietQR
    
    state "Kiểm Tra Thời Điểm Hủy (Luật 2)" as CancelChoice <<choice>>
    CONFIRMED --> CancelChoice : Khách gửi yêu cầu hủy đơn
    CancelChoice --> CANCELLED_FULL_REFUND : Hủy trước Check-in >= 48h (Hoàn 100% cọc)
    CancelChoice --> CANCELLED_PENALTY : Hủy trước Check-in < 48h (Phạt 1 đêm đầu tiên)
    CANCELLED_FULL_REFUND --> [*]
    CANCELLED_PENALTY --> [*]

    CONFIRMED --> CHECKED_IN : Lễ tân đón tiếp khách (14h00 nhận phòng)
    CHECKED_IN --> CHECKED_OUT : Lễ tân trả phòng (12h00) & thu 50% còn lại
    CHECKED_OUT --> [*]
```

---

### 3.5. Sơ Đồ Hoạt Động (Activity Diagram)

```mermaid
flowchart TD
    Start([Khách chọn phòng & ngày lưu trú]) --> InputDates[Nhập ngày Check-in & Check-out]
    InputDates --> CheckOverbooking{Kiểm tra Luật 1:<br>Đêm phòng có bị trùng?}
    
    CheckOverbooking -- "Có (Trùng đêm)" --> ErrorConflict[Báo lỗi: Phòng đã có người đặt trong thời gian này!]
    ErrorConflict --> InputDates

    CheckOverbooking -- "Không (Trống lịch)" --> CalcPrice[Tính tổng tiền = Σ giá từng đêm theo RatePlan]
    CalcPrice --> CalcDeposit[Tính tiền cọc 50% = Tổng tiền x 0.5]
    CalcDeposit --> FillGuestInfo[Khách điền thông tin Họ tên, SĐT, Email]
    FillGuestInfo --> SubmitBooking[Bấm xác nhận đặt phòng]
    
    SubmitBooking --> TransactionDB[(Lưu Header Bookings & LineItems BookingNights trong 1 Transaction)]
    TransactionDB --> ShowVietQR[Hiển thị mã VietQR chuyển khoản cọc 50%]
    ShowVietQR --> WaitDeposit{Khách chuyển tiền cọc?}
    
    WaitDeposit -- "Không (Quá 30p)" --> AutoCancel[Hủy đơn & Giải phóng phòng]
    WaitDeposit -- "Có (Xác nhận cọc)" --> ConfirmBooking[Đơn chuyển trạng thái CONFIRMED]
    ConfirmBooking --> ReceptionCheckIn[Lễ tân đón tiếp lúc 14h00 Check-in]
    ReceptionCheckIn --> ReceptionCheckOut[Lễ tân trả phòng lúc 12h00 Check-out & chuyển dọn phòng]
    ReceptionCheckOut --> End([Kết thúc chu trình lưu trú])
```

---

## ⚖️ 4. HAI LUẬT NGHIỆP VỤ CỐT LÕI

* **Luật Nghiệp Vụ 1 (Chống Overbooking):**
  * Quản lý trạng thái lưu trú theo từng đêm (`NightDate` từ 14h00 ngày $D$ đến 12h00 ngày $D+1$).
  * Quy tắc: Khách cũ trả phòng ngày $D$ (12h00) và khách mới nhận phòng ngày $D$ (14h00) là **hoàn toàn hợp lệ**, không xung đột lịch.
* **Luật Nghiệp Vụ 2 (Dynamic Pricing & Chính Sách Phạt Hủy 48H):**
  * Tổng tiền thuê phòng tự động tính:
    $$\text{TotalAmount} = \sum_{i=1}^{N} \text{Giá đêm}_i$$
    *(Giá ngày thường Thứ 2 - Thứ 5 thấp hơn giá cuối tuần Thứ 6 - Chủ Nhật theo `RatePlans`)*.
  * Tiền cọc yêu cầu: $\text{DepositAmount} = 50\% \times \text{TotalAmount}$.
  * Chính sách hủy cọc:
    * Hủy trước $\ge 48$ tiếng trước giờ Check-in: Hoàn 100% tiền cọc.
    * Hủy gấp $< 48$ tiếng trước giờ Check-in: Khấu trừ phí phạt tương đương **giá của 1 đêm đầu tiên** (`CancellationFee`) để bù lỗ phòng trống.

---

## 🔐 5. CẤU TRÚC XÁC THỰC & PHÂN QUYỀN (AUTHENTICATION & AUTHORIZATION)

Hệ thống được thiết kế theo mô hình phân quyền chặt chẽ đáp ứng tiêu chí **K4.1 & K4.2** trong barem đánh giá:

| Đối Tượng Người Dùng | Yêu Cầu Đăng Nhập | Quyền Hạn & Chức Năng Trên Hệ Thống |
|---|---|---|
| **Khách Hàng Vãng Lai (Guest)** | ❌ **Không cần đăng nhập** | Tự do tìm kiếm buồng phòng, xem chi tiết phòng, chọn phòng vào giỏ và hoàn tất đặt cọc trực tuyến chỉ với việc nhập thông tin liên lạc (Họ tên, SĐT, Email). |
| **Khách Hàng Thành Viên (Customer)** | 💡 **Tùy chọn đăng nhập** | Đăng nhập tài khoản (`khachhang` / `123456`) để tự động điền sẵn thông tin khi đặt phòng và lưu vết lịch sử giao dịch cá nhân. |
| **Nhân Viên Tiếp Tân (Staff / Receptionist)** | 🔒 **BẮT BUỘC đăng nhập** | Truy cập phân hệ `/admin` (`[Authorize(Roles = "Staff,Admin")]`) để **kiểm tra danh sách đơn đặt phòng**, duyệt cọc, kiểm tra bảng trạng thái buồng phòng (Sẵn sàng / Đang có khách / Dọn phòng). |
| **Quản Trị Viên (Admin / Host)** | 🔒 **BẮT BUỘC đăng nhập** | Toàn quyền kiểm tra, cấu hình bảng giá `RatePlans`, duyệt đơn và quản lý toàn bộ hệ thống. |

### Danh Sách Tài Khoản Thử Nghiệm Hệ Thống (Mật khẩu chung: `123456`)
* 🛡️ **Nhân viên / Lễ tân:** Username: `letan` | Role: `Staff` *(Dành riêng cho nhân viên đăng nhập để kiểm tra hệ thống)*
* 👑 **Quản trị viên:** Username: `admin` | Role: `Admin` *(Toàn quyền quản trị)*
* 👤 **Khách hàng thân thiết:** Username: `khachhang` | Role: `Customer` *(Tài khoản khách hàng tùy chọn)*

---

## 🗄️ 6. CƠ SỞ DỮ LIỆU SQL SERVER (CHUẨN 3NF)

Kịch bản CSDL lưu tại: [database/schema.sql](database/schema.sql)

```mermaid
erDiagram
    RoomTypes ||--o{ Rooms : "has"
    RoomTypes ||--o{ RatePlans : "prices"
    Guests ||--o{ Bookings : "places"
    Bookings ||--|{ BookingNights : "consists_of (Header-Line)"
    Rooms ||--o{ BookingNights : "assigned_to"

    RoomTypes {
        int Id PK
        nvarchar TypeName UK
        decimal BasePrice
        int MaxGuests
        nvarchar Amenities
    }

    Rooms {
        int Id PK
        varchar RoomNumber UK
        int RoomTypeId FK
        varchar Status
    }

    RatePlans {
        int Id PK
        int RoomTypeId FK
        tinyint DayOfWeek
        decimal Price
        bit IsWeekend
    }

    Guests {
        int Id PK
        nvarchar FullName
        varchar PhoneNumber
        varchar Email
        varchar IdentityCard
    }

    Bookings {
        int Id PK
        varchar BookingCode UK
        int GuestId FK
        date CheckInDate
        date CheckOutDate
        decimal TotalAmount
        decimal DepositAmount
        varchar Status
    }

    BookingNights {
        int Id PK
        int BookingId FK
        int RoomId FK
        date NightDate
        decimal Price
    }
```

---

## 🚀 7. HƯỚNG DẪN KHỞI CHẠY DỰ ÁN

### Yêu Cầu Môi Trường
* **.NET SDK:** 10.0 trở lên
* **Hệ Quản trị CSDL:** Microsoft SQL Server 2019/2022 hoặc SQL Server Express (`.\SQLEXPRESS`)

### Bước 1: Khởi tạo Cơ sở Dữ liệu
Chạy tệp SQL kịch bản trực tiếp bằng `sqlcmd` hoặc mở bằng SQL Server Management Studio (SSMS):
```powershell
sqlcmd -S ".\SQLEXPRESS" -E -C -i "database/schema.sql"
```

### Bước 2: Cấu hình Chuỗi Kết Nối
Kiểm tra cấu hình trong `project/HomeStayHue/HomeStayHue.Web/appsettings.json`:
```json
"ConnectionStrings": {
  "DefaultConnection": "Server=.\\SQLEXPRESS;Database=HomeStayHueDB;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

### Bước 3: Biên dịch & Chạy Website
```powershell
# Chuyển vào thư mục solution
cd project/HomeStayHue

# Biên dịch toàn bộ 10 dự án thành phần
dotnet build HomeStayHue.slnx

# Khởi chạy Website Blazor
dotnet run --project HomeStayHue.Web/HomeStayHue.Web.csproj
```
Truy cập trình duyệt tại địa chỉ: `https://localhost:7082` (hoặc cổng hiển thị trên console).