# Ứng Dụng Máy Tính Nâng Cao (Advanced Mobile Calculator)

## Mô tả dự án
Đây là một ứng dụng máy tính chuyên nghiệp và toàn diện được xây dựng bằng Flutter. Ứng dụng không chỉ có các phép toán cơ bản mà còn cung cấp các hàm Khoa học (Scientific), chế độ Lập trình viên (Programmer) với khả năng chuyển đổi hệ cơ số và thao tác bit, lịch sử tính toán được lưu cục bộ, cùng với các cài đặt tùy chỉnh như giao diện Tối/Sáng và phản hồi rung/âm thanh.

## Tính năng nổi bật
- Ba chế độ hoạt động: Cơ bản (Basic), Khoa học (Scientific), và Lập trình viên (Programmer).
- Phân tích biểu thức: Sử dụng bộ phân tích đệ quy (Recursive Descent Parser) tùy chỉnh để xử lý đúng thứ tự ưu tiên phép toán (PEMDAS), dấu ngoặc đơn và các hàm lồng nhau.
- Chế độ Lập trình viên: Hỗ trợ chuyển đổi giữa hệ HEX, DEC, OCT, BIN và các phép toán thao tác bit (AND, OR, XOR, NOT, <<, >>).
- Quản lý lịch sử: Lưu trữ cục bộ lên đến 100 phép tính gần nhất. Nhấn vào lịch sử để sử dụng lại kết quả.
- Tùy chỉnh cá nhân: Chuyển đổi giao diện Sáng/Tối/Hệ thống, điều chỉnh số lượng chữ số thập phân và đơn vị góc (Độ/Radian).
- Phản hồi tương tác: Tích hợp phản hồi xúc giác (rung) và hiệu ứng âm thanh khi bấm phím.

## Ảnh chụp màn hình (screenshots)

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/8bc66ccf-2fad-4b3a-96de-aea99f3ebab1" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/ddce43e5-2c73-4f4d-b592-e7d50bdfb877" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/616f48cd-0530-4a46-89a1-dfec95880556" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/546479fb-fec5-4ca6-8416-965808ea172d" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/3cef4b3d-576a-4dcf-b839-a79d9c122844" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/0ddb0a58-f0db-44d9-b460-c3b2ec63960b" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/df87c4f4-f4a4-4708-8758-4b90bcfdaed9" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/4fd06098-356d-4406-97ca-6c1ef4c92f6f" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/840316d6-a2ca-4bf9-a936-4dd9a92a79d9" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/3f3ca663-c232-4557-ad94-363399a14b7e" />


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
- Để chạy toàn bộ test, sử dụng lệnh: flutter test

## Hạn chế hiện tại
- Các phép toán thao tác bit trong chế độ Lập trình viên hiện bị giới hạn bởi giới hạn số nguyên 64-bit tiêu chuẩn của ngôn ngữ Dart.
- Các phép tính giai thừa quá lớn (ví dụ: > 170!) sẽ trả về Infinity.
