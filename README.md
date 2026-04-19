# Ứng Dụng Máy Tính Nâng Cao (Advanced Mobile Calculator)

## Mô tả dự án
Đây là một ứng dụng máy tính chuyên nghiệp và toàn diện được xây dựng bằng Flutter. Ứng dụng không chỉ có các phép toán cơ bản mà còn cung cấp các hàm Khoa học (Scientific), chế độ Lập trình viên (Programmer) với khả năng chuyển đổi hệ cơ số và thao tác bit, lịch sử tính toán được lưu cục bộ, cùng với các cài đặt tùy chỉnh như giao diện Tối/Sáng và phản hồi rung/âm thanh.

## Tính năng nổi bật
* Ba chế độ hoạt động: Cơ bản (Basic), Khoa học (Scientific), và Lập trình viên (Programmer).
* Phân tích biểu thức: Sử dụng bộ phân tích đệ quy (Recursive Descent Parser) tùy chỉnh để xử lý đúng thứ tự ưu tiên phép toán (PEMDAS), dấu ngoặc đơn và các hàm lồng nhau.
* **Chế độ Lập trình viên: Hỗ trợ chuyển đổi giữa hệ HEX, DEC, OCT, BIN và các phép toán thao tác bit (AND, OR, XOR, NOT, <<, >>).
* Quản lý lịch sử: Lưu trữ cục bộ lên đến 100 phép tính gần nhất. Nhấn vào lịch sử để sử dụng lại kết quả.
* Tùy chỉnh cá nhân: Chuyển đổi giao diện Sáng/Tối/Hệ thống, điều chỉnh số lượng chữ số thập phân và đơn vị góc (Độ/Radian).
* Phản hồi tương tác: Tích hợp phản hồi xúc giác (rung) và hiệu ứng âm thanh khi bấm phím.

## Ảnh chụp màn hình (screenshots)



## Sơ đồ Kiến trúc
Dự án tuân thủ chặt chẽ mô hình Quản lý trạng thái Provider (Provider State Management), tách biệt hoàn toàn thành phần giao diện (UI) khỏi logic nghiệp vụ.
UI (Widgets/Screens) ↔ Providers (State) ↔ Services (SharedPreferences) & Utils (Parser)

## Hướng dẫn Cài đặt
1. Đảm bảo bạn đã cài đặt Flutter trên máy.
2. Clone repository này về máy.
3. Chạy lệnh flutter pub get để cài đặt các thư viện phụ thuộc (Provider, Shared Preferences).
4. Chạy lệnh flutter run để mở ứng dụng trên thiết bị thật hoặc máy ảo.

## Hướng dẫn Kiểm thử (Testing)
Dự án bao gồm cả Unit Tests (kiểm tra logic toán học) và Widget Tests (kiểm tra tương tác UI).
* Để chạy toàn bộ test, sử dụng lệnh: flutter test

## Hạn chế hiện tại
* Các phép toán thao tác bit trong chế độ Lập trình viên hiện bị giới hạn bởi giới hạn số nguyên 64-bit tiêu chuẩn của ngôn ngữ Dart.
* Các phép tính giai thừa quá lớn (ví dụ: > 170!) sẽ trả về Infinity.

## Hướng phát triển tương lai
* Thêm hỗ trợ giao diện xoay ngang (landscape) với bàn phím mở rộng.
* Tích hợp tính năng vẽ đồ thị (Graph Plotting) cho các hàm toán học.
* Hỗ trợ nhập liệu bằng giọng nói (Voice input).
