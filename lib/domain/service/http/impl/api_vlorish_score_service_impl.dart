import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_vlorish_score_service.dart';
import 'package:dio/src/response.dart';

class ApiVlorishScoreServiceImpl extends ApiVlorishScoreService {
  ApiVlorishScoreServiceImpl(this.httpManager) : super(httpManager);
  final String getLastEndpoint = '/vlorish-score/get-last';
  final String postRefreshEndpoint = '/vlorish-score/refresh';
  final String postTempCreateForAllUsersEndpoint =
      '/vlorish-score/temp-create-for-all-users';
  final String postTempRefreshForAllUsersEndpoint =
      '/vlorish-score/temp-refresh-for-all-users';

  final HttpManager httpManager;

  @override
  Future<Response> getLast() async {
    return await httpManager.dio.get(getLastEndpoint);
  }

  @override
  Future<Response> refresh() async {
    return await httpManager.dio.post(postRefreshEndpoint);
  }
}
