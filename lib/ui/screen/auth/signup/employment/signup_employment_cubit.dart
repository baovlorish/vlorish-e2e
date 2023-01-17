import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/ui/model/add_employment_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/employment/signup_employment_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/experience/signup_experience_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SignupEmploymentCubit extends Cubit<SignupEmploymentState> {
  final Logger logger = getLogger('SignupEmploymentCubit');
  final UserRepository userRepository;
  final String generalErrorMessage = 'Sorry, something went wrong';
  UserRole role;

  SignupEmploymentCubit(this.userRepository, {required this.role})
      : super(SignupEmploymentInitial()) {
    logger.i('Employment Page');
    load();
  }

  Future<void> load() async {
    try {
      var model = await userRepository.getUserDetails();
      var user = await userRepository.getProfileOverview();
      emit(SignupEmploymentLoaded(userDetails: model, user: user));
    } catch (e) {
      emit(SignupEmploymentInitial());
      logger.e(e.toString());
      rethrow;
    }
  }

  void navigateToExperiencePage(BuildContext context,
      {required EmploymentModel model}) async {
    emit(LoadingEmploymentState());
    try {
      var errorMessage = await userRepository.addEmploymentSignUp(model);
      if (errorMessage == '') {
        logger.i('Added Data: $model');
        NavigatorManager.navigateTo(context, SignupExperiencePage.routeName,
            transition: TransitionType.material,
            params: {'role': role.mappedValue.toString()});
      } else {
        logger.i('Failed to add data: $model');
        emit(ErrorEmploymentState(errorMessage));
      }
    } on DioError catch (e) {
      logger.e('Sign up Employment Page Dio Error $e');
      emit(ErrorEmploymentState(generalErrorMessage));
    } catch (e) {
      logger.e('Sign up Employment Page $e');
      emit(ErrorEmploymentState(e.toString()));
      rethrow;
    }
  }
}
