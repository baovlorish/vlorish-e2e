import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/landing/pass_recovery_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

import 'email_sent_state.dart';

class RecoveryMailCodeCubit extends Cubit<RecoveryMailCodeState> {
  final Logger logger = getLogger('Recovery Mail Code Cubit');
  final AuthRepository authRepository;

  RecoveryMailCodeCubit(this.authRepository)
      : super(RecoveryMailCodeInitial()) {
    logger.i('Mail Code Page');
  }

  void navigateToSigninPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      SigninPage.routeName,
      transition: TransitionType.material,
    );
  }

  Future<void> setNewPass(
      BuildContext context, String code, String newPass) async {
    emit(RecoveryMailCodeLoading());
    try {
      var passChanged = await authRepository.confirmPassword(code, newPass);
      if (passChanged) {
        navigateToSigninPage(context);
      }
    } on CognitoClientException catch (e) {
      emit(RecoveryMailErrorState(e.message!));
    } catch (e) {
      emit(RecoveryMailErrorState(e.toString()));
      rethrow;
    } finally {
      emit(RecoveryMailCodeInitial());
    }
  }

  void stateNotRestored(BuildContext context) {
    logger.e('Pass recovery Code state not restored');
    NavigatorManager.navigateTo(
      context,
      PassRecoveryPage.routeName,
      replace: true,
      transition: TransitionType.material,
    );
    emit(RecoveryMailErrorState(
      AppLocalizations.of(context)!.somethingWentWrong,
    ));
  }

  Future<void> resendCode({
    required String email,
    required String successMessage,
    required String errorMessage,
  }) async {
    try {
      await authRepository.forgotPassword(email);

      emit(RecoveryMailSuccessState(successMessage));
    } on CognitoClientException catch (e) {
      emit(RecoveryMailErrorState(e.message!));
    } catch (e) {
      emit(RecoveryMailErrorState(e.toString()));
      rethrow;
    } finally {
      emit(RecoveryMailCodeInitial());
    }
  }
}
