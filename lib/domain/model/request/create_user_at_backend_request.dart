import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';

class CreateUserAtBackendRequest {
  final String email;
  final String password;
  final String? invitationId;
  final UserRole? role;

  CreateUserAtBackendRequest(this.email, this.password,
      {this.invitationId, this.role});

  Map<String, dynamic>? toJson() {
    return {
      'email': email,
      'password': password,
      'role': role?.mappedValue ?? 1,
      'invitationId': invitationId,
    };
  }
}
