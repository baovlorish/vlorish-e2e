import 'package:equatable/equatable.dart';

abstract class SigninGoogleCodeState with EquatableMixin {
  const SigninGoogleCodeState();
}

class SigninGoogleCodeInitial extends SigninGoogleCodeState {
  final String errorMessage = '';
  final bool successLogin = false;

  //LoginInitial({this.successLogin, this.errorMessage});

  @override
  List<Object> get props => [errorMessage, successLogin];
}

class LoadingState extends SigninGoogleCodeState {
  LoadingState();

  @override
  List<Object> get props => [];
}

class ErrorState extends SigninGoogleCodeState {
  String error = '';

  ErrorState(this.error);

  @override
  List<Object> get props => [];
}
