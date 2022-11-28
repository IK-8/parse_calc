import 'package:parse_calc/parse_calc.dart';
import 'package:test/test.dart';

void main() {
  test('(x*3-5)/5; x=10', () {
    expect(ParsingCalculator('(x*3-5)/5').calculate({'x': 10}), 5);
  });
  test('x*5+4/2-1; x=10', () {
    expect(ParsingCalculator('x*5+4/2-1').calculate({'x': 10}), 51);
  });
  test('3*x+15/(3+2); x=10', () {
    expect(ParsingCalculator('3*x+15/(3+2)').calculate({'x': 10}), 33);
  });
  test('3.0*x+15.0/(3.0+2.0); x=10', () {
    expect(ParsingCalculator('3.0*x+15.0/(3.0+2.0)').calculate({'x': 10}), 33);
  });
}
