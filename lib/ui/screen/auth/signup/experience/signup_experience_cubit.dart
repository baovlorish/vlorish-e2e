import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/ui/model/add_experience_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/experience/signup_experience_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SignupExperienceCubit extends Cubit<SignupExperienceState> {
  final Logger logger = getLogger('SignupPersonalDataCubit');

  final UserRepository userRepository;
  final String generalErrorMessage = 'Sorry, something went wrong';
  UserRole role;

  SignupExperienceCubit(this.userRepository, {required this.role})
      : super(SignupExperienceInitial()) {
    logger.i('Experience Page');
    load();
  }

  void navigateToNextPage(BuildContext context) {
    if (role.isPartner) {
      NavigatorManager.navigateTo(
        context,
        BudgetPersonalPage.routeName,
        transition: TransitionType.fadeIn,
      );
    } else {
      NavigatorManager.navigateTo(
        context,
        SubscriptionPage.routeName,
        params: {
          'type': 'signup',
          'role': role.mappedValue.toString(),
        },
        transition: TransitionType.material,
      );
    }
  }

  Future<void> load() async {
    try {
      var model = await userRepository.getUserDetails();
      var user = await userRepository.getProfileOverview();
      emit(SignupExperienceLoaded(userDetails: model, user: user));
    } catch (e) {
      emit(SignupExperienceInitial());
      logger.e(e.toString());
      rethrow;
    }
  }

  void submitAndNavigateToNextPage(BuildContext context,
      {required ExperienceModel model}) async {
    emit(LoadingExperienceState());
    try {
      var errorMessage = await userRepository.addExperienceSignUp(model);
      if (errorMessage == '') {
        logger.i('Added Data: $model');
        navigateToNextPage(context);
      } else {
        logger.i('Failed to add data: $model');
        emit(ErrorExperienceState(errorMessage));
      }
    } on DioError catch (e) {
      logger.e('Sign up Experience Page Dio Error $e');
      emit(ErrorExperienceState(generalErrorMessage));
    } catch (e) {
      logger.e('Sign up Experience Page $e');
      emit(ErrorExperienceState(e.toString()));
      rethrow;
    }
  }
}
