import 'package:equatable/equatable.dart';

abstract class SigninState with EquatableMixin {
  const SigninState();
}

class SigninInitial extends SigninState {
  @override
  List<Object> get props => [];
}

class LoadingState extends SigninState {
  LoadingState();

  @override
  List<Object> get props => [];
}

class ErrorState extends SigninState {
  final String error;
  final void Function()? errorDialogCallBack;
  final String? errorDialogButtonText;

  ErrorState(this.error,
      {this.errorDialogCallBack, this.errorDialogButtonText});

  @override
  List<Object> get props => [error];
}
