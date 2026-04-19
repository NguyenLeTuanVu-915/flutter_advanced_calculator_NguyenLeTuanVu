import 'package:flutter/material.dart';

import '../widgets/display_area.dart';
import '../widgets/button_grid.dart';
import '../widgets/mode_selector.dart';
import '../utils/constants.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HistoryScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          children: [
            ModeSelector(),
            SizedBox(height: 8),

            // ĐÃ FIX: Xóa bỏ Expanded ở đây. DisplayArea giờ sẽ tự động
            // phình to ra vừa đủ để chứa chữ số bên trong mà không bị ép khuôn.
            DisplayArea(),

            SizedBox(height: 8),

            // ĐÃ FIX: ButtonGrid lấy toàn bộ không gian còn lại trên màn hình
            Expanded(child: ButtonGrid()),
          ],
        ),
      ),
    );
  }
}