import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/model/subscription_model.dart';

abstract class UserDataService {
  ProfileOverviewModel? user;

  abstract bool checkInstitutionsRequireLogin;

  abstract int? accountLinkType;
  void clearUserData();

  void setUserData(ProfileOverviewModel? user);

  void updateUserData({
    String? firstName,
    String? lastName,
    String? creationTimeUtc,
    SubscriptionModel? subscription,
    String? imageUrl,
    bool? hasInstitutionAccounts,
    bool? hasConfiguredBankAccounts,
  });
}

class UserDataServiceImpl extends UserDataService {
  @override
  ProfileOverviewModel? user;

  @override
  bool checkInstitutionsRequireLogin = true;

  UserDataServiceImpl();

  @override
  void clearUserData() {
    user = null;
    checkInstitutionsRequireLogin = true;
  }

  @override
  void setUserData(ProfileOverviewModel? user) {
    this.user = user;
  }

  @override
  void updateUserData({
    String? firstName,
    String? lastName,
    String? creationTimeUtc,
    SubscriptionModel? subscription,
    String? imageUrl,
    bool? hasInstitutionAccounts,
    bool? hasConfiguredBankAccounts,
  }) {
    user = user?.copyWith(
        firstName: firstName,
        lastName: lastName,
        creationTimeUtc: creationTimeUtc,
        subscription: subscription,
        imageUrl: imageUrl,
        hasInstitutionAccounts: hasInstitutionAccounts,
        hasConfiguredBankAccounts: hasConfiguredBankAccounts);
  }

  @override
  int? accountLinkType;
}
