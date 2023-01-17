import 'package:burgundy_budgeting_app/ui/model/budget/annual_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/monthly_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';

class GoalNodeRequest {
  final String monthYear;
  final int? plannedAmount;
  final String categoryId;
  final int? budgetedFunds;
  final String? arithmeticExpressionForBudgeted;
  final String? arithmeticExpressionForActual;

  GoalNodeRequest({
    required this.monthYear,
    required this.plannedAmount,
    required this.categoryId,
    required this.budgetedFunds,
    required this.arithmeticExpressionForBudgeted,
    required this.arithmeticExpressionForActual,
  });

  factory GoalNodeRequest.fromNode(
      {required BudgetNode node, required String categoryId}) {
    return GoalNodeRequest(
      monthYear: node.date.toIso8601String(),
      plannedAmount: node.actualFunds,
      categoryId: categoryId,
      budgetedFunds: node.budgetedFunds,
      arithmeticExpressionForBudgeted:
          node.arithmeticExpressionForBudgeted.expression,
      arithmeticExpressionForActual:
          node.arithmeticExpressionForActual.expression,
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      'monthYear': monthYear,
      'investedAmount': plannedAmount,
      'goalId': categoryId,
      'plannedAmount': budgetedFunds,
      'arithmeticExpressionForInvested': arithmeticExpressionForActual ?? '',
      'arithmeticExpressionForPlanned': arithmeticExpressionForBudgeted ?? '',
    };
  }

  factory GoalNodeRequest.fromAnnualNode(
      {required BudgetAnnualNode node,
      required TableType type,
      required String categoryId}) {
    return GoalNodeRequest(
      monthYear: node.monthYear.toIso8601String(),
      plannedAmount: type == TableType.Actual ? node.amount : null,
      categoryId: categoryId,
      budgetedFunds: type == TableType.Budgeted ? node.amount : null,
      arithmeticExpressionForBudgeted:
          type == TableType.Budgeted ? node.expression?.expression : null,
      arithmeticExpressionForActual:
          type == TableType.Actual ? node.expression?.expression : null,
    );
  }

  factory GoalNodeRequest.fromMonthly(
      {required MonthlyBudgetSubcategory subcategory,
      required TableType type,
      required DateTime monthYear}) {
    return GoalNodeRequest(
      monthYear: monthYear.toIso8601String(),
      plannedAmount:
          type == TableType.Actual ? subcategory.actual.amount : null,
      categoryId: subcategory.id,
      budgetedFunds:
          type == TableType.Budgeted ? subcategory.planned.amount : null,
      arithmeticExpressionForBudgeted: type == TableType.Budgeted
          ? subcategory.actual.expression?.expression
          : null,
      arithmeticExpressionForActual: type == TableType.Actual
          ? subcategory.actual.expression?.expression
          : null,
    );
  }
}
