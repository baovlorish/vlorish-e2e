import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_loading_indicator.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/navigation_line_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_appbar.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_menu/home_screen_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_menu/home_screen_menu_cubit.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/signup_add_card_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/employment/signup_employment_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/experience/signup_experience_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/mail_code/signup_mail_code_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/personal_data/signup_personal_data_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum Tabs {
  BudgetPersonal,
  BudgetBusiness,
  Debt,
  NetWorth,
  Goals,
  Tax,
  Investments,
  Retirement,
  Planning,
  FIScore,
  AppbarTransactions,
  AppbarHelp,
}

class HomeScreen extends StatefulWidget {
  final Widget bodyWidget;
  final Tabs? currentTab;
  final String title;
  final Widget? headerWidget;

  const HomeScreen({
    required this.bodyWidget,
    this.currentTab,
    required this.title,
    this.headerWidget,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSmall = false;
  late final HomeScreenCubit homeScreenCubit;

  @override
  void initState() {
    homeScreenCubit = BlocProvider.of<HomeScreenCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isSmall = MediaQuery.of(context).size.width < 650;
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        var currentForeignSession = homeScreenCubit.currentForeignSession;
        if (state is HomeScreenLoaded) {
          if (!state.user.isRegistrationCompleted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              NavigatorManager.navigateTo(
                context,
                chooseStep(state.user.registrationStep),
                params: {'role': state.user.role.mappedValue.toString()},
              );
            });
          }
        }
        return Scaffold(
          appBar: HomeAppBar(
            context,
            isSmall: isSmall,
            currentTab: widget.currentTab,
            loginRequiringInstitutions: (state is HomeScreenLoaded)
                ? state.user.getLoginRequiringInstitutionsAsString()
                : '',
            initials: (state is HomeScreenLoaded)
                ? homeScreenCubit.getInitials()
                : null,
            imageUrl: (state is HomeScreenLoaded) ? state.user.imageUrl : null,
            remainedTransactionRefreshCount: (state is HomeScreenLoaded)
                ? state.user.remainedTransactionRefreshCount
                : 0,
            hasConfiguredAccounts: (state is HomeScreenLoaded)
                ? state.user.hasConfiguredBankAccounts
                : false,
            hasInstitutionAccounts: (state is HomeScreenLoaded)
                ? state.user.hasInstitutionAccounts
                : false,
            unreadNotificationCount: (state is HomeScreenLoaded)
                ? state.user.unreadNotificationCount
                : 0,
            homeScreenCubit: homeScreenCubit,
          ),
          backgroundColor: CustomColorScheme.homeBodyWidgetBackground,
          body: Title(
            title: widget.title,
            color: CustomColorScheme.generalBackground,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocProvider<HomeScreenMenuCubit>(
                      create: (context) => HomeScreenMenuCubit(),
                      lazy: false,
                      child: HomeScreenMenu(currentTab: widget.currentTab)),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (currentForeignSession != null)
                          NavigationLine(
                            callback: () {
                              homeScreenCubit.stopForeignSession();
                              homeScreenCubit // navigation to the current page
                                  .navigateTo(
                                      ModalRoute.of(context)!.settings.name!,
                                      context);
                            },
                            lastName: currentForeignSession.lastName,
                            firstName: currentForeignSession.firstName,
                          ),
                        if (widget.headerWidget != null)
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              16.0,
                              16.0,
                              16.0,
                              0.0,
                            ),
                            child: widget.headerWidget,
                          ),
                        state is HomeScreenLoading
                            ? CustomLoadingIndicator()
                            : widget.bodyWidget,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String chooseStep(int registrationStep) {
  switch (registrationStep) {
    case 2:
      return SignupMailCodePage.routeName;
    case 3:
      return SignupPersonalDataPage.routeName;
    case 4:
      return SignupEmploymentPage.routeName;
    case 5:
      return SignupExperiencePage.routeName;
    case 6:
      return SubscriptionPage.routeName;
    case 7:
      return SignupAddCardPage.routeName;
    default:
      return BudgetPersonalPage.routeName;
  }
}
