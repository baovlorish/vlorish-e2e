import 'package:burgundy_budgeting_app/domain/model/request/add_employment_signup_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/add_experience_signup_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/add_personal_data_signup_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/search_city_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/user_details_post_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

abstract class ApiUserService {
  ApiUserService(HttpManager httpManager);

  Future<Response<dynamic>> addPersonalDataSignUp(
      AddPersonalDataSignUpRequest query);

  Future<Response<dynamic>> addUserDetails(UserDetailsPostRequest query);

  Future<Response<dynamic>> getUserDetails();
  Future<Response<dynamic>> getProfileOverview();
  Future<Response<dynamic>> addExperienceSignUp(
      AddExperienceSignUpRequest addExperienceSignUpRequest);

  Future<Response<dynamic>> addEmploymentSignUp(
      AddEmploymentSignUpRequest addEmploymentSignUpRequest);

  Future<Response> setUserImage(XFile? image);

  Future<Response> searchCity(SearchCityRequest request);

  Future<Response> deleteUser();

  Future<Response> fetchClientsList(int clientsCount);

  Future<Response> getCoachAccessType();

  Future<Response> confirmUserEmail(String email, String code);
}
