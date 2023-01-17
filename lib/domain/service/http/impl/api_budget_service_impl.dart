import 'package:burgundy_budgeting_app/domain/model/request/budget_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/goal_node_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_budget_service.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';

class ApiBudgetServiceImpl extends ApiBudgetService {
  final String budgetPersonalEndpoint = '/budget/get-personal';
  final String budgetBusinessEndpoint = '/budget/get-business';
  final String setBudgetedNodeEndpoint = '/budget/node';
  final String setIncomeBudgetedNodeEndpoint = '/budget/income-node';
  final String setGoalBudgetedNodeEndpoint = '/budget/goal-node';
  final String copyEndpoint = '/budget/copy';
  final String getNotesEndpoint = '/budget/get-notes';
  final String getGoalNotesEndpoint = '/budget/get-goal-notes';
  final String goalNoteEndpoint = '/budget/goal-note';
  final String noteEndpoint = '/budget/note';
  final String goalNoteReplyEndpoint = '/budget/goal-note-reply';
  final String noteReplyEndpoint = '/budget/note-reply';
  final String migrateEndpoint = '/budget/migrate';
  final String budgetAnnualPersonalActualEndpoint =
      '/budget/get-annual-personal-actual';
  final String budgetAnnualPersonalPlannedEndpoint =
      '/budget/get-annual-personal-planned';
  final String budgetAnnualPersonalDifferenceEndpoint =
      '/budget/get-annual-personal-difference';
  final String budgetAnnualBusinessActualEndpoint =
      '/budget/get-annual-business-actual';
  final String budgetAnnualBusinessPlannedEndpoint =
      '/budget/get-annual-business-planned';
  final String budgetAnnualBusinessDifferenceEndpoint =
      '/budget/get-annual-business-difference';
  final String budgetPersonalMonthlyEndpoint = '/budget/get-monthly-personal';
  final String budgetBusinessMonthlyEndpoint = '/budget/get-monthly-business';

  final String businessListEndpoint = '/business/list';
  final String businessGetNameListBySearchEndpoint =
      '/business/get-name-list-by-search';

  final HttpManager httpManager;

  ApiBudgetServiceImpl(this.httpManager) : super(httpManager);

  @override
  Future<Response> getBudget(
      {required BudgetRequest query, required bool isPersonal}) async {
    var response = await httpManager.dio.post(
      isPersonal ? budgetPersonalEndpoint : budgetBusinessEndpoint,
      data: query,
    );
    return response;
  }

  @override
  Future<Response> getAnnualBudget(
      {required int year,
      required bool isPersonal,
      required TableType type,
      String? businessId}) async {
    return await httpManager.dio.post(getBudgetAnnualEndpoint(isPersonal, type),
        data: isPersonal
            ? {
                'year': year,
              }
            : {'year': year, 'businessId': businessId});
  }

  @override
  Future<Response> getMonthlyBudget(
      {required String monthYear,
      required bool isPersonal,
      String? businessId}) async {
    return await httpManager.dio.post(
      isPersonal
          ? budgetPersonalMonthlyEndpoint
          : budgetBusinessMonthlyEndpoint,
      data: isPersonal
          ? {
              'monthYear': monthYear,
            }
          : {'monthYear': monthYear, 'businessId': businessId},
    );
  }

  @override
  Future<Response> setBudgetedNodeValue(query) async {
    return await httpManager.dio.post(
      setBudgetedNodeEndpoint,
      data: query.toJson(),
    );
  }

  @override
  Future<Response> setGoalBudgetedNodeValue(GoalNodeRequest query) async {
    return await httpManager.dio.post(
      setGoalBudgetedNodeEndpoint,
      data: query.toJson(),
    );
  }

  @override
  Future<Response> copyMonth(Map<String, dynamic> query) async {
    return await httpManager.dio.post(
      copyEndpoint,
      data: query,
    );
  }

  @override
  Future<Response> getNotes(Map<String, dynamic> query, bool isGoal) async {
    return await httpManager.dio.post(
      isGoal ? getGoalNotesEndpoint : getNotesEndpoint,
      data: query,
    );
  }

  @override
  Future<Response> addNote(Map<String, dynamic> query, bool isGoal) async {
    return await httpManager.dio.post(
      isGoal ? goalNoteEndpoint : noteEndpoint,
      data: query,
    );
  }

  @override
  Future<Response> deleteNote(Map<String, dynamic> query, bool isGoal) async {
    return await httpManager.dio.delete(
      isGoal ? goalNoteEndpoint : noteEndpoint,
      data: query,
    );
  }

  @override
  Future<Response> editNote(Map<String, dynamic> query, bool isGoal) async {
    return await httpManager.dio.put(
      isGoal ? goalNoteEndpoint : noteEndpoint,
      data: query,
    );
  }

  String getBudgetAnnualEndpoint(bool isPersonal, TableType type) {
    if (isPersonal) {
      if (type == TableType.Budgeted) {
        return budgetAnnualPersonalPlannedEndpoint;
      } else if (type == TableType.Actual) {
        return budgetAnnualPersonalActualEndpoint;
      } else {
        return budgetAnnualPersonalDifferenceEndpoint;
      }
    } else {
      if (type == TableType.Budgeted) {
        return budgetAnnualBusinessPlannedEndpoint;
      } else if (type == TableType.Actual) {
        return budgetAnnualBusinessActualEndpoint;
      } else {
        return budgetAnnualBusinessDifferenceEndpoint;
      }
    }
  }

  @override
  Future<void> migrate() async {
    await httpManager.dio.post(migrateEndpoint);
  }

  @override
  Future<Response> addNoteReply(Map<String, String> query, bool isGoal) async {
    return await httpManager.dio.post(
      isGoal ? goalNoteReplyEndpoint : noteReplyEndpoint,
      data: query,
    );
  }

  @override
  Future<Response> deleteNoteReply(
      Map<String, String> query, bool isGoal) async {
    return await httpManager.dio.delete(
      isGoal ? goalNoteReplyEndpoint : noteReplyEndpoint,
      data: query,
    );
  }

  @override
  Future<Response> editNoteReply(Map<String, String> query, bool isGoal) async {
    return await httpManager.dio.put(
      isGoal ? goalNoteReplyEndpoint : noteReplyEndpoint,
      data: query,
    );
  }

  @override
  Future<Response> getBusinessList() async {
    return await httpManager.dio.get(businessListEndpoint);
  }

  @override
  Future<Response> getBusinessListBySearchName(String name) async {
    return await httpManager.dio.post(businessGetNameListBySearchEndpoint,
        data: {'searchString': name});
  }
}
