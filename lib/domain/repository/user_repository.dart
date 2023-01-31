import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/general/support_ticket.dart';
import 'package:burgundy_budgeting_app/domain/model/request/add_employment_signup_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/add_experience_signup_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/add_personal_data_signup_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/search_city_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/user_details_post_request.dart';
import 'package:burgundy_budgeting_app/domain/model/response/profile_overview_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/user_details_response.dart';
import 'package:burgundy_budgeting_app/domain/network/api_client.dart';
import 'package:burgundy_budgeting_app/domain/service/foreign_session_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_notification_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_transactions_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_user_service.dart';
import 'package:burgundy_budgeting_app/domain/service/notification_service.dart';
import 'package:burgundy_budgeting_app/domain/service/user_data_service.dart';
import 'package:burgundy_budgeting_app/domain/service/user_support_service.dart';
import 'package:burgundy_budgeting_app/ui/model/add_employment_model.dart';
import 'package:burgundy_budgeting_app/ui/model/add_experience_model.dart';
import 'package:burgundy_budgeting_app/ui/model/add_personal_data_model.dart';
import 'package:burgundy_budgeting_app/ui/model/city_model.dart';
import 'package:burgundy_budgeting_app/ui/model/client_menu_item_model.dart';
import 'package:burgundy_budgeting_app/ui/model/notification_model.dart';
import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/model/user_details_model.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserRepository {
  Future<String> addPersonalDataSignUp(PersonalDataModel model);

  Future<String> addExperienceSignUp(ExperienceModel model);

  Future<String> addEmploymentSignUp(EmploymentModel model);

  Future<String> addUserDetails(UserDetailsModel model);

  Future<UserDetailsModel> getUserDetails();

  Future<ProfileOverviewModel> getProfileOverview();

  Future<String> setUserImage(XFile? image);

  Future<List<CityModel>> searchCity(String value);

  Future<ProfileOverviewModel> getUserData({bool needUpdateUserData = false});

  void clearUserData();

  Future<void> updateUserData([ProfileOverviewModel? data]);

  Future<bool> deleteUser();

  Future<void> confirmUserEmail(String email, String code);

  Future<bool> refreshTransactions();

  void startForeignSession(
      String id, int accessType, String? firstName, String? lastName);

  void stopForeignSession();

  ForeignSessionParams? currentForeignSession();

  Future<List<ClientMenuItemModel>> fetchClientsList(int clientsCount);

  Future<void> clearNotifications();

  Future<NotificationPageModel> fetchNotificationPage({required bool all});

  Future<void> markAsRead({required List<String> ids});

  Future<void> deleteNotification(String id);

  Stream get notificationStream;

  void initNotificationService(String userId);

  Future<int> getCoachAccessType({bool returnZeroIfNoAccess = false});

  Future<bool> createSupportTicket(SupportTicketModel ticket);
}

class UserRepositoryImpl implements UserRepository {
  final ApiUserService _apiUserService;
  final ApiNotificationService _apiNotificationService;
  final ForeignSessionService _foreignSessionService;
  final UserDataService _userDataService;
  final ApiTransactionsService _apiTransactionsService;
  final NotificationService _notificationService;
  final UserSupportService _userSupportService;
  final String generalErrorMessage = 'Oops! Something went wrong!';
  NotificationPageModel? notificationPageMock;

  final imageErrorMessage =
      'The total image should be less than 4 MB and saved as JPG, PNG, GIF files. Please try another image';

  UserRepositoryImpl(
    this._apiUserService,
    this._userDataService,
    this._apiTransactionsService,
    this._foreignSessionService,
    this._apiNotificationService,
    this._notificationService,
    this._userSupportService,
  );

  @override
  Future<String> addPersonalDataSignUp(PersonalDataModel model) async {
    var response = await _apiUserService.addPersonalDataSignUp(
      AddPersonalDataSignUpRequest(
        lastName: model.lastName,
        firstName: model.firstName,
        gender: model.gender != null ? model.gender! + 1 : null,
        city: model.cityModel?.cityName,
        stateCode: model.cityModel?.stateCode,
        dateOfBirth: model.dateOfBirth,
      ),
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return '';
    } else {
      return response.data['message'] ?? generalErrorMessage;
    }
  }

  @override
  Future<String> addEmploymentSignUp(EmploymentModel model) async {
    var response = await _apiUserService.addEmploymentSignUp(
      AddEmploymentSignUpRequest(
        profession: model.profession + 1,
        income: model.income,
        employmentType: model.employmentType + 1,
      ),
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return '';
    } else {
      return response.data['message'] ?? generalErrorMessage;
    }
  }

  @override
  Future<String> addExperienceSignUp(ExperienceModel model) async {
    var response = await _apiUserService.addExperienceSignUp(
      AddExperienceSignUpRequest(
        mostUsedBudgetingAppName: model.mostUsedBudgetingAppName,
        experienceWithBudgetingLevel: model.experienceWithBudgetingLevel + 1,
      ),
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return '';
    } else {
      return response.data['message'] ?? generalErrorMessage;
    }
  }

  @override
  Future<String> addUserDetails(UserDetailsModel model) async {
    var response = await _apiUserService.addUserDetails(
      UserDetailsPostRequest.fromUserDetailsModel(model),
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      _userDataService.updateUserData(
          firstName: model.firstName, lastName: model.lastName);
      return '';
    } else {
      return response.data['message'] ?? generalErrorMessage;
    }
  }

  @override
  Future<UserDetailsModel> getUserDetails() async {
    var response = await _apiUserService.getUserDetails();
    var responseModel = UserDetailsResponse.fromJson(response.data);
    return UserDetailsModel.fromResponseModel(responseModel);
  }

  @override
  Future<ProfileOverviewModel> getProfileOverview() async {
    var response = await _apiUserService.getProfileOverview();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var responseModel = ProfileOverviewResponse.fromJson(response.data);
      return ProfileOverviewModel.fromResponseModel(responseModel);
    } else {
      throw CustomException(response.data?['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<String> setUserImage(XFile? image) async {
    var response = await _apiUserService.setUserImage(image);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      _userDataService.updateUserData(imageUrl: response.data['imageUrl']);
      return response.data['imageUrl'];
    } else {
      throw CustomException(response.data?['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<List<CityModel>> searchCity(String value) async {
    final apiKey = ApiClient.ENV_GEO_CREDENTIALS['ApiKey']!;
    var response;
    if (value.isNotEmpty) {
      response = await _apiUserService.searchCity(SearchCityRequest(
        apiKey: apiKey,
        query: value,
        country: 'USA',
        resultType: 'city',
        maxresults: '5',
      ));

      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        var cityArray = <CityModel>[];
        var suggestions = List.from(response.data['suggestions']);
        for (var item in suggestions) {
          var state = item['address']['state'] as String;
          var stateCode = CityModel.getStateCode(state.replaceAll(' ', ''));
          if (stateCode != null) {
            cityArray.add(CityModel(item['address']['city'], stateCode));
          }
        }
        return cityArray;
      } else {
        throw Exception(generalErrorMessage);
      }
    }
    return [];
  }

  @override
  void clearUserData() {
    HydratedBloc.storage.delete('BudgetPersonalCubit');
    HydratedBloc.storage.delete('BudgetBusinessCubit');
    _userDataService.clearUserData();
  }

  @override
  Future<ProfileOverviewModel> getUserData(
      {bool needUpdateUserData = false}) async {//fixme: not for everytime ProfileOverview call, only for return from Stripe
    if (_userDataService.user != null && !needUpdateUserData) {
      return _userDataService.user!;
    } else {
      var data = await getProfileOverview();
      _userDataService.setUserData(data);
      if (data.loginRequiringInstitutions.isNotEmpty &&
          _userDataService.checkInstitutionsRequireLogin) {
        _userDataService.checkInstitutionsRequireLogin = false;
        throw CustomException(data.getLoginRequiringInstitutionsAsString(),
            type: CustomExceptionType.Inform);
      }
      return data;
    }
  }

  @override
  Future<void> updateUserData([ProfileOverviewModel? data]) async {
    data ??= await getProfileOverview();
    _userDataService.setUserData(data);
  }

  @override
  Future<bool> deleteUser() async {
    var response = await _apiUserService.deleteUser();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw Exception(generalErrorMessage);
    }
  }

  @override
  Future<bool> refreshTransactions() async {
    var isSuccessful = false;
    var response = await _apiTransactionsService.refreshTransactions();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      isSuccessful = true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
    return isSuccessful;
  }

  @override
  void startForeignSession(
      String id, int accessType, String? firstName, String? lastName) {
    _foreignSessionService.startForeignSession(ForeignSessionParams(
        id: id,
        accessType: accessType,
        firstName: firstName,
        lastName: lastName));
  }

  @override
  void stopForeignSession() {
    _foreignSessionService.stopForeignSession();
  }

  @override
  ForeignSessionParams? currentForeignSession() {
    return _foreignSessionService.currentForeignSession();
  }

  @override
  Future<List<ClientMenuItemModel>> fetchClientsList(int clientsCount) async {
    var response = await _apiUserService.fetchClientsList(clientsCount);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var clientsList = <ClientMenuItemModel>[];

      for (var client in response.data['clients']) {
        clientsList.add(ClientMenuItemModel.fromJson(client));
      }

      return clientsList;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<void> clearNotifications() async {
    var response = await _apiNotificationService.clearNotifications();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
/*    notificationPageMock =
        NotificationPageModel(notifications: [], totalCount: 0);*/
  }

  @override
  Future<void> deleteNotification(String id) async {
    var response = await _apiNotificationService.deleteNotification(id);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
/*    var notifications = notificationPageMock!.notifications
        .where((element) => element.id != id);
    notificationPageMock = NotificationPageModel(
        notifications: notifications.toList(),
        totalCount: notificationPageMock!.totalCount - 1);*/
  }

  @override
  Future<NotificationPageModel> fetchNotificationPage(
      {required bool all}) async {
    var response = await _apiNotificationService.fetchNotifications(all: all);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return NotificationPageModel.fromJson(response.data);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }

/*    await Future.delayed(Duration(milliseconds: 400));

    notificationPageMock ??= NotificationPageModel.mocked();
    return all
        ? notificationPageMock!
        : NotificationPageModel.mockedShort(notificationPageMock!);*/
  }

  @override
  Future<void> markAsRead({required List<String> ids}) async {
    var response = await _apiNotificationService.markAsRead(ids);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Stream get notificationStream => _notificationService.notificationStream;

  @override
  void initNotificationService(String userId) {
    _notificationService.initNotificationService(userId);
  }

  @override
  Future<int> getCoachAccessType({bool returnZeroIfNoAccess = false}) async {
    var response = await _apiUserService.getCoachAccessType();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data['accessType'];
    } else if (response.statusCode == 403 && returnZeroIfNoAccess) {
      return 0;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> createSupportTicket(SupportTicketModel ticket) async {
    var response = await _userSupportService.createTicket(ticket.toJson());
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<void> confirmUserEmail(String email, String code) async {
    var response = await _apiUserService.confirmUserEmail(email, code);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }
}
