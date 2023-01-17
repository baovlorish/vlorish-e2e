import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/avatar_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_vertical_devider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/appbar_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/inform_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/clients_dashboard_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/notification_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/contact_us/contact_us_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/education_center/education_center_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeAppBar extends AppBar {
  final BuildContext context;
  final String? initials;
  final String? imageUrl;
  final int remainedTransactionRefreshCount;
  final String loginRequiringInstitutions;
  final bool hasConfiguredAccounts;
  final bool hasInstitutionAccounts;
  final bool isSmall;
  final int unreadNotificationCount;
  final HomeScreenCubit homeScreenCubit;
  final Tabs? currentTab;

  HomeAppBar(
    this.context, {
    this.initials,
    this.imageUrl,
    required this.remainedTransactionRefreshCount,
    required this.loginRequiringInstitutions,
    required this.hasConfiguredAccounts,
    required this.hasInstitutionAccounts,
    required this.isSmall,
    required this.unreadNotificationCount,
    required this.homeScreenCubit,
    required this.currentTab,
  }) : super(
          automaticallyImplyLeading: false,
          backgroundColor: CustomColorScheme.mainDarkBackground,
          toolbarHeight: 76,
          elevation: 0.0,
          flexibleSpace: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              child: CustomMaterialInkWell(
                type: InkWellType.White,
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  homeScreenCubit.navigateToBudgetPersonalPage(context);
                },
                child: Image.asset(
                  isSmall
                      ? 'assets/images/logo_white_small.png'
                      : 'assets/images/logo_white_full.png',
                  height: 50.0,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          actions: [
            if (!isSmall)
              CustomVerticalDivider(
                color: CustomColorScheme.menuBackgroundActive,
              ),
            if (homeScreenCubit.user.hasClients)
              AppBarItem(
                hoverMenuWidget: ClientsDashboardMenu(
                    clientsList: homeScreenCubit.fetchClientsList,
                    onTapItem: homeScreenCubit.startForeignSession,
                    onTapButton: () {
                      if (homeScreenCubit.currentForeignSession != null) {
                        homeScreenCubit.stopForeignSession();
                      }
                      homeScreenCubit.navigateTo(
                          ManageUsersPage.routeName, context);
                    }),
                iconUrl: 'assets/images/icons/group.png',
                isSmall: isSmall,
                minPadding: 4.0,
                maxPadding: 8.0,
              ),
            AppBarItem(
              showMenuOnHover: true,
              isSelected: currentTab == Tabs.AppbarTransactions,
              iconUrl: 'assets/images/icons/card_default.png',
              onTap: () => homeScreenCubit.navigateToTransactionsPage(context),
              hoverMenuWidget: homeScreenCubit.currentForeignSession == null
                  ? _RefreshItem(
                      key: ObjectKey(homeScreenCubit.user),
                      homeScreenCubit: BlocProvider.of<HomeScreenCubit>(context),
                      remainedTransactionRefreshCount:
                          remainedTransactionRefreshCount,
                      onRefresh: () {
                        if (loginRequiringInstitutions.isEmpty) {
                          homeScreenCubit.refreshTransactions();
                          showDialog(
                            context: context,
                            builder: (context) => InformAlertDialog(
                              context,
                              title: AppLocalizations.of(context)!
                                  .theTransactionsRefreshHasStarted,
                              text: AppLocalizations.of(context)!
                                  .youWillReceiveNotificationWhenItIsComplete,
                              onButtonPress: () {},
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => TwoButtonsDialog(
                              context,
                              title: AppLocalizations.of(context)!
                                  .pleaseUpdateTheCredentialsOfPlaidAccounts,
                              mainButtonText:
                                  AppLocalizations.of(context)!.manageAccounts,
                              bodyWidget: Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Label(
                                  text: AppLocalizations.of(context)!
                                      .loginWithPlaidBeforeTheRefreshing,
                                  type: LabelType.General,
                                ),
                              ),
                              dismissButtonText:
                                  AppLocalizations.of(context)!.cancel,
                              onMainButtonPressed: () {
                                NavigatorManager.navigateTo(
                                  context,
                                  ManageAccountsPage.routeName,
                                );
                              },
                            ),
                          );
                        }
                      },
                      hasInstitutionAccounts: hasInstitutionAccounts,
                      hasConfiguredBankAccounts: hasConfiguredAccounts,
                    )
                  : SizedBox(),
              isSmall: isSmall,
              minPadding: 4.0,
              maxPadding: 8.0,
            ),
            AppBarItem(
              iconUrl: 'assets/images/icons/gift.png',
              isSmall: isSmall,
              minPadding: 4.0,
              maxPadding: 8.0,
              onTap: () {
                homeScreenCubit.navigateToReferralPage(context);
              },
            ),
            AppBarItem(
              iconUrl: 'assets/images/icons/24_help_default.png',
              isSelected: currentTab == Tabs.AppbarHelp,
              isSmall: isSmall,
              minPadding: 4.0,
              maxPadding: 8.0,
              modalAlignment: Alignment.topCenter,
              anchorAlignment: Alignment.bottomCenter,
              hoverMenuWidget: EducationCenterMenu(homeScreenCubit: BlocProvider.of<HomeScreenCubit>(context),),
            ),
            AppBarItem(
              iconUrl: 'assets/images/icons/notification.png',
              isSmall: isSmall,
              minPadding: 4.0,
              maxPadding: 8.0,
              usesAlignedMenu: true,
              notificationCount: unreadNotificationCount,
              hoverMenuWidget: NotificationMenu(
                maxHeight: MediaQuery.of(context).size.height - 100,
                width: homeScreenCubit.user.hasClients ? 469 : 409,
                fetchNotificationPage: homeScreenCubit.fetchNotificationPage,
                deleteNotification: (String id) async {
                  await homeScreenCubit.deleteNotification(id);
                },
                clearAll: () async {
                  await homeScreenCubit.clearNotifications();
                },
                homeScreenCubit: homeScreenCubit,
              ),
              showMenuOnHover: false,
            ),
            CustomVerticalDivider(
              color: CustomColorScheme.menuBackgroundActive,
            ),
            CustomMaterialInkWell(
              type: InkWellType.White,
              border: CircleBorder(),
              onTap: () {
                homeScreenCubit.navigateToProfileOverviewPage(context);
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: isSmall ? 12.0 : 24.0),
                child: Center(
                  child: AvatarWidget(
                    initials: initials,
                    imageUrl: imageUrl,
                  ),
                ),
              ),
            ),
            AppBarItem(
              iconUrl: 'assets/images/icons/logout.png',
              onTap: () {
                homeScreenCubit.logout(context);
              },
              isSmall: isSmall,
              minPadding: 4.0,
              maxPadding: 8.0,
            ),
            SizedBox(width: 8),
          ],
        );
}

class _RefreshItem extends StatelessWidget {
  final int remainedTransactionRefreshCount;
  final bool hasConfiguredBankAccounts;
  final bool hasInstitutionAccounts;
  final Function onRefresh;
  final HomeScreenCubit homeScreenCubit;

  _RefreshItem({
    Key? key,
    required this.remainedTransactionRefreshCount,
    required this.homeScreenCubit,
    required this.onRefresh,
    required this.hasConfiguredBankAccounts,
    required this.hasInstitutionAccounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var enabled = remainedTransactionRefreshCount > 0 &&
        hasConfiguredBankAccounts &&
        hasInstitutionAccounts;
    var hintMessage = !hasInstitutionAccounts
        ? AppLocalizations.of(context)!.addPlaidAccountsToRefresh
        : !hasConfiguredBankAccounts
            ? AppLocalizations.of(context)!.configurePlaidAccountsToRefresh
            : null;

    return Container(
      color: CustomColorScheme.mainDarkBackground,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomMaterialInkWell(
          type: InkWellType.White,
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            if (enabled) {
              onRefresh();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.refresh_rounded,
                        size: 28,
                        color: enabled
                            ? CustomColorScheme.mainDarkBackground
                            : CustomColorScheme.clipElementInactive,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 16),
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: enabled
                              ? CustomColorScheme.successPopupButton
                              : CustomColorScheme.clipElementInactive,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Label(
                            text: remainedTransactionRefreshCount.toString(),
                            type: LabelType.GeneralBold,
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: AppLocalizations.of(context)!.refreshTransactions,
                      type: LabelType.GeneralBold,
                      color: enabled
                          ? Colors.white
                          : CustomColorScheme.clipElementInactive,
                    ),
                    if (hintMessage != null)
                      Label(
                        text: hintMessage,
                        type: LabelType.GeneralBold,
                        color: CustomColorScheme.clipElementInactive,
                        fontSize: 10,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EducationCenterMenu extends StatelessWidget {
  final HomeScreenCubit homeScreenCubit;
  const EducationCenterMenu({Key? key, required this.homeScreenCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      color: CustomColorScheme.mainDarkBackground,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomMaterialInkWell(
            type: InkWellType.White,
            onTap: () {
              removeModal();
              homeScreenCubit.stopForeignSession();
              NavigatorManager.navigateTo(
                context,
                EducationCenterPage.routeName,
                params: {
                  'tab': '0',
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Label(
                    type: LabelType.General,
                    fontWeight: FontWeight.w500,
                    text: AppLocalizations.of(context)!.educationCenter,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          CustomMaterialInkWell(
            type: InkWellType.White,
            onTap: () {
              removeModal();
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Label(
                    type: LabelType.General,
                    fontWeight: FontWeight.w500,
                    text: AppLocalizations.of(context)!.blog,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          CustomMaterialInkWell(
            type: InkWellType.White,
            onTap: () {
              removeModal();
              homeScreenCubit.stopForeignSession();
              NavigatorManager.navigateTo(
                context,
                ContactUsPage.routeName,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Label(
                    type: LabelType.General,
                    fontWeight: FontWeight.w500,
                    text: AppLocalizations.of(context)!.contactUs,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
