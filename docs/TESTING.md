# Tài liệu Kiểm thử (Testing Documentation)

Ứng dụng đi kèm với một bộ kiểm thử toàn diện để đảm bảo tính ổn định, đạt độ bao phủ (coverage) >80% cho các logic cốt lõi.

## 1. Kiểm thử Đơn vị (Unit Tests - test/calculator_logic_test.dart)
Kiểm thử độc lập các logic toán học và phân tích chuỗi mà không liên quan đến UI:
* Toán học cơ bản: Xác thực các phép toán +, -, *, /.
* Thứ tự ưu tiên (PEMDAS): Đảm bảo biểu thức 2 + 3 * 4 trả về kết quả 14, chứ không phải 20.
* Hàm Khoa học: Xác thực đầu ra của các hàm lượng giác và logarit.
* Các trường hợp ngoại lệ (Edge Cases): Xử lý chính xác lỗi chia cho 0 (5 / 0 -> Error) và các đầu vào không hợp lệ như sqrt(-4).

## 2. Kiểm thử Giao diện (Widget Tests - test/widget_test.dart)
Mô phỏng các tương tác của người dùng để đảm bảo UI phản hồi chính xác với sự thay đổi của trạng thái:
* Xác minh ứng dụng khởi động thành công và hiển thị giao diện ban đầu.
* Kiểm tra việc render thanh chọn chế độ (Cơ bản, Khoa học, Lập trình viên).
* Xác thực việc bấm phím sẽ cập nhật thông tin lên DisplayArea chính xác.
* Đảm bảo nút "C" (Clear) đặt lại trạng thái ứng dụng thành công.