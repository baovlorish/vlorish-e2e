class AddPersonalDataSignUpRequest {
  final String lastName;
  final String firstName;
  final int? gender;
  final String? city;
  final String? stateCode;
  final String? dateOfBirth;

  AddPersonalDataSignUpRequest({
    required this.lastName,
    required this.firstName,
    this.gender,
    this.city,
    this.stateCode,
    this.dateOfBirth,
  });

  Map<String, dynamic>? toJson() {
    return {
      'lastName': lastName,
      'firstName': firstName,
      'gender': gender ?? 0,
      'city': city,
      'stateCode': stateCode,
      'dateOfBirth': dateOfBirth,
    };
  }
}
