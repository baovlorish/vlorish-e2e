class LargestTransactionModel {
  final double amount;
  final String merchantName;

  LargestTransactionModel({
    required this.amount,
    required this.merchantName,
  });

  factory LargestTransactionModel.fromJson(Map<String, dynamic> json) {
    return LargestTransactionModel(
      amount: json['amount'],
      merchantName: json['merchantName'],
    );
  }
}
