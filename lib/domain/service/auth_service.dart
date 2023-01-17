import 'package:burgundy_budgeting_app/domain/service/session_manager.dart';
import 'package:burgundy_budgeting_app/domain/storage/session_storage.dart';

abstract class AuthService {
  SessionManager get sessionManager;

  AuthService(SessionStorage storage);

  Future<bool> login(String login, String password);

  Future<bool> reSendCode();

  /// registration moved to backend, and this method currently creates instances needed for session creation
  void register(String email, String pass);

  Future<bool> confirmEmail(String code);

  Future<bool> changePassword(String oldUserPassword, String newUserPassword);

  Future<bool> confirmPassword(String code, String newPass);

  Future<bool> isUserConfirmed();

  Future<void> forgotPassword(String email);

  Future<void> signInWithGoogle(String code);

  void openGoogleSignInUrl();
}
