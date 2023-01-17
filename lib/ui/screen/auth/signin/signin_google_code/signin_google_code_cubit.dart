import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_google_code/signin_google_code_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SigninGoogleCodeCubit extends Cubit<SigninGoogleCodeState> {
  final Logger logger = getLogger('SigninCubit');

  final String code;

  AuthRepository authRepository;

  SigninGoogleCodeCubit(BuildContext context, this.authRepository, this.code)
      : super(SigninGoogleCodeInitial()) {
    signInWithGoogle(context, code);
  }

  Future<void> signInWithGoogle(BuildContext context, String code) async {
    try {
      await authRepository.signInWithGoogle(code);
      NavigatorManager.navigateTo(context, BudgetPersonalPage.routeName);
    } on CognitoClientException catch (e) {
      emit(ErrorState(e.message!));
    } catch (e) {
      emit(ErrorState(e.toString()));
      rethrow;
    }
  }
}
