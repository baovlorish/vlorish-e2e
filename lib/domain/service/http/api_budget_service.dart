import 'package:burgundy_budgeting_app/domain/model/request/budget_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/budgeted_node_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/goal_node_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:dio/dio.dart';

abstract class ApiBudgetService {
  ApiBudgetService(HttpManager httpManager);

  Future<Response<dynamic>> getBudget(
      {required BudgetRequest query, required bool isPersonal});

  Future<Response<dynamic>> setBudgetedNodeValue(BudgetedNodeRequest query);

  Future<Response<dynamic>> setGoalBudgetedNodeValue(GoalNodeRequest query);

  Future<Response<dynamic>> copyMonth(Map<String, dynamic> query);

  Future<Response> getNotes(Map<String, dynamic> query, bool isGoal);

  Future<Response> addNote(Map<String, dynamic> query, bool isGoal);

  Future<Response> editNote(Map<String, dynamic> query, bool isGoal);

  Future<Response> deleteNote(Map<String, dynamic> query, bool isGoal);

  Future<Response> getAnnualBudget(
      {required int year,
      required bool isPersonal,
      required TableType type,
      String? businessId});

  Future<Response> getMonthlyBudget(
      {required String monthYear,
      required bool isPersonal,
      String? businessId});

  Future<void> migrate();

  Future<Response> editNoteReply(Map<String, String> query, bool isGoal);

  Future<Response> deleteNoteReply(Map<String, String> query, bool isGoal);

  Future<Response> addNoteReply(Map<String, String> query, bool isGoal);

  Future<Response> getBusinessList();

  Future<Response> getBusinessListBySearchName(String name);
}
