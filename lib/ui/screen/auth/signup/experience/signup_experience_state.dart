import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/model/user_details_model.dart';
import 'package:equatable/equatable.dart';

abstract class SignupExperienceState extends Equatable {
  const SignupExperienceState();
}

class SignupExperienceInitial extends SignupExperienceState {
  SignupExperienceInitial();

  @override
  List<Object> get props => [];
}

class SignupExperienceLoaded extends SignupExperienceState {
  final UserDetailsModel userDetails;
  final ProfileOverviewModel user;

  SignupExperienceLoaded({required this.userDetails, required this.user});

  @override
  List<Object> get props => [userDetails];
}

class LoadingExperienceState extends SignupExperienceState {
  LoadingExperienceState();

  @override
  List<Object> get props => [];
}

class ErrorExperienceState extends SignupExperienceState {

  final String error;
  ErrorExperienceState(this.error);

  @override
  List<Object> get props => [error];
}
