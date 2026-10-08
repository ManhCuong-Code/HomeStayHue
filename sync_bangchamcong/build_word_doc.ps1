# Script tao file Word BAO_CAO_SO_DO_UML_DU_AN_17.docx hoan chinh chuan bao cao danh gia
$ErrorActionPreference = "Stop"

$imagesDir = "C:\Users\TUF\Desktop\bangChamCong\uml\images"
$outDocx = "C:\Users\TUF\Desktop\bangChamCong\BAO_CAO_SO_DO_UML_DU_AN_17.docx"

Write-Host "Khoi dong Microsoft Word Application..."
$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0

$doc = $word.Documents.Add()

# Thiet lap kho giay A4: Trai 3cm, Phai 2cm, Tren 2cm, Duoi 2cm
$doc.PageSetup.PaperSize = 7 # wdPaperA4
$doc.PageSetup.LeftMargin = 85.05 # 3.0 cm
$doc.PageSetup.RightMargin = 56.7  # 2.0 cm
$doc.PageSetup.TopMargin = 56.7    # 2.0 cm
$doc.PageSetup.BottomMargin = 56.7 # 2.0 cm

$s = $word.Selection

function Add-H1($text) {
    $s.ParagraphFormat.Alignment = 0
    $s.ParagraphFormat.SpaceBefore = 14
    $s.ParagraphFormat.SpaceAfter = 6
    $s.Font.Name = "Times New Roman"
    $s.Font.Size = 15
    $s.Font.Bold = 1
    $s.Font.Italic = 0
    $s.Font.Color = 0x8B1A1A
    $s.TypeText("$text`n")
}

function Add-H2($text) {
    $s.ParagraphFormat.Alignment = 0
    $s.ParagraphFormat.SpaceBefore = 10
    $s.ParagraphFormat.SpaceAfter = 4
    $s.Font.Name = "Times New Roman"
    $s.Font.Size = 13.5
    $s.Font.Bold = 1
    $s.Font.Italic = 0
    $s.Font.Color = 0x1A365D
    $s.TypeText("$text`n")
}

function Add-H3($text) {
    $s.ParagraphFormat.Alignment = 0
    $s.ParagraphFormat.SpaceBefore = 6
    $s.ParagraphFormat.SpaceAfter = 2
    $s.Font.Name = "Times New Roman"
    $s.Font.Size = 12.5
    $s.Font.Bold = 1
    $s.Font.Italic = 1
    $s.Font.Color = 0x2D3748
    $s.TypeText("$text`n")
}

function Add-P($text) {
    $s.ParagraphFormat.Alignment = 3 # Justify
    $s.ParagraphFormat.SpaceBefore = 0
    $s.ParagraphFormat.SpaceAfter = 4
    $s.Font.Name = "Times New Roman"
    $s.Font.Size = 12.5
    $s.Font.Bold = 0
    $s.Font.Italic = 0
    $s.Font.Color = 0x111827
    $s.TypeText("$text`n")
}

function Add-Bullet($boldPrefix, $text) {
    $s.ParagraphFormat.Alignment = 3
    $s.ParagraphFormat.SpaceBefore = 0
    $s.ParagraphFormat.SpaceAfter = 3
    $s.ParagraphFormat.LeftIndent = 18
    $s.Font.Name = "Times New Roman"
    $s.Font.Size = 12.5
    $s.Font.Bold = 1
    $s.Font.Italic = 0
    $s.Font.Color = 0x111827
    $s.TypeText("• $boldPrefix ")
    $s.Font.Bold = 0
    $s.TypeText("$text`n")
    $s.ParagraphFormat.LeftIndent = 0
}

function Add-Img($imgPath, $caption, $maxW = 450.0) {
    if (Test-Path $imgPath) {
        $s.ParagraphFormat.Alignment = 1 # Center
        $s.ParagraphFormat.SpaceBefore = 8
        $s.ParagraphFormat.SpaceAfter = 4
        $sh = $s.InlineShapes.AddPicture($imgPath, $false, $true)
        if ($sh.Width -gt [single]$maxW) {
            $ratio = [single]$maxW / [single]$sh.Width
            $sh.Width = [single]$maxW
            $sh.Height = [single]($sh.Height * $ratio)
        }
        if ($sh.Height -gt [single]500.0) {
            $ratio = [single]500.0 / [single]$sh.Height
            $sh.Height = [single]500.0
            $sh.Width = [single]($sh.Width * $ratio)
        }
        $s.TypeText("`n")
        $s.Font.Name = "Times New Roman"
        $s.Font.Size = 10.5
        $s.Font.Bold = 1
        $s.Font.Italic = 1
        $s.Font.Color = 0x334155 # Slate-700
        $s.TypeText("$caption`n`n")
        $s.ParagraphFormat.Alignment = 0
    } else {
        Add-P "[Chưa tìm thấy ảnh tại: $imgPath]"
    }
}

function Add-PageBreak {
    $s.InsertBreak(7) # wdPageBreak
}

# ================= 1. TRANG BIA =================
Write-Host "1. Writing Cover Page..."
$s.ParagraphFormat.Alignment = 1
$s.Font.Name = "Times New Roman"
$s.Font.Size = 13
$s.Font.Bold = 1
$s.Font.Color = 0x1E3A8A
$s.TypeText("BỘ GIÁO DỤC VÀ ĐÀO TẠO — TRƯỜNG ĐẠI HỌC KHOA HỌC`n")
$s.Font.Size = 12
$s.Font.Color = 0x4B5563
$s.TypeText("KHOA CÔNG NGHỆ THÔNG TIN`n`n`n")

$s.Font.Size = 14
$s.Font.Bold = 1
$s.Font.Color = 0xB45309
$s.TypeText("ĐỒ ÁN CAPSTONE — HỌC PHẦN ECO2415`n`n")

$s.Font.Size = 20
$s.Font.Bold = 1
$s.Font.Color = 0x1E3A8A
$s.TypeText("BÁO CÁO PHÂN TÍCH VÀ THIẾT KẾ HỆ THỐNG PHẦN MỀM`n")
$s.Font.Size = 17
$s.Font.Color = 0x8B1A1A
$s.TypeText("DỰ ÁN: HỆ THỐNG CHẤM CÔNG & TÍNH LƯƠNG TỰ ĐỘNG`n")
$s.Font.Size = 13.5
$s.Font.Color = 0x1E3A8A
$s.TypeText("(TIMESHEET & PAYROLL AUTOMATION SYSTEM)`n`n")

$s.Font.Size = 12.5
$s.Font.Bold = 1
$s.Font.Italic = 1
$s.Font.Color = 0x4A5568
$s.TypeText("TẬP HỢP TOÀN BỘ SƠ ĐỒ MÔ HÌNH HÓA UML CHUẨN PLANTUML`nKÈM ĐẶC TẢ USE CASE & MA TRẬN TRUY VẾT YÊU CẦU ĐỒNG BỘ 100%`n`n`n")

$s.ParagraphFormat.Alignment = 0
$s.ParagraphFormat.LeftIndent = 50
$s.Font.Size = 12.5
$s.Font.Bold = 1
$s.Font.Italic = 0
$s.Font.Color = 0x000000
$s.TypeText("Giảng viên hướng dẫn: ")
$s.Font.Bold = 0
$s.TypeText("Hội đồng Chấm thi Capstone ECO2415 / TS. Giảng Viên Hướng Dẫn`n")

$s.Font.Bold = 1
$s.TypeText("Học phần: ")
$s.Font.Bold = 0
$s.TypeText("Phân tích & Thiết kế Hệ thống Thông tin (ECO2415)`n")

$s.Font.Bold = 1
$s.TypeText("Nhóm sinh viên thực hiện: ")
$s.Font.Bold = 0
$s.TypeText("Nhóm Sinh Viên Thực Hiện Đồ Án`n")

$s.Font.Bold = 1
$s.TypeText("Mã Dự Án: ")
$s.Font.Bold = 0
$s.TypeText("Dự Án 17 (Quy mô doanh nghiệp vừa và nhỏ: 20 – 50 nhân sự)`n`n`n`n")
$s.ParagraphFormat.LeftIndent = 0

$s.ParagraphFormat.Alignment = 1
$s.Font.Size = 12
$s.Font.Bold = 1
$s.Font.Color = 0x4B5563
$s.TypeText("NĂM THỰC HIỆN: 2026`n")

Add-PageBreak

# ================= 2. TONG QUAN & KIEN TRUC CONG NGHE =================
Write-Host "2. Writing Overview & Architecture..."
Add-H1 "LỜI MỞ ĐẦU VÀ TỔNG QUAN HỆ THỐNG"
Add-P "Trong các doanh nghiệp vừa và nhỏ (quy mô từ 20 đến 50 nhân sự), việc tính lương và quản lý ngày công hầu hết vẫn dựa vào các bảng tính Excel thủ công. Thực trạng này gây ra 3 vấn đề nhức nhối:"
Add-Bullet "Dễ sai lệch công thức:" "Kế toán chỉ cần kéo nhầm một dòng dữ liệu là nhân viên bị tính thiếu hoặc thừa cả triệu đồng, gây khiếu nại tranh cãi gay gắt."
Add-Bullet "Tốn nhiều thời gian:" "Cuối mỗi tháng, kế toán mất từ 2 đến 3 ngày để đối soát từng tờ giấy chấm công, đơn xin nghỉ phép và dò tìm các khoản trích bảo hiểm."
Add-Bullet "Lộ bí mật thu nhập:" "Gửi chung bảng Excel hoặc chuyển tay danh sách rất dễ khiến nhân viên dòm ngó mức thu nhập của đồng nghiệp, gây mất đoàn kết nội bộ."
Add-P "Dự án 'Phần Mềm Chấm Công & Tính Lương Tự Động (Timesheet & Payroll System)' được xây dựng nhằm chuẩn hóa công thức theo quy định của Luật Lao Động Việt Nam, cung cấp tính năng tính lương tự động 1-chạm (1-Click Run), khóa sổ an toàn với Transaction tài chính, bảo mật cấp dữ liệu cá nhân tuyệt đối và tích hợp Trợ lý AI giải đáp thắc mắc lương tức thì."

Add-H2 "Kiến Trúc Ngăn Xếp Công Nghệ Thống Nhất (Unified Technology Stack)"
Add-P "Dự án thống nhất áp dụng một ngăn xếp công nghệ hiện đại, chuẩn mực công nghiệp, loại bỏ hoàn toàn các lựa chọn mập mờ:"
Add-Bullet "Giao diện người dùng (Frontend):" "Ứng dụng Web Single Page Application (SPA) phát triển trên nền tảng React hiện đại, thiết kế Responsive đáp ứng mượt mà trên cả Desktop PC và Mobile."
Add-Bullet "Máy chủ Web & Điều hướng (Reverse Proxy):" "Nginx chạy trên nền Ubuntu Linux 22.04 LTS, chứng chỉ bảo mật HTTPS (Port 443), cân bằng tải và điều hướng API."
Add-Bullet "Ứng dụng Backend cốt lõi:" "Java Spring Boot 3.2 (JDK 17/21) cung cấp RESTful API, bảo mật Spring Security & JWT Token, quản trị giao dịch @Transactional ACID và động cơ tính lương hàng loạt."
Add-Bullet "Tầng truy cập dữ liệu (ORM):" "Spring Data JPA kết hợp Connection Pool HikariCP tối ưu hóa hiệu năng truy vấn."
Add-Bullet "Hệ quản trị cơ sở dữ liệu:" "PostgreSQL 16 lưu trữ 10 bảng nghiệp vụ cốt lõi với khóa ngoại và chỉ mục B-Tree đảm bảo toàn vẹn dữ liệu."
Add-Bullet "Dịch vụ Trí tuệ nhân tạo (AI Microservice):" "Python 3.11 với FastAPI kết nối mô hình Google Gemini 1.5 Pro / OpenAI API để phân tích đối soát lương thông minh."

Add-PageBreak

# ================= 3. CHUONG 1: USE CASE =================
Write-Host "3. Writing Chapter 1: Use Cases..."
Add-H1 "CHƯƠNG 1: MÔ HÌNH HÓA CA SỬ DỤNG (USE CASE MODELING)"
Add-P "Mô hình Ca sử dụng (Use Case Model) xác định các yêu cầu chức năng của hệ thống dưới góc nhìn của các tác nhân (Actors) tham gia tương tác. Toàn bộ mã Use Case đã được chuẩn hóa thống nhất 100% xuyên suốt tài liệu: UC_AUTH_xx (Xác thực), UC_EMP_xx (Nhân viên), UC_HR_xx (Kế toán HR), UC_ADMIN_xx (Quản trị hệ thống) và UC_AI_xx (Trợ lý AI). Tác nhân AI ngoài hệ thống được định nghĩa chuẩn là External LLM Service."

Add-H2 "1.1. Sơ Đồ Use Case Tổng Quan Toàn Hệ Thống"
Add-P "Sơ đồ tổng quan thể hiện 4 tác nhân: Nhân Viên (Employee), Kế Toán / HR (Accountant / HR), Quản Trị Viên (System Admin) và Dịch vụ LLM bên ngoài (External LLM Service) cùng 5 phân hệ chức năng độc lập."
Add-Img "$imagesDir\01_usecase_overview.png" "Hình 1.1: Sơ đồ Use Case tổng quan toàn hệ thống (Chuẩn hóa mã UC_AUTH, UC_EMP, UC_HR, UC_ADMIN, UC_AI)"

Add-H2 "1.2. Sơ Đồ Use Case Phân Rã: Phân Hệ Nhân Viên & Trợ Lý AI"
Add-P "Phân hệ Nhân viên tập trung vào các chức năng tự phục vụ (Self-service): Điểm danh chấm công hàng ngày (UC_EMP_01), nộp đơn xin nghỉ phép (UC_EMP_02), xem lịch sử bảng công (UC_EMP_03), tra cứu phiếu lương cá nhân (UC_EMP_04), tải PDF (UC_EMP_06) và tương tác cùng Trợ lý AI (UC_AI_01) với các nhánh mở rộng phân tích biến động (UC_AI_02) và công thức bảo hiểm (UC_AI_03)."
Add-Img "$imagesDir\02_usecase_employee.png" "Hình 1.2: Sơ đồ Use Case phân rã phân hệ Nhân viên & Trợ lý AI"

Add-H2 "1.3. Sơ Đồ Use Case Phân Rã: Phân Hệ Kế Toán HR & Quản Trị Viên"
Add-P "Phân hệ Kế toán và Quản trị bao gồm các chức năng: Quản lý phòng ban (UC_HR_01), hồ sơ nhân sự (UC_HR_02), hợp đồng lao động (UC_HR_03), phụ cấp & khấu trừ (UC_HR_04), cấu hình tỷ lệ trích nộp (UC_HR_05), duyệt công (UC_HR_06), tính lương tự động (UC_HR_07), xem đối soát bảng lương (UC_HR_08), chốt kỳ lương Read-Only (UC_HR_09) và xuất file ngân hàng (UC_HR_10)."
Add-Img "$imagesDir\03_usecase_hr_admin.png" "Hình 1.3: Sơ đồ Use Case phân rã phân hệ Kế toán HR & Quản trị viên"

Add-H2 "1.4. Đặc Tả Chi Tiết 4 Use Case Then Chốt (Use Case Specifications)"
Add-H3 "Đặc tả UC_HR_07: Tính Lương Tự Động (Batch Run)"
Add-Bullet "Tác nhân chính:" "Kế toán / HR (ROLE_HR_ACCOUNTANT)"
Add-Bullet "Mục đích:" "Tự động hóa tính toán lương toàn bộ 20-50 nhân sự trong một kỳ xác định dựa trên ngày công thực tế, hợp đồng và tỷ lệ trích nộp theo luật định."
Add-Bullet "Điều kiện tiên quyết:" "Kế toán đã đăng nhập; bảng chấm công tháng đã được duyệt và khóa sổ (Timesheet.is_locked = true); bảng tỷ lệ trích nộp DeductionRate có hiệu lực."
Add-Bullet "Luồng sự kiện chính:" "1. Kế toán chọn kỳ lương và nhấn 'Chạy tính toán lương'. 2. Hệ thống mở Database Transaction (@Transactional). 3. Hệ thống nạp danh sách nhân viên, hợp đồng và tổng công từ Timesheet. 4. Áp dụng công thức chuẩn: Lương ngày công = Lương CB * Công thực tế / Công chuẩn; Thu nhập gộp (Gross) = Lương công + Phụ cấp; Khấu trừ lấy động từ DeductionRate (BHXH 8%, BHYT 1.5%, BHTN 1%); Thuế TNCN tạm tính; Thực lĩnh (Net) = Gross - Khấu trừ. 5. Lưu vào Payslip và PayslipLine. 6. Commit Transaction và chuyển trạng thái kỳ lương sang CALCULATED."
Add-Bullet "Luồng ngoại lệ:" "Khi phát sinh lỗi dữ liệu hoặc mất kết nối: Hệ thống tự động ROLLBACK TRANSACTION, bảo toàn 100% dữ liệu nguyên trạng, không làm sai lệch số liệu."

Add-H3 "Đặc tả UC_HR_08: Xem Bảng Lương Tổng Hợp & Đối Soát (Payroll Summary Preview)"
Add-Bullet "Tác nhân chính:" "Kế toán / HR"
Add-Bullet "Mục đích:" "Cung cấp giao diện tổng quan để kế toán rà soát toàn bộ danh sách 50 nhân viên, tổng quỹ lương gộp, tổng bảo hiểm trích nộp và lương thực lĩnh trước khi chốt sổ."
Add-Bullet "Điều kiện tiên quyết:" "Kỳ lương đang ở trạng thái CALCULATED."

Add-H3 "Đặc tả UC_HR_09: Chốt Kỳ Lương Khóa Sổ (Lock Payroll Period - Read-Only)"
Add-Bullet "Tác nhân chính:" "Kế toán / Quản trị viên"
Add-Bullet "Mục đích:" "Đóng băng toàn bộ số liệu của kỳ lương, chuyển dữ liệu sang chế độ CHỈ ĐỌC (Read-Only), ngăn chặn tuyệt đối mọi hành vi sửa lén dữ liệu quá khứ và chuẩn bị chi trả ngân hàng."
Add-Bullet "Điều kiện tiên quyết:" "Kỳ lương ở trạng thái CALCULATED và kế toán đã đối soát qua UC_HR_08."
Add-Bullet "Quy tắc chuyển trạng thái:" "PayrollPeriod.status chuyển sang LOCKED. Bảng công Timesheet khóa vĩnh viễn (is_locked = true). Phiếu lương hiển thị công khai tới nhân viên và xuất file ủy nhiệm chi (UC_HR_10). Sau khi ngân hàng hoàn tất thanh toán, kỳ lương chuyển sang PAID."

Add-H3 "Đặc tả UC_AI_01: Hỏi Đáp & Giải Thích Biến Động Lương Với Trợ Lý AI"
Add-Bullet "Tác nhân chính:" "Nhân viên (Employee), Dịch vụ LLM bên ngoài (External LLM Service)"
Add-Bullet "Mục đích:" "Giúp nhân viên tự động hiểu rõ lý do tăng/giảm lương và các khoản trích nộp mà không cần làm phiền kế toán."
Add-Bullet "Điều kiện tiên quyết:" "Nhân viên đã đăng nhập và kỳ lương hiện tại đã ở trạng thái LOCKED."
Add-Bullet "Cơ chế bảo mật:" "Áp dụng cơ chế kiểm soát truy cập dựa trên quyền sở hữu cá nhân (Ownership-based Access Control), chỉ truy xuất phiếu lương của chính nhân viên gửi yêu cầu, ngăn chặn tuyệt đối lỗi IDOR."
Add-Bullet "Hiệu năng kỳ vọng:" "Mục tiêu phản hồi AI dưới 2 giây trong điều kiện mạng và tải thử nghiệm phù hợp, giúp kỳ vọng giảm đáng kể thời gian giải trình lương của kế toán."

Add-PageBreak

# ================= 4. CHUONG 2: CLASS DIAGRAM =================
Write-Host "4. Writing Chapter 2: Class Diagrams..."
Add-H1 "CHƯƠNG 2: MÔ HÌNH HÓA CẤU TRÚC TĨNH (CLASS DIAGRAMS)"
Add-P "Mô hình cấu trúc tĩnh định nghĩa các thực thể dữ liệu nghiệp vụ cốt lõi và kiến trúc phân tầng của ứng dụng."

Add-H2 "2.1. Sơ Đồ Lớp Miền Nghiệp Vụ (Domain Class Diagram) — 10 Thực Thể Cốt Lõi"
Add-P "Hệ thống xây dựng dựa trên 10 Thực thể nghiệp vụ cốt lõi, phản ánh đầy đủ nghiệp vụ quản lý nhân sự, chấm công, hợp đồng và động cơ tính lương. Trách nhiệm của các lớp Entity được phân định rõ: Entity chỉ quản lý trạng thái của chính nó (như lock(), canCalculate()), còn các phương thức xử lý lô lớn (như runBatchCalculation()) được chuyển giao cho tầng Service."
Add-Img "$imagesDir\04_class_domain_model.png" "Hình 2.1: Sơ đồ Lớp miền nghiệp vụ — 10 Thực thể cốt lõi và các Enums"

Add-P "Bảng danh mục 10 Thực thể nghiệp vụ cốt lõi:"
Add-Bullet "1. Department (Phòng ban):" "Quản lý cơ cấu tổ chức, mã phòng ban, tên phòng và trưởng phòng."
Add-Bullet "2. UserAccount (Tài khoản người dùng):" "Lưu thông tin đăng nhập, mật khẩu mã hóa BCrypt, vai trò UserRole (ROLE_EMPLOYEE, ROLE_HR_ACCOUNTANT, ROLE_ADMIN)."
Add-Bullet "3. Employee (Hồ sơ nhân viên):" "Lưu lý lịch nhân sự, CCCD, ngày sinh, số tài khoản ngân hàng và phòng ban trực thuộc."
Add-Bullet "4. Contract (Hợp đồng lao động):" "Lưu loại hợp đồng, lương cơ bản, định mức phụ cấp ăn trưa, phụ cấp xăng xe."
Add-Bullet "5. Timesheet (Bảng chấm công):" "Ghi nhận giờ check-in, check-out hàng ngày, số giờ làm việc thực tế và trạng thái ca làm."
Add-Bullet "6. LeaveRequest (Đơn xin nghỉ phép):" "Quản lý loại phép (nghỉ ốm, thai sản, không lương), ngày nghỉ và trạng thái phê duyệt."
Add-Bullet "7. DeductionRate (Bảng tỷ lệ trích nộp):" "Lưu cấu hình tỷ lệ đóng BHXH (8%), BHYT (1.5%), BHTN (1%) linh hoạt, không hardcode."
Add-Bullet "8. PayrollPeriod (Kỳ lương):" "Quản lý chu kỳ tính lương theo tháng/năm, số ngày công chuẩn và trạng thái vòng đời (PeriodStatus)."
Add-Bullet "9. Payslip (Phiếu lương tổng quát):" "Lưu kết quả tính lương của từng nhân viên: tổng công thực tế, lương gộp, tổng giảm trừ và thực lĩnh."
Add-Bullet "10. PayslipLine (Dòng chi tiết cấu thành lương):" "Mối quan hệ Composition với Payslip, lưu chi tiết từng khoản cộng/trừ trong bảng lương."

Add-H2 "2.2. Sơ Đồ Lớp Thiết Kế Phân Tầng (Layered Architecture Class Diagram)"
Add-P "Kiến trúc phần mềm phân tầng rõ ràng theo chuẩn Java Spring Boot 3 và Spring Data JPA:"
Add-Bullet "Presentation Layer:" "PayrollController tiếp nhận HTTP Request và chuyển đổi dữ liệu thông qua DTO (CalculatePayrollDTO, PayrollSummaryDTO, PayslipDTO)."
Add-Bullet "Business Logic Layer:" "PayrollServiceImpl kết hợp cùng SalaryFormulaEngine thực thi các thuật toán tính lương, xử lý giao dịch @Transactional."
Add-Bullet "Data Access Layer:" "Các Interfaces Spring Data JPA Repository (PayrollPeriodRepository, TimesheetRepository, ContractRepository, PayslipRepository, DeductionRateRepository) trừu tượng hóa truy vấn CSDL."
Add-Bullet "Entity Layer:" "Các JPA Entities phản ánh trực tiếp cấu trúc 10 bảng cơ sở dữ liệu quan hệ PostgreSQL 16."
Add-Img "$imagesDir\05_class_layered_architecture.png" "Hình 2.2: Sơ đồ Lớp thiết kế phân tầng kiến trúc phần mềm Spring Boot 3"

Add-PageBreak

# ================= 5. CHUONG 3: SEQUENCE DIAGRAMS =================
Write-Host "5. Writing Chapter 3: Sequence Diagrams..."
Add-H1 "CHƯƠNG 3: MÔ HÌNH HÓA TƯƠNG TÁC ĐỘNG (SEQUENCE DIAGRAMS)"
Add-P "Hệ thống tách độc lập thành 4 sơ đồ Tuần tự chuyên biệt để mô tả rõ ràng, tập trung cho từng nghiệp vụ then chốt."

Add-H2 "3.1. Sơ Đồ Tuần Tự: Xác Thực Đăng Nhập & Phân Quyền JWT (RBAC)"
Add-P "Mô tả quy trình kiểm tra thông tin người dùng, so khớp mật khẩu mã hóa qua PasswordEncoder, phát hành chuỗi JSON Web Token (JWT) chứa thông tin vai trò (Roles) và điều hướng giao diện phù hợp với quyền hạn."
Add-Img "$imagesDir\06_sequence_login.png" "Hình 3.1: Sơ đồ Tuần tự xác thực đăng nhập và phân quyền JWT (RBAC)"

Add-H2 "3.2. Sơ Đồ Tuần Tự: Tính Lương Tự Động & Giao Dịch An Toàn (Transaction Safety)"
Add-P "Tập trung chuyên sâu vào nghiệp vụ tính toán hàng loạt: Khởi tạo BEGIN TRANSACTION, nạp tỷ lệ trích nộp động từ DeductionRate (không hardcode 10.5%), duyệt vòng lặp tính toán cho 50 nhân viên. Nếu tất cả thành công thì COMMIT TRANSACTION; nếu phát sinh lỗi bất kỳ thì ROLLBACK TRANSACTION, bảo toàn 100% dữ liệu gốc."
Add-Img "$imagesDir\07_sequence_payroll_calculation.png" "Hình 3.2: Sơ đồ Tuần tự tính lương tự động với cơ chế Transaction an toàn"

Add-H2 "3.3. Sơ Đồ Tuần Tự: Đối Soát, Chốt Kỳ Lương & Xuất File Ngân Hàng"
Add-P "Mô tả quy trình đối soát bảng lương tổng hợp qua UC_HR_08, xác nhận chốt kỳ lương chuyển trạng thái sang LOCKED (Đã khóa chỉnh sửa, Read-Only), khóa bảng chấm công và tự động tạo file Excel danh sách chi lương gửi ngân hàng (UC_HR_10)."
Add-Img "$imagesDir\08_sequence_lock_payroll.png" "Hình 3.3: Sơ đồ Tuần tự đối soát, chốt kỳ lương Read-Only và xuất file ngân hàng"

Add-H2 "3.4. Sơ Đồ Tuần Tự: Nhân Viên Tra Cứu Phiếu Lương & Hỏi Đáp Trợ Lý AI"
Add-P "Mô tả quá trình nhân viên mở xem phiếu lương và đặt câu hỏi thắc mắc lương. Hệ thống áp dụng cơ chế bảo mật Ownership-based Authorization chặn IDOR, tổng hợp phiếu lương 2 tháng liền kề và gửi Grounding Prompt tới Microservice Python FastAPI kết nối Google Gemini API để giải thích chính xác với mục tiêu phản hồi dưới 2 giây."
Add-Img "$imagesDir\09_sequence_ai_inquiry.png" "Hình 3.4: Sơ đồ Tuần tự nhân viên tra cứu lương và tương tác AI"

Add-PageBreak

# ================= 6. CHUONG 4: ACTIVITY DIAGRAMS =================
Write-Host "6. Writing Chapter 4: Activity Diagrams..."
Add-H1 "CHƯƠNG 4: MÔ HÌNH HÓA QUY TRÌNH HOẠT ĐỘNG (ACTIVITY DIAGRAMS)"
Add-P "Để đảm bảo sơ đồ rõ ràng, dễ đọc trên trang in A4 và phân định rõ ranh giới trách nhiệm, quy trình được tách thành 2 sơ đồ phân làn Swimlane độc lập:"

Add-H2 "4.1. Sơ Đồ Hoạt Động 01: Quy Trình Chấm Công & Nghỉ Phép"
Add-P "Mô tả chu trình hàng ngày: Nhân viên điểm danh check-in/out, nộp đơn xin nghỉ phép, HR kiểm tra phê duyệt và chốt khóa bảng công tháng."
Add-Img "$imagesDir\10_activity_timesheet_leave.png" "Hình 4.1: Sơ đồ Hoạt động quy trình Chấm công & Nghỉ phép (Swimlane)"

Add-H2 "4.2. Sơ Đồ Hoạt Động 02: Quy Trình Tính Lương, Đối Soát & Quyết Toán Chi Trả"
Add-P "Mô tả chu trình cuối tháng: Kế toán khởi tạo kỳ lương, máy tự động tính lương theo Transaction, kế toán đối soát trên bảng tổng hợp, chốt sổ khóa Read-Only, xuất file ngân hàng và phát hành phiếu lương kèm hỗ trợ AI."
Add-Img "$imagesDir\11_activity_payroll_settlement.png" "Hình 4.2: Sơ đồ Hoạt động quy trình Tính lương, Đối soát & Quyết toán chi trả (Swimlane)"

Add-PageBreak

# ================= 7. CHUONG 5: STATE MACHINE =================
Write-Host "7. Writing Chapter 5: State Machine Diagram..."
Add-H1 "CHƯƠNG 5: MÔ HÌNH HÓA MÁY TRẠNG THÁI (STATE MACHINE DIAGRAM)"
Add-P "Sơ đồ Máy trạng thái mô tả vòng đời của đối tượng tài chính cốt lõi: PayrollPeriod (Kỳ Lương)."
Add-P "Vòng đời đối tượng được định nghĩa chuẩn xác và chặt chẽ, loại bỏ hoàn toàn các mâu thuẫn:"
Add-Bullet "DRAFT:" "Kỳ lương mới tạo, đang tiếp nhận công và đơn phép."
Add-Bullet "CALCULATING:" "Đang trong quá trình chạy Transaction tính toán hàng loạt."
Add-Bullet "CALCULATED:" "Đã tính xong và chờ kế toán đối soát số liệu tổng hợp. Tại trạng thái này, hệ thống cho phép chạy lại tính toán khi dữ liệu đầu vào bảng công hợp lệ."
Add-Bullet "LOCKED:" "Đã khóa chỉnh sửa, toàn bộ dữ liệu chuyển sang chế độ CHỈ ĐỌC (Read-Only), ngăn chặn tuyệt đối mọi hành vi sửa đổi dữ liệu quá khứ. Sau khi chốt, kỳ lương tiếp tục chuyển sang PAID khi hoàn tất thanh toán."
Add-Bullet "PAID:" "Kế toán xác nhận ủy nhiệm chi ngân hàng thành công, tiền đã về tài khoản nhân viên và lưu trữ lịch sử."
Add-Img "$imagesDir\12_state_payroll_period.png" "Hình 5.1: Sơ đồ Máy trạng thái vòng đời Kỳ Lương (PayrollPeriod Lifecycle)"

Add-PageBreak

# ================= 8. CHUONG 6: DEPLOYMENT =================
Write-Host "8. Writing Chapter 6: Deployment Diagram..."
Add-H1 "CHƯƠNG 6: MÔ HÌNH HÓA KIẾN TRÚC & TRIỂN KHAI (DEPLOYMENT DIAGRAM)"
Add-P "Sơ đồ Triển khai (Deployment Diagram) thể hiện kiến trúc phần cứng, hạ tầng mạng và các thành phần phần mềm trên môi trường thực tế với một ngăn xếp công nghệ duy nhất, đã được chốt chuẩn mực:"
Add-Bullet "Client Devices:" "Máy tính PC/Laptop của Kế toán/Admin chạy ứng dụng React SPA trên trình duyệt Chrome/Edge; Điện thoại thông minh của Nhân viên sử dụng PWA/Mobile Browser."
Add-Bullet "Web Server & Reverse Proxy:" "Nginx tiếp nhận cổng HTTPS 443, phục vụ các tệp tĩnh và điều hướng API."
Add-Bullet "Application Server:" "Java Spring Boot 3.2 chạy dịch vụ REST API, bảo mật Spring Security & JWT, xử lý nghiệp vụ tính lương."
Add-Bullet "AI Microservice:" "Python FastAPI thực thi bộ xử lý Prompt và kết nối dịch vụ Google Gemini Cloud."
Add-Bullet "Database Server:" "Hệ quản trị CSDL PostgreSQL 16 lưu trữ 10 bảng nghiệp vụ cốt lõi với tính năng ACID và toàn vẹn dữ liệu."
Add-Img "$imagesDir\13_deployment_diagram.png" "Hình 6.1: Sơ đồ Triển khai hạ tầng và thành phần công nghệ thống nhất"

Add-PageBreak

# ================= 9. PHU LUC: TRACEABILITY MATRIX =================
Write-Host "9. Writing Appendix: Traceability Matrix..."
Add-H1 "PHỤ LỤC: MA TRẬN TRUY VẾT YÊU CẦU & BẢNG TIÊU CHÍ CHẤM ĐIỂM"
Add-H2 "Bảng Ma Trận Truy Vết Yêu Cầu (Requirements Traceability Matrix) Đồng Bộ 100%"

$tableData = @(
    @("Mã BR", "Mô Tả Yêu Cầu Nghiệp Vụ", "Mã Use Case Thống Nhất", "Lớp Thực Thể (Domain Class)", "Bảng CSDL PostgreSQL"),
    @("BR-01", "Quản lý cơ cấu tổ chức & phòng ban", "UC_HR_01", "Department", "departments"),
    @("BR-02", "Quản lý tài khoản, mật khẩu & phân quyền", "UC_AUTH_01, UC_AUTH_02, UC_ADMIN_01, UC_ADMIN_02", "UserAccount", "user_accounts"),
    @("BR-03", "Quản lý hồ sơ lý lịch nhân sự công ty", "UC_HR_02", "Employee", "employees"),
    @("BR-04", "Quản lý hợp đồng lao động & lương cơ bản", "UC_HR_03", "Contract", "contracts"),
    @("BR-05", "Quản lý phụ cấp & các khoản khấu trừ", "UC_HR_04", "Contract, PayslipLine", "contracts, payslip_lines"),
    @("BR-06", "Cấu hình tỷ lệ trích nộp bảo hiểm & thuế", "UC_HR_05", "DeductionRate", "deduction_rates"),
    @("BR-07", "Ghi nhận công & quản lý đơn nghỉ phép", "UC_EMP_01, UC_EMP_02, UC_EMP_03, UC_HR_06", "Timesheet, LeaveRequest", "timesheets, leave_requests"),
    @("BR-08", "Khởi tạo kỳ & tính lương tự động 1-chạm", "UC_HR_07", "PayrollPeriod, Payslip", "payroll_periods, payslips"),
    @("BR-09", "Đối soát tổng hợp, chốt Read-Only & xuất Excel", "UC_HR_08, UC_HR_09, UC_HR_10", "PayrollPeriod, Payslip", "payroll_periods, payslips"),
    @("BR-10", "Bảo mật phiếu lương cá nhân & Trợ lý ảo AI", "UC_EMP_04, UC_EMP_06, UC_AI_01, UC_AI_02, UC_AI_03", "Payslip, PayslipLine", "payslips, payslip_lines")
)

$numRows = $tableData.Count
$numCols = 5
$table = $doc.Tables.Add($s.Range, $numRows, $numCols)
$table.Borders.Enable = 1
$table.Range.Font.Name = "Times New Roman"
$table.Range.Font.Size = 10.5

for ($r = 1; $r -le $numRows; $r++) {
    for ($c = 1; $c -le $numCols; $c++) {
        $cell = $table.Cell($r, $c)
        $cell.Range.Text = $tableData[$r - 1][$c - 1]
        $cell.VerticalAlignment = 1 # wdCellAlignVerticalCenter
        if ($r -eq 1) {
            $cell.Range.Font.Bold = 1
            $cell.Range.Font.Color = 0xFFFFFF # White text
            $cell.Shading.BackgroundPatternColor = 0x1E3A8A # Deep Navy
            $cell.Range.ParagraphFormat.Alignment = 1 # Center
        } else {
            if ($r % 2 -eq 0) {
                $cell.Shading.BackgroundPatternColor = 0xF8FAFC # Zebra light row
            }
            if ($c -eq 1 -or $c -eq 3) {
                $cell.Range.ParagraphFormat.Alignment = 1 # Center BR and UC codes
                $cell.Range.Font.Bold = 1
            } else {
                $cell.Range.ParagraphFormat.Alignment = 0 # Left
            }
        }
    }
}
try {
    $table.Columns.Item(1).Width = 55
    $table.Columns.Item(2).Width = 140
    $table.Columns.Item(3).Width = 110
    $table.Columns.Item(4).Width = 75
    $table.Columns.Item(5).Width = 75
} catch {}

$s.SetRange($table.Range.End, $table.Range.End)
$s.TypeParagraph()

# Nhúng tất cả hình ảnh vĩnh viễn (BreakLink)
Write-Host "Embedding all shapes permanently into DOCX..."
foreach ($shape in $doc.InlineShapes) {
    try {
        if ($shape.LinkFormat) {
            $shape.LinkFormat.SavePictureWithDocument = $true
            $shape.LinkFormat.BreakLink()
        }
    } catch {
        # Shape already embedded
    }
}

# Lưu tài liệu hoàn tất
# Lưu tài liệu hoàn tất
$doc.SaveAs([ref]$outDocx, [ref]16) # wdFormatXMLDocument = 16 (.docx)
$doc.Close()
$word.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($word) | Out-Null

$finalSize = (Get-Item $outDocx).Length
Write-Host "BUILD SUCCESSFUL! File saved to: $outDocx ($finalSize bytes)"
