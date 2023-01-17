class IsRegisteredUserRequest {
  final String email;

  IsRegisteredUserRequest(this.email);

  Map<String, dynamic>? toJson() {
    return {'email': email};
  }
}
