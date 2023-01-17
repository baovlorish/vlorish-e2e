import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/request/add_manual_account_request.dart';
import 'package:burgundy_budgeting_app/domain/repository/accounts_transactions_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/budget_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/networth_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/account.dart';
import 'package:burgundy_budgeting_app/ui/model/account_group.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/model/manual_account.dart';
import 'package:burgundy_budgeting_app/ui/screen/transactions/transactions_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'manage_accounts_state.dart';

class ManageAccountsCubit extends Cubit<ManageAccountsState> {
  final Logger logger = getLogger('ManageAccountsCubit');
  final UserRepository userRepository;
  final AccountsTransactionsRepository accountsTransactionsRepository;
  final BudgetRepository budgetRepository;
  final NetWorthRepository netWorthRepository;

  ManageAccountsCubit(this.userRepository, this.accountsTransactionsRepository,
      this.budgetRepository, this.netWorthRepository)
      : super(ManageAccountsInitial()) {
    logger.i('ManageAccounts Page');
    getAccounts();
  }

  void navigateToTransactionsPage(BuildContext context) {
    NavigatorManager.navigateTo(
      context,
      TransactionsPage.routeName,
      replace: true,
    );
  }

  Future<List<String>> businessNameList() async {
    try {
      var businesses = await budgetRepository.getBusinessList();
      var businessNameList = <String>[];
      businesses.forEach((element) {
        businessNameList.add(element.name);
      });
      return businessNameList;
    } catch (e) {
      emit(ManageAccountsError(e.toString()));
      rethrow;
    }
  }

  Future<void> getAccounts() async {
    emit(ManageAccountsLoading());
    await updateAccounts();
  }

  Future<void> updateAccounts() async {
    try {
      var accounts = await accountsTransactionsRepository.getAccounts();
      emit(ManageAccountsLoaded(accounts));
    } catch (e) {
      emit(ManageAccountsError(e.toString()));
      rethrow;
    }
  }

  Future<String?> addManualAccount(
      {required String name,
      required int usageType,
      required int accountType,
      String? businessName}) async {
    try {
      var error = await accountsTransactionsRepository.addManualAccount(
        request: AddManualAccountRequest(
          name: name,
          usageType: usageType,
          accountType: accountType,
          businessName: businessName,
        ),
        errorCallback: (Exception e) {
          return 'Error';
        },
      );

      await updateAccounts();
      return error;
    } catch (e) {
      emit(ManageAccountsError(e.toString()));
      rethrow;
    }
  }

  void addPlaidAccount({
    required Function(List<BankAccount>) onSuccessCallback,
    required int type,
  }) async {
    try {
      emit(ManageAccountsLoading());
      await accountsTransactionsRepository.openPlaidModalWindow(
        onSuccessCallback: (List<BankAccount> bankAccounts) {
          onSuccessCallback(bankAccounts);
          updateAccounts();
        },
        onExitCallback: () {
          updateAccounts();
        },
        onError: (Exception e) {
          emit(ManageAccountsError(e.toString()));
          updateAccounts();
        },
        index: type,
      );
    } catch (e) {
      emit(ManageAccountsError(e.toString()));
      rethrow;
    }
  }

  Future<void> changeMuteMode(Account account) async {
    try {
      var isSuccessful = await accountsTransactionsRepository.changeMuteMode(
          account.id, !account.isMuted, account is ManualAccount);
      if (isSuccessful) {
        logger
            .i('User ${account.isMuted ? 'unmuted' : 'muted'} ${account.name}');
        await updateAccounts();
      } else {
        emit(ManageAccountsError(
            accountsTransactionsRepository.generalErrorMessage));
      }
    } catch (e) {
      emit(ManageAccountsError(e.toString()));
      rethrow;
    }
  }

  Future<void> deleteInstitution(AccountGroup institution) async {
    try {
      var isSuccessful = await accountsTransactionsRepository
          .deleteInstitutionAccount(institution.id);
      if (isSuccessful) {
        logger.i('User deleted ${institution.institutionName}');
        await updateAccounts();
      } else {
        emit(ManageAccountsError(
            accountsTransactionsRepository.generalErrorMessage));
      }
    } catch (e) {
      emit(ManageAccountsError(e.toString()));
      rethrow;
    }
  }

  Future<void> deleteManualAccount(Account item) async {
    try {
      var isSuccessful =
          await accountsTransactionsRepository.deleteManualAccount(item.id);
      if (isSuccessful) {
        logger.i('User deleted ${item.name}');
        await updateAccounts();
      } else {
        emit(ManageAccountsError(
            accountsTransactionsRepository.generalErrorMessage));
      }
    } catch (e) {
      emit(ManageAccountsError(e.toString()));
      rethrow;
    }
  }

  Future<void> loginWithPlaid(String id, context) async {
    try {
      await accountsTransactionsRepository.openPlaidModalWindowUpdateMode(
          id: id,
          onSuccessCallback: () async {
            await updateAccounts();
            await BlocProvider.of<HomeScreenCubit>(context).updateUserData();
          });
    } catch (e) {
      emit(ManageAccountsError(e.toString()));
      rethrow;
    }
  }

  Future<void> manageInstitution(String id,
      {required Function onSuccessCallback}) async {
    try {
      await accountsTransactionsRepository
          .openPlaidModalWindowUpdateAccountsMode(
              id: id,
              onSuccessCallback: (List<BankAccount> bankAccounts) {
                try {
                  onSuccessCallback(bankAccounts);
                } catch (e) {
                  emit(ManageAccountsError(e.toString()));
                }
                updateAccounts();
              });
    } catch (e) {
      emit(ManageAccountsError(e.toString()));
      rethrow;
    }
  }
}
