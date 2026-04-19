import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.lightAccent,
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: Colors.white,
      // FIX: Dùng màu đỏ (Accent) làm màu nền phụ
      secondary: AppColors.lightAccent,
      // FIX: Chữ màu trắng trên nền đỏ
      onSecondary: Colors.white,
    ),
    useMaterial3: true,
    fontFamily: 'Roboto',
  );

  ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkAccent,
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      onPrimary: Colors.white,
      // FIX: Dùng màu xanh ngọc (Accent) làm màu nền phụ
      secondary: AppColors.darkAccent,
      // FIX: Chữ màu đen trên nền xanh ngọc sẽ cực kỳ rõ nét
      onSecondary: Colors.black,
    ),
    useMaterial3: true,
    fontFamily: 'Roboto',
  );

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() {
    _themeMode =
    _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    _saveTheme();
  }

  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    _saveTheme();
  }

  void _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme', _themeMode.name);
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme');
    if (saved != null) {
      _themeMode = ThemeMode.values.firstWhere(
            (e) => e.name == saved,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }
}