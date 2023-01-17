import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';

class SetupBankTypeRequest {
  List<BankAccount>? _bankAccounts;

  List<BankAccount>? get bankAccounts => _bankAccounts;

  SetupBankTypeRequest({List<BankAccount>? bankAccounts}) {
    _bankAccounts = bankAccounts;
  }

  SetupBankTypeRequest.fromBankAccounts(this._bankAccounts);

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_bankAccounts != null) {
      map['bankAccounts'] =
          _bankAccounts?.map((v) => v.toMapSetTypeRequest()).toList();
    }
    return map;
  }
}
