import 'package:equatable/equatable.dart';

abstract class RecoveryMailCodeState extends Equatable {
  const RecoveryMailCodeState();
}

class RecoveryMailCodeInitial extends RecoveryMailCodeState {
  const RecoveryMailCodeInitial();

  @override
  List<Object> get props => [];
}

class RecoveryMailCodeReady extends RecoveryMailCodeState {
  RecoveryMailCodeReady();

  @override
  List<Object> get props => [];
}

class RecoveryMailCodeLoading extends RecoveryMailCodeState {
  RecoveryMailCodeLoading();

  @override
  List<Object> get props => [];
}


class RecoveryMailSuccessState extends RecoveryMailCodeState {
  final String message;
  final void Function()? callback;

  RecoveryMailSuccessState(this.message, {this.callback});

  @override
  List<Object> get props => [message];
}

class RecoveryMailErrorState extends RecoveryMailCodeState {
  final String error;
  final void Function()? callback;

  RecoveryMailErrorState(this.error, {this.callback});

  @override
  List<Object> get props => [error];
}
