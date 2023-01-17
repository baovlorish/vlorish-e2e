import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:equatable/equatable.dart';

abstract class SignupMailCodeState extends Equatable {
  const SignupMailCodeState();
}

class SignupMailCodeInitial extends SignupMailCodeState {
  final String email;
  final UserRole role;
  SignupMailCodeInitial(this.email,  this.role);

  @override
  List<Object?> get props => [email, role];

  Map<String, dynamic>? toJson() {
    return {
      'email': email,
      'role': role.mappedValue,
    };
  }
}

class EmptyMailCodeState extends SignupMailCodeState {
  EmptyMailCodeState();

  @override
  List<Object> get props => [];
}

class LoadingMailCodeState extends SignupMailCodeState {
  LoadingMailCodeState();

  @override
  List<Object> get props => [];
}

class SignupMailCodeSuccessState extends SignupMailCodeState {
  final String message;
  final void Function()? callback;

  SignupMailCodeSuccessState(this.message, {this.callback});

  @override
  List<Object> get props => [message];
}

class SignupMailCodeErrorState extends SignupMailCodeState {
  final String error;
  final void Function()? callback;
  SignupMailCodeErrorState(this.error, {this.callback});

  @override
  List<Object> get props => [error];
}
