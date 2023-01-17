import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_details/profile_details_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class ProfileOverviewCubit extends Cubit<ProfileOverviewState> {
  late final AuthRepository authRepository;
  final Logger logger = getLogger('ProfileOverview Cubit');
  final String generalErrorMessage = 'Sorry, something went wrong';
  final UserRepository userRepository;
  final String changePasswordErrorMessage =
      'Password does not match with the current password. Please re-enter the password';

  ProfileOverviewCubit(this.authRepository, this.userRepository)
      : super(ProfileOverviewInitial()) {
    logger.i('Profile overview page');
    getOverviewDataFromBackend();
  }

  Future<void> getOverviewDataFromBackend() async {
    emit(ProfileOverviewLoading());
    try {
      var model = await userRepository.getProfileOverview();
      logger.i('ProfileOverview Data: $model');
      emit(ProfileOverviewLoaded(model));
    } on DioError catch (e) {
      logger.e('Dio Error $e');
      emit(ProfileOverviewError(generalErrorMessage));
    } catch (e) {
      emit(ProfileOverviewError(e.toString()));
      rethrow;
    }
  }

  Future<void> changePassword(
      String oldUserPassword, String newUserPassword) async {
    if (state is ProfileOverviewLoaded) {
      var model = (state as ProfileOverviewLoaded).model;
      emit(ProfileOverviewLoaded(model, isPasswordLoading: true));
      try {
        var isChanged = await authRepository.changePassword(
          oldUserPassword,
          newUserPassword,
        );

        if (isChanged) {
          var model = await userRepository.getProfileOverview();
          logger.i('ProfileOverview Data: $model');
          emit(PasswordChangedSuccessfully());
        } else {
          emit(ProfileOverviewError(generalErrorMessage));
        }
      } on CognitoClientException catch (e) {
        if (e.message == 'Incorrect username or password.') {
          emit(ProfileOverviewError(changePasswordErrorMessage));
        } else {
          emit(ProfileOverviewError(e.message!));
        }
      } catch (e) {
        emit(ProfileOverviewError(e.toString()));
        rethrow;
      } finally {
        emit(ProfileOverviewLoaded(model));
      }
    }
  }

  void navigateToProfileDetailsPage(BuildContext context) {
    NavigatorManager.navigateTo(context, ProfileDetailsPage.routeName);
  }

  void navigateToSignIn(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      SigninPage.routeName,
      clearStack: true,
    );
  }

  Future<bool?> deleteUser() async {
    var model;
    try {
      if (state is ProfileOverviewLoaded) {
        model = (state as ProfileOverviewLoaded).model;
      }
      await userRepository.deleteUser();
      return true;
    } catch (e) {
      emit(ProfileOverviewError(e.toString()));
      emit(ProfileOverviewLoaded(model));
      rethrow;
    }
  }
}
