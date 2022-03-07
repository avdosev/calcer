import 'package:expressions/expressions.dart';
import 'dart:math' as math;

class ExpressionResult {
  final num result;

  const ExpressionResult({
    required this.result,
  });
}

class ExpressionContext {
  final bool useRadians;

  const ExpressionContext({
    this.useRadians = false,
  });
}

Future<ExpressionResult> doExpression(
  String expression, [
  ExpressionContext params = const ExpressionContext(),
]) async {
  final useRadians = params.useRadians;
  final expText = expression
      .replaceAll('e+', 'e')
      .replaceAll('e', '*10^')
      .replaceAll('÷', '/')
      .replaceAll('×', '*')
      .replaceAll('%', '/100')
      .replaceAll('sin(', useRadians ? 'sin(' : 'sin(π/180.0 *')
      .replaceAll('cos(', useRadians ? 'cos(' : 'cos(π/180.0 *')
      .replaceAll('tan(', useRadians ? 'tan(' : 'tan(π/180.0 *')
      .replaceAll('sin⁻¹', useRadians ? 'asin' : '180/π*asin')
      .replaceAll('cos⁻¹', useRadians ? 'acos' : '180/π*acos')
      .replaceAll('tan⁻¹', useRadians ? 'atan' : '180/π*atan')
      .replaceAll('π', 'PI')
      .replaceAll('℮', 'E')
      .replaceAllMapped(RegExp(r'(\d+)\!'), (Match m) => "fact(${m.group(1)})")
      .replaceAllMapped(
          RegExp(
              r'(?:\(([^)]+)\)|([0-9A-Za-z]+(?:\.\d+)?))\^(?:\(([^)]+)\)|([0-9A-Za-z]+(?:\.\d+)?))'),
          (Match m) =>
              "pow(${m.group(1) ?? ''}${m.group(2) ?? ''},${m.group(3) ?? ''}${m.group(4) ?? ''})")
      .replaceAll('√(', 'sqrt(');
  print(expText);
  Expression exp = Expression.parse(expText);
  var context = {
    "PI": math.pi,
    "E": math.e,
    "asin": math.asin,
    "acos": math.acos,
    "atan": math.atan,
    "sin": math.sin,
    "cos": math.cos,
    "tan": math.tan,
    "ln": math.log,
    "log": log10,
    "pow": math.pow,
    "sqrt": math.sqrt,
    "fact": factorial,
  };
  const evaluator = ExpressionEvaluator();
  num outcome = evaluator.eval(exp, context);

  return ExpressionResult(result: outcome);
}

double log10(num x) => math.log(x) / math.log(10);

int factorial(int number) {
  if (number < 2) return 1;
  return number * factorial(number - 1);
}
