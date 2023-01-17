import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:equatable/equatable.dart';

abstract class SignupLandingState extends Equatable {
  const SignupLandingState();
}

class SignupLandingInitial extends SignupLandingState {
  SignupLandingInitial();

  @override
  List<Object> get props => [];
}

class LoadingLandingState extends SignupLandingState {
  LoadingLandingState();

  @override
  List<Object> get props => [];
}

class SignupLandingErrorState extends SignupLandingState {
  final String error;

  SignupLandingErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class SignupLandingStoredState extends SignupLandingState {
  final String email;
  final String? invitationId;
  final UserRole role;

  SignupLandingStoredState({
    required this.email,
    required this.invitationId,
    required this.role,
  });

  @override
  List<Object?> get props => [email, role, invitationId];

  Map<String, dynamic>? toJson() {
    return {
      'email': email,
      'invitationId': invitationId,
      'role': role.mappedValue,
    };
  }
}
