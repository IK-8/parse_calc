part of '../parse_calc.dart';

// сложения, вычитания, умножения, деления, должны поддерживаться числовые константы и именованные переменные, а также скобки
enum OperationType { add, sub, mul, div, lpar, rpar, variable }

const Map<String, OperationType> operationMap = {
  '+': OperationType.add,
  '-': OperationType.sub,
  '*': OperationType.mul,
  '/': OperationType.div,
  '(': OperationType.lpar,
  ')': OperationType.rpar
};

class MathOperation {
  final double? value;
  final OperationType type;

  const MathOperation(
    this.type, {
    this.value,
  });

  @override
  String toString() {
    switch (type) {
      case OperationType.add:
        return '+';
      case OperationType.sub:
        return '-';
      case OperationType.mul:
        return '*';
      case OperationType.div:
        return '/';
      case OperationType.lpar:
        return '(';
      case OperationType.rpar:
        return ')';
      case OperationType.variable:
        return '$value';
    }
  }
}

bool isPreviewUnaryMinus(MathOperation? operation) {
  return operation == null || operation.type != OperationType.variable;
}

const Set<String> _operations = {'+', '-', '*', '/'};
const Set<String> _unit = {'(', ')'};
const Set<String> _unitOperations = {..._operations, ..._unit};

const Set<OperationType> _operationsPriority = {
  OperationType.mul,
  OperationType.div
};
