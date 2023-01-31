import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/landing/signup_landing_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/mail_code/signup_mail_code_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/landing/pass_recovery_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

import '../../../../domain/repository/user_repository.dart';

class SigninCubit extends Cubit<SigninState> {
  final Logger logger = getLogger('SigninCubit');

  AuthRepository authRepository;
  final UserRepository userRepository;

  SigninCubit(this.authRepository, this.userRepository) : super(SigninInitial());

  void login(String login, String password, BuildContext context) async {
    emit(LoadingState());
    userRepository.clearUserData();
    var role = 1;
    try {
      final checkEmail = await authRepository.isRegistered(login);
      role = checkEmail.role;
      if (checkEmail.isRegistered) {
        var isLoginSuccessful = await authRepository.login(login, password);
        if (isLoginSuccessful) {
          NavigatorManager.navigateTo(context, BudgetPersonalPage.routeName);
        }
      } else {
        emit(ErrorState(AppLocalizations.of(context)!.noUserWithSuchEmail));
      }
    } on CognitoClientException catch (e) {
      if (e.code == 'UserNotConfirmedException') {
        emit(ErrorState(e.message ?? authRepository.generalErrorMessage,
            errorDialogCallBack: () {
          reSendCode(context, email: login, role: role, );
        },
            errorDialogButtonText:
                AppLocalizations.of(context)!.completeRegistration));
      }
      emit(ErrorState(e.message ?? authRepository.generalErrorMessage));
    } catch (e) {
      emit(ErrorState(e.toString()));
      rethrow;
    }
  }

  void reSendCode(BuildContext context, {required String email, required int role}) {
    try {
      authRepository.reSendCode();
    } on CognitoClientException catch (e) {
      emit(ErrorState(e.message ?? authRepository.generalErrorMessage));
    } catch (e) {
      emit(ErrorState(e.toString()));
      rethrow;
    }

    NavigatorManager.navigateTo(
      context,
      SignupMailCodePage.routeName,
      routeSettings: RouteSettings(
        arguments: {'email': email},
      ),
      params: {'role': role.toString()},
    );
  }

  void navigateToSignupLandingPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      SignupLandingPage.routeName,
      transition: TransitionType.material,
    );
  }

  void navigateToPassRecoveryPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      PassRecoveryPage.routeName,
      transition: TransitionType.material,
    );
  }

  void signInWithGoogle() {
    authRepository.openGoogleSignInUrl();
  }
}
