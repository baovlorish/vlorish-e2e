import 'package:burgundy_budgeting_app/ui/model/subscription_model.dart';

class ProfileOverviewResponse {
  final String? firstName;
  final String? lastName;
  final String creationTimeUtc;
  final SubscriptionModel? subscription;
  final String? imageUrl;
  final List<String>? loginRequiringInstitutions;
  final int? remainedTransactionRefreshCount;
  final bool? hasConfiguredBankAccounts;
  final bool? hasInstitutionAccounts;
  final String userId;
  final String? partnerId;
  final int? role;
  final bool? hasClients;
  final int registrationStep;

  final int unreadNotificationCount;

  ProfileOverviewResponse({
    this.firstName,
    this.lastName,
    this.imageUrl,
    required this.registrationStep,
    this.loginRequiringInstitutions,
    required this.unreadNotificationCount,
    required this.creationTimeUtc,
    required this.userId,
    required this.partnerId,
    this.subscription,
    this.remainedTransactionRefreshCount,
    required this.hasConfiguredBankAccounts,
    required this.hasInstitutionAccounts,
    this.role,
    this.hasClients,
  });

  factory ProfileOverviewResponse.fromJson(Map<String, dynamic> json) {
    var subscription = json['subscription'] == null
        ? null
        : SubscriptionModel.fromJson(json['subscription']);
    var loginRequiringInstitutions = <String>[];
    if (json['loginRequiringInstitutions'] != null) {
      for (var item in json['loginRequiringInstitutions']) {
        loginRequiringInstitutions.add(item);
      }
    }
    return ProfileOverviewResponse(
      creationTimeUtc: json['creationTimeUtc'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      imageUrl: json['imageUrl'],
      registrationStep: json['registrationStep'],
      userId: json['userId'],
      partnerId: json['partnerUserId'],
      unreadNotificationCount: json['unreadNotificationsCount'],
      loginRequiringInstitutions: loginRequiringInstitutions,
      subscription: subscription,
      remainedTransactionRefreshCount: json['remainedTransactionRefreshCount'],
      hasConfiguredBankAccounts: json['hasConfiguredBankAccounts'],
      hasInstitutionAccounts: json['hasInstitutionAccounts'],
      role: json['role'],
      hasClients: json['hasClients'],
    );
  }
}
