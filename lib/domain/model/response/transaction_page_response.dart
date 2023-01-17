import 'package:burgundy_budgeting_app/domain/model/response/transaction_response.dart';

class TransactionPageResponse {
  final List<TransactionResponse> transactions;
  final List<TransactionResponse> splittedTransactions;
  final int pageNumber;
  final int totalPages;

  final String? budgetOwnerId;

  TransactionPageResponse(
      {required this.transactions,
      required this.splittedTransactions,
      required this.pageNumber,
      required this.totalPages,
      required this.budgetOwnerId});

  factory TransactionPageResponse.fromJson(Map<String, dynamic> json) {
    var transactions = <TransactionResponse>[];
    for (var item in json['transactions']) {
      transactions.add(TransactionResponse.fromJson(item));
    }
    var splittedTransactions = <TransactionResponse>[];
    for (var item in json['splittedTransactions']) {
      splittedTransactions.add(TransactionResponse.fromJson(item));
    }
    return TransactionPageResponse(
      transactions: transactions,
      splittedTransactions: splittedTransactions,
      totalPages: json['totalPages'],
      pageNumber: json['pageNumber'],
      budgetOwnerId:
          json['budgetOwnerId'] ?? json['budgetUserId'] ?? json['userId'],
    );
  }
}
