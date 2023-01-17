class MerchantResponse {
  final String merchantName;
  final double totalExpensesByMerchant;

  MerchantResponse({
    required this.merchantName,
    required this.totalExpensesByMerchant,
  });

  factory MerchantResponse.fromJson(Map<String, dynamic> json) {
    return MerchantResponse(
      merchantName: json['merchantName'],
      totalExpensesByMerchant: json['totalExpensesByMerchant'],
    );
  }
}
