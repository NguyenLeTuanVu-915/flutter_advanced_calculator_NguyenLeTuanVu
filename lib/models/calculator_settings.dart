/// Lớp lưu trữ các thiết lập cấu hình của ứng dụng máy tính.
/// Quản lý các tùy chọn như độ chính xác thập phân, rung, âm thanh và kích thước lịch sử.
class CalculatorSettings {
  /// Số lượng chữ số thập phân tối đa được hiển thị (Ví dụ: 6 chữ số).
  final int decimalPrecision;

  /// Bật/tắt phản hồi xúc giác (rung nhẹ) khi người dùng bấm phím.
  final bool hapticFeedback;

  /// Bật/tắt âm thanh (tiếng click) khi người dùng bấm phím.
  final bool soundEffects;

  /// Số lượng tối đa các phép tính được lưu lại trong màn hình Lịch sử.
  final int historySize;

  /// Constructor khởi tạo các thiết lập với các giá trị mặc định an toàn.
  const CalculatorSettings({
    this.decimalPrecision = 6,
    this.hapticFeedback = true,
    this.soundEffects = false,
    this.historySize = 50,
  });

  /// Phương thức `copyWith` rất phổ biến trong Flutter (đặc biệt khi dùng Provider/Bloc).
  /// Giúp tạo ra một bản sao (copy) của thiết lập hiện tại, nhưng thay đổi một vài giá trị mới.
  /// Ví dụ: settings.copyWith(soundEffects: true) -> Giữ nguyên mọi thứ, chỉ bật âm thanh.
  CalculatorSettings copyWith({
    int? decimalPrecision,
    bool? hapticFeedback,
    bool? soundEffects,
    int? historySize,
  }) {
    return CalculatorSettings(
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
      soundEffects: soundEffects ?? this.soundEffects,
      historySize: historySize ?? this.historySize,
    );
  }

  /// Chuyển đổi đối tượng [CalculatorSettings] thành định dạng Map (JSON).
  /// Dùng để lưu các thiết lập này vào SharedPreferences (bộ nhớ thiết bị).
  Map<String, dynamic> toJson() => {
    'decimalPrecision': decimalPrecision,
    'hapticFeedback': hapticFeedback,
    'soundEffects': soundEffects,
    'historySize': historySize,
  };

  /// Phương thức factory để đọc dữ liệu từ Map (JSON) đã lưu trong máy lên.
  /// Sử dụng toán tử `??` để cung cấp giá trị mặc định (fallback) trong trường hợp
  /// app được cài lần đầu tiên và chưa có dữ liệu nào được lưu.
  factory CalculatorSettings.fromJson(Map<String, dynamic> json) =>
      CalculatorSettings(
        decimalPrecision: json['decimalPrecision'] ?? 6,
        hapticFeedback: json['hapticFeedback'] ?? true,
        soundEffects: json['soundEffects'] ?? false,
        historySize: json['historySize'] ?? 50,
      );
}