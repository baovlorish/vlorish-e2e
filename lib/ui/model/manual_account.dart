import 'package:burgundy_budgeting_app/ui/model/account.dart';

class ManualAccount extends Account {
  @override
  final String id;
  @override
  final String name;
  @override
  final int usageType;
  @override
  final int kind;
  @override
  final int type;
  @override
  final double balance;
  @override
  final bool isMuted;

  final bool isOwnerBudgetUser;
  final String? ownerName;

  ManualAccount({
    required this.id,
    required this.name,
    required this.usageType,
    required this.kind,
    required this.type,
    required this.balance,
    required this.isMuted,
    required this.isOwnerBudgetUser,
    required this.ownerName,
  }) : super(
            id: id,
            name: name,
            usageType: usageType,
            kind: kind,
            type: type,
            balance: balance,
            isMuted: isMuted);

  factory ManualAccount.fromJson(Map<String, dynamic> json) {
    return ManualAccount(
      id: json['id'],
      name: json['name'],
      usageType: json['usageType'],
      kind: json['kind'],
      type: json['type'],
      balance: json['balance'] as double,
      isMuted: json['isMuted'],
      isOwnerBudgetUser: json['isOwnerBudgetUser'] ?? true,
      ownerName: json['ownerName'],
    );
  }
}
