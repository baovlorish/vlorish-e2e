import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/domain/model/request/create_user_at_backend_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/is_registered_user_request.dart';
import 'package:burgundy_budgeting_app/domain/model/response/check_email.dart';
import 'package:burgundy_budgeting_app/domain/model/response/check_invitation_response_model.dart';
import 'package:burgundy_budgeting_app/domain/service/auth_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_auth_service.dart';

abstract class AuthRepository {
  abstract final String generalErrorMessage;

  AuthRepository(AuthService authService, ApiAuthService apiAuthService);

  Future<bool> login(String login, String password);

  Future<bool> register(String email, String pass,
      {String? invitationId, UserRole? role});

  Future<bool> confirmEmail(String code);

  Future<CheckEmailResponse> isRegistered(String email);

  Future<void> forgotPassword(String email);

  Future<bool> confirmPassword(String code, String newPass);

  Future<bool> changePassword(String oldUserPassword, String newUserPassword);

  Future<void> signInWithGoogle(String code);

  void openGoogleSignInUrl();

  bool sessionExists();

  Future<bool> isUserConfirmed();

  void logout();

  Future<bool> reSendCode();

  Future<CheckInvitationResponseModel> checkInvitationId(String invitationId);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  final ApiAuthService apiAuthService;

  AuthRepositoryImpl(this.authService, this.apiAuthService);

  @override
  Future<bool> changePassword(
      String oldUserPassword, String newUserPassword) async {
    return await authService.changePassword(
      oldUserPassword,
      newUserPassword,
    );
  }

  @override
  Future<bool> confirmEmail(String code) async {
    var isSuccessful = await authService.confirmEmail(code);
    return isSuccessful;
  }

  @override
  Future<bool> confirmPassword(String code, String newPass) async {
    return await authService.confirmPassword(code, newPass);
  }

  @override
  Future<CheckEmailResponse> isRegistered(String email) async {
    var response = await apiAuthService
        .isRegistered(IsRegisteredUserRequest(email.toLowerCase()));
    return CheckEmailResponse.fromJson(response.data);
  }

  @override
  Future<void> forgotPassword(String email) async {
    return await authService.forgotPassword(email.toLowerCase());
  }

  @override
  Future<bool> login(String login, String password) async {
    return await authService.login(login.toLowerCase(), password);
  }

  @override
  Future<bool> register(String email, String pass,
      {String? invitationId, UserRole? role}) async {
    var response = await apiAuthService.createUserAtBackend(
        CreateUserAtBackendRequest(email.toLowerCase(), pass,
            invitationId: invitationId, role: role));
    if (response.statusCode == 200) {
      authService.register(email.toLowerCase(), pass);
      return true;
    } else {
      return false;
    }
  }

  @override
  void openGoogleSignInUrl() {
    return authService.openGoogleSignInUrl();
  }

  @override
  Future<void> signInWithGoogle(String code) async {
    await authService.signInWithGoogle(code);
  }

  @override
  bool sessionExists() {
    return authService.sessionManager.sessionExists();
  }

  @override
  void logout() {
    authService.sessionManager.logout();
  }

  @override
  final String generalErrorMessage = 'Oops! Something went wrong!';

  @override
  Future<bool> reSendCode() async {
    return await authService.reSendCode();
  }

  @override
  Future<bool> isUserConfirmed() async {
    return await authService.isUserConfirmed();
  }

  @override
  Future<CheckInvitationResponseModel> checkInvitationId(String invitationId) async {
   var response = await apiAuthService.checkInvitationId(invitationId);
   if(response.statusCode != null &&
       response.statusCode! >= 200 &&
       response.statusCode! < 300){
     return CheckInvitationResponseModel.fromJson(response.data);
   }else {
     throw CustomException(response.data['message'] ?? generalErrorMessage);
   }
  }
}
