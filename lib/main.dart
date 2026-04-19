import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/calculator_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/history_provider.dart';
import 'screens/calculator_screen.dart';
import 'utils/constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProv = context.watch<ThemeProvider>();
    return MaterialApp(
      // Bug 2 fix: ValueKey buộc MaterialApp rebuild hoàn toàn khi theme thay đổi
      // → toàn bộ widget tree nhận đúng màu mới ngay lập tức
      key: ValueKey(themeProv.themeMode),
      title: 'Advanced Calculator',
      debugShowCheckedModeBanner: false,
      themeMode: themeProv.themeMode,
      // Dùng theme từ ThemeProvider để đồng nhất
      theme: themeProv.lightTheme,
      darkTheme: themeProv.darkTheme,
      home: const CalculatorScreen(),
    );
  }
}