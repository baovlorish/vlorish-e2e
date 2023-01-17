import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthRepository authRepository;
  UserRepository userRepository;
  bool fetchUserData;

  AuthCubit(this.authRepository, this.userRepository,
      {this.fetchUserData = false})
      : super(AuthInitial()) {
    load();
  }

  Future<void> load() async {
    if (authRepository.sessionExists()) {
      if (fetchUserData) {
        var user = await userRepository.getProfileOverview();
        emit(AuthLoadedState(
          sessionExists: true,
          availableStep: user.registrationStep,
        ));
      } else {
        emit(AuthLoadedState(
          sessionExists: true,
          availableStep: null,
        ));
      }
    } else {
      emit(AuthLoadedState(
        sessionExists: false,
        availableStep: null,
      ));
    }
  }
}
