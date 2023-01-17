import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_cubit.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_google_code/signin_google_code_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_layout.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/signup_add_card_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/employment/signup_employment_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/experience/signup_experience_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/landing/signup_landing_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/mail_code/signup_mail_code_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/password/signup_password_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/personal_data/signup_personal_data_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/business/budget_business_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/category_management/category_management_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/contact_us/contact_us_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/debts/debts_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/education_center/education_center_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/fi_score/fi_score_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/add_goal/add_goal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/archived_goals/archived_goals_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/edit_goal/edit_goal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/goals/goals/goals_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_investment/add_investment_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_retirement/add_retirement_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/add_retirement/edit_retirement_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/edit_investment/edit_investment_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/investments/investments/investments_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_accounts/manage_accounts_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/net_worth/net_worth_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/not_found/not_found_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/code/email_sent_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/landing/pass_recovery_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/policies/privacy_policy_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/policies/terms_and_conditions_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/policies/terms_referral_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_details/profile_details_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/referral/referral_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/retirement/retirement_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/tax/tax_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/transactions/transactions_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigatorManager with DiProvider {
  static FluroRouter router = FluroRouter();
  static final NavigatorManager singleton = NavigatorManager._internal();

  factory NavigatorManager() => singleton;

  NavigatorManager._internal() {
    _configureRoutes();
  }

  void _configureRoutes() {
    router.notFoundHandler = NotFoundPage.initHandler(router, this);

    var redirectUnauthorizedOptions = BlocProvider<SigninCubit>(
      create: (_) => SigninCubit(authRepository),
      child: SigninLayout(),
    );

    SigninPage.initRoute(router, this);
    SigninGoogleCodePage.initRoute(router, this);
    PassRecoveryPage.initRoute(router, this);
//    SplashScreen.initRoute(router, this);
    SignupLandingPage.initRoute(router, this);
    SignupPasswordPage.initRoute(router, this);
    SignupMailCodePage.initRoute(router, this);
    SignupPersonalDataPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    SignupAddCardPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    SignupEmploymentPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    SignupExperiencePage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    RecoveryMailCodePage.initRoute(router, this);
    SubscriptionPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    PrivacyPolicyPage.initRoute(router);
    TermsAndConditionsPage.initRoute(router);
    TermsReferralPage.initRoute(router);
    BudgetPersonalPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    ProfileOverviewPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    ProfileDetailsPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    BudgetBusinessPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    TransactionsPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    ManageAccountsPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    NetWorthPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    DebtsPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    TaxPage.initRoute(router, this, defaultRoute: redirectUnauthorizedOptions);
    FiScorePage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    InvestmentsPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    AddInvestmentPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    EditInvestmentPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    AddRetirementPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    EditRetirementPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    GoalsPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    AddGoalPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    EditGoalPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    ArchivedGoalsPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    RetirementPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    CategoryManagementPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    ManageUsersPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    EducationCenterPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    ReferralPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
    ContactUsPage.initRoute(router, this,
        defaultRoute: redirectUnauthorizedOptions);
  }

  static void navigateTo(BuildContext context, String routeName,
      {TransitionType? transition = TransitionType.fadeIn,
      Duration? transitionDuration = const Duration(milliseconds: 600),
      RouteSettings? routeSettings,
      Map<String, String>? params,
      bool replace = false,
      bool clearStack = false}) {
    var path = routeName;
    if (params != null) {
      path = '$path?';
      params.forEach((key, value) {
        path = '$path$key=$value&';
      });
      path = path.substring(0, path.length - 1);
    }
    router.navigateTo(
      context,
      path,
      transition: transition,
      transitionDuration: transitionDuration,
      routeSettings: routeSettings,
      replace: replace,
      clearStack: clearStack,
    );
  }

  static void navigateBack(BuildContext context) {
    router.pop(
      context,
    );
  }
}
