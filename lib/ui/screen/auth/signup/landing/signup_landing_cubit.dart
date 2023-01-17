import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/landing/signup_landing_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/password/signup_password_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

class SignupLandingCubit extends Cubit<SignupLandingState> with HydratedMixin {
  final Logger logger = getLogger('SignupLandingCubit');

  final AuthRepository authRepository;
  final String? invitationId;
  String? emailFromInvitation;
  UserRole? role;

  SignupLandingCubit(
    this.authRepository, {
    this.invitationId,
  }) : super(SignupLandingInitial()) {
    hydrate();
    logger.i('Sign up Landing Page');
    checkInvitationId();
    authRepository.logout();
  }

  Future<void> checkInvitationId() async {
    if (invitationId != null) {
      emit(LoadingLandingState());
      try {
        var result = await authRepository.checkInvitationId(invitationId!);
        logger.i('Invitation info: ${result.email} ${result.role}');
        emailFromInvitation = result.email;
        role = UserRole.fromMapped(result.role);
        emit(SignupLandingStoredState(
            email: emailFromInvitation!,
            invitationId: invitationId,
            role: role!));
      } catch (e) {
        emit(SignupLandingErrorState(e.toString()));
      }
    }
  }

  void navigateToPasswordPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      SignupPasswordPage.routeName,
      transition: TransitionType.material,
      params: {'role': (role ?? UserRole.primary()).mappedValue.toString()},
    );
  }

  void navigateToSigninPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      SigninPage.routeName,
      transition: TransitionType.material,
    );
  }

  // todo: separate to few different methods
  Future<void> checkIfNotExistingUser(
    BuildContext context,
    String email, {
    UserRole? userRole,
  }) async {
    emit(LoadingLandingState());
    try {
      var checkEmailAnswer = await authRepository.isRegistered(email);
      if (!checkEmailAnswer.isRegistered) {
        if(userRole !=null) role = userRole;

        emit(SignupLandingStoredState(
            email: email,
            invitationId: invitationId,
            role: role ?? UserRole.primary()));
        navigateToPasswordPage(context);
      } else {
        emit(SignupLandingErrorState(
            AppLocalizations.of(context)!.existingEmail));
      }
    } on CognitoClientException catch (e) {
      emit(SignupLandingErrorState(e.message!));
      logger.e(e.toString());
    } catch (e) {
      emit(SignupLandingErrorState(e.toString()));
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  SignupLandingState? fromJson(Map<String, dynamic> json) {
    if (json['email'] != null) {
      return SignupLandingStoredState(
          email: json['email'],
          invitationId: json['invitationId'],
          role: json['role'] != null
              ? UserRole.fromMapped(json['role'] as int)
              : UserRole.primary());
    }
  }

  @override
  Map<String, dynamic>? toJson(SignupLandingState state) {
    if (state is SignupLandingStoredState) {
      return state.toJson();
    }
  }
}
