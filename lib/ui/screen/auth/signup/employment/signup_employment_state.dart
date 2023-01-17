import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/model/user_details_model.dart';
import 'package:equatable/equatable.dart';

abstract class SignupEmploymentState extends Equatable {
  const SignupEmploymentState();
}

class SignupEmploymentInitial extends SignupEmploymentState {
  SignupEmploymentInitial();

  @override
  List<Object> get props => [];
}

class SignupEmploymentLoaded extends SignupEmploymentState {
  final UserDetailsModel userDetails;
  final ProfileOverviewModel user;

  SignupEmploymentLoaded({required this.userDetails, required this.user});

  @override
  List<Object> get props => [userDetails];
}

class LoadingEmploymentState extends SignupEmploymentState {
  LoadingEmploymentState();

  @override
  List<Object> get props => [];
}

class ErrorEmploymentState extends SignupEmploymentState {
  final String error;

  ErrorEmploymentState(this.error);

  @override
  List<Object> get props => [error];
}
