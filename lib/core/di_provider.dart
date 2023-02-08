import 'package:burgundy_budgeting_app/domain/network/api_client.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/repository/accounts_transactions_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/auth_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/budget_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/category_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/debt_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/goals_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/investments_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/manage_users_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/networth_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/referral_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/subscription_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/tax_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/vlorish_score_repository.dart';
import 'package:burgundy_budgeting_app/domain/service/auth_service.dart';
import 'package:burgundy_budgeting_app/domain/service/cognito_auth_service.dart';
import 'package:burgundy_budgeting_app/domain/service/foreign_session_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_auth_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_bank_account_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_budget_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_category_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_debt_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_goals_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_institution_account_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_investments_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_invites_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_net_worth_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_notification_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_referral_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_request_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_subscription_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_tax_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_transactions_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_user_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_vlorish_score_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_auth_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_bank_account_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_budget_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_category_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_debt_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_goals_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_institution_account_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_investments_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_invites_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_net_worth_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_notification_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_referrals_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_request_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_subscription_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_tax_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_transactions_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_user_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/http/impl/api_vlorish_score_service_impl.dart';
import 'package:burgundy_budgeting_app/domain/service/notification_service.dart';
import 'package:burgundy_budgeting_app/domain/service/user_data_service.dart';
import 'package:burgundy_budgeting_app/domain/service/user_support_service.dart';
import 'package:burgundy_budgeting_app/domain/storage/impl/session_storage_hive_impl.dart';
import 'package:burgundy_budgeting_app/domain/storage/session_storage.dart';
import 'package:get_it/get_it.dart';

class DiProvider implements AuthContractor, UserContractor {
  Future<void> init() async {
    GetIt.I.registerSingleton<Environment>(Environment.DEVELOP);

    // async singletons and those other depend on

    GetIt.I.registerSingletonAsync<SessionStorage>(
        () async => SessionStorageHiveImpl().init());

    GetIt.I.registerSingletonWithDependencies<ForeignSessionService>(
      () => ForeignSessionServiceImpl(GetIt.instance<SessionStorage>()),
      dependsOn: [SessionStorage],
    );

    GetIt.I.registerSingletonWithDependencies<AuthService>(
      () => CognitoAuthService(GetIt.instance<SessionStorage>(),
          GetIt.instance<ForeignSessionService>()),
      dependsOn: [SessionStorage, ForeignSessionService],
    );

    GetIt.I.registerSingletonAsync<HttpManager>(
      () async => HttpManager(GetIt.instance<AuthService>().sessionManager),
      dependsOn: [AuthService, SessionStorage],
    );

    // api services

    GetIt.I.registerSingletonWithDependencies<ApiAuthService>(
      () => ApiAuthServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<UserSupportService>(
          () => UserSupportService(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiUserService>(
      () => ApiUserServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiCategoryService>(
      () => ApiCategoryServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiBudgetService>(
      () => ApiBudgetServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiInstitutionAccountService>(
      () => ApiInstitutionAccountServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiBankAccountService>(
      () => ApiBankAccountServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiTransactionsService>(
      () => ApiTransactionsServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiSubscriptionService>(
      () => ApiSubscriptionServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiDebtsService>(
      () => ApiDebtsServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiNetWorthService>(
      () => ApiNetWorthServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiInviteService>(
      () => ApiInviteServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiRequestService>(
      () => ApiRequestServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiNotificationService>(
      () => ApiNotificationServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );
    GetIt.I.registerSingleton<NotificationService>(
      NotificationServiceImpl(),
    );

    GetIt.I.registerSingletonWithDependencies<ApiTaxService>(
      () => ApiTaxServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiInvestmentsService>(
      () => ApiInvestmentsServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiVlorishScoreService>(
      () => ApiVlorishScoreServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ApiReferralService>(
      () => ApiReferralServiceImpl(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingleton<UserDataService>(
      UserDataServiceImpl(),
    );
    // repositories

    GetIt.I.registerSingletonWithDependencies<AuthRepository>(
      () => AuthRepositoryImpl(
        GetIt.instance<AuthService>(),
        GetIt.instance<ApiAuthService>(),
      ),
      dependsOn: [AuthService, ApiAuthService],
    );

    GetIt.I.registerSingletonWithDependencies<UserRepository>(
      () => UserRepositoryImpl(
        GetIt.instance<ApiUserService>(),
        GetIt.instance<UserDataService>(),
        GetIt.instance<ApiTransactionsService>(),
        GetIt.instance<ForeignSessionService>(),
        GetIt.instance<ApiNotificationService>(),
        GetIt.instance<NotificationService>(),
        GetIt.instance<UserSupportService>(),
      ),
      dependsOn: [ApiUserService, ApiTransactionsService],
    );
    GetIt.I.registerSingletonWithDependencies<BudgetRepository>(
      () => BudgetRepositoryImpl(
        GetIt.instance<ApiBudgetService>(),
      ),
      dependsOn: [ApiBudgetService],
    );

    GetIt.I.registerSingletonWithDependencies<CategoryRepository>(
      () => CategoryRepositoryImpl(
        GetIt.instance<ApiCategoryService>(),
      ),
      dependsOn: [ApiCategoryService],
    );
    GetIt.I.registerSingletonWithDependencies<SubscriptionRepository>(
      () => SubscriptionRepositoryImpl(
        GetIt.instance<ApiSubscriptionService>(),
      ),
      dependsOn: [ApiSubscriptionService],
    );

    GetIt.I.registerSingletonWithDependencies<AccountsTransactionsRepository>(
      () => AccountsTransactionsRepositoryImpl(
        GetIt.instance<ApiInstitutionAccountService>(),
        GetIt.instance<ApiBankAccountService>(),
        GetIt.instance<ApiTransactionsService>(),
        GetIt.instance<UserDataService>(),
      ),
      dependsOn: [
        ApiInstitutionAccountService,
        ApiBankAccountService,
        ApiTransactionsService,
        HttpManager
      ],
    );

    GetIt.I.registerSingletonWithDependencies<ApiGoalsService>(
      () => ApiGoalsServiceImp(
        GetIt.instance<HttpManager>(),
      ),
      dependsOn: [HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<GoalsRepository>(
      () => GoalsRepositoryImpl(
        GetIt.instance<ApiGoalsService>(),
      ),
      dependsOn: [ApiGoalsService, HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<DebtsRepository>(
      () => DebtsRepositoryImpl(
        GetIt.instance<ApiDebtsService>(),
        GetIt.instance<ApiBankAccountService>(),
      ),
      dependsOn: [ApiDebtsService, ApiBankAccountService, HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<NetWorthRepository>(
      () => NetWorthRepositoryImpl(
        GetIt.instance<ApiNetWorthService>(),
        GetIt.instance<ApiBankAccountService>(),
        GetIt.instance<ApiDebtsService>(),
      ),
      dependsOn: [ApiNetWorthService, HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<ManageUsersRepository>(
      () => ManageUsersRepositoryImpl(
        GetIt.instance<ApiInviteService>(),
        GetIt.instance<ApiRequestService>(),
      ),
      dependsOn: [ApiInviteService, ApiRequestService, HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<TaxRepository>(
      () => TaxRepositoryImpl(
        GetIt.instance<ApiTaxService>(),
      ),
      dependsOn: [ApiTaxService, HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<InvestmentsRepository>(
      () => InvestmentsRepositoryImp(
        GetIt.instance<ApiInvestmentsService>(),
      ),
      dependsOn: [ApiInvestmentsService, HttpManager],
    );

    GetIt.I.registerSingletonWithDependencies<VlorishScoreRepository>(
      () => VlorishScoreRepositoryImpl(
        GetIt.instance<ApiVlorishScoreService>(),
      ),
      dependsOn: [ApiVlorishScoreService, HttpManager],
    );
    GetIt.I.registerSingletonWithDependencies<ReferralRepository>(
      () => ReferralRepositoryImpl(
        GetIt.instance<ApiReferralService>(),
      ),
      dependsOn: [ApiReferralService, HttpManager],
    );

    await GetIt.instance.allReady();
  }

  @override
  AuthRepository get authRepository => GetIt.I<AuthRepository>();

  @override
  UserRepository get userRepository => GetIt.I<UserRepository>();

  @override
  BudgetRepository get budgetRepository => GetIt.I<BudgetRepository>();

  @override
  SubscriptionRepository get subscriptionRepository =>
      GetIt.I<SubscriptionRepository>();

  @override
  AccountsTransactionsRepository get accountsTransactionsRepository =>
      GetIt.I<AccountsTransactionsRepository>();

  @override
  GoalsRepository get goalsRepository => GetIt.I<GoalsRepository>();

  @override
  DebtsRepository get debtsRepository => GetIt.I<DebtsRepository>();

  @override
  NetWorthRepository get netWorthRepository => GetIt.I<NetWorthRepository>();

  @override
  TaxRepository get taxRepository => GetIt.I<TaxRepository>();

  @override
  CategoryRepository get categoryRepository => GetIt.I<CategoryRepository>();

  @override
  ManageUsersRepository get manageUsersRepository =>
      GetIt.I<ManageUsersRepository>();

  @override
  InvestmentsRepository get investmentRepository =>
      GetIt.I<InvestmentsRepository>();

  @override
  VlorishScoreRepository get vlorishScoreRepository =>
      GetIt.I<VlorishScoreRepository>();

  @override
  ReferralRepository get referralRepository => GetIt.I<ReferralRepository>();
}

abstract class AuthContractor {
  AuthRepository get authRepository;
}

abstract class UserContractor {
  UserRepository get userRepository;

  SubscriptionRepository get subscriptionRepository;

  TaxRepository get taxRepository;

  AccountsTransactionsRepository get accountsTransactionsRepository;

  AuthRepository get authRepository;

  BudgetRepository get budgetRepository;

  GoalsRepository get goalsRepository;

  DebtsRepository get debtsRepository;

  NetWorthRepository get netWorthRepository;

  CategoryRepository get categoryRepository;

  ManageUsersRepository get manageUsersRepository;

  ReferralRepository get referralRepository;

  InvestmentsRepository get investmentRepository;

  VlorishScoreRepository get vlorishScoreRepository;
}
