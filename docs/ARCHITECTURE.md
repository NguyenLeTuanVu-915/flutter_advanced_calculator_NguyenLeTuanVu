# Nhật ký Quyết định Kiến trúc (ADR)

## 1. Quản lý Trạng thái: Provider
Quyết định: Sử dụng Provider (ChangeNotifier) thay vì Bloc hoặc GetX.
Lý do: Trạng thái của máy tính tương đối phẳng nhưng lại được chia sẻ rộng rãi qua nhiều widget khác nhau (Màn hình hiển thị, Lưới phím bấm, Màn hình cài đặt). Provider cung cấp một cách tiếp cận thuần Flutter, sạch sẽ và dễ bảo trì để quản lý trạng thái này mà không làm phức tạp hóa mã nguồn (over-engineering).
Triển khai: 
- CalculatorProvider: Xử lý logic tính toán cốt lõi, biểu thức hiện tại và chuyển đổi chế độ.
- ThemeProvider: Quản lý trạng thái giao diện Sáng/Tối.
- HistoryProvider: Quản lý danh sách các phép tính đã thực hiện.

## 2. Logic Tính toán: Bộ Phân tích Biểu thức Tùy chỉnh (Custom Expression Parser)
Quyết định: Xây dựng một bộ phân tích đệ quy (ExpressionParser) thay vì chỉ dựa vào dart:math hoặc hàm eval().
Lý do:Chúng ta cần kiểm soát chặt chẽ thứ tự ưu tiên của các phép toán (PEMDAS), xử lý chính xác dấu trừ (số âm) và khả năng tích hợp mượt mà các hàm khoa học (sin, cos, ln).

## 3. Lưu trữ Dữ liệu: SharedPreferences
Quyết định: Sử dụng shared_preferences để lưu trữ dữ liệu cục bộ.
Lý do: Khối lượng dữ liệu cần lưu rất nhỏ (Tùy chọn giao diện, 50 phép tính gần nhất, giá trị bộ nhớ M). Việc sử dụng một cơ sở dữ liệu SQL đầy đủ như SQLite sẽ gây dư thừa hiệu năng không cần thiết. Tất cả các đối tượng phức tạp (CalculationHistory, CalculatorSettings) đều được mã hóa thành chuỗi JSON trước khi lưu.