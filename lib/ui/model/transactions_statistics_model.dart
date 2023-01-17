import 'package:burgundy_budgeting_app/domain/model/response/merchant_response.dart';
import 'package:burgundy_budgeting_app/ui/model/largest_transaction_model.dart';
import 'package:burgundy_budgeting_app/ui/model/merchant.dart';

class TransactionsStatisticsModel {
  final List<MerchantResponse> _merchants;
  final double totalExpensesByTopMerchants;
  final List<LargestTransactionModel> largestTransactions;

  TransactionsStatisticsModel(
    this._merchants, {
    required this.totalExpensesByTopMerchants,
    required this.largestTransactions,
  });

  factory TransactionsStatisticsModel.fromJson(Map<String, dynamic> json) {
    var merchants = <MerchantResponse>[];
    var transactions = <LargestTransactionModel>[];
    for (var item in json['topMerchants']) {
      merchants.add(MerchantResponse.fromJson(item));
    }
    for (var item in json['largestTransactions']) {
      transactions.add(LargestTransactionModel.fromJson(item));
    }
    return TransactionsStatisticsModel(
      merchants,
      totalExpensesByTopMerchants:
          json['totalExpensesByTopMerchants'] as double,
      largestTransactions: transactions,
    );
  }

  List<Merchant> get merchants {
    var result = <Merchant>[];
    for (var merchant in _merchants) {
      result.add(
        Merchant(
          sum: merchant.totalExpensesByMerchant,
          name: merchant.merchantName,
          sumOfAllTransactions: totalExpensesByTopMerchants,
          number: _merchants.indexOf(merchant),
        ),
      );
    }
    return result;
  }

  @override
  String toString() =>
      'totalExpensesByTopMerchants $totalExpensesByTopMerchants merchants ${merchants.length} largestTransactions ${largestTransactions.length}';
}
