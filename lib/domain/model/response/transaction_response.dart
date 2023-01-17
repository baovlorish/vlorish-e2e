import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';

class TransactionResponse {
  final String id;
  final String creationTimeUtc;
  final double amount;
  final String merchantName;
  final String bankAccountName;
  final String lastFourDigits;
  final String currency;
  final String? categoryId;
  final String? parentCategoryId;
  final int usageType;
  final bool isInterest;
  final bool isPending;
  final MemoNoteModel? note;
  final bool isChildOfSplit;
  final List<TransactionResponse>? splitChildren;
  final String? splitTransactionId;
  final bool? isIgnored;

  TransactionResponse({
    required this.id,
    required this.creationTimeUtc,
    required this.amount,
    required this.isIgnored,
    required this.merchantName,
    required this.bankAccountName,
    required this.lastFourDigits,
    required this.currency,
    this.categoryId,
    this.parentCategoryId,
    required this.usageType,
    required this.isInterest,
    required this.isPending,
    this.note,
    required this.isChildOfSplit,
    this.splitChildren,
    required this.splitTransactionId,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    List<TransactionResponse>? splitChildren;
    if (json['splitChildren'] != null) {
      splitChildren = [];
      for (var item in json['splitChildren']) {
        splitChildren.add(TransactionResponse.fromJson(item));
      }
    }
    MemoNoteModel? note;
    if(json['transactionNote']!=null) {
      note = MemoNoteModel.fromTransactionJson(json['transactionNote']);
    }
    return TransactionResponse(
      id: json['id'],
      creationTimeUtc: json['creationTimeUtc'] ?? json['creationDate'],
      isIgnored: json['isIgnored'],
      amount: json['amount'] as double,
      merchantName: json['merchantName'],
      bankAccountName: json['bankAccountName'] ?? '',
      lastFourDigits: json['lastFourDigits'] ?? '',
      currency: json['currency'] ?? 'USD',
      categoryId: json['categoryId'],
      parentCategoryId: json['parentCategoryId'],
      usageType: json['usageType'] ?? 0,
      isInterest: json['isInterest'] ?? false,
      note: note,
      isChildOfSplit: json['isChildOfSplit'] ?? false,
      splitChildren: splitChildren,
      splitTransactionId: json['splitTransactionId'],
      isPending: json['isPending'] ?? false,
    );
  }
}
