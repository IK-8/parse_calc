part of '../parse_calc.dart';

class ParsingCalculator {
  final String function;
  final List<OperationType> priority;
  const ParsingCalculator(this.function, {this.priority = basePriority});

  double calculate(Map<String, double> params) {
    final parsedParts = parse(params);
    return calculateOperations(parsedParts)!.value!;
  }

  List<MathOperation> parse(Map<String, double> params) {
    List<MathOperation> parsedParts = [];
    String doubleS = '';
    MathOperation? last;
    add(MathOperation operation) {
      if (operation.type == OperationType.sub && isPreviewUnaryMinus(last)) {
        doubleS = '-';
      } else {
        parsedParts.add(operation);
      }
      last = operation;
    }

    for (var char in function.characters) {
      if (char.isDoublePart) {
        doubleS += char;
      } else {
        if (doubleS.isNotEmpty && !doubleS.isMinus) {
          add(MathOperation(OperationType.variable,
              value: double.parse(doubleS)));
          doubleS = '';
        }
        if (char.isUnitOperation) {
          add(MathOperation(operationMap[char]!));
        } else if (char.isVariable) {
          add(MathOperation(OperationType.variable,
              value: params[char]! * (doubleS.isMinus ? -1 : 1)));
          doubleS = '';
        }
      }
    }
    if (doubleS.isNotEmpty) {
      add(MathOperation(OperationType.variable, value: double.parse(doubleS)));
      doubleS = '';
    }
    return parsedParts;
  }

  MathOperation? calculateOperations(List<MathOperation> operation) {
    if (operation.isEmpty) {
      return null;
    }
    if (operation.isBaseOperation) {
      return MathOperation(OperationType.variable,
          value: calculatePair(operation));
    }
    List<MathOperation> withoutInternalGroups = [];
    //  Разбивает внутренние группы
    for (int i = 0; i < operation.length; i++) {
      var itemOperation = operation[i];
      if (itemOperation.type == OperationType.lpar) {
        List<MathOperation> includeGroup = [];

        while (i < operation.length - 1) {
          i++;
          itemOperation = operation[i];
          if (itemOperation.type == OperationType.rpar) {
            var calcInclude = calculateOperations(includeGroup);
            if (calcInclude != null) {
              withoutInternalGroups.add(calcInclude);
            }
            break;
          } else {
            includeGroup.add(itemOperation);
          }
        }
      } else {
        withoutInternalGroups.add(itemOperation);
      }
    }
    return calcProrityOperation(withoutInternalGroups);
  }

  MathOperation? calcProrityOperation(List<MathOperation> operation) {
    if (operation.isEmpty) {
      return null;
    } else if (operation.isBaseOperation) {
      return MathOperation(OperationType.variable,
          value: calculatePair(operation));
    }
    List<MathOperation> calcListOperation = [...operation];
    for (var currentOperator in priority) {
      List<MathOperation> currentOperation = [...calcListOperation];
      for (var i = 1; i < currentOperation.length; i += 2) {
        var operator = currentOperation[i];
        if (operator.type == currentOperator) {
          var sum = calcProrityOperation(
              [calcListOperation[i - 1], operator, calcListOperation[i + 1]])!;
          currentOperation.removeRange(i - 1, i + 1);
          currentOperation[i - 1] = sum;
          i -= 2;
        }
      }
      calcListOperation = currentOperation;
    }
    return calcListOperation.first;
  }

  double calculatePair(List<MathOperation> operation) {
    return _operationsAction[operation[1].type]!(
        operation[0].value!, operation[2].value!);
  }
}

final Map<OperationType, double Function(double param1, double param2)>
    _operationsAction = {
  OperationType.add: (param1, param2) {
    return param1 + param2;
  },
  OperationType.sub: (param1, param2) {
    return param1 - param2;
  },
  OperationType.mul: (param1, param2) {
    return param1 * param2;
  },
  OperationType.div: (param1, param2) {
    return param1 / param2;
  },
};
