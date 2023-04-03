import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/code/email_sent_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/landing/pass_recovery_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

class PassRecoveryCubit extends Cubit<PassRecoveryState> with HydratedMixin {
  final AuthRepository authRepository;
  final Logger logger = getLogger('PassRecoveryCubit');
  final String? email;

  PassRecoveryCubit(this.authRepository, {this.email}) : super(PassRecoveryInitial()) {
    logger.i('Pass Recovery page');
    hydrate();
  }

  String get getEmail => email ?? '';

  void navigateToSigninPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      SigninPage.routeName,
      transition: TransitionType.material,
    );
  }

  void navigateToEmailSentLayout(BuildContext context, String emailInput) {
    emit(PassRecoveryStoredState(email: emailInput));
    NavigatorManager.navigateTo(
      context,
      RecoveryMailCodePage.routeName,
      transition: TransitionType.material,
    );
  }

  Future<void> checkIfNotExistingUser(
      String email, BuildContext context) async {
    emit(PassRecoveryLoadingState());
    try {
      var checkEmail = await authRepository.isRegistered(email);
      if (checkEmail.isRegistered) {
        await authRepository.forgotPassword(email);
        navigateToEmailSentLayout(context, email);
      } else {
        emit(PassRecoveryErrorState(
            AppLocalizations.of(context)!.noUserWithSuchEmail));
      }
    } on CognitoClientException catch (e) {
      emit(PassRecoveryErrorState(e.message!));
    } catch (e) {
      emit(PassRecoveryErrorState(e.toString()));
      rethrow;
    }
  }

  @override
  PassRecoveryState? fromJson(Map<String, dynamic> json) {
    if (json['email'] != null) {
      return PassRecoveryStoredState(email: json['email']);
    }
  }

  @override
  Map<String, dynamic>? toJson(PassRecoveryState state) {
    if (state is PassRecoveryStoredState) {
      return state.toJson();
    }
  }
}
