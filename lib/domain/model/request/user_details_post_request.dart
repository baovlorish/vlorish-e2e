import 'package:burgundy_budgeting_app/ui/model/user_details_model.dart';

class UserDetailsPostRequest {
  final String firstName;
  final String lastName;
  final int gender;
  final String dateOfBirth;
  final int relationshipStatus;
  final int dependents;

  final String city;
  final String stateCode;
  final String currency;

  final int education;
  final int employmentType;
  final int profession;
  final int? creditScore;
  final int? income;

  UserDetailsPostRequest({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.relationshipStatus,
    required this.dependents,
    required this.city,
    required this.stateCode,
    required this.currency,
    required this.education,
    required this.employmentType,
    required this.profession,
    this.creditScore,
    required this.income,
  });

  factory UserDetailsPostRequest.fromUserDetailsModel(UserDetailsModel model) {
    return UserDetailsPostRequest(
      lastName: model.lastName ?? '',
      firstName: model.firstName ?? '',
      gender: model.gender != null ? model.gender! + 1 : 4,
      city: (model.cityModel != null) ? model.cityModel!.cityName : '',
      dateOfBirth: model.dateOfBirth ?? '',
      relationshipStatus:
          model.relationshipStatus != null ? model.relationshipStatus! + 1 : 1,
      dependents: model.dependents != null ? model.dependents! + 1 : 1,
      stateCode: (model.cityModel != null) ? model.cityModel!.stateCode : '',
      currency: 'usd',
      education: model.education != null ? model.education! + 1 : 1,
      employmentType:
          model.employmentType != null ? model.employmentType! + 1 : 1,
      profession: model.profession != null ? model.profession! + 1 : 1,
      creditScore: model.creditScore,
      income: model.income,
    );
  }

  Map<String, dynamic>? toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'relationshipStatus': relationshipStatus,
      'dependents': dependents,
      'city': city,
      'stateCode': stateCode,
      'currency': currency,
      'education': education,
      'employmentType': employmentType,
      'profession': profession,
      'creditScore': creditScore,
      'income': income,
    };
  }
}
