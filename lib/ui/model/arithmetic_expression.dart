import 'dart:math';

import 'package:petitparser/petitparser.dart';

enum ExpressionStatus { Valid, Invalid, DivisionByZero, Negative }

class ArithmeticExpression {
  final String expression;
  final bool isValid;

  static ArithmeticExpression empty =
      ArithmeticExpression(expression: '', isValid: true);

  ArithmeticExpression({required this.expression, required this.isValid});

  factory ArithmeticExpression.fromExpression(String expression) {
    var isValid = checkExpression(expression) == ExpressionStatus.Valid;
    return ArithmeticExpression(expression: expression, isValid: isValid);
  }

  factory ArithmeticExpression.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ArithmeticExpression(expression: '', isValid: true);
    } else {
      return ArithmeticExpression(
          expression: json['expression'] ?? '',
          isValid: json['isValid'] ?? true);
    }
  }

  static ExpressionStatus checkExpression(String expression) {
    // todo refactor! boilerplate and code duplication
    var builder = ExpressionBuilder();
    builder.group()
      ..primitive(digit()
          .plus()
          .seq(char('.').seq(digit().plus()).optional())
          .flatten()
          .trim()
          .map((a) => num.tryParse(a)))
      ..wrapper(
          char('(').trim(), char(')').trim(), (String l, num a, String r) => a);

    builder.group().prefix(char('-').trim(), (String op, num a) => -a);

// power is right-associative
    builder
        .group()
        .right(char('^').trim(), (num a, String op, num b) => pow(a, b));

// multiplication and addition are left-associative
    builder.group()
      ..left(char('*').trim(), (num a, String op, num b) => a * b)
      ..left(char('/').trim(), (num a, String op, num b) => a / b);
    builder.group()
      ..left(char('+').trim(), (num a, String op, num b) => a + b)
      ..left(char('-').trim(), (num a, String op, num b) => a - b);

    var parser = builder.build().end();
    if(expression == '') {
      return ExpressionStatus.Valid;
    } else {
      try {
      var result = parser.parse(expression);
      if (result.value == double.infinity ||
          result.value == double.nan ||
          result.value == double.negativeInfinity) {
        return ExpressionStatus.DivisionByZero;
      } else if (result.value < 0) {
        return ExpressionStatus.Negative;
      } else {
        return ExpressionStatus.Valid;
      }
    } catch (e) {
      return ExpressionStatus.Invalid;
    }
    }
  }
}
