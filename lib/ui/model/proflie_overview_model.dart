import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/domain/model/response/profile_overview_response.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';
import 'package:burgundy_budgeting_app/ui/model/subscription_model.dart';

/// [partnerId] is id of other participant. for primary it's partner,
/// for partner it's primary
class ProfileOverviewModel {
  final String? firstName;
  final String? lastName;
  final String creationTimeUtc;
  final SubscriptionModel? subscription;
  final String? imageUrl;
  final List<String> loginRequiringInstitutions;
  late final Period longTablePeriod;
  final String? partnerId;
  final int remainedTransactionRefreshCount;
  final bool hasConfiguredBankAccounts;
  final bool hasInstitutionAccounts;
  final UserRole role;
  final String userId;
  final bool hasClients;
  final int registrationStep;

  ///period until current year and current month,
  ///using in Debt and Net Worth
  late final Period shortTablePeriod;

  final int unreadNotificationCount;

  late final bool isInstitutionLoginRequired = loginRequiringInstitutions.isNotEmpty;

  bool get isRegistrationCompleted =>
      registrationStep == 8 || (registrationStep == 5 && role.isPartner);

  ProfileOverviewModel(
      {this.firstName,
      this.lastName,
      required this.registrationStep,
      required this.loginRequiringInstitutions,
      required this.creationTimeUtc,
      this.subscription,
      this.imageUrl,
      required this.userId,
      required this.partnerId,
      required this.role,
      required this.remainedTransactionRefreshCount,
      required this.hasConfiguredBankAccounts,
      required this.hasInstitutionAccounts,
      required this.unreadNotificationCount,
      required this.hasClients}) {
    var startDate = DateTime(DateTime.parse(creationTimeUtc).year - 2);
    longTablePeriod = Period(
      startDate,
      (DateTime.now().year - startDate.year + 11) * 12,
    );
    shortTablePeriod = Period(
      startDate,
      ((DateTime.now().year - startDate.year + 1) * 12) -
          (12 - DateTime.now().month),
    );
  }

  @override
  String toString() {
    return 'firstName: $firstName, lastName: $lastName, subscription: $subscription, creationTimeUtc: $creationTimeUtc, imageUrl: $imageUrl, role: $role, hasClients: $hasClients';
  }

  factory ProfileOverviewModel.fromResponseModel(
      ProfileOverviewResponse responseModel) {
    return ProfileOverviewModel(
      lastName: responseModel.lastName,
      firstName: responseModel.firstName,
      registrationStep: responseModel.registrationStep,
      imageUrl: responseModel.imageUrl,
      unreadNotificationCount: responseModel.unreadNotificationCount,
      partnerId: responseModel.partnerId,
      creationTimeUtc: responseModel.creationTimeUtc,
      loginRequiringInstitutions:
          responseModel.loginRequiringInstitutions ?? [],
      subscription: responseModel.subscription,
      remainedTransactionRefreshCount:
          responseModel.remainedTransactionRefreshCount ?? 0,
      hasInstitutionAccounts: responseModel.hasInstitutionAccounts ?? true,
      hasConfiguredBankAccounts:
          responseModel.hasConfiguredBankAccounts ?? true,
      userId: responseModel.userId,
      role: UserRole.fromMapped(responseModel.role ?? 0),
      hasClients: responseModel.hasClients ?? false,
    );
  }

  ProfileOverviewModel copyWith({
    String? firstName,
    String? lastName,
    String? creationTimeUtc,
    List<String>? loginRequiringInstitutions,
    SubscriptionModel? subscription,
    String? imageUrl,
    int? remainedTransactionRefreshCount,
    bool? hasConfiguredBankAccounts,
    bool? hasInstitutionAccounts,
    bool? hasClients,
    int? unreadNotificationCount,
    int? registrationStep,
  }) {
    return ProfileOverviewModel(
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      imageUrl: imageUrl ?? this.imageUrl,
      registrationStep: registrationStep ?? this.registrationStep,
      unreadNotificationCount:
          unreadNotificationCount ?? this.unreadNotificationCount,
      userId: userId,
      partnerId: partnerId,
      creationTimeUtc: creationTimeUtc ?? this.creationTimeUtc,
      loginRequiringInstitutions:
          loginRequiringInstitutions ?? this.loginRequiringInstitutions,
      subscription: subscription ?? this.subscription,
      remainedTransactionRefreshCount: remainedTransactionRefreshCount ??
          this.remainedTransactionRefreshCount,
      hasInstitutionAccounts:
          hasInstitutionAccounts ?? this.hasInstitutionAccounts,
      hasConfiguredBankAccounts:
          hasConfiguredBankAccounts ?? this.hasConfiguredBankAccounts,
      role: role,
      hasClients: hasClients ?? this.hasClients,
    );
  }

  String getLoginRequiringInstitutionsAsString() {
    var resultString = '';
    for (var item in loginRequiringInstitutions) {
      if (item != loginRequiringInstitutions.last) {
        resultString = '$resultString$item, ';
      } else {
        resultString = '$resultString$item';
      }
    }
    return resultString;
  }

  factory ProfileOverviewModel.empty() {
    return ProfileOverviewModel(
      loginRequiringInstitutions: [],
      partnerId: null,
      registrationStep: 8,
      creationTimeUtc: DateTime.now().toString(),
      remainedTransactionRefreshCount: 0,
      hasConfiguredBankAccounts: false,
      hasInstitutionAccounts: false,
      role: UserRole.none(),
      unreadNotificationCount: 0,
      userId: '',
      hasClients: false,
    );
  }
}
