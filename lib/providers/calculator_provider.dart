import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/calculator_mode.dart';
import '../models/calculation_history.dart';
import '../models/calculator_settings.dart'; // Thêm dòng này để dùng CalculatorSettings
import '../services/storage_service.dart';
import '../utils/expression_parser.dart';

/// Provider chịu trách nhiệm quản lý toàn bộ trạng thái (state) và logic tính toán của máy tính.
class CalculatorProvider extends ChangeNotifier {
  // ─── CÁC BIẾN TRẠNG THÁI (STATE) ─────────────────────────────────────────────

  String _expression = '';
  String _result = '0';
  String _previousResult = '';
  CalculatorMode _mode = CalculatorMode.basic;
  AngleMode _angleMode = AngleMode.degrees;
  double _memory = 0;
  bool _hasMemory = false;
  int _decimalPrecision = 6;
  int _maxHistory = 50;
  bool _isError = false;
  CalculationHistory? _lastCalculation;
  NumberBase _currentBase = NumberBase.dec;

  bool _hapticFeedback = true;
  bool _soundEffects = false;

  // ─── GETTERS ─────────────────────────────────────────────────────────────────
  String get expression => _expression;
  String get result => _result;
  String get previousResult => _previousResult;
  CalculatorMode get mode => _mode;
  AngleMode get angleMode => _angleMode;
  double get memory => _memory;
  bool get hasMemory => _hasMemory;
  int get decimalPrecision => _decimalPrecision;
  int get maxHistory => _maxHistory;
  bool get isError => _isError;
  CalculationHistory? get lastCalculation => _lastCalculation;
  NumberBase get currentBase => _currentBase;
  bool get hapticFeedback => _hapticFeedback;
  bool get soundEffects => _soundEffects;

  // ─── KHỞI TẠO ───────────────────────────────────────────────────────────────
  CalculatorProvider() {
    _loadData();
  }

  void _loadData() async {
    _memory = await StorageService.loadMemory();
    _hasMemory = _memory != 0;
    final modeStr = await StorageService.loadAngleMode();
    _angleMode = modeStr == 'radians' ? AngleMode.radians : AngleMode.degrees;

    // NẠP SETTINGS
    final settings = await StorageService.loadSettings();
    _decimalPrecision = settings.decimalPrecision;
    _maxHistory = settings.historySize;
    _hapticFeedback = settings.hapticFeedback;
    _soundEffects = settings.soundEffects;

    notifyListeners();
  }

  // ─── CẬP NHẬT CÀI ĐẶT ───────────────────────────────────────────────────────

  void _saveSettings() {
    StorageService.saveSettings(CalculatorSettings(
      decimalPrecision: _decimalPrecision,
      historySize: _maxHistory,
      hapticFeedback: _hapticFeedback,
      soundEffects: _soundEffects,
    ));
  }

  void toggleHapticFeedback(bool value) {
    _hapticFeedback = value;
    _saveSettings();
    notifyListeners();
  }

  void toggleSoundEffects(bool value) {
    _soundEffects = value;
    _saveSettings();
    notifyListeners();
  }

  void setDecimalPrecision(int p) {
    _decimalPrecision = p;
    _saveSettings();
    notifyListeners();
  }

  void setMaxHistory(int s) {
    _maxHistory = s;
    _saveSettings();
    notifyListeners();
  }

  // ─── XỬ LÝ NHẬP LIỆU (INPUT) ────────────────────────────────────────────────
  /// Thêm một ký tự/chuỗi mới vào biểu thức đang nhập
  void addToExpression(String value) {
    if (_isError) {
      _expression = ''; // Nếu đang lỗi, gõ phím mới sẽ tự động xóa lỗi đi
      _isError = false;
    }

    // --- LOGIC CHO CHAIN CALCULATIONS (TÍNH TOÁN NỐI TIẾP) ---
    // Nếu biểu thức đang trống (vừa bấm dấu '=' xong)
    if (_expression.isEmpty) {
      // Danh sách các toán tử có thể nối tiếp
      final operators = ['+', '-', '×', '÷', '^', '^2', ' AND ', ' OR ', ' XOR ', ' << ', ' >> '];

      // Nếu người dùng gõ ngay một toán tử
      if (operators.contains(value)) {
        // Lấy kết quả cũ làm số hạng đầu tiên cho phép tính mới (Ví dụ: "8" + "+")
        _expression = (_result == 'Error' ? '0' : _result) + value;
        notifyListeners();
        return;
      }
    }

    _expression += value;
    notifyListeners();
  }

  void setExpression(String value) {
    _expression = value;
    _result = value;
    _isError = false;
    notifyListeners();
  }

  // ─── LẬP TRÌNH VIÊN (PROGRAMMER MODE) ───────────────────────────────────────
  void setNumberBase(NumberBase newBase) {
    if (_mode != CalculatorMode.programmer || _result == 'Error') return;
    try {
      int radixOld = _getRadix(_currentBase);
      int decimalValue = int.parse(_result.isEmpty ? '0' : _result, radix: radixOld);
      int radixNew = _getRadix(newBase);
      _result = decimalValue.toRadixString(radixNew).toUpperCase();
      _currentBase = newBase;
      notifyListeners();
    } catch (e) {
      _result = 'Error';
      _isError = true;
      notifyListeners();
    }
  }

  int _getRadix(NumberBase base) {
    return switch (base) {
      NumberBase.bin => 2,
      NumberBase.oct => 8,
      NumberBase.dec => 10,
      NumberBase.hex => 16,
    };
  }

  // ─── TÍNH TOÁN CỐT LÕI (CORE CALCULATION) ───────────────────────────────────
  void calculate() {
    if (_expression.isEmpty) return;
    _lastCalculation = null;
    try {
      if (_mode == CalculatorMode.programmer) {
        _result = _evaluateProgrammer(_expression);
        _isError = false;
      } else {
        final parser = ExpressionParser(angleMode: _angleMode);
        final evalResult = parser.parse(_expression);

        if (evalResult == double.infinity || evalResult == double.negativeInfinity) {
          _result = 'Error: Division by zero';
          _isError = true;
        } else if (evalResult.isNaN) {
          _result = 'Error: Invalid input';
          _isError = true;
        } else {
          _result = _formatResult(evalResult);
          _isError = false;
        }
      }

      if (!_isError) {
        _lastCalculation = CalculationHistory(
          expression: _expression,
          result: _result,
          timestamp: DateTime.now(),
        );
        _previousResult = _result;
      }
      _expression = '';
    } catch (e) {
      _result = 'Error';
      _isError = true;
      _expression = '';
    }
    notifyListeners();
  }

  String _evaluateProgrammer(String expr) {
    String cleanExpr = expr.replaceAll(' ', '');
    if (cleanExpr.isEmpty) return '0';

    try {
      if (cleanExpr.startsWith('NOT')) {
        String valStr = cleanExpr.substring(3);
        int val = int.parse(valStr, radix: _getRadix(_currentBase));
        return (~val).toRadixString(_getRadix(_currentBase)).toUpperCase();
      }

      final RegExp regex = RegExp(r'^([0-9A-F]+)(AND|OR|XOR|<<|>>)([0-9A-F]+)$');
      final match = regex.firstMatch(cleanExpr);

      if (match != null) {
        int left = int.parse(match.group(1)!, radix: _getRadix(_currentBase));
        String op = match.group(2)!;
        int right = int.parse(match.group(3)!, radix: _getRadix(_currentBase));

        int resultInt = switch (op) {
          'AND' => left & right,
          'OR'  => left | right,
          'XOR' => left ^ right,
          '<<'  => left << right,
          '>>'  => left >> right,
          _ => throw Exception('Toán tử không hợp lệ'),
        };

        return resultInt.toRadixString(_getRadix(_currentBase)).toUpperCase();
      }

      return int.parse(cleanExpr, radix: _getRadix(_currentBase))
          .toRadixString(_getRadix(_currentBase)).toUpperCase();
    } catch (e) {
      throw Exception('Lỗi tính toán Programmer');
    }
  }

  // ─── CÁC CHỨC NĂNG BỔ TRỢ ───────────────────────────────────────────────────
  void clear() {
    _expression = '';
    _result = '0';
    _previousResult = '';
    _isError = false;
    _lastCalculation = null;
    notifyListeners();
  }

  void clearEntry() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      notifyListeners();
    }
  }

  void toggleSign() {
    if (_expression.isEmpty) {
      if (_result != '0' && _result != 'Error') {
        _expression = _result.startsWith('-') ? _result.substring(1) : '-' + _result;
        _result = '0';
      } else {
        _expression = '-';
      }
      notifyListeners();
      return;
    }

    if (_expression == '-') {
      _expression = '';
      notifyListeners();
      return;
    }

    final isProgrammer = _mode == CalculatorMode.programmer;
    final pattern = isProgrammer ? r'(-?[0-9A-F]+)$' : r'(-?\d+\.?\d*)$';
    final regExp = RegExp(pattern);

    final match = regExp.firstMatch(_expression);
    if (match != null) {
      String lastNum = match.group(1)!;
      String newNum = lastNum.startsWith('-') ? lastNum.substring(1) : '-' + lastNum;
      _expression = _expression.substring(0, _expression.length - lastNum.length) + newNum;
    } else {
      _expression += '-';
    }
    notifyListeners();
  }

  void addPercentage() {
    if (_mode == CalculatorMode.programmer) return;
    final val = double.tryParse(_result);
    if (val != null) {
      _result = _formatResult(val / 100);
      notifyListeners();
    }
  }

  void addScientificFunction(String function) {
    addToExpression('$function(');
  }

  // ─── CHUYỂN CHẾ ĐỘ ──────────────────────────────────────────────────────────
  void toggleMode(CalculatorMode mode) {
    _mode = mode;
    clear();
    notifyListeners();
  }

  void setMode(CalculatorMode m) => toggleMode(m);

  void toggleAngleMode() {
    _angleMode = _angleMode == AngleMode.degrees ? AngleMode.radians : AngleMode.degrees;
    StorageService.saveAngleMode(_angleMode.name);
    notifyListeners();
  }

  // ─── QUẢN LÝ BỘ NHỚ ─────────────────────────────────────────────────────────
  void memoryAdd() {
    _memory += double.tryParse(_result) ?? 0;
    _hasMemory = true;
    StorageService.saveMemory(_memory);
    notifyListeners();
  }

  void memorySubtract() {
    _memory -= double.tryParse(_result) ?? 0;
    StorageService.saveMemory(_memory);
    notifyListeners();
  }

  void memoryRecall() {
    _expression = _memory.toString();
    _result = _memory.toString();
    notifyListeners();
  }

  void memoryClear() {
    _memory = 0;
    _hasMemory = false;
    StorageService.saveMemory(0);
    notifyListeners();
  }

  // ─── FORMAT KẾT QUẢ ─────────────────────────────────────────────────────────
  String _formatResult(double val) {
    if (val.isNaN) return 'Error: Invalid input';
    if (val.isInfinite) return val > 0 ? '∞' : '-∞';
    if (val == val.truncateToDouble()) return val.toInt().toString();
    return double.parse(val.toStringAsFixed(_decimalPrecision)).toString();
  }
}