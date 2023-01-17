import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/city_model.dart';
import 'package:burgundy_budgeting_app/ui/model/user_details_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_details/profile_details_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class ProfileDetailsCubit extends Cubit<ProfileDetailsState> {
  final Logger logger = getLogger('Profile Details Cubit');
  final String generalErrorMessage = 'Sorry, something went wrong';
  final String generalSuccessMessage = 'Success!';
  final UserRepository userRepository;

  ProfileDetailsCubit(this.userRepository) : super(ProfileDetailsInitial()) {
    getUserDataFromBackend();
  }

  void navigateBackToProfileOverviewPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      ProfileOverviewPage.routeName,
      replace: true,
    );
  }

  Future<void> saveUserDataToBackend(BuildContext context,
      {required String? firstName,
      required String? lastName,
      required int? gender,
      required String? dateOfBirth,
      required int? relationshipStatus,
      required int? dependents,
      required CityModel? cityModel,
      required String? currency,
      required int? education,
      required int? employmentType,
      required int? profession,
      required int? income,
      String? imageUrl}) async {
    emit(ProfileDetailsLoading());
    try {
      var model = UserDetailsModel(
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        relationshipStatus: relationshipStatus,
        dependents: dependents,
        cityModel: cityModel,
        currency: 'usd',
        education: education,
        employmentType: employmentType,
        profession: profession,
        income: income,
        imageUrl: imageUrl,
      );
      var errorMessage = await userRepository.addUserDetails(model);
      if (errorMessage == '') {
        logger.i('Added Data: $model');
        await BlocProvider.of<HomeScreenCubit>(context).updateUserData();
        emit(ProfileDetailsSuccessState(generalSuccessMessage));
      } else {
        logger.i('Failed to add data: $model');
        emit(ProfileDetailsErrorState(errorMessage));
      }
    } on DioError catch (e) {
      logger.e('Dio Error $e');
      emit(ProfileDetailsErrorState(generalErrorMessage));
    } catch (e) {
      logger.e(e);
      emit(ProfileDetailsErrorState(e.toString()));
      rethrow;
    }
  }

  Future<void> getUserDataFromBackend() async {
    emit(ProfileDetailsLoading());
    try {
      var userDetailsModel = await userRepository.getUserDetails();
      logger.i('User Model Data: $userDetailsModel');
      emit(ProfileDetailsLoadedUserDataState(userDetailsModel));
    } on DioError catch (e) {
      logger.e('Dio Error $e');
      emit(ProfileDetailsErrorState(generalErrorMessage));
    } catch (e) {
      emit(ProfileDetailsErrorState(e.toString()));
      rethrow;
    }
  }

  Future<void> setUserPhoto(XFile? image) async {
    emit(ProfileDetailsLoading());
    try {
      await userRepository.setUserImage(image);
    } on DioError catch (e) {
      logger.e('Dio Error $e');
      emit(ProfileDetailsErrorState(generalErrorMessage));
    } catch (e) {
      emit(ProfileDetailsErrorState(e.toString()));
      rethrow;
    }
  }

  Future<List<CityModel>> searchCity(String value) async {
    try {
      return await userRepository.searchCity(value);
    } catch (e) {
      emit(ProfileDetailsErrorState(e.toString()));
      logger.e(e.toString());
      return [];
    }
  }
}
