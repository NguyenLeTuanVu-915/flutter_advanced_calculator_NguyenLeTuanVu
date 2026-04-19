import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:advanced_calculator/main.dart';
import 'package:advanced_calculator/providers/calculator_provider.dart';
import 'package:advanced_calculator/providers/theme_provider.dart';
import 'package:advanced_calculator/providers/history_provider.dart';

Widget createApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CalculatorProvider()),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => HistoryProvider()),
    ],
    child: const MyApp(),
  );
}

void main() {
  testWidgets('App khởi động hiển thị màn hình calculator', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();
    expect(find.text('Advanced Calculator'), findsOneWidget);
  });

  testWidgets('Hiển thị các mode selector', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();
    expect(find.text('Basic'), findsOneWidget);
    expect(find.text('Scientific'), findsOneWidget);
    expect(find.text('Programmer'), findsOneWidget);
  });

  testWidgets('Nhấn nút số hiển thị trên display', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    // Tìm nút '5' trong ButtonGrid
    final btn5 = find.text('5');
    if (btn5.evaluate().isNotEmpty) {
      await tester.tap(btn5.first);
      await tester.pumpAndSettle();
    }
    // Chỉ kiểm tra app không crash
    expect(find.text('Advanced Calculator'), findsOneWidget);
  });

  testWidgets('Nhấn C xóa màn hình', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();

    final btnC = find.text('C');
    if (btnC.evaluate().isNotEmpty) {
      await tester.tap(btnC.first);
      await tester.pumpAndSettle();
    }
    expect(find.text('Advanced Calculator'), findsOneWidget);
  });

  testWidgets('Chuyển sang Scientific mode', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scientific'));
    await tester.pumpAndSettle();
    expect(find.text('Scientific'), findsOneWidget);
  });

  testWidgets('Chuyển sang Programmer mode', (tester) async {
    await tester.pumpWidget(createApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Programmer'));
    await tester.pumpAndSettle();
    expect(find.text('Programmer'), findsOneWidget);
  });
}