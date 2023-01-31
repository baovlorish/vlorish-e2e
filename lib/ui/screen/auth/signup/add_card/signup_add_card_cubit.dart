import 'dart:js';

import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/domain/model/general/roles.dart';
import 'package:burgundy_budgeting_app/domain/repository/accounts_transactions_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/networth_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/user_repository.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/add_account_from_plaid_popup.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/signup_add_card_state.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/subscription/subscription_page.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class SignupAddCardCubit extends Cubit<SignupAddCardState> {
  final Logger logger = getLogger('SignupPersonalDataCubit');
  final AccountsTransactionsRepository repository;
  final NetWorthRepository netWorthRepository;
  final UserRepository userRepository;

  UserRole? role;

  SignupAddCardCubit(
    this.repository,
    this.userRepository,
    this.netWorthRepository,
  ) : super(SignupAddCardInitial()) {
    logger.i('Add Card Page');
    init();
  }

  void connectPlaidAccount(BuildContext context, bool isStandard) async {
    try {
      emit(LoadingAddCardState());
      await repository.openPlaidModalWindow(
        onSuccessCallback: (bankAccounts) async {
          await updateUserData();
          onPlaidPopupSuccessClose(context, bankAccounts, isStandard);
        },
        onExitCallback: () {
          emit(SignupAddCardInitial());
        },
        onError: (Exception e) {
          emit(SignupAddCardInitial());
        },

        ///transactions index
        index: 0,
      );
    } catch (e) {
      emit(ErrorAddCardState(e.toString()));
      rethrow;
    }
  }

  void onPlaidPopupSuccessClose(
      BuildContext context, List<BankAccount> bankAccounts, bool isStandard) async {
    emit(LoadedAddCardState());
    var isDismissible = role != null && role!.isCoach;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AddAccountFromPlaidPopup(
          browserBackButtonDismissible: false,
          showCancelOption: isDismissible,
          isStandardSubscription: isStandard,
          businessNameList: [],
          onCancel: () => NavigatorManager.navigateTo(
            context,
            BudgetPersonalPage.routeName,
            transition: TransitionType.material,
          ),
          bankAccounts: bankAccounts,
          plaidRepository: repository,
          netWorthRepository: netWorthRepository,
          onSuccessCallback: () async {
            NavigatorManager.navigateTo(
              context,
              BudgetPersonalPage.routeName,
              transition: TransitionType.material,
            );
          },
        );
      },
    );
  }

  Future<void> updateUserData() async{
    await userRepository.updateUserData();
  }

  void userNotSubscribed(BuildContext context, String message) {
    NavigatorManager.navigateTo(
      context,
      SubscriptionPage.routeName,
      transition: TransitionType.material,
    );
    emit(ErrorAddCardState(message));
  }

  void init() async {
    emit(LoadingAddCardState());
    var user = await userRepository.getUserData();
    role = user.role;
    emit(SignupAddCardInitial());
  }

  void referralConvert() async {
    var user = await userRepository.getUserData();
    context.callMethod('convert', [user.subscription!.customerEmail]);
  }
}
