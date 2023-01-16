part of '../parse_calc.dart';

extension CharEx on String {
  bool get isUnitOperation => _unitOperations.contains(this);

  bool get isDoublePart => _variableChars.contains(this);

  bool get isVariable => !isUnitOperation && !isDoublePart;
}

extension OperatorEx on String {
  bool get isMinus => this == '-';
}

const Set<String> _variableChars = {
  '0',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '.'
};

extension MathOperationEx on List<MathOperation> {
  bool get isBaseOperation => length == 3;
}
