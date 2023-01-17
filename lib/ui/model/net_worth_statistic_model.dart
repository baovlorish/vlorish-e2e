class NetWorthStatisticModel {
  final int totalAssets;
  final int totalDebts;
  late final int netWorth;

  NetWorthStatisticModel({
    required this.totalDebts,
    required this.totalAssets,
  }) {
    netWorth = totalAssets - totalDebts;
  }
}
