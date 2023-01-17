import 'package:equatable/equatable.dart';

abstract class AuthState with EquatableMixin {
  const AuthState();
}

class AuthInitial extends AuthState {
  AuthInitial();

  @override
  List<Object?> get props => [];
}

class AuthLoadedState extends AuthState {
  final bool sessionExists;
  final int? availableStep;

  AuthLoadedState({
    required this.sessionExists,
    required this.availableStep,
  });

  @override
  List<Object?> get props => [
        sessionExists,
        availableStep,
      ];
}
