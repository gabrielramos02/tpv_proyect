import 'package:flutter_proyect/domain/calculate_from_expression.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('calculate', () {
    group('operator precedence', () {
      test('multiplication before addition', () {
        expect(calculate('2+3*4'), '14.0');
      });

      test('parentheses override precedence', () {
        expect(calculate('(2+3)*4'), '20.0');
      });

      test('complex precedence', () {
        expect(calculate('10-2*3+1'), '5.0');
      });

      test('nested parentheses', () {
        expect(calculate('((2+3)*4)/2'), '10.0');
      });
    });

    group('decimals', () {
      test('decimal addition', () {
        expect(calculate('1.5+2.5'), '4.0');
      });

      test('decimal multiplication', () {
        expect(calculate('1.5*2'), '3.0');
      });

      test('division produces decimal', () {
        expect(calculate('1/2'), '0.5');
      });

      test('division with non-terminating result', () {
        final result = calculate('10/3');
        expect(result, isNot(equals('NaN')));
        expect(double.tryParse(result), isNotNull);
      });
    });

    group('invalid input', () {
      test('empty string returns NaN', () {
        expect(calculate(''), 'NaN');
      });

      test('non-numeric string returns NaN', () {
        expect(calculate('abc'), 'NaN');
      });

      test('incomplete expression returns NaN', () {
        expect(calculate('2+'), 'NaN');
      });

      test('only operator returns NaN', () {
        expect(calculate('*'), 'NaN');
      });
    });
  });
}
