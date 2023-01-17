import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/landing/signup_landing_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/mail_code/signup_mail_code_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/personal_data/signup_personal_data_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

class SignupMailCodeCubit extends Cubit<SignupMailCodeState>
    with HydratedMixin {
  final Logger logger = getLogger('SignupPersonalDataCubit');
  final String? email;
  final AuthRepository authRepository;
  final UserRepository userRepository;
  UserRole role;
  var availableIndex = 2;

  SignupMailCodeCubit(this.authRepository, this.userRepository,
      {required this.email, required this.role})
      : super(email != null
            ? SignupMailCodeInitial(email, role)
            : EmptyMailCodeState()) {
    hydrate();
    if (email != null) emit(SignupMailCodeInitial(email!, role));
    logger.i('Mail Code Page');
  }

  void navigateToPersonalDataPage(BuildContext context) {
    NavigatorManager.navigateTo(context, SignupPersonalDataPage.routeName,
        transition: TransitionType.material,
        params: {'role': role.mappedValue.toString()});
  }

  Future<void> resendCode({
    required String successMessage,
    required String errorMessage,
  }) async {
    try {
      var codeResend = await authRepository.reSendCode();
      if (codeResend) {
        emit(SignupMailCodeSuccessState(successMessage));
      }
    } on CognitoClientException catch (e) {
      emit(SignupMailCodeErrorState(e.message!));
    } catch (e) {
      emit(SignupMailCodeErrorState(e.toString()));
      rethrow;
    } finally {
      emit(SignupMailCodeInitial(email!, role));
    }
  }

  void confirmEmail(String code, BuildContext context) async {
    emit(LoadingMailCodeState());

    try {
      await userRepository.confirmUserEmail(email!, code);
      await authRepository.confirmEmail(code);
        NavigatorManager.navigateTo(context, SignupPersonalDataPage.routeName,
            transition: TransitionType.material,
            params: {'role': role.mappedValue.toString()});
    } on CognitoClientException catch (e) {
      emit(SignupMailCodeErrorState(e.message!));
    } catch (e) {
      emit(SignupMailCodeErrorState(e.toString()));
      rethrow;
    } finally {
      emit(SignupMailCodeInitial(email!, role));
    }
  }

  void stateNotRestored(BuildContext context) {
    logger.e('Sign up Mail Code state not restored');
    emit(SignupMailCodeErrorState(
        AppLocalizations.of(context)!.somethingWentWrong,
        callback: () => NavigatorManager.navigateTo(
              context,
              SignupLandingPage.routeName,
              transition: TransitionType.material,
            )));
  }

  @override
  SignupMailCodeState? fromJson(Map<String, dynamic> json) {
    if (json['email'] != null) {
      return SignupMailCodeInitial(
          json['email'], UserRole.fromMapped(json['role']));
    }
  }

  @override
  Map<String, dynamic>? toJson(SignupMailCodeState state) {
    if (state is SignupMailCodeInitial) {
      return state.toJson();
    }
  }
}
