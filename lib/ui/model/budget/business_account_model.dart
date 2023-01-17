class BusinessAccountModel {
  final String id;
  final String name;
  final bool? hasTransactions;

  BusinessAccountModel(this.id, this.name, this.hasTransactions);

  factory BusinessAccountModel.fromJson(Map<String, dynamic> data) {
    final id = data['id'] as String;
    final name = data['name'] as String;
    var hasTransactions = data['isBusinessHasTransactions'] as bool?;
    return BusinessAccountModel(id, name, hasTransactions);
  }

  @override
  String toString() => 'id: $id, name: $name \n';
}
