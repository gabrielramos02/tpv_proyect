import 'package:function_tree/function_tree.dart';

String calculate(String expression) {
  try {
    final result = expression.interpret().toDouble();
    return result.toString();
  } catch (e) {
    return double.nan.toString();
  }
}
