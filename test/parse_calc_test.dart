import 'package:parse_calc/parse_calc.dart';
import 'package:test/test.dart';

void main() {
  test('(x*3-5)/5; x=10\nresult:5', () {
    expect(ParsingCalculator('(x*3-5)/5').calculate({'x': 10}), 5);
  });
  test('x*5+4/2-1; x=10\nresult:51', () {
    expect(ParsingCalculator('x*5+4/2-1').calculate({'x': 10}), 51);
  });
  test('3*x+15/(3+2); x=10\nresult:33', () {
    expect(ParsingCalculator('3*x+15/(3+2)').calculate({'x': 10}), 33);
  });

  //3*10+15/(3+2)
  //3*25/5
  //75/5
  //15
  test('3*x+15/(3+2); x=10; priority = [+, -, *, /]\nresult:15', () {
    expect(
        ParsingCalculator('3*x+15/(3+2)', priority: [
          OperationType.add,
          OperationType.sub,
          OperationType.mul,
          OperationType.div,
        ]).calculate({'x': 10}),
        15);
  });
  test('3.0*x+15.0/(3.0+2.0); x=10\nresult:33', () {
    expect(ParsingCalculator('3.0*x+15.0/(3.0+2.0)').calculate({'x': 10}), 33);
  });
}
