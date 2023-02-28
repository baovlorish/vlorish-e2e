import 'dart:developer';

import 'package:burgundy_budgeting_app/domain/model/request/setup_bank_type_request.dart';
import 'package:burgundy_budgeting_app/domain/repository/accounts_transactions_repository.dart';
import 'package:burgundy_budgeting_app/domain/repository/networth_repository.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signup/add_card/add_account_popup/add_account_popup_state.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class AddAccountPopupCubit extends Cubit<AddAccountPopupState> {
  final Logger logger = getLogger('AddAccountPopupCubit');

  final AccountsTransactionsRepository plaidRepository;
  final NetWorthRepository netWorthRepository;

  AddAccountPopupCubit(this.plaidRepository, this.netWorthRepository)
      : super(AddAccountPopupInitialState()) {
    logger.i('Add Account Popup');
  }

  Future<List<AddPlaidAccountError>?> sendPlaidAccountsDataToBacked(
      {required Function() onSuccessCallback,
      required bool isExistingAccounts}) async {
    try {
      if (isExistingAccounts) {
        for (var item in validAccounts) {
          await netWorthRepository.setBankAccountName(
              bankAccountId: item.id, name: item.name);
          onSuccessCallback();
        }
      } else {
        var request =
            SetupBankTypeRequest.fromBankAccounts(validAccounts.toList());
        var errors = await plaidRepository.postBankAccount(
          request: request,
          successCallback: onSuccessCallback,
          errorCallback: (Exception e) {
            emit(AddAccountPopupGeneralErrorState(e.toString()));
          },
        );

        return errors;
      }
    } catch (e) {
      emit(AddAccountPopupGeneralErrorState(e.toString()));
    }
  }

  var validAccounts = <BankAccount>{};

  void validateAccount(BankAccount i, List<BankAccount> list) {
    validAccounts.removeWhere((element) => element.id == i.id);
    validAccounts.add(i);
    validateForm(list);
  }

  void unvalidateAccount(BankAccount i, List<BankAccount> list) {
    validAccounts.removeWhere((element) => element.id == i.id);
    validateForm(list);
  }

  void validateForm(List<BankAccount> list) {
    if (validAccounts.isEmpty) {
      emit(AddAccountPopupValidateState(false));
      return;
    }
    var _nameSet = <String>{};
    var accountWithNonUniqueNameIds = <String>[];
    for (var item in validAccounts) {
      if (item.name.isNotEmpty && !_nameSet.add(item.name)) {
        accountWithNonUniqueNameIds.add(item.id);
      }
    }
    if (validAccounts.length == _nameSet.length &&
        validAccounts.length == list.length) {
      emit(AddAccountPopupValidateState(true));
    } else if (validAccounts.isNotEmpty &&
        validAccounts.length != _nameSet.length) {
      var errors = <AddPlaidAccountError>[];
      for (var item in accountWithNonUniqueNameIds) {
        errors.add(AddPlaidAccountError.withNonUniqueName(item));
      }
      emit(AddAccountPopupAccountErrorState(errors: errors));
    } else {
      emit(AddAccountPopupAccountErrorState(errors: []));
    }
  }

  void unvalidateAccountsWithErrors(List<AddPlaidAccountError> errors) {
    emit(AddAccountPopupAccountErrorState(errors: errors));
  }
}
