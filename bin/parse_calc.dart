import 'package:parse_calc/parse_calc.dart' as parse_calc;

void main(List<String> arguments) {
  print(parse_calc.ParsingCalculator('x*5+4/2-1').calculate({'x': 10}));
  print(parse_calc.ParsingCalculator('(x*3-5)/5').calculate({'x': 10}));
  print(parse_calc.ParsingCalculator('3*x+15/(3+2)').calculate({'x': 10}));
}
