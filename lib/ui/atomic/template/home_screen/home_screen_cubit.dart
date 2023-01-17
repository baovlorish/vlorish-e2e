import 'dart:convert';
import 'dart:html' as html;

import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/subscription_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/domain/service/foreign_session_service.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_state.dart';
import 'package:burgundy_budgeting_app/ui/model/client_menu_item_model.dart';
import 'package:burgundy_budgeting_app/ui/model/notification_model.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';
import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/business/budget_business_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/debts/debts_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/fi_score/fi_score_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/goals/goals_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/net_worth/net_worth_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/referral/referral_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/retirement/retirement_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/tax/tax_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/transactions/transactions_page.dart';
import 'package:burgundy_budgeting_app/utils/helpers/url_launcher_helper.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:logger/logger.dart';

import 'home_screen.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  ProfileOverviewModel user = ProfileOverviewModel.empty();

  final AuthRepository authRepository;
  final UserRepository userRepository;
  final SubscriptionRepository subscriptionRepository;
  ForeignSessionParams? currentForeignSession;
  final Logger logger = getLogger('HomeScreenCubit');

  Tabs? currentTab;

  HomeScreenCubit(
      this.authRepository, this.userRepository, this.subscriptionRepository,
      {bool checkInstitutions = false})
      : super(HomeScreenInitial()) {
    load();
  }

  Period get longPeriod =>
      state is HomeScreenLoaded ? user.longTablePeriod : Period.fromNow();

  Period get shortPeriod =>
      state is HomeScreenLoaded ? user.shortTablePeriod : Period.fromNow();

  Future<void> getUserData({bool initial = false}) async {
    emit(HomeScreenLoading());
    try {
      user = await userRepository.getUserData();
      logger.i('get user data successful');
      emit(HomeScreenLoaded(user));
      if (initial) {
        userRepository.initNotificationService(user.userId);
      }
    } catch (e) {
      //login requiring institutions
      if (e is CustomException && e.type == CustomExceptionType.Inform) {
        emit(HomeScreenError(e.toString(), type: e.type));
        await getUserData();
      } else {
        emit(HomeScreenError(e.toString()));
        rethrow;
      }
    }
  }

  String getInitials() {
    var initials = '';
    if (user.firstName != null && user.firstName!.isNotEmpty) {
      initials = initials + user.firstName![0];
    }
    if (user.lastName != null && user.lastName!.isNotEmpty) {
      initials = initials + user.lastName![0];
    }
    return initials.toUpperCase();
  }

  Future<void> goToCustomerPortal(String routeName) async {
    try {
      var url = await subscriptionRepository.getCustomerPortalUrl(routeName);
      await openUrl(
        url: url,
        launchInThisTab: true,
        exceptionMessage: authRepository.generalErrorMessage,
      );
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  void setCurrentTab(Tabs? tab) {
    currentTab = tab;
  }

  void logout(BuildContext context) {
    userRepository.clearUserData();
    stopForeignSession();
    authRepository.logout();
    NavigatorManager.navigateTo(
      context,
      SigninPage.routeName,
      clearStack: true,
    );
  }

  void navigateToSubscriptionPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      SubscriptionPage.routeName,
    );
  }

  void navigateToTransactionsPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      TransactionsPage.routeName,
    );
  }

  void navigateToProfileOverviewPage(BuildContext context) {
    stopForeignSession();
    NavigatorManager.navigateTo(
      context,
      ProfileOverviewPage.routeName,
    );
  }

  void navigateToBudgetPersonalPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      BudgetPersonalPage.routeName,
    );
  }

  void navigateToBudgetBusinessPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      BudgetBusinessPage.routeName,
    );
  }

  void navigateToDebtsPersonalPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      DebtsPage.routeName,
    );
  }

  void navigateToNetWorthPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      NetWorthPage.routeName,
    );
  }

  void navigateToGoalsPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      GoalsPage.routeName,
    );
  }

  void navigateToTaxPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      TaxPage.routeName,
    );
  }

  void navigateToFiScorePage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      FiScorePage.routeName,
    );
  }

  void navigateToRetirementPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      RetirementPage.routeName,
    );
  }

  void navigateToInvestmentsPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      InvestmentsPage.routeName,
    );
  }

  void navigateToReferralPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      ReferralPage.routeName,
    );
  }

  Future<void> refreshTransactions() async {
    if (state is HomeScreenLoaded) {
      var loadedState = state;
      try {
        var isSuccessful = await userRepository.refreshTransactions();
        if (isSuccessful) {
          var updatedUser = user.copyWith(
            remainedTransactionRefreshCount:
                user.remainedTransactionRefreshCount - 1,
            hasConfiguredBankAccounts: user.hasConfiguredBankAccounts,
            hasInstitutionAccounts: user.hasInstitutionAccounts,
          );
          user = updatedUser;
          await userRepository.updateUserData(updatedUser);
          emit(HomeScreenLoaded(updatedUser));
        } else {
          emit(HomeScreenError(authRepository.generalErrorMessage));
          emit(loadedState);
        }
      } catch (e) {
        emit(HomeScreenError(e.toString()));
        emit(loadedState);
        rethrow;
      }
    }
  }

  Future<void> updateUserData() async {
    try {
      await userRepository.updateUserData();
      await getUserData();
    } catch (e) {
      emit(HomeScreenError(e.toString()));
      rethrow;
    }
  }

  void startForeignSession(BuildContext context, String id, int accessType,
      String? firstName, String? lastName) {
    userRepository.startForeignSession(id, accessType, firstName, lastName);
    navigateTo(
      BudgetPersonalPage.routeName,
      context,
    );
  }

  void stopForeignSession() {
    currentForeignSession = null;
    userRepository.stopForeignSession();
  }

  ForeignSessionParams? getCurrentForeignSession() {
    return userRepository.currentForeignSession();
  }

  void navigateTo(String route, BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      route,
    );
  }

  Future<List<ClientMenuItemModel>> fetchClientsList(int clientsCount) async {
    return await userRepository.fetchClientsList(clientsCount);
  }

  Future<NotificationPageModel> fetchNotificationPage(
      {bool all = false}) async {
    var result = await userRepository.fetchNotificationPage(all: all);
    var ids = <String>[];
    result.notifications.forEach((element) {
      ids.add(element.id);
    });

    await userRepository.markAsRead(ids: ids);
    await updateUserData();
    await getUserData();
    return result;
  }

  Future<void> clearNotifications() async {
    await userRepository.clearNotifications();
  }

  Future<void> deleteNotification(String id) async {
    await userRepository.deleteNotification(id);
  }

  Future<void> load() async {
    await getUserData();
    userRepository.initNotificationService(user.userId);
    currentForeignSession = getCurrentForeignSession();
    userRepository.notificationStream.listen((event) async {
      await updateUserData();
      await getUserData();
      var notification = NotificationModel.fromJson(
          json.decode(event.payload['Notification']),
          fromNotification: true);
      if (notification.notificationType == 8 && currentForeignSession != null) {
        logger.e('Client changed access type');
        var accessType = await userRepository.getCoachAccessType();
        if (currentForeignSession!.access.mappedValue != accessType) {
          userRepository.startForeignSession(
              currentForeignSession!.id,
              accessType,
              currentForeignSession!.firstName,
              currentForeignSession!.lastName);
          html.window.location.reload();
        }
      }
      if (notification.notificationType == 14 &&
          currentForeignSession != null) {
        logger.e('Client changed access type');
        var accessType =
            await userRepository.getCoachAccessType(returnZeroIfNoAccess: true);
        if (accessType == 0) {
          stopForeignSession();
          await Future.delayed(Duration(milliseconds: 800));
          html.window.location.reload();
        }
      } else if (notification.notificationType == 13) {
        logger.e('Transactions refreshed');
        await updateUserData();
        await getUserData();
      }
    });
  }
}
