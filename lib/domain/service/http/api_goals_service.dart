import 'package:burgundy_budgeting_app/domain/model/request/post_add_goal_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';

abstract class ApiGoalsService {
  ApiGoalsService(HttpManager httpManager);

  Future<Response<dynamic>> canAddGoal();

  Future<Response<dynamic>> getGoals();

  Future<Response<dynamic>> getActiveGoals();

  Future<Response<dynamic>> getArchivedGoals();

  Future<Response<dynamic>> archiveGoal(String id);

  Future<Response<dynamic>> unarchiveGoal(String id);

  Future<Response<dynamic>> deleteGoal(String id);

  Future<Response<dynamic>> addGoal(PostAddGoalRequest request);

  Future<Response<dynamic>> updateGoal(PostAddGoalRequest request);

// Future<Response> setGoalImage(PickedFile? image);
}
