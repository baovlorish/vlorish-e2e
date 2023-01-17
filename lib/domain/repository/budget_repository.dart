import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/request/budget_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/budgeted_node_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/goal_node_request.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_budget_service.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/annual_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/business_account_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/monthly_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';

abstract class BudgetRepository {
  Future<BudgetModel> getBudget(
      {required DateTime startDate,
      required int durationInMonths,
      required bool isPersonal});

  Future<String> setGoalBudgetedNodeValue(
      {required BudgetNode node, required String categoryId});

  Future<bool> copyMonth(
      {required DateTime month, required int usageType, String? businessId});

  Future<MemoNotesPage> fetchNotesForNode(
      {required TableType selectedType,
      bool isGoal = false,
      required DateTime monthYear,
      required String categoryId,
      String? businessId});

  Future<String?> addNote(
      {required TableType selectedType,
      bool isGoal = false,
      required String note,
      required DateTime monthYear,
      required String categoryId,
      String? businessId});

  Future<bool> editNote({
    bool isGoal = false,
    required String note,
    required String id,
  });

  Future<bool> deleteNote({
    bool isGoal = false,
    required String id,
  });

  Future<String?> addNoteReply(
      {bool isGoal = false, required String note, required String noteId});

  Future<bool> editNoteReply({
    bool isGoal = false,
    required String note,
    required String id,
  });

  Future<bool> deleteNoteReply({
    bool isGoal = false,
    required String id,
  });

  Future<AnnualBudgetModel?> getAnnualBudget({
    required int year,
    required bool isPersonal,
    required TableType type,
    String? businessId,
  });

  Future<MonthlyBudgetModel?> getMonthlyBudget(
      {required String monthYear,
      required bool isPersonal,
      String? businessId});

  Future<void> setNewAnnualNodeValue({
    required BudgetAnnualNode node,
    required TableType type,
    required bool isGoal,
    required String categoryId,
    String? businessId,
  });

  Future<void> setNewMonthlyNodeValue(
      {required MonthlyBudgetSubcategory subcategory,
      required TableType type,
      required bool isGoal,
      required DateTime monthYear,
      String? businessId});

  Future<List<BusinessAccountModel>> getBusinessList();

  Future<List<String>> getBusinessListBySearchName(String name);
}

class BudgetRepositoryImpl implements BudgetRepository {
  final ApiBudgetService _apiBudgetService;
  final String generalErrorMessage = 'Sorry, something went wrong';

  BudgetRepositoryImpl(this._apiBudgetService);

  @override
  Future<AnnualBudgetModel?> getAnnualBudget(
      {required int year,
      required bool isPersonal,
      required TableType type,
      String? businessId}) async {
    var response = await _apiBudgetService.getAnnualBudget(
        year: year, isPersonal: isPersonal, type: type, businessId: businessId);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      if (response.statusCode == 204) {
        await _apiBudgetService.migrate();
      } else {
        return AnnualBudgetModel.fromJson(
          response.data,
          isPersonal: isPersonal,
          type: type,
          businessId: businessId,
        );
      }
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<MonthlyBudgetModel?> getMonthlyBudget(
      {required String monthYear,
      required bool isPersonal,
      String? businessId}) async {
    var response = await _apiBudgetService.getMonthlyBudget(
        monthYear: monthYear, isPersonal: isPersonal, businessId: businessId);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      if (response.statusCode == 204) {
        await _apiBudgetService.migrate();
      } else {
        return MonthlyBudgetModel.fromJson(response.data,
            isPersonal: isPersonal, businessId: businessId);
      }
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<BudgetModel> getBudget(
      {required DateTime startDate,
      required int durationInMonths,
      required bool isPersonal}) async {
    var budgetRequest = BudgetRequest(
        startMonthYear: startDate.toIso8601String(),
        durationInMonths: durationInMonths);

    var response = await _apiBudgetService.getBudget(
        query: budgetRequest, isPersonal: isPersonal);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return BudgetModel.fromJson(
        response.data,
        isPersonal: isPersonal,
        period: Period(startDate, durationInMonths),
      );
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<String> setGoalBudgetedNodeValue(
      {required BudgetNode node, required String categoryId}) async {
    var response = await _apiBudgetService.setGoalBudgetedNodeValue(
      GoalNodeRequest.fromNode(node: node, categoryId: categoryId),
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return '';
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> copyMonth(
      {required DateTime month,
      required int usageType,
      String? businessId}) async {
    var response = await _apiBudgetService.copyMonth({
      'monthYear': month.toIso8601String(),
      'usageType': usageType,
      'businessId': businessId
    });
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<MemoNotesPage> fetchNotesForNode(
      {required TableType selectedType,
      bool isGoal = false,
      required DateTime monthYear,
      required String categoryId,
      String? businessId}) async {
    var nodeType = selectedType == TableType.Budgeted
        ? 1
        : selectedType == TableType.Actual
            ? 2
            : 3;
    var idKey = isGoal ? 'goalId' : 'categoryId';

    var response = await _apiBudgetService.getNotes({
      'monthYear': monthYear.toIso8601String(),
      'nodeType': nodeType,
      'businessId': businessId,
      idKey: categoryId
    }, isGoal);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return MemoNotesPage.fromJson(response.data, isGoal, monthYear);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<String?> addNote(
      {required TableType selectedType,
      bool isGoal = false,
      required String note,
      required DateTime monthYear,
      required String categoryId,
      String? businessId}) async {
    var nodeType = selectedType == TableType.Budgeted
        ? 1
        : selectedType == TableType.Actual
            ? 2
            : 3;
    var idKey = isGoal ? 'goalId' : 'nodeCategoryId';
    var response = await _apiBudgetService.addNote({
      'note': note,
      'nodeMonthYear': monthYear.toIso8601String(),
      'nodeType': nodeType,
      'businessId': businessId,
      idKey: categoryId,
    }, isGoal);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300 &&
        response.data['noteId'] != null) {
      return response.data['noteId'];
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> deleteNote({bool isGoal = false, required String id}) async {
    var idKey = isGoal ? 'goalBudgetNoteId' : 'categoryBudgetNoteId';
    var response = await _apiBudgetService.deleteNote({idKey: id}, isGoal);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> editNote(
      {bool isGoal = false, required String note, required String id}) async {
    var idKey = isGoal ? 'goalBudgetNoteId' : 'categoryBudgetNoteId';
    var response =
        await _apiBudgetService.editNote({idKey: id, 'note': note}, isGoal);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> setNewAnnualNodeValue(
      {required BudgetAnnualNode node,
      required TableType type,
      required bool isGoal,
      required String categoryId,
      String? businessId}) async {
    var response = isGoal
        ? await _apiBudgetService.setGoalBudgetedNodeValue(
            GoalNodeRequest.fromAnnualNode(
                node: node, type: type, categoryId: categoryId))
        : await _apiBudgetService.setBudgetedNodeValue(
            BudgetedNodeRequest.fromAnnualNode(
                node: node, categoryId: categoryId, businessId: businessId),
          );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> setNewMonthlyNodeValue(
      {required MonthlyBudgetSubcategory subcategory,
      required TableType type,
      required bool isGoal,
      required DateTime monthYear,
      String? businessId}) async {
    var response = isGoal
        ? await _apiBudgetService.setGoalBudgetedNodeValue(
            GoalNodeRequest.fromMonthly(
                subcategory: subcategory, type: type, monthYear: monthYear))
        : await _apiBudgetService.setBudgetedNodeValue(
            BudgetedNodeRequest.fromMonthly(
              subcategory: subcategory,
              monthYear: monthYear,
              businessId: businessId,
            ),
          );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<String?> addNoteReply(
      {bool isGoal = false,
      required String note,
      required String noteId}) async {
    var idKey = isGoal ? 'goalBudgetNoteId' : 'budgetNoteId';
    var response = await _apiBudgetService.addNoteReply({
      'note': note,
      idKey: noteId,
    }, isGoal);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data['budgetNoteReplyId'] ??
          response.data['goalNoteReplyId'];
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> deleteNoteReply(
      {bool isGoal = false, required String id}) async {
    var idKey = isGoal ? 'goalBudgetNoteReplyId' : 'budgetNoteReplyId';
    var response = await _apiBudgetService.deleteNoteReply({idKey: id}, isGoal);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> editNoteReply(
      {bool isGoal = false, required String note, required String id}) async {
    var idKey = isGoal ? 'goalBudgetNoteReplyId' : 'budgetNoteReplyId';
    var response = await _apiBudgetService
        .editNoteReply({idKey: id, 'note': note}, isGoal);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<List<BusinessAccountModel>> getBusinessList() async {
    var response = await _apiBudgetService.getBusinessList();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      final businesses = response.data['businesses'] as List<dynamic>?;

      var businessesList = <BusinessAccountModel>[];
      if (businesses != null) {
        businesses.forEach((element) {
          businessesList.add(BusinessAccountModel.fromJson(element));
        });
      }
      return businessesList;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<List<String>> getBusinessListBySearchName(String name) async {
    var response = await _apiBudgetService.getBusinessListBySearchName(name);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var businessNames = response.data['businessNames'];

      return businessNames;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }
}
