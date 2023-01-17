import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/ui/model/add_personal_data_model.dart';
import 'package:burgundy_budgeting_app/ui/model/city_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/employment/signup_employment_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/personal_data/signup_personal_data_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SignupPersonalDataCubit extends Cubit<SignupPersonalDataState> {
  final Logger logger = getLogger('SignupPersonalDataCubit');
  final UserRepository userRepository;
  final String generalErrorMessage = 'Sorry, something went wrong';
  UserRole role;

  SignupPersonalDataCubit(this.userRepository, {required this.role})
      : super(SignupPersonalDataInitial()) {
    logger.i('Personal Data Page');
    load();
  }

  Future<void> navigateToEmploymentPage(BuildContext context,
      {required PersonalDataModel model}) async {
    try {
      var errorMessage = await userRepository.addPersonalDataSignUp(model);
      if (errorMessage == '') {
        logger.i('Added Data: $model');
        NavigatorManager.navigateTo(context, SignupEmploymentPage.routeName,
            transition: TransitionType.material,
            params: {'role': role.mappedValue.toString()});
      } else {
        logger.i('Failed to add data: $model');
        emit(ErrorPersonalDataState(errorMessage));
      }
    } on DioError catch (e) {
      logger.e('Sign up Personal Data Page Dio Error $e');
      emit(ErrorPersonalDataState(generalErrorMessage));
    } catch (e) {
      logger.e('Sign up Personal Data Page $e');
      emit(ErrorPersonalDataState(e.toString()));
      rethrow;
    }
  }

  Future<List<CityModel>> searchCity(String value) async {
    try {
      return await userRepository.searchCity(value);
    } catch (e) {
      emit(ErrorPersonalDataState(generalErrorMessage));
      logger.e(e.toString());
      return [];
    }
  }

  void addLater(BuildContext context) {
    NavigatorManager.navigateTo(context, SignupEmploymentPage.routeName,
        transition: TransitionType.material,
        params: {'role': role.mappedValue.toString()});
  }

  Future<void> load() async {
    try {
      var model = await userRepository.getUserDetails();
      var user = await userRepository.getProfileOverview();
      emit(SignupPersonalDataLoaded(userDetails: model, user: user));
    } catch (e) {
      emit(SignupPersonalDataInitial());
      logger.e(e.toString());
      rethrow;
    }
  }
}
