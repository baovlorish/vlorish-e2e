import 'package:burgundy_budgeting_app/domain/model/response/institution_account_response.dart';
import 'package:burgundy_budgeting_app/ui/model/account.dart';
import 'package:burgundy_budgeting_app/ui/model/manual_account.dart';

import 'bank_account.dart';

class AccountGroup {
  final String id;
  final String institutionName;
  final bool isLoginRequired;
  final List<Account> accounts;
  final String? ownerName;
  final bool isOwnerBudgetUser;
  final bool isInvestment;

  bool get isManual => accounts.isNotEmpty && accounts.first is ManualAccount;

  bool get hasConfiguredAccounts {
    for (var item in accounts) {
      if (item.isConfigured) return true;
    }
    return false;
  }

  AccountGroup(
      {required this.id,
      required this.ownerName,
      required this.isOwnerBudgetUser,
      required this.institutionName,
      required this.isLoginRequired,
      required this.accounts,
      this.isInvestment = false});

  factory AccountGroup.fromResponse(InstitutionResponse response) {
    var _accounts = <BankAccount>[];

    for (var item in response.bankAccounts) {
      _accounts.add(
        BankAccount.fromInstitutionResponse(
          item,
          bankName: response.institutionName,
        ),
      );
    }

    return AccountGroup(
      id: response.id,
      institutionName: response.institutionName,
      isInvestment: response.isInvestment,
      isLoginRequired: response.isLoginRequired,
      accounts: _accounts,
      isOwnerBudgetUser: response.isOwnerBudgetUser,
      ownerName: response.ownerName,
    );
  }

  AccountGroup copyWith({
    String? id,
    String? institutionName,
    bool? isLoginRequired,
    List<Account>? accounts,
  }) {
    return AccountGroup(
      id: id ?? this.id,
      institutionName: institutionName ?? this.institutionName,
      isLoginRequired: isLoginRequired ?? this.isLoginRequired,
      accounts: accounts ?? this.accounts,
      ownerName: ownerName,
      isOwnerBudgetUser: isOwnerBudgetUser,
    );
  }
}
