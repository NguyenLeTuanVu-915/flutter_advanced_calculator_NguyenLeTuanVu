import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/history_provider.dart';
import '../models/calculator_mode.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  String _themeLabel(ThemeMode mode) => switch (mode) {
    ThemeMode.light => 'Sáng',
    ThemeMode.dark => 'Tối',
    ThemeMode.system => 'Hệ thống',
  };

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    final calc = context.watch<CalculatorProvider>();
    final historyProv = context.read<HistoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        children: [
          // ── THEME ──────────────────────────────────────────────────
          _sectionHeader('Giao diện'),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Chế độ giao diện'),
            trailing: PopupMenuButton<ThemeMode>(
              tooltip: '',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _themeLabel(themeProv.themeMode),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
              itemBuilder: (_) => const [
                PopupMenuItem(value: ThemeMode.light, child: Text('Sáng')),
                PopupMenuItem(value: ThemeMode.dark, child: Text('Tối')),
                PopupMenuItem(value: ThemeMode.system, child: Text('Hệ thống')),
              ],
              onSelected: (v) => themeProv.setTheme(v),
            ),
          ),

          // ── PHẢN HỒI THAO TÁC (HAPTIC & SOUND) ─────────────────────
          _sectionHeader('Phản hồi thao tác'),
          SwitchListTile(
            secondary: const Icon(Icons.vibration),
            title: const Text('Rung khi chạm (Haptic)'),
            value: calc.hapticFeedback,
            onChanged: (v) => calc.toggleHapticFeedback(v),
            // FIX: Sử dụng màu Accent tương ứng với Theme để công tắc sáng rực lên
            activeColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkAccent
                : AppColors.lightAccent,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up),
            title: const Text('Âm thanh phím (Sound)'),
            value: calc.soundEffects,
            onChanged: (v) => calc.toggleSoundEffects(v),
            // FIX: Sử dụng màu Accent tương ứng với Theme
            activeColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkAccent
                : AppColors.lightAccent,
          ),

          // ── ANGLE MODE ─────────────────────────────────────────────
          _sectionHeader('Khoa học'),
          ListTile(
            leading: const Icon(Icons.rotate_right),
            title: const Text('Đơn vị góc'),
            trailing: SizedBox(
              width: 150,
              child: SegmentedButton<AngleMode>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: AngleMode.degrees, label: Text('DEG')),
                  ButtonSegment(value: AngleMode.radians, label: Text('RAD')),
                ],
                selected: {calc.angleMode},
                onSelectionChanged: (_) => calc.toggleAngleMode(),
              ),
            ),
          ),

          // ── DECIMAL PRECISION ──────────────────────────────────────
          _sectionHeader('Hiển thị'),
          ListTile(
            leading: const Icon(Icons.numbers),
            title: const Text('Số chữ số thập phân'),
            trailing: PopupMenuButton<int>(
              tooltip: '',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${calc.decimalPrecision}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
              itemBuilder: (_) => [2, 4, 6, 8, 10]
                  .map((v) => PopupMenuItem(value: v, child: Text('$v')))
                  .toList(),
              onSelected: (v) => calc.setDecimalPrecision(v),
            ),
          ),

          // ── HISTORY ────────────────────────────────────────────────
          _sectionHeader('Lịch sử'),
          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text('Số lượng lưu tối đa'),
            trailing: PopupMenuButton<int>(
              tooltip: '',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${calc.maxHistory}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
              itemBuilder: (_) => [25, 50, 100]
                  .map((v) => PopupMenuItem(value: v, child: Text('$v')))
                  .toList(),
              onSelected: (v) => calc.setMaxHistory(v),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Xóa toàn bộ lịch sử',
                style: TextStyle(color: Colors.red)),
            onTap: () => _confirmClearHistory(context, historyProv),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
    child: Text(title,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            fontSize: 13)),
  );

  void _confirmClearHistory(BuildContext context, HistoryProvider prov) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa lịch sử'),
        content: const Text('Bạn có chắc muốn xóa toàn bộ lịch sử?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy')),
          FilledButton(
            onPressed: () {
              prov.clearAll();
              Navigator.pop(context);
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}