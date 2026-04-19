import 'dart:math' as math;
import '../models/calculator_mode.dart';

class CalculatorLogic {
  static double evaluateSin(double x, AngleMode mode) {
    final rad = mode == AngleMode.degrees ? x * math.pi / 180 : x;
    return math.sin(rad);
  }

  static double evaluateCos(double x, AngleMode mode) {
    final rad = mode == AngleMode.degrees ? x * math.pi / 180 : x;
    return math.cos(rad);
  }

  static double evaluateTan(double x, AngleMode mode) {
    final rad = mode == AngleMode.degrees ? x * math.pi / 180 : x;
    return math.tan(rad);
  }

  static double evaluateLog(double x) => math.log(x) / math.ln10;

  static double evaluateLn(double x) => math.log(x);

  static double evaluateSqrt(double x) => math.sqrt(x);

  static double evaluateFactorial(int n) {
    if (n < 0) throw ArgumentError('Factorial undefined for negative numbers');
    if (n == 0 || n == 1) return 1;
    double result = 1;
    for (int i = 2; i <= n; i++) result *= i;
    return result;
  }
}