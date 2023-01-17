import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/model/transactions_filter_model.dart';

class TransactionsPageRequest {
  final int pageNumber;
  final int transactionsPerPage;
  final TransactionFiltersModel transactionFiltersModel;

  TransactionsPageRequest({
    required this.pageNumber,
    required this.transactionFiltersModel,
    this.transactionsPerPage = 50,
  });

  Map<String, dynamic> toJson() {
    var json = transactionFiltersModel.toMap();
    json.addAll({
      'pageNumber': pageNumber,
      'pageSize': transactionsPerPage,
    });
    return json;
  }
}
