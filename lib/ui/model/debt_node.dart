class DebtNode {
  final int totalAmount;
  final DateTime monthYear;
  final int interestAmount;
  final int debtAmount;

  late final bool isEditable;

  DebtNode({
    required this.totalAmount,
    required this.interestAmount,
    required this.debtAmount,
    required this.monthYear,
    required bool isManual,
  }) {
    final now = DateTime.now();
    isEditable = isManual &&
        (monthYear.year < now.year ||
            (monthYear.year == now.year && monthYear.month <= now.month));
  }

  factory DebtNode.fromJson(Map json, bool isManual) {
    return DebtNode(
      totalAmount: json['totalAmount'],
      monthYear: DateTime.parse(json['monthYear']),
      interestAmount: json['interestAmount'],
      debtAmount: isManual
          ? (json['totalAmount'] - json['interestAmount'])
          : json['debtAmount'] ?? 0,
      isManual: isManual,
    );
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['totalAmount'] = totalAmount;
    map['monthYear'] = monthYear.toIso8601String();
    map['interestAmount'] = interestAmount;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtNode &&
          runtimeType == other.runtimeType &&
          totalAmount == other.totalAmount &&
          monthYear == other.monthYear &&
          interestAmount == other.interestAmount &&
          debtAmount == other.debtAmount &&
          isEditable == other.isEditable;

  @override
  int get hashCode =>
      totalAmount.hashCode ^
      monthYear.hashCode ^
      interestAmount.hashCode ^
      debtAmount.hashCode ^
      isEditable.hashCode;
}
