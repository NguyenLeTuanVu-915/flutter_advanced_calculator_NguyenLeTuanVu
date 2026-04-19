import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_history.dart';
import '../models/calculator_settings.dart';

class StorageService {
  static const _historyKey = 'history';
  static const _settingsKey = 'settings';
  static const _memoryKey = 'memory';
  static const _angleModeKey = 'angleMode';

  // History
  static Future<void> saveHistory(List<CalculationHistory> history) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(history.map((h) => h.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
  }

  static Future<List<CalculationHistory>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded.map((e) => CalculationHistory.fromJson(e)).toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  // Settings
  static Future<void> saveSettings(CalculatorSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  static Future<CalculatorSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null) return const CalculatorSettings();
    return CalculatorSettings.fromJson(jsonDecode(raw));
  }

  // Memory
  static Future<void> saveMemory(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_memoryKey, value);
  }

  static Future<double> loadMemory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_memoryKey) ?? 0.0;
  }

  // Angle mode
  static Future<void> saveAngleMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_angleModeKey, mode);
  }

  static Future<String> loadAngleMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_angleModeKey) ?? 'degrees';
  }
}