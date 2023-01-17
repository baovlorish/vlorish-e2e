import 'package:burgundy_budgeting_app/ui/model/city_model.dart';

class PersonalDataModel {
  final String lastName;
  final String firstName;
  final int? gender;
  final CityModel? cityModel;
  final String? dateOfBirth;

  PersonalDataModel(
      {required this.lastName,
      required this.firstName,
      this.gender,
      this.cityModel,
      this.dateOfBirth});

  @override
  String toString() =>
      'PersonalDataModel{lastName: $lastName, firstName: $firstName, gender: $gender, cityModel: $cityModel, dateOfBirth: $dateOfBirth}';
}
