import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:flutter/material.dart';

class BudgetLayoutInherited extends InheritedWidget {
  const BudgetLayoutInherited({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  final BudgetLayoutHighlightedCellData? data;

  static BudgetLayoutInherited of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<BudgetLayoutInherited>();
    return result!;
  }

  @override
  bool updateShouldNotify(BudgetLayoutInherited old) =>
      (data == null && old.data != null) || (data != null && old.data == null);
}

class BudgetLayoutHighlightedCellData {
  DateTime monthYear;
  String id;
  TableType selectedType;

  BudgetLayoutHighlightedCellData(
      {required this.monthYear, required this.id, required this.selectedType});
}
