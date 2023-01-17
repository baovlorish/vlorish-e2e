import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/model/user_details_model.dart';
import 'package:equatable/equatable.dart';

abstract class SignupPersonalDataState extends Equatable {
  const SignupPersonalDataState();
}

class SignupPersonalDataInitial extends SignupPersonalDataState {
  SignupPersonalDataInitial();

  @override
  List<Object> get props => [];
}

class SignupPersonalDataLoaded extends SignupPersonalDataState {
  final UserDetailsModel userDetails;
  final ProfileOverviewModel user;

  SignupPersonalDataLoaded({required this.userDetails, required this.user});

  @override
  List<Object> get props => [userDetails, user];
}

class LoadingPersonalDataState extends SignupPersonalDataState {
  LoadingPersonalDataState();

  @override
  List<Object> get props => [];
}

class ErrorPersonalDataState extends SignupPersonalDataState {
  final String error;

  ErrorPersonalDataState(this.error);

  @override
  List<Object> get props => [error];
}
