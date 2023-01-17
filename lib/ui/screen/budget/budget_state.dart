import 'package:burgundy_budgeting_app/ui/model/budget/annual_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/monthly_budget_model.dart';
import 'package:equatable/equatable.dart';

abstract class BudgetState extends Equatable {}

abstract class BudgetLoadedState extends BudgetState {
  abstract final BaseBudgetModel model;
}

class BudgetInitialState extends BudgetState {
  @override
  List<Object?> get props => [];
}

class BudgetLoadingState extends BudgetState {
  final bool showLoading;

  BudgetLoadingState(this.showLoading);

  @override
  List<Object?> get props => [showLoading];
}

class SaveCategoriesState extends BudgetState {
  final Map<String, dynamic> expandedCategories;

  SaveCategoriesState(this.expandedCategories);

  @override
  List<Object?> get props => [expandedCategories];
}

class BudgetMigratingState extends BudgetState {
  @override
  List<Object?> get props => [];
}

class BudgetAnnualLoadedState extends BudgetLoadedState {
  @override
  final AnnualBudgetModel model;
  final bool showCopyMonthAnimation;

  BudgetAnnualLoadedState(
      {this.showCopyMonthAnimation = false, required this.model});

  @override
  List<Object?> get props => [model, showCopyMonthAnimation];
}

class BudgetMonthlyLoadedState extends BudgetLoadedState {
  @override
  final MonthlyBudgetModel model;

  BudgetMonthlyLoadedState({required this.model});

  @override
  List<Object?> get props => [model];
}

class BudgetErrorState extends BudgetState {
  final String message;

  BudgetErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
