import 'package:equatable/equatable.dart';

abstract class PassRecoveryState extends Equatable {
  const PassRecoveryState();
}

class PassRecoveryInitial extends PassRecoveryState {
  const PassRecoveryInitial();

  @override
  List<Object> get props => [];
}

class PassRecoveryLoadingState extends PassRecoveryState {
  PassRecoveryLoadingState();

  @override
  List<Object> get props => [];
}

class PassRecoveryErrorState extends PassRecoveryState {
  final String error;

  PassRecoveryErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class PassRecoveryStoredState extends PassRecoveryState {
  final String email;

  PassRecoveryStoredState({
    required this.email,
  });

  @override
  List<Object?> get props => [email];

  Map<String, dynamic>? toJson() {
    return {
      'email': email,
    };
  }
}
