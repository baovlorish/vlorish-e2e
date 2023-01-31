import 'dart:async';

import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/request/add_manual_account_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/change_bank_account_mute_mode_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/change_manual_account_mute_mode_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/setup_bank_type_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/transactions_page_request.dart';
import 'package:burgundy_budgeting_app/domain/model/response/exchange_public_token_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/institution_account_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/transaction_page_response.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_bank_account_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_institution_account_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_transactions_service.dart';
import 'package:burgundy_budgeting_app/domain/service/plaid/plaid_js.dart';
import 'package:burgundy_budgeting_app/domain/service/plaid/plaid_link.dart';
import 'package:burgundy_budgeting_app/domain/service/user_data_service.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/model/transactions_filter_model.dart';
import 'package:burgundy_budgeting_app/ui/model/account_group.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/model/filter_parameters_model.dart';
import 'package:burgundy_budgeting_app/ui/model/investment_institution_account.dart';
import 'package:burgundy_budgeting_app/ui/model/manual_account.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:burgundy_budgeting_app/ui/model/transaction_model.dart';
import 'package:burgundy_budgeting_app/ui/model/transactions_statistics_model.dart';
import 'package:burgundy_budgeting_app/utils/logger.dart';

abstract class AccountsTransactionsRepository {
  abstract final String generalErrorMessage;

  AccountsTransactionsRepository(
      ApiInstitutionAccountService institutionService,
      ApiBankAccountService bankAccountService,
      ApiTransactionsService transactionsService,
      UserDataService userDataService);

  Future<void> openPlaidModalWindow({
    required Function(List<BankAccount>) onSuccessCallback,
    required Function() onExitCallback,
    required Function(Exception e) onError,
    required int index,
  });

  Future<void> openPlaidModalWindowUpdateMode({
    required String id,
    required Function() onSuccessCallback,
  });

  Future<List<AddPlaidAccountError>?> postBankAccount({
    required SetupBankTypeRequest request,
    required Function(Exception e) errorCallback,
    required Function() successCallback,
  });

  Future<List<AccountGroup>> getAccounts();
  Future<List<InvestmentInstitutionAccount>> getAccountsByType(int type);
  Future<String?> addManualAccount({
    required AddManualAccountRequest request,
    required Function(Exception e) errorCallback,
  });

  Future<bool> changeMuteMode(String accountId, bool isMuted, bool isManual);

  Future<bool> deleteInstitutionAccount(String accountId);

  Future<bool> deleteManualAccount(String id);

  Future<List<BankAccount>> getBankAccounts();

  Future<TransactionListModel> getTransactionPage(
    TransactionsPageRequest request,
  );

  Future<bool> setTransactionCategory(
      String categoryId, List<String> transactionIds, bool shouldBeRemembered);

  Future<TransactionsStatisticsModel> getStatistics({
    required TransactionFiltersModel transactionFiltersModel,
  });

  Future<FilterParametersModel> getFilterParameters();

  Future<bool> setTransactionNote(String note, String transactionId);

  Future<bool> deleteTransactionNote(String transactionId);

  Future<bool> splitTransactions(
      {required String transactionIdToSplit,
      required List<SplitChildRequestModel> childsOfSplit,
      required bool shouldBeRemembered});

  Future<bool> uniteTransactions(String splitTransactionId);

  Future<String?> addNoteReply({required String note, required String noteId});

  Future<bool> editTransactionNoteReply(String note, String replyId);

  Future<bool> deleteTransactionNoteReply(String replyId);

  Future<MemoNoteModel?> fetchNote(String transactionId);

  Future<void> openPlaidModalWindowUpdateAccountsMode({
    required String id,
    required Function(List<BankAccount>) onSuccessCallback,
  });
}

class AccountsTransactionsRepositoryImpl
    implements AccountsTransactionsRepository {
  var logger = getLogger('AccountsTransactionsRepositoryImpl');

  @override
  final String generalErrorMessage = 'Sorry, something went wrong';

  final ApiInstitutionAccountService institutionService;

  final ApiBankAccountService bankAccountService;

  final ApiTransactionsService transactionsService;
  final UserDataService userDataService;

  AccountsTransactionsRepositoryImpl(this.institutionService,
      this.bankAccountService, this.transactionsService, this.userDataService);

  Future<void> onSuccessCallbackInner(
    String publicToken,
    PlaidJsSuccessMetadata metadata,
    Function _successCallback,
    Function _errorCallback,
  ) async {
    logger.i('onSuccess: $publicToken \n metadata: ${metadata.institution}');

    var response = await institutionService.exchangePublicToken(publicToken);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var bankAccounts = <BankAccount>[];
      for (var item in response.data['bankAccounts']!) {
        bankAccounts.add(
          BankAccount.fromPlaidAccountsResponse(
            ExchangePublicTokenResponse.fromJson(item),
          ),
        );
      }
      _successCallback.call(bankAccounts);
    } else {
      _errorCallback(
          CustomException(response.data['message'] ?? generalErrorMessage));
    }
  }

  void onEventCallbackInner(
    String event,
    PlaidJsEventMetadata metadata,
    Function(Exception e) _onError,
  ) {
    if (event == 'ERROR' &&
        (metadata.error_code.isNotEmpty ||
            metadata.errorType.isNotEmpty ||
            metadata.errorMessage.isNotEmpty)) {
      _onError(CustomException(
        metadata.errorMessage.isNotEmpty
            ? metadata.errorMessage
            : generalErrorMessage,
      ));
    }
  }

  void onExitCallbackInner(
    PlaidJsError? error,
    PlaidJsExitMetadata metadata,
    Function() _exitCallback,
    Function(Exception e) _onError,
  ) {
    _exitCallback.call();

    if (error != null) {
      _onError.call(CustomException(error.displayMessage));
      return;
    }
  }

  @override
  Future<void> openPlaidModalWindow({
    required Function(List<BankAccount>) onSuccessCallback,
    required Function() onExitCallback,
    required Function(Exception e) onError,
    required int index,
  }) async {
    var response = await institutionService.getPlaidLinkToken(index);
    var token = response.data['linkToken'] as String;
    await PlaidLink.open(
      PlaidLinkOptions(
        linkToken: token,
      ),
      onSuccess: (publicToken, metadata) {
        onSuccessCallbackInner(
          publicToken,
          metadata,
          onSuccessCallback,
          onError,
        );
      },
      onEvent: (event, metadata) {
        onEventCallbackInner(
          event,
          metadata,
          onError,
        );
      },
      onExit: (error, metadata) {
        onExitCallbackInner(
          error,
          metadata,
          onExitCallback,
          onError,
        );
      },
    );
  }

  @override
  Future<void> openPlaidModalWindowUpdateMode({
    required String id,
    required Function() onSuccessCallback,
  }) async {
    var response = await institutionService.updateMode(id);
    var token = response.data['linkToken'];
    await PlaidLink.open(
      PlaidLinkOptions(linkToken: token),
      onSuccess: (publicToken, metadata) => () async {
        await institutionService.completeUpdateMode(id);
        onSuccessCallback();
      }(),
      onExit: (_, metadata) async {
        await institutionService.completeUpdateMode(id);
        onSuccessCallback();
      },
    );
  }

  @override
  Future<List<AddPlaidAccountError>?> postBankAccount({
    required SetupBankTypeRequest request,
    required Function(Exception e) errorCallback,
    required Function() successCallback,
  }) async {
    var response = await bankAccountService.postBankAccount(request);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      successCallback();
    } else if (response.statusCode == 400) {
      var _listOfInvalidAccounts = <AddPlaidAccountError>[];

      (response.data as List).forEach((element) {
        _listOfInvalidAccounts.add(AddPlaidAccountError.fromJson(element));
      });
      return _listOfInvalidAccounts;
    } else {
      errorCallback(CustomException(generalErrorMessage));
    }
  }

  @override
  Future<List<AccountGroup>> getAccounts() async {
    var resultList = <AccountGroup>[];
    var response = await institutionService.getInstitutionAccount();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      for (var item in response.data['institutionAccounts']) {
        resultList.add(
          AccountGroup.fromResponse(
            InstitutionResponse.fromJsonMap(item),
          ),
        );
      }
      for (var item in response.data['investmentAccounts']) {
        resultList.add(
          AccountGroup.fromResponse(
            InstitutionResponse.fromJsonMap(item, isInvestment: true),
          ),
        );
      }
      //adding manual AccountGroup
      var manualAccounts = <ManualAccount>[];
      var otherUserManualAccounts = <ManualAccount>[];
      for (var item in response.data['manualAccounts']) {
        var account = ManualAccount.fromJson(item);
        if ((userDataService.user?.role.isPartner == true) ^
            account.isOwnerBudgetUser) {
          manualAccounts.add(account);
        } else {
          otherUserManualAccounts.add(account);
        }
      }
      if (manualAccounts.isNotEmpty) {
        resultList.add(
          AccountGroup(
            id: 'manual',
            isLoginRequired: true,
            institutionName: 'Manual',
            accounts: manualAccounts,
            ownerName: manualAccounts.first.ownerName,
            isOwnerBudgetUser: manualAccounts.first.isOwnerBudgetUser,
          ),
        );
      }
      if (otherUserManualAccounts.isNotEmpty) {
        resultList.add(
          AccountGroup(
            id: 'manual_partner',
            isLoginRequired: true,
            institutionName: 'Manual',
            accounts: otherUserManualAccounts,
            ownerName: otherUserManualAccounts.first.ownerName,
            isOwnerBudgetUser: otherUserManualAccounts.first.isOwnerBudgetUser,
          ),
        );
      }
      return resultList;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<List<InvestmentInstitutionAccount>> getAccountsByType(int type) async {
    var resultList = <InvestmentInstitutionAccount>[];
    var response = await institutionService.getInstitutionAccountByType(type);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      for (var item in response.data['items']) {
        resultList.add(
          InvestmentInstitutionAccount.fromJson(item),
        );
      }
      return resultList;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<String?> addManualAccount({
    required AddManualAccountRequest request,
    required Function(Exception e) errorCallback,
  }) async {
    var response = await bankAccountService.addManualAccount(
        request, request.isPersonalType);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
    } else if (response.statusCode == 400) {
      return response.data['message'];
    } else {
      throw CustomException(generalErrorMessage);
    }
  }

  @override
  Future<bool> changeMuteMode(
      String accountId, bool isMuted, bool isManual) async {
    var isSuccessful = false;
    var response;
    if (isManual) {
      response = await bankAccountService.changeManualAccountMuteMode(
          ChangeManualAccountMuteModeRequest(
              bankAccountId: accountId, isMuted: isMuted));
    } else {
      response = await bankAccountService.changeBankAccountMuteMode(response =
          ChangeBankAccountMuteModeRequest(
              bankAccountId: accountId, isMuted: isMuted));
    }
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      isSuccessful = true;
    }
    return isSuccessful;
  }

  @override
  Future<bool> deleteInstitutionAccount(String accountId) async {
    var isSuccessful = false;
    var response = await institutionService.deleteInstitutionAccount(accountId);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      isSuccessful = true;
    }
    return isSuccessful;
  }

  @override
  Future<bool> deleteManualAccount(String id) async {
    var isSuccessful = false;
    var response = await bankAccountService.deleteManualAccount(id);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      isSuccessful = true;
    }
    return isSuccessful;
  }

  @override
  Future<List<BankAccount>> getBankAccounts() async {
    var result = <BankAccount>[];
    var response = await bankAccountService.getBankAccount();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      for (var item in response.data['bankAccounts']) {
        var bankAccount = BankAccount.fromBankAccountsResponseItem(item);
        result.add(bankAccount);
      }
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
    return result;
  }

  @override
  Future<TransactionListModel> getTransactionPage(
    TransactionsPageRequest request,
  ) async {
    var response = await transactionsService.getTransactionsPage(request);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return TransactionListModel.fromResponse(
        TransactionPageResponse.fromJson(response.data),
      );
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> setTransactionCategory(String categoryId,
      List<String> transactionIds, bool shouldBeRemembered) async {
    var isSuccessful = false;
    var response = await transactionsService.setTransactionCategory(
        categoryId, transactionIds, shouldBeRemembered);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      isSuccessful = true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
    return isSuccessful;
  }

  @override
  Future<TransactionsStatisticsModel> getStatistics({
    required TransactionFiltersModel transactionFiltersModel,
  }) async {
    var response = await transactionsService.getStatistics(
      transactionFiltersModel,
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return TransactionsStatisticsModel.fromJson(response.data);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<FilterParametersModel> getFilterParameters() async {
    var response = await transactionsService.getFilterParameters();
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return FilterParametersModel.fromJson(response.data);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> setTransactionNote(String note, String transactionId) async {
    var response =
        await transactionsService.setTransactionNote(note, transactionId);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(
        response.data['errors']
                ?.toString()
                .replaceAll(RegExp(r'[\[\]\{\}]'), '') ??
            generalErrorMessage,
      );
    }
  }

  @override
  Future<bool> deleteTransactionNote(String transactionId) async {
    var response =
        await transactionsService.deleteTransactionNote(transactionId);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(
        response.data['errors']
                ?.toString()
                .replaceAll(RegExp(r'[\[\]\{\}]'), '') ??
            generalErrorMessage,
      );
    }
  }

  @override
  Future<bool> splitTransactions(
      {required String transactionIdToSplit,
      required List<SplitChildRequestModel> childsOfSplit,
      required bool shouldBeRemembered}) async {
    var response = await transactionsService.splitTransaction({
      'transactionIdToSplit': transactionIdToSplit,
      'shouldBeRemembered': shouldBeRemembered,
      'childsOfSplit': [
        for (var child in childsOfSplit) child.toJson(),
      ]
    });
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(
        response.data['message'] ?? generalErrorMessage,
      );
    }
  }

  @override
  Future<bool> uniteTransactions(String splitTransactionId) async {
    var response =
        await transactionsService.uniteTransactions(splitTransactionId);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(
        response.data['message'] ?? generalErrorMessage,
      );
    }
  }

  @override
  Future<String?> addNoteReply(
      {required String note, required String noteId}) async {
    var response =
        await transactionsService.addTransactionNoteReply(note, noteId);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data['transactionNoteReplyId'];
    } else {
      throw CustomException(
        response.data['errors']
                ?.toString()
                .replaceAll(RegExp(r'[\[\]\{\}]'), '') ??
            generalErrorMessage,
      );
    }
  }

  @override
  Future<bool> deleteTransactionNoteReply(String replyId) async {
    var response =
        await transactionsService.deleteTransactionNoteReply(replyId);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(
        response.data['errors']
                ?.toString()
                .replaceAll(RegExp(r'[\[\]\{\}]'), '') ??
            generalErrorMessage,
      );
    }
  }

  @override
  Future<bool> editTransactionNoteReply(String note, String replyId) async {
    var response =
        await transactionsService.editTransactionNoteReply(note, replyId);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(
        response.data['errors']
                ?.toString()
                .replaceAll(RegExp(r'[\[\]\{\}]'), '') ??
            generalErrorMessage,
      );
    }
  }

  @override
  // ignore: body_might_complete_normally_nullable
  Future<MemoNoteModel?> fetchNote(String transactionId) async {
    var response = await transactionsService.fetchNote(transactionId);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      if (response.data['note'] != null) {
        return MemoNoteModel.fromTransactionJson(response.data['note']);
      }
    } else {
      throw CustomException(
        response.data['message'] ?? generalErrorMessage,
      );
    }
  }

  @override
  Future<void> openPlaidModalWindowUpdateAccountsMode({
    required String id,
    required Function(List<BankAccount>) onSuccessCallback,
  }) async {
    var response =
        await institutionService.updateMode(id, accountsUpdate: true);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var token = response.data['linkToken'];
      await PlaidLink.open(
        PlaidLinkOptions(linkToken: token),
        onSuccess: (publicToken, metadata) => () async {
          var accounts = await _onSuccess(id);
          onSuccessCallback.call(accounts);
        },
        onEvent: (event, metadata) async {
          if (event == 'HANDOFF') {
            var accounts = await _onSuccess(id);
            onSuccessCallback.call(accounts);
          }
        },
      );
    } else {
      throw (CustomException(response.data['message'] ?? generalErrorMessage));
    }
  }

  Future<List<BankAccount>> _onSuccess(String id) async {
    var response =
        await institutionService.completeUpdateMode(id, accountsUpdate: true);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      var bankAccounts = <BankAccount>[];
      for (var item in response.data['bankAccounts']) {
        var account = BankAccount.fromPlaidAccountsResponse(
            ExchangePublicTokenResponse.fromJson(item));
        if (!account.isConfigured) bankAccounts.add(account);
      }
      return bankAccounts;
    } else {
      throw (CustomException(response.data['message'] ?? generalErrorMessage));
    }
  }
}

class AddPlaidAccountError {
  final String id;
  final bool nonUniqueName;
  final bool incorrectType;
  final String? otherMessages;
  final String? businessName;

  AddPlaidAccountError(
      {required this.id,
      required this.nonUniqueName,
      required this.incorrectType,
      this.otherMessages,
      this.businessName});

  factory AddPlaidAccountError.fromJson(Map<String, dynamic> json) {
    var otherMessages = '';
    var nonUniqueName = false;
    var incorrectType = false;
    for (var item in json['Messages']) {
      if (item ==
          'Specified Account Type is not appropriate according to External Account Type and Subtype') {
        incorrectType = true;
      } else if (item == 'This Account name already exists') {
        nonUniqueName = true;
      } else {
        otherMessages += '$item ';
      }
    }

    return AddPlaidAccountError(
      id: json['BankAccountId'],
      nonUniqueName: nonUniqueName,
      incorrectType: incorrectType,
      otherMessages: otherMessages.isNotEmpty ? otherMessages : null,
      businessName: json['businessName'],
    );
  }

  factory AddPlaidAccountError.withNonUniqueName(String id) {
    return AddPlaidAccountError(
      id: id,
      nonUniqueName: true,
      incorrectType: false,
      businessName: null,
    );
  }

  @override
  String toString() {
    return '$id incorrectType:$incorrectType nonUniqueName:$nonUniqueName $otherMessages';
  }
}
