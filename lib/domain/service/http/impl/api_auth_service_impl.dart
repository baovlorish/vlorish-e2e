import 'package:burgundy_budgeting_app/domain/model/request/create_user_at_backend_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/is_registered_user_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_auth_service.dart';
import 'package:dio/dio.dart';

class ApiAuthServiceImpl extends ApiAuthService {
  final String createUserAtBackendEndpoint = '/user';
  final String isRegisteredEndpoint = '/user/check-email';
  final String deleteAccountEndpoint = '/user/delete-account';
  final String checkInvitationEndpoint = '/invitation/get-to-register';

  final HttpManager httpManager;

  ApiAuthServiceImpl(this.httpManager) : super(httpManager);

  @override
  Future<Response> createUserAtBackend(CreateUserAtBackendRequest query) async {
    var response = await httpManager.dio.post(
      createUserAtBackendEndpoint,
      data: query.toJson(),
    );
    return response;
  }

  @override
  Future<Response> isRegistered(IsRegisteredUserRequest request) async {
    var response = await httpManager.dio.post(
      isRegisteredEndpoint,
      data: request.toJson(),
    );
    return response;
  }

  @override
  Future<Response> deleteUser() async {
    var response = await httpManager.dio.post(deleteAccountEndpoint);
    return response;
  }

  @override
  Future<Response> checkInvitationId(String invitationId) async{
    var response = await httpManager.dio.post(checkInvitationEndpoint,
      data: {'invitationId': invitationId}
    );
    return response;
  }
}
