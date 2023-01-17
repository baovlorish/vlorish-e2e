import 'package:burgundy_budgeting_app/ui/model/budget/annual_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/monthly_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';

abstract class BudgetEvent {}

class BudgetAnnualFetchEvent extends BudgetEvent {
  final int year;
  final TableType type;

  final bool withOtherModels;
  final bool showLoading;
  final bool initial;
  final String? businessId;

  BudgetAnnualFetchEvent({
    required this.year,
    required this.type,
    this.withOtherModels = false,
    this.showLoading = true,
    this.initial = false,
    required this.businessId,
  });
}

class BudgetMonthlyFetchEvent extends BudgetEvent {
  final DateTime monthYear;
  final bool showLoading;
  final bool withOtherModels;
  final String? businessId;

  BudgetMonthlyFetchEvent({
    required this.monthYear,
    this.showLoading = false,
    this.withOtherModels = true,
    required this.businessId,
  });
}

class ToggleCategoriesEvent extends BudgetEvent {
  final Map<String, bool> expandedCategories;

  ToggleCategoriesEvent(this.expandedCategories);
}

class EditNoteEvent extends BudgetEvent {
  final MemoNoteModel note;
  final bool isGoal;

  EditNoteEvent({required this.note, required this.isGoal});
}

class UpdateAnnualBudgetEvent extends BudgetEvent {
  final AnnualBudgetModel newModel;
  final BudgetAnnualNode node;
  final BudgetAnnualNode? oldNode;
  final bool locally;
  final BudgetAnnualSubcategory? oldNodeCategory;

  UpdateAnnualBudgetEvent({
    required this.newModel,
    required this.node,
    this.oldNode,
    this.oldNodeCategory,
    this.locally = false,
  });
}

class UpdateMonthlyBudgetEvent extends BudgetEvent {
  final MonthlyBudgetModel newModel;
  final MonthlyBudgetSubcategory subcategory;
  final MonthlyBudgetSubcategory? oldSubcategory;
  final bool locally;

  final TableType tableType;

  UpdateMonthlyBudgetEvent({
    required this.tableType,
    required this.newModel,
    required this.subcategory,
    this.locally = false,
    this.oldSubcategory,
  });
}

class HideCategoryEvent extends BudgetEvent {
  final String id;
  final String? newCategoryId;

  final BudgetSubcategory subcategoryToExclude;

  HideCategoryEvent(
    this.id, {
    this.newCategoryId,
    required this.subcategoryToExclude,
  });
}

class BudgetErrorEvent extends BudgetEvent {
  final String message;

  BudgetErrorEvent(
    this.message,
  );
}

class CopyMonthEvent extends BudgetEvent {
  final DateTime month;
  final String? businessId;

  CopyMonthEvent(this.month, this.businessId);
}

class ChangeBusinessNameEvent extends BudgetEvent {
  final String? businessId;
  final bool isAnnual;
  ChangeBusinessNameEvent(this.businessId, this.isAnnual);
}

class UndoNodeEvent extends BudgetEvent {
  UndoNodeEvent();
}

class RedoNodeEvent extends BudgetEvent {
  RedoNodeEvent();
}
