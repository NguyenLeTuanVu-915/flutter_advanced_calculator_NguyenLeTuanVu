import 'package:flutter/material.dart';
import '../models/calculation_history.dart';
import '../services/storage_service.dart';

/// Provider quản lý danh sách lịch sử các phép tính.
/// Đóng vai trò làm cầu nối đồng bộ dữ liệu giữa giao diện (UI) và bộ nhớ thiết bị (Storage).
class HistoryProvider extends ChangeNotifier {
  /// Danh sách nội bộ chứa các lịch sử tính toán (được private bằng dấu `_` để bảo mật dữ liệu).
  List<CalculationHistory> _history = [];

  /// Getter cho phép UI (ví dụ: HistoryScreen) đọc danh sách lịch sử.
  /// Việc này đảm bảo UI chỉ có quyền đọc, không có quyền sửa trực tiếp biến `_history`.
  List<CalculationHistory> get history => _history;

  /// Constructor: Tự động tải dữ liệu lịch sử đã lưu trên máy ngay khi Provider được tạo ra.
  HistoryProvider() {
    _load();
  }

  /// Hàm nội bộ (private) gọi đến StorageService để lấy dữ liệu từ SharedPreferences.
  void _load() async {
    _history = await StorageService.loadHistory();
    // Thông báo cho UI biết dữ liệu đã tải xong để vẽ lại màn hình (hiện danh sách)
    notifyListeners();
  }

  /// Thêm một phép tính mới vào lịch sử.
  /// [item] là phép tính vừa thực hiện xong.
  /// [maxSize] là giới hạn số lượng lịch sử tối đa (mặc định là 50, có thể chỉnh trong Cài đặt).
  void add(CalculationHistory item, {int maxSize = 50}) {
    // Chèn phép tính mới vào ĐẦU danh sách (index 0) để phép tính mới nhất luôn hiển thị trên cùng.
    _history.insert(0, item);

    // Nếu số lượng vượt quá giới hạn cho phép, xóa phần tử cũ nhất (nằm ở cuối danh sách).
    if (_history.length > maxSize) {
      _history.removeLast();
    }

    // Lưu danh sách mới cập nhật vào bộ nhớ thiết bị để lần sau mở app vẫn còn.
    StorageService.saveHistory(_history);

    // Báo hiệu để UI cập nhật lại danh sách hiển thị.
    notifyListeners();
  }

  /// Xóa toàn bộ dữ liệu lịch sử hiện có.
  void clearAll() {
    _history.clear(); // Xóa sạch dữ liệu trên RAM (danh sách hiện tại)
    StorageService.clearHistory(); // Xóa sạch dữ liệu dưới ổ cứng (SharedPreferences)
    notifyListeners(); // Báo cho UI để lập tức hiển thị giao diện "Chưa có lịch sử"
  }
}