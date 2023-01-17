class SubscriptionModel {
  final String planName;
  final double pricePerMonth;
  final bool isCancelledByPeriodEnd;
  final int status;
  final int type;
  final String? creditCardLastFourDigits;
  final String? customerEmail;
  final DateTime? creditCardExpirationDate;
  final DateTime? nextPaymentDate;

  SubscriptionModel({
    required this.planName,
    required this.type,
    required this.pricePerMonth,
    required this.isCancelledByPeriodEnd,
    required this.status,
    required this.customerEmail,
    required this.creditCardLastFourDigits,
    required this.creditCardExpirationDate,
    required this.nextPaymentDate,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      planName: json['plan'],
      type: json['type'],
      customerEmail: json['customerEmail'],
      pricePerMonth: json['pricePerMonth'],
      isCancelledByPeriodEnd: json['isCancelledByPeriodEnd'],
      status: json['status'],
      creditCardLastFourDigits: json['creditCardLastFourDigits'],
      creditCardExpirationDate: (json['creditCardExpirationDate']) != null
          ? DateTime.parse(json['creditCardExpirationDate'])
          : null,
      nextPaymentDate: (json['nextPaymentDate']) != null
          ? DateTime.parse(json['nextPaymentDate'])
          : null,
    );
  }

  bool get isExist => !(creditCardLastFourDigits == null ||
      creditCardExpirationDate == null ||
      nextPaymentDate == null);

  bool get isPremiumOrHigher => type > 0;

  @override
  String toString() {
    return 'planName $planName isPremiumOrHigher $isPremiumOrHigher pricePerMonth $pricePerMonth isCancelledByPeriodEnd $isCancelledByPeriodEnd status $status creditCardLastFourDigits $creditCardLastFourDigits creditCardExpirationDate $creditCardExpirationDate nextPaymentDate $nextPaymentDate ';
  }
}
