import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/domain/model/response/user_details_response.dart';
import 'package:burgundy_budgeting_app/ui/model/city_model.dart';

class UserDetailsModel {
  final String? firstName;
  final String? lastName;
  final int? gender;
  final String? dateOfBirth;
  final int? relationshipStatus;
  final int? dependents;

  final CityModel? cityModel;
  final String? currency;

  final int? education;
  final int? employmentType;
  final int? profession;
  final int? creditScore;
  final String? imageUrl;
  final UserRole? role;

  final int? income;
  final String? mostUsedBudgetingAppName;
  final int? experienceWithBudgetingLevel;

  UserDetailsModel({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.dateOfBirth,
    required this.relationshipStatus,
    required this.dependents,
    required this.cityModel,
    required this.currency,
    required this.education,
    required this.employmentType,
    required this.profession,
    this.creditScore,
    this.imageUrl,
    this.income,
    this.mostUsedBudgetingAppName,
    this.experienceWithBudgetingLevel,
    this.role,
  });

  @override
  String toString() {
    return 'firstName: $firstName, lastName: $lastName, gender: $gender, dateOfBirth: $dateOfBirth, relationshipStatus: $relationshipStatus, dependents: $dependents, cityModel: $cityModel, currency: $currency, education: $education, employmentType: $employmentType, profession: $profession, creditScore: $creditScore, imageUrl: $imageUrl, income: $income, mostUsedBudgetingAppName $mostUsedBudgetingAppName, experienceWithBudgetingLevel $experienceWithBudgetingLevel, role: $role';
  }

  factory UserDetailsModel.fromResponseModel(
      UserDetailsResponse responseModel) {
    CityModel? cityModel;
    if (responseModel.city != null && responseModel.stateCode != null) {
      cityModel = CityModel(responseModel.city!, responseModel.stateCode!);
    }

    return UserDetailsModel(
      lastName: responseModel.lastName,
      firstName: responseModel.firstName,
      gender: responseModel.gender == 0 ? null : responseModel.gender - 1,
      cityModel: cityModel,
      dateOfBirth: responseModel.dateOfBirth,
      relationshipStatus: responseModel.relationshipStatus == 0
          ? null
          : responseModel.relationshipStatus - 1,
      dependents:
          responseModel.dependents == 0 ? null : responseModel.dependents - 1,
      currency: responseModel.currency,
      education:
          responseModel.education == 0 ? null : responseModel.education - 1,
      employmentType: responseModel.employmentType == 0
          ? null
          : responseModel.employmentType - 1,
      profession:
          responseModel.profession == 0 ? null : responseModel.profession - 1,
      creditScore: responseModel.creditScore,
      imageUrl: responseModel.imageUrl,
      income: responseModel.income,
      experienceWithBudgetingLevel:
          responseModel.experienceWithBudgetingLevel == 0
              ? null
              : responseModel.experienceWithBudgetingLevel - 1,
      mostUsedBudgetingAppName: responseModel.mostUsedBudgetingAppName,
      role: UserRole.fromMapped(responseModel.role ?? 0),
    );
  }
}
