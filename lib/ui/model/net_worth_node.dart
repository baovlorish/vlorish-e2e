class NetWorthNode {
  final int amount;
  final DateTime monthYear;

  late final bool isEditable;

  NetWorthNode({
    required this.amount,
    required this.monthYear,
  }) {
    final now = DateTime.now();
    isEditable = (monthYear.year < now.year ||
        (monthYear.year == now.year && monthYear.month <= now.month));
  }

  factory NetWorthNode.fromJson(var json) {
    return NetWorthNode(
      amount: json['amount'] ?? json['totalAmount'],
      monthYear: DateTime.parse(json['monthYear']),
    );
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['amount'] = amount;
    map['monthYear'] = monthYear.toIso8601String();
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetWorthNode &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          monthYear == other.monthYear &&
          isEditable == other.isEditable;

  @override
  int get hashCode =>
      amount.hashCode ^ monthYear.hashCode ^ isEditable.hashCode;
}
