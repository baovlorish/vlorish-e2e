import 'package:equatable/equatable.dart';

abstract class SignupAddCardState extends Equatable {
  const SignupAddCardState();
}

class SignupAddCardInitial extends SignupAddCardState {
  SignupAddCardInitial();

  @override
  List<Object> get props => [];
}

class LoadingAddCardState extends SignupAddCardState {
  LoadingAddCardState();

  @override
  List<Object> get props => [];
}

class LoadedAddCardState extends SignupAddCardState {
  LoadedAddCardState();

  @override
  List<Object> get props => [];
}

class ErrorAddCardState extends SignupAddCardState {
  final String message;
  ErrorAddCardState(this.message);

  @override
  List<Object> get props => [];
}
