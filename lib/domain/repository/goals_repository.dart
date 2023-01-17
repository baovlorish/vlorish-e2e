import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/request/post_add_goal_request.dart';
import 'package:burgundy_budgeting_app/domain/model/response/goals_response.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_goals_service.dart';
import 'package:burgundy_budgeting_app/ui/model/goal.dart';

abstract class GoalsRepository {
  Future<bool> canAddGoals();

  Future<List<Goal>> getGoals();

  Future<List<Goal>> getActiveGoals();

  Future<List<Goal>> getArchivedGoals();

  Future<void> archiveGoal(String id);

  Future<void> unarchiveGoal(String id);

  Future<void> deleteGoal(String id);

  Future<void> addGoal(PostAddGoalRequest request);

  Future<void> updateGoal(PostAddGoalRequest request);
}

class GoalsRepositoryImpl implements GoalsRepository {
  final ApiGoalsService _apiGoalsService;
  final String generalErrorMessage = 'Sorry, something went wrong';

  GoalsRepositoryImpl(this._apiGoalsService);

  @override
  Future<List<Goal>> getGoals() async {
    var response = await _apiGoalsService.getGoals();

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var goals = GoalsResponse.fromJson(response.data).goals;
      if (goals == null) {
        return [];
      } else {
        return goals;
      }
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<List<Goal>> getActiveGoals() async {
    var response = await _apiGoalsService.getActiveGoals();

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var goals = GoalsResponse.fromJson(response.data).goals;
      if (goals == null) {
        return [];
      } else {
        return goals;
      }
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<List<Goal>> getArchivedGoals() async {
    var response = await _apiGoalsService.getArchivedGoals();

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var goals = GoalsResponse.fromJson(response.data).goals;
      if (goals == null) {
        return [];
      } else {
        return goals;
      }
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> addGoal(PostAddGoalRequest request) async {
    var response = await _apiGoalsService.addGoal(request);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> updateGoal(PostAddGoalRequest request) async {
    var response = await _apiGoalsService.updateGoal(request);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> archiveGoal(String id) async {
    var response = await _apiGoalsService.archiveGoal(id);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> canAddGoals() async {
    var response = await _apiGoalsService.canAddGoal();
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 403) {
      return false;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> deleteGoal(String id) async {
    var response = await _apiGoalsService.deleteGoal(id);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> unarchiveGoal(String id) async {
    var response = await _apiGoalsService.unarchiveGoal(id);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }
}
