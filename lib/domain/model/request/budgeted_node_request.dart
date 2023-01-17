import 'package:burgundy_budgeting_app/ui/model/budget/annual_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/monthly_budget_model.dart';

class BudgetedNodeRequest {
  final String monthYear;
  final int plannedAmount;
  final String categoryId;
  final String? arithmeticExpression;
  final String? businessId;

  BudgetedNodeRequest({
    required this.monthYear,
    required this.plannedAmount,
    required this.categoryId,
    required this.arithmeticExpression,
    required this.businessId,
  });

  Map<String, dynamic>? toJson() {
    return {
      'monthYear': monthYear,
      'plannedAmount': plannedAmount,
      'categoryId': categoryId,
      'arithmeticExpression': arithmeticExpression ?? '',
      'businessId': businessId,
    };
  }

  factory BudgetedNodeRequest.fromAnnualNode(
      {required BudgetAnnualNode node,
      required String categoryId,
      required String? businessId}) {
    return BudgetedNodeRequest(
      monthYear: node.monthYear.toIso8601String(),
      plannedAmount: node.amount,
      categoryId: categoryId,
      arithmeticExpression: node.expression?.expression,
      businessId: businessId,
    );
  }

  factory BudgetedNodeRequest.fromMonthly(
      {required MonthlyBudgetSubcategory subcategory,
      required DateTime monthYear,
      required String? businessId}) {
    return BudgetedNodeRequest(
      monthYear: monthYear.toIso8601String(),
      plannedAmount: subcategory.planned.amount,
      categoryId: subcategory.id,
      arithmeticExpression: subcategory.planned.expression?.expression,
      businessId: businessId,
    );
  }
}
