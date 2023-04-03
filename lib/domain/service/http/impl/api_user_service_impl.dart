import 'package:burgundy_budgeting_app/domain/model/request/add_employment_signup_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/add_experience_signup_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/add_personal_data_signup_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/search_city_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/user_details_post_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_user_service.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class ApiUserServiceImpl extends ApiUserService {
  final String personalInfoEndpoint = '/user/personal-info';
  final String userDetailsEndpoint = '/user/profile-details';
  final String getUserDetailsEndpoint = '/user/profile-details';
  final String experienceEndpoint = '/user/budgeting-experience-info';
  final String employmentEndpoint = '/user/employment-info';
  final String setUserImageEndpoint = '/user/image';
  final String getProfileOverviewEndpoint = '/user/profile-overview';
  final String deleteUserEndpoint = '/user/delete-account';
  final String getCoachAccessTypeEndpoint = '/user/get-coach-access-type';

  final String searchCityEndpoint = '/suggest.json';

  final String requestClientsListEndpoint = '/request/clients-list';

  final Logger logger = getLogger('HttpUserServiceImpl');

  final HttpManager httpManager;

  final String confirmEmailEndpoint = '/user/confirm-email';

  ApiUserServiceImpl(this.httpManager) : super(httpManager);

  ///documentation API v.1
  ///https://www.notion.so/API-versioning-88818d094b354a429d2c0c2755eed1e9?pvs=4#64765bef26e54e69a15a8709d6011383

  @override
  Future<Response<dynamic>> addPersonalDataSignUp(AddPersonalDataSignUpRequest query) async {
    //TODO: (viacheslav) remove, when change the registration
    return await httpManager.dio
        .post(personalInfoEndpoint, data: query.toJson(), options: Options(headers: {'Api-Version': '1'}));
  }

  @override
  Future<Response> addEmploymentSignUp(AddEmploymentSignUpRequest query) async {
    //TODO: (viacheslav) remove, when change the registration
    return await httpManager.dio
        .post(employmentEndpoint, data: query.toJson(), options: Options(headers: {'Api-Version': '1'}));
  }

  @override
  Future<Response> addExperienceSignUp(AddExperienceSignUpRequest query) async {
    //TODO: (viacheslav) remove, when change the registration
    return await httpManager.dio
        .post(experienceEndpoint, data: query.toJson(), options: Options(headers: {'Api-Version': '1'}));
  }

  @override
  Future<Response<dynamic>> addUserDetails(UserDetailsPostRequest query) async {
    return await httpManager.dio.post(
      userDetailsEndpoint,
      data: query.toJson(),
    );
  }

  @override
  Future<Response<dynamic>> getUserDetails() async {
    return await httpManager.dio.get(
      getUserDetailsEndpoint,
    );
  }

  @override
  Future<Response<dynamic>> getProfileOverview() async {
    return await httpManager.dio.get(
      getProfileOverviewEndpoint,
    );
  }

  @override
  Future<Response> setUserImage(XFile? image) async {
    //The file should have one of the extensions:
    var fileName = image?.path.split('/').last;
    logger.i('Send photo FileName=$fileName');
    logger.i('image?.path=${image?.path}');
    var data = FormData.fromMap({
      'formFile': MultipartFile.fromBytes(
        await image!.readAsBytes(),
        filename: fileName,
      )
    });
    logger.i('data.files.length=${data.files.length}');
    var response = await httpManager.dio.post(
      setUserImageEndpoint,
      data: data,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data; ',
          'Accept': '*/*',
          //'Content-Length': image.lengthSync().toString(),
          'Connection': 'keep-alive',
        },
      ),
    );
    logger.i('Send photo response=$response');
    logger.i('Send photo response data=${response.data}');
    if (response.data != null && response.data['imageUrl'] != null && response.data['imageUrl'].toString().isNotEmpty) {
      logger.i('Image URL=${response.data['imageUrl']}');
    }

    return response;
  }

  @override
  Future<Response> searchCity(SearchCityRequest request) async {
    return await httpManager.dioCitySearch.get(
      searchCityEndpoint,
      queryParameters: request.toMap(),
    );
  }

  @override
  Future<Response> deleteUser() async {
    return await httpManager.dio.post(deleteUserEndpoint);
  }

  @override
  Future<Response> fetchClientsList(int clientsCount) async {
    return await httpManager.dio.post(
      requestClientsListEndpoint,
      data: {'clientsCount': clientsCount},
    );
  }

  @override
  Future<Response> getCoachAccessType() async {
    return await httpManager.dio.post(
      getCoachAccessTypeEndpoint,
    );
  }

  @override
  Future<Response> confirmUserEmail(String email, String code) async {
    return await httpManager.dio.post(confirmEmailEndpoint, data: {
      'email': email,
      'confirmationCode': code,
    });
  }
}
