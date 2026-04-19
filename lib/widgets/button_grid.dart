import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../providers/history_provider.dart';
import '../utils/constants.dart';
import 'calculator_button.dart';

class ButtonGrid extends StatelessWidget {
  const ButtonGrid({super.key});

  static const _basicButtons = [
    ['C', 'CE', '%', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '+'],
    ['±', '0', '.', '='],
  ];

  static const _scientificButtons = [
    ['2nd', 'sin', 'cos', 'tan', 'ln', 'log'],
    ['x²', '√', 'x^y', '(', ')', '÷'],
    ['MC', '7', '8', '9', 'C', '×'],
    ['MR', '4', '5', '6', 'CE', '-'],
    ['M+', '1', '2', '3', '%', '+'],
    ['M-', '±', '0', '.', 'π', '='],
  ];

  // CẬP NHẬT: Thêm HEX, DEC, OCT, BIN thành 1 hàng để dễ thao tác
  static const _programmerButtons = [
    ['HEX', 'DEC', 'OCT', 'BIN'],
    ['AND', 'OR', 'XOR', 'NOT'],
    ['<<', '>>', 'C', 'CE'],
    ['7', '8', '9', '÷'],
    ['4', '5', '6', '×'],
    ['1', '2', '3', '-'],
    ['±', '0', '=', '+'],
  ];

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();
    final buttons = calc.mode == CalculatorMode.scientific
        ? _scientificButtons
        : calc.mode == CalculatorMode.programmer
        ? _programmerButtons
        : _basicButtons;
    final columns = calc.mode == CalculatorMode.scientific ? 6 : 4;
    final rows = buttons.length;
    final flat = buttons.expand((r) => r).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalVSpacing = AppDimensions.buttonSpacing * (rows - 1);
        final totalHSpacing = AppDimensions.buttonSpacing * (columns - 1);
        final cellHeight = (constraints.maxHeight - totalVSpacing) / rows;
        final cellWidth = (constraints.maxWidth - totalHSpacing) / columns;
        final aspectRatio = (cellWidth / cellHeight).clamp(0.5, 4.0);

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: AppDimensions.buttonSpacing,
            mainAxisSpacing: AppDimensions.buttonSpacing,
            childAspectRatio: aspectRatio,
          ),
          itemCount: flat.length,
          itemBuilder: (ctx, index) {
            final label = flat[index];
            return CalculatorButton(
              label: label,
              color: _buttonColor(ctx, label),
              textColor: _textColor(ctx, label),
              onPressed: () => _handleButton(ctx, calc, label),
            );
          },
        );
      },
    );
  }

  void _handleButton(BuildContext context, CalculatorProvider calc, String label) {
    switch (label) {
      case '=':
        calc.calculate();
        final item = calc.lastCalculation;
        if (item != null) {
          Provider.of<HistoryProvider>(context, listen: false)
              .add(item, maxSize: calc.maxHistory);
        }
      case 'C':
        calc.clear();
      case 'CE':
        calc.clearEntry();
      case '±':
        calc.toggleSign();
      case '%':
        calc.addPercentage();
      case 'M+':
        calc.memoryAdd();
      case 'M-':
        calc.memorySubtract();
      case 'MR':
        calc.memoryRecall();
      case 'MC':
        calc.memoryClear();
      case 'x²':
        calc.addToExpression('^2');
      case '√':
        calc.addToExpression('√(');
      case 'x^y':
        calc.addToExpression('^');
      case 'sin':
      case 'cos':
      case 'tan':
      case 'ln':
      case 'log':
        calc.addScientificFunction(label);

    // THÊM: Các case cho Programmer Mode
      case 'HEX':
        calc.setNumberBase(NumberBase.hex);
      case 'DEC':
        calc.setNumberBase(NumberBase.dec);
      case 'OCT':
        calc.setNumberBase(NumberBase.oct);
      case 'BIN':
        calc.setNumberBase(NumberBase.bin);
      case 'AND':
      case 'OR':
      case 'XOR':
      case '<<':
      case '>>':
        calc.addToExpression(' $label '); // Thêm khoảng trắng nhìn cho đẹp
      case 'NOT':
        calc.addToExpression('NOT ');
      case '2nd':
        break;
      default:
        calc.addToExpression(label);
    }
  }

  Color? _buttonColor(BuildContext context, String label) {
    // FIX: Đổi dấu = sang lấy màu nền secondary (màu Accent đã cài ở trên)
    if (label == '=') return Theme.of(context).colorScheme.secondary;

    if (['÷', '×', '-', '+'].contains(label)) {
      return Theme.of(context).colorScheme.primaryContainer;
    }
    if (['C', 'CE', '%', '±'].contains(label)) {
      return Theme.of(context).colorScheme.secondaryContainer;
    }
    // Màu riêng cho các nút base conversion và bitwise
    if (['sin', 'cos', 'tan', 'ln', 'log', '√', 'x²', 'x^y', 'π',
      'AND', 'OR', 'XOR', 'NOT', '<<', '>>', 'HEX', 'DEC', 'OCT', 'BIN'].contains(label)) {
      return Theme.of(context).colorScheme.tertiaryContainer;
    }
    return null;
  }

  Color? _textColor(BuildContext context, String label) {
    // FIX: Lấy màu chữ tương phản với nền (Màu đen cho Dark mode, Trắng cho Light mode)
    if (label == '=') return Theme.of(context).colorScheme.onSecondary;
    return null;
  }
}