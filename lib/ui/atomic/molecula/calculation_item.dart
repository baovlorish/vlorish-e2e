import 'dart:math' as math;

import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/input_item.dart';
import 'package:burgundy_budgeting_app/ui/model/arithmetic_expression.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/annual_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/monthly_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:burgundy_budgeting_app/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petitparser/petitparser.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalculationItem extends StatefulWidget {
  final GeneralFormulaDataModel model;
  final Function() onValueSubmitted;
  final Function(int? value, String? expression) onValueUpdated;
  final Function() onClose;

  const CalculationItem({
    Key? key,
    required this.onValueSubmitted,
    required this.onValueUpdated,
    required this.onClose,
    required this.model,
  }) : super(key: key);

  @override
  _CalculationItemState createState() => _CalculationItemState();
}

class _CalculationItemState extends State<CalculationItem> {
  late final Parser parser;
  final builder = ExpressionBuilder();
  bool isError = false;
  late final FocusNode focusNode = FocusNode(
    onKey: (FocusNode node, RawKeyEvent evt) {
      if (evt.isKeyPressed(LogicalKeyboardKey.enter) ||
          evt.isKeyPressed(LogicalKeyboardKey.numpadEnter)) {
        resolve();
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    },
  );
  final debouncer = Debouncer(Duration(milliseconds: 400));
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        resolve();
      }
    });
    builder.group()
      ..primitive(digit()
          .plus()
          .seq(char('.').seq(digit().plus()).optional())
          .flatten()
          .trim()
          .map((a) => num.tryParse(a)))
      ..wrapper(
          char('(').trim(), char(')').trim(), (String l, num a, String r) => a);

    builder.group().prefix(char('-').trim(), (String op, num a) => -a);

// power is right-associative
    builder
        .group()
        .right(char('^').trim(), (num a, String op, num b) => math.pow(a, b));

// multiplication and addition are left-associative
    builder.group()
      ..left(char('*').trim(), (num a, String op, num b) => a * b)
      ..left(char('/').trim(), (num a, String op, num b) => a / b);
    builder.group()
      ..left(char('+').trim(), (num a, String op, num b) => a + b)
      ..left(char('-').trim(), (num a, String op, num b) => a - b);

    parser = builder.build().end();
    focusNode.requestFocus();
    if (widget.model.initialExpression?.isValid == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.validate();
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: InputItem(
        style:
            CustomTextStyle.LabelTextStyle(context).copyWith(letterSpacing: 1),
        value: widget.model.initialExpression?.expression,
        prefix: '= ',
        maxLines: 5,
        autofocus: true,
        onChanged: (value) {
          debouncer.run(() {
            _formKey.currentState!.validate();
          });
        },
        validateFunction: (String? value, BuildContext context) {
          if (value != null && value.isNotEmpty) {
            try {
              var result = parser.parse(value);
              if (result.value == double.infinity ||
                  result.value == double.nan ||
                  result.value == double.negativeInfinity) {
                isError = false;
                widget.onValueUpdated(0, value);
                return AppLocalizations.of(context)!.undefinedDivisionByZero;
              } else if (result.value < 0) {
                widget.onValueUpdated(0, value);
                isError = false;
                return AppLocalizations.of(context)!
                    .resultOfExpressionIsANegativeNumber;
              } else {
                isError = false;
                widget.onValueUpdated((result.value as double).round(), value);
                return null;
              }
            } catch (e) {
              isError = false;
              widget.onValueUpdated(0, value);
              return AppLocalizations.of(context)!.enterCorrectExpression;
            }
          } else {
            isError = false;
            widget.onValueUpdated(0, value);
          }
        },
        onEditingComplete: () {
          resolve();
        },
        textInputFormatters: [
          FilteringTextInputFormatter.deny(',', replacementString: '.'),
          LengthLimitingTextInputFormatter(250),
          FilteringTextInputFormatter.allow(RegExp(r'^[\d*+\/()\.-]+')),
        ],
        focusNode: focusNode,
        suffixIconButton: IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.cancel_rounded),
          onPressed: widget.onClose,
        ),
      ),
    );
  }

  void resolve() {
    if (isError) {
      widget.onClose();
    } else {
      widget.onValueSubmitted();
    }
  }
}

class FormulaDataModel {
  final BudgetNode initialNode;
  final TableType selectedType;
  final bool isGoal;
  final BudgetCategory category;
  final BudgetModel budgetModel;

  late BudgetNode currentNode = initialNode;

  FormulaDataModel({
    required this.initialNode,
    required this.selectedType,
    required this.isGoal,
    required this.category,
    required this.budgetModel,
  });
}

abstract class GeneralFormulaDataModel {
  bool get isGoal;

  TableType get tableType;

  ArithmeticExpression? get initialExpression;
}

class AnnualFormulaDataModel extends GeneralFormulaDataModel {
  final BudgetAnnualNode initialNode;
  @override
  final bool isGoal;
  final BudgetAnnualSubcategory category;
  final AnnualBudgetModel budgetModel;

  late BudgetAnnualNode currentNode = initialNode;

  AnnualFormulaDataModel(
      {required this.initialNode,
      required this.isGoal,
      required this.category,
      required this.budgetModel});

  @override
  TableType get tableType => initialNode.tableType;

  @override
  ArithmeticExpression? get initialExpression => initialNode.expression;
}

class MonthlyFormulaDataModel extends GeneralFormulaDataModel {
  final MonthlyNode initialNode;
  @override
  final bool isGoal;
  final MonthlyBudgetSubcategory category;
  @override
  final TableType tableType;
  final MonthlyBudgetModel budgetModel;

  late MonthlyNode currentNode = initialNode;

  MonthlyFormulaDataModel(
      {required this.initialNode,
      required this.isGoal,
      required this.tableType,
      required this.category,
      required this.budgetModel});

  @override
  ArithmeticExpression? get initialExpression => initialNode.expression;
}
