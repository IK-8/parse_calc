part of '../parse_calc.dart';

class ParsingCalculator {
  final String function;

  const ParsingCalculator(this.function);

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
        if (doubleS.isNotEmpty && doubleS != '-') {
          add(MathOperation(OperationType.variable,
              value: double.parse(doubleS)));
          doubleS = '';
        }
        if (char.isUnitOperation) {
          add(MathOperation(operationMap[char]!));
        } else if (char.isVariable) {
          add(MathOperation(OperationType.variable,
              value: params[char]! * (doubleS == '-' ? -1 : 1)));
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
    if (operation.length == 3) {
      return calcSequentialOperation(operation);
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
    List<MathOperation> sequential = [];
    //  Приоритетность операций
    for (int i = 0; i < withoutInternalGroups.length; i += 2) {
      if (i + 1 == withoutInternalGroups.length) {
        sequential.add(withoutInternalGroups[i]);
        break;
      }
      var operationType = withoutInternalGroups[i + 1].type;
      if (_operationsPriority.contains(operationType)) {
        var calc = calcSequentialOperation([
          withoutInternalGroups[i],
          withoutInternalGroups[i + 1],
          withoutInternalGroups[i + 2],
        ]);
        if (calc != null) {
          sequential.add(calc);
          if (i + 3 < withoutInternalGroups.length) {
            sequential.add(withoutInternalGroups[i + 3]);
          }
        }
        i += 2;
      } else {
        sequential.add(withoutInternalGroups[i]);
        sequential.add(withoutInternalGroups[i + 1]);
      }
    }
    return calcSequentialOperation(sequential);
  }

  MathOperation? calcSequentialOperation(List<MathOperation> operation) {
    if (operation.isEmpty) {
      return null;
    } else if (operation.length < 3) {
      return operation.first;
    } else if (operation.length == 3) {
      return MathOperation(OperationType.variable, value: sum(operation));
    } else {
      return calcSequentialOperation([
        calcSequentialOperation(operation.take(3).toList())!,
        ...operation.skip(3)
      ]);
    }
  }

  double sum(List<MathOperation> operation) {
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
