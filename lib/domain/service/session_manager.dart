import 'package:burgundy_budgeting_app/domain/storage/session_storage.dart';
import 'package:dio/dio.dart';

abstract class SessionManager extends Interceptor{

  Future<void> createSession(SessionDetails details);

  bool sessionExists();

  bool isSessionValid();

  Future<String?> get idToken;

  Future<bool> refreshSession();

  void logout();
}
