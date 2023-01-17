import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Account {
  final String id;
  final String name;
  final int usageType;
  final int kind;
  final int type;
  final double balance;
  final bool isMuted;

  Account(
      {required this.id,
      required this.name,
      required this.usageType,
      required this.kind,
      required this.type,
      required this.balance,
      required this.isMuted});

  bool get isConfigured => usageType != 0;

  String getAccountTypeName(BuildContext context) {
    var map = {
      1: AppLocalizations.of(context)!.bankAccount,
      2: AppLocalizations.of(context)!.creditCard,
      3: AppLocalizations.of(context)!.businessLoan,
      4: AppLocalizations.of(context)!.studentLoan,
      5: AppLocalizations.of(context)!.autoLoan,
      6: AppLocalizations.of(context)!.personalLoan,
      7: AppLocalizations.of(context)!.mortgageLoan,
      8: AppLocalizations.of(context)!.investment,
      9: AppLocalizations.of(context)!.retirementAccount,
      10: AppLocalizations.of(context)!.businessAssets,
      11: AppLocalizations.of(context)!.primaryHome,
      12: AppLocalizations.of(context)!.vehicle,
      13: AppLocalizations.of(context)!.otherAsset,
      14: AppLocalizations.of(context)!.backTaxes,
      15: AppLocalizations.of(context)!.medicalBills,
      16: AppLocalizations.of(context)!.alimony,
      17: AppLocalizations.of(context)!.otherDebt,
    };
    return map[type] ?? AppLocalizations.of(context)!.noType;
  }

  Account copyWith({
    String? id,
    String? name,
    int? usageType,
    int? kind,
    int? type,
    double? balance,
    bool? isMuted,
  }) {
    return Account(
        id: id ?? this.id,
        name: name ?? this.name,
        usageType: usageType ?? this.usageType,
        kind: kind ?? this.kind,
        type: type ?? this.type,
        balance: balance ?? this.balance,
        isMuted: isMuted ?? this.isMuted);
  }
}
