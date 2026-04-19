import 'dart:math' as math;
import '../models/calculator_mode.dart';

class ExpressionParser {
  final AngleMode angleMode;

  ExpressionParser({this.angleMode = AngleMode.degrees});

  double toRad(double deg) => deg * math.pi / 180;

  double parse(String expression) {
    String expr = expression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('π', math.pi.toString())
        .replaceAll('e', math.e.toString())
        .replaceAll('²', '^2');

    // Handle scientific functions
    expr = _replaceFunctions(expr);

    return _evaluate(expr);
  }

  String _replaceFunctions(String expr) {
    final funcs = {
      'sin': (double x) => math.sin(angleMode == AngleMode.degrees ? toRad(x) : x),
      'cos': (double x) => math.cos(angleMode == AngleMode.degrees ? toRad(x) : x),
      'tan': (double x) => math.tan(angleMode == AngleMode.degrees ? toRad(x) : x),
      'ln': (double x) => math.log(x),
      'log': (double x) => math.log(x) / math.ln10,
      '√': (double x) => math.sqrt(x),
    };

    String result = expr;
    for (final entry in funcs.entries) {
      final pattern = RegExp('${entry.key}\\(([^)]+)\\)');
      result = result.replaceAllMapped(pattern, (m) {
        final inner = double.tryParse(m.group(1) ?? '0') ?? 0;
        return entry.value(inner).toString();
      });
    }
    return result;
  }

  double _evaluate(String expr) {
    try {
      // Simple recursive descent parser
      final tokens = _tokenize(expr);
      final result = _parseExpression(tokens, 0);
      return result.value;
    } catch (_) {
      throw Exception('Invalid expression');
    }
  }

  List<String> _tokenize(String expr) {
    final tokens = <String>[];
    String current = '';
    for (int i = 0; i < expr.length; i++) {
      final c = expr[i];
      if ('+-*/^()'.contains(c)) {
        if (current.isNotEmpty) { tokens.add(current); current = ''; }
        // Handle negative numbers
        if (c == '-' && (tokens.isEmpty || '+-*/^('.contains(tokens.last))) {
          current = '-';
        } else {
          tokens.add(c);
        }
      } else if (c == ' ') {
        if (current.isNotEmpty) { tokens.add(current); current = ''; }
      } else {
        current += c;
      }
    }
    if (current.isNotEmpty) tokens.add(current);
    return tokens;
  }

  ({double value, int pos}) _parseExpression(List<String> tokens, int pos) {
    var left = _parseTerm(tokens, pos);
    int p = left.pos;
    while (p < tokens.length && (tokens[p] == '+' || tokens[p] == '-')) {
      final op = tokens[p];
      final right = _parseTerm(tokens, p + 1);
      left = (value: op == '+' ? left.value + right.value : left.value - right.value, pos: right.pos);
      p = left.pos;
    }
    return left;
  }

  ({double value, int pos}) _parseTerm(List<String> tokens, int pos) {
    var left = _parsePower(tokens, pos);
    int p = left.pos;
    while (p < tokens.length && (tokens[p] == '*' || tokens[p] == '/')) {
      final op = tokens[p];
      final right = _parsePower(tokens, p + 1);
      left = (value: op == '*' ? left.value * right.value : left.value / right.value, pos: right.pos);
      p = left.pos;
    }
    return left;
  }

  ({double value, int pos}) _parsePower(List<String> tokens, int pos) {
    var base = _parseFactor(tokens, pos);
    if (base.pos < tokens.length && tokens[base.pos] == '^') {
      final exp = _parseFactor(tokens, base.pos + 1);
      return (value: math.pow(base.value, exp.value).toDouble(), pos: exp.pos);
    }
    return base;
  }

  ({double value, int pos}) _parseFactor(List<String> tokens, int pos) {
    if (pos >= tokens.length) return (value: 0, pos: pos);
    if (tokens[pos] == '(') {
      final inner = _parseExpression(tokens, pos + 1);
      final closePos = inner.pos < tokens.length && tokens[inner.pos] == ')' ? inner.pos + 1 : inner.pos;
      return (value: inner.value, pos: closePos);
    }
    final val = double.tryParse(tokens[pos]) ?? 0;
    return (value: val, pos: pos + 1);
  }
}