import 'package:burgundy_budgeting_app/domain/model/request/post_add_goal_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_goals_service.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:logger/logger.dart';

class ApiGoalsServiceImp extends ApiGoalsService {
  final String postGoals = '/goals';
  final String getGoalsEndpoint = '/goals';
  final String getGoalsActiveEndpoint = '/goals/active';
  final String getGoalsArchivedEndpoint = '/goals/archived';
  final String updateGoalEndpoint = '/goals';
  final String deleteGoalsEndpoint = '/goals';
  final String canAddGoalGoalsEndpoint = '/goals/can-add-goals';
  final String archiveGoalEndpoint = '/goals/archive';
  final String unarchiveGoalsEndpoint = '/goals/unarchive';

  final Logger logger = getLogger('ApiGoalsServiceImp');

  final HttpManager httpManager;

  ApiGoalsServiceImp(this.httpManager) : super(httpManager);

  @override
  Future<Response> getGoals() async {
    return await httpManager.dio.get(getGoalsEndpoint);
  }

  @override
  Future<Response> getActiveGoals() async {
    return await httpManager.dio.get(getGoalsActiveEndpoint);
  }

  @override
  Future<Response> getArchivedGoals() async {
    return await httpManager.dio.get(getGoalsArchivedEndpoint);
  }

  @override
  Future<Response> archiveGoal(String id) async {
    return await httpManager.dio.post(archiveGoalEndpoint, data: {
      'id': id,
    });
  }

  @override
  Future<Response> canAddGoal() async {
    return await httpManager.dio.get(canAddGoalGoalsEndpoint);
  }

  @override
  Future<Response> deleteGoal(String id) async {
    return await httpManager.dio.delete(deleteGoalsEndpoint, data: {
      'id': id,
    });
  }

  @override
  Future<Response> unarchiveGoal(String id) async {
    return await httpManager.dio.post(unarchiveGoalsEndpoint, data: {
      'id': id,
    });
  }

  @override
  Future<Response> addGoal(PostAddGoalRequest request) async {
    var response =
        await httpManager.dio.post(postGoals, data: request.toJson());

    return response;
  }

  @override
  Future<Response> updateGoal(PostAddGoalRequest request) async {
   var response =
        await httpManager.dio.put(updateGoalEndpoint, data: request.toJson());
    return response;
  }
}
