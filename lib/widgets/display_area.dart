import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/calculator_mode.dart';
import '../providers/calculator_provider.dart';
import '../utils/constants.dart';

class DisplayArea extends StatelessWidget {
  const DisplayArea({super.key});

  @override
  Widget build(BuildContext context) {
    final calc = context.watch<CalculatorProvider>();

    // Tự động thay đổi Nhãn hiển thị góc/hệ cơ số
    String modeLabel = '';
    if (calc.mode == CalculatorMode.programmer) {
      modeLabel = calc.currentBase.name.toUpperCase(); // Hiển thị HEX, DEC...
    } else {
      modeLabel = calc.angleMode == AngleMode.degrees ? 'DEG' : 'RAD';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.screenPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppDimensions.displayRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Fix Overflow
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (calc.hasMemory)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text('M',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onPrimaryContainer)),
                )
              else
                const SizedBox(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  modeLabel,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondaryContainer),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            calc.previousResult,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true,
            child: Text(
              calc.expression.isEmpty ? '' : calc.expression,
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Roboto',
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            calc.result,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w500,
              fontFamily: 'Roboto',
              color: calc.isError
                  ? Colors.red
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}