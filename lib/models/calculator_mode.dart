/// Các chế độ hoạt động chính của máy tính.
enum CalculatorMode {
  /// Chế độ cơ bản: Các phép toán số học thông thường (+, -, ×, ÷)
  basic,

  /// Chế độ khoa học: Hỗ trợ lượng giác (sin, cos), logarit, căn bậc, số mũ...
  scientific,

  /// Chế độ lập trình viên: Hỗ trợ tính toán bitwise (AND, OR, XOR, dịch bit)
  /// và chuyển đổi giữa các hệ cơ số.
  programmer
}

/// Đơn vị đo góc, được sử dụng chủ yếu cho các hàm lượng giác (sin, cos, tan)
/// trong chế độ Scientific.
enum AngleMode {
  /// Góc tính bằng Độ (Degrees) - Ví dụ: sin(90°)
  degrees,

  /// Góc tính bằng Radian - Ví dụ: sin(π/2)
  radians
}

/// Các hệ cơ số được sử dụng để hiển thị và tính toán trong chế độ Programmer.
enum NumberBase {
  /// Hệ nhị phân (Binary - Cơ số 2): Chỉ gồm 0 và 1
  bin,

  /// Hệ bát phân (Octal - Cơ số 8): Gồm các số từ 0 đến 7
  oct,

  /// Hệ thập phân (Decimal - Cơ số 10): Hệ đếm thông thường từ 0 đến 9
  dec,

  /// Hệ thập lục phân (Hexadecimal - Cơ số 16): Gồm số từ 0-9 và chữ A-F
  hex
}