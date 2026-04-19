import 'dart:convert';

/// Lớp đại diện cho một bản ghi lịch sử tính toán.
/// Lưu trữ biểu thức đã nhập, kết quả và thời gian thực hiện phép tính.
class CalculationHistory {
  /// Biểu thức toán học đã nhập (Ví dụ: "5 + 3")
  final String expression;

  /// Kết quả của phép tính (Ví dụ: "8")
  final String result;

  /// Thời điểm thực hiện phép tính
  final DateTime timestamp;

  /// Constructor khởi tạo một bản ghi lịch sử
  CalculationHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  /// Chuyển đổi đối tượng [CalculationHistory] thành dạng Map (JSON)
  /// để có thể lưu trữ vào SharedPreferences hoặc Database.
  Map<String, dynamic> toJson() => {
    'expression': expression,
    'result': result,
    // Chuyển DateTime thành chuỗi ISO 8601 (VD: "2023-10-25T14:30:00.000Z") để dễ lưu trữ
    'timestamp': timestamp.toIso8601String(),
  };

  /// Phương thức factory (tạo mới đối tượng) từ một Map (JSON)
  /// Thường được sử dụng khi đọc dữ liệu đã lưu từ SharedPreferences lên.
  factory CalculationHistory.fromJson(Map<String, dynamic> json) =>
      CalculationHistory(
        expression: json['expression'],
        result: json['result'],
        // Phân tích ngược chuỗi ISO 8601 về lại kiểu DateTime
        timestamp: DateTime.parse(json['timestamp']),
      );
}