import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/landing/signup_landing_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/mail_code/signup_mail_code_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/password/signup_password_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/policies/privacy_policy_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/policies/terms_and_conditions_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:logger/logger.dart';

class SignupPasswordCubit extends Cubit<SignupPasswordState> {
  final Logger logger = getLogger('SignupPasswordCubit');
  final AuthRepository authRepository;

  UserRole role;
  int availableIndex=1;

  SignupPasswordCubit(this.authRepository, {required this.role}) : super(SignupPasswordInitial()) {
    logger.i('Sign up Password Page');
  }

  void navigateToMailCodePage(BuildContext context,
      {required String email}) {
    NavigatorManager.navigateTo(
      context,
      SignupMailCodePage.routeName,
      transition: TransitionType.material,
      routeSettings: RouteSettings(
        arguments: {'email': email},
      ),
      params: {'role': role.mappedValue.toString()},
    );
  }

  void navigateToTermsAndConditionsLayout(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      TermsAndConditionsPage.routeName,
      transition: TransitionType.material,
    );
  }

  void navigateToPrivacyPolicyLayout(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      PrivacyPolicyPage.routeName,
      transition: TransitionType.material,
    );
  }

  void createCognitoAccount(String email, String pass, BuildContext context,
      {String? invitationId}) async {
    emit(LoadingPasswordState());
    try {
      var isRegisterSuccessful = await authRepository.register(
        email,
        pass,
        invitationId: invitationId,
        role: role,
      );
      if (isRegisterSuccessful) {
        navigateToMailCodePage(context, email: email);
      } else {
        emit(SignUpPasswordErrorState(
            AppLocalizations.of(context)!.somethingWentWrong));
      }
    } on CognitoClientException catch (e) {
      logger.e('Sign up Password Page CognitoClientException $e');
      emit(SignUpPasswordErrorState(e.message!));
    } catch (e) {
      logger.e('Sign up Password Page $e');
      emit(SignUpPasswordErrorState(e.toString()));
      rethrow;
    }
  }

  void stateNotRestored(BuildContext context) {
    logger.e('Sign up Password Page state not restored');
    NavigatorManager.navigateTo(
      context,
      SignupLandingPage.routeName,
      replace: true,
      transition: TransitionType.material,
    );
    emit(SignUpPasswordErrorState(
      AppLocalizations.of(context)!.somethingWentWrong,
    ));
  }

  Future<bool> isUserConfirmed() async {
    return await authRepository.isUserConfirmed();
  }
}
