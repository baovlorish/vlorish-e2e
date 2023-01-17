import 'package:burgundy_budgeting_app/domain/model/request/create_user_at_backend_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/is_registered_user_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';

abstract class ApiAuthService {
  ApiAuthService(HttpManager httpManager);

  Future<Response> createUserAtBackend(CreateUserAtBackendRequest query);

  Future<Response> isRegistered(IsRegisteredUserRequest query);

  Future<Response> deleteUser();

  Future<Response> checkInvitationId(String invitationId);
}
