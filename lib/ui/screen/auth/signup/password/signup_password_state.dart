import 'package:equatable/equatable.dart';

abstract class SignupPasswordState extends Equatable {
  const SignupPasswordState();
}

class SignupPasswordInitial extends SignupPasswordState {
  SignupPasswordInitial();

  @override
  List<Object> get props => [];
}

class LoadingPasswordState extends SignupPasswordState {
  LoadingPasswordState();

  @override
  List<Object> get props => [];
}

class SignUpPasswordErrorState extends SignupPasswordState {
  final String error;
  final void Function()? callback;

  SignUpPasswordErrorState(this.error, {this.callback});

  @override
  List<Object> get props => [error];
}
