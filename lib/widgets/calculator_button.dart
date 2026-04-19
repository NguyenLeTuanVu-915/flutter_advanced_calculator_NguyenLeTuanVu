import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Bắt buộc cho Rung và Âm thanh
import 'package:provider/provider.dart'; // Đọc dữ liệu cài đặt
import '../providers/calculator_provider.dart';
import '../utils/constants.dart';

class CalculatorButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final double? fontSize;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.textColor,
    this.fontSize,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimensions.buttonPressAnimMs),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Đọc trạng thái Rung và Âm thanh từ Provider
    final haptic = context.select((CalculatorProvider p) => p.hapticFeedback);
    final sound = context.select((CalculatorProvider p) => p.soundEffects);

    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();

        // Kích hoạt Rung & Kêu nếu cài đặt đang Bật
        if (haptic) HapticFeedback.lightImpact();
        if (sound) SystemSound.play(SystemSoundType.click);
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color ?? Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.fontSize ?? 20,
                color: widget.textColor ?? Theme.of(context).colorScheme.onSurface,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ),
    );
  }
}