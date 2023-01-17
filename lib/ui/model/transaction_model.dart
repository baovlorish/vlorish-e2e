import 'package:burgundy_budgeting_app/domain/model/response/transaction_page_response.dart';
import 'package:burgundy_budgeting_app/domain/model/response/transaction_response.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:burgundy_budgeting_app/ui/model/statistic_model.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';

import 'merchant.dart';

enum TransactionType {
  none,
  personalIncome,
  personalExpense,
  businessIncome,
  businessExpense
}

class TransactionModel {
  final String id;
  final DateTime creationTimeUtc;
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
  final bool? isIgnored;
  final MemoNoteModel? note;
  final bool isChildOfSplit;
  final List<TransactionModel>? splitChildren;
  final String? splitTransactionId;

  TransactionModel({
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
    required this.splitChildren,
    required this.splitTransactionId,
  });

  factory TransactionModel.fromResponse(TransactionResponse response) {
    List<TransactionModel>? splitChildren;
    if (response.splitChildren != null) {
      splitChildren = [];
      for (var item in response.splitChildren!) {
        splitChildren.add(TransactionModel.fromResponse(item));
      }
    }
    return TransactionModel(
      id: response.id,
      creationTimeUtc: DateTime.parse(response.creationTimeUtc),
      amount: response.amount,
      isIgnored: response.isIgnored,
      merchantName: response.merchantName,
      bankAccountName: response.bankAccountName,
      lastFourDigits: response.lastFourDigits,
      currency: response.currency,
      usageType: response.usageType,
      isInterest: response.isInterest,
      isPending: response.isPending,
      parentCategoryId: response.parentCategoryId,
      categoryId: response.categoryId,
      note: response.note,
      splitTransactionId: response.splitTransactionId,
      isChildOfSplit: response.isChildOfSplit,
      splitChildren: splitChildren,
    );
  }

  TransactionType get transactionType {
    if (usageType == 1) {
      if (isIncome) {
        return TransactionType.personalIncome;
      } else {
        return TransactionType.personalExpense;
      }
    }
    if (usageType == 2) {
      if (isIncome) {
        return TransactionType.businessIncome;
      } else {
        return TransactionType.businessExpense;
      }
    }
    return TransactionType.none;
  }

  static List<StatisticModel> mapToStatisticModel(
      List<TransactionModel> transactions) {
    var models = <StatisticModel>[];

    var sortedTransactions = <String, List<TransactionModel>>{};

    var sumOfAllTransactions = 0.0;

    transactions.forEach((tr) {
      sumOfAllTransactions += tr.amount;
      sortedTransactions[tr.merchantName] = transactions
          .where((trans) => trans.merchantName == tr.merchantName)
          .toList();
    });

    var number = 0;

    var merchants = <Merchant>[];

    sortedTransactions.forEach(
      (key, value) {
        merchants.add(
          Merchant.fromTransactions(
            sortedTransactions[key]!,
            sumOfAllTransactions,
            number++,
          ),
        );
      },
    );

    merchants.sort();

    merchants.forEach((element) {
      models.add(StatisticModel.fromMerchant(element));
    });

    return models;
  }

  bool get isIncome =>
      parentCategoryId == '938beaea-4e0a-458a-a6d2-27ed1e5b1de3' ||
      parentCategoryId == '0d4cf5cc-4d0f-4bde-9e71-7fedd9fae0c2' ||
      amount > 0;

  List<String>? getSubcategoryNameListForParentId(BuildContext context,
      {required String parentId, required int usageType}) {
    if (CategoriesMapping.categoriesMap(isIncome)[usageType] != null) {
      if (CategoriesMapping.categoriesMap(isIncome)[usageType]![parentId] !=
          null) {
        return [
          for (var item in CategoriesMapping.categoriesMap(
              isIncome)[usageType]![parentId]!)
            item.nameLocalization(context)
        ];
      }
    }
  }

  String? getParentCategoryName(BuildContext context) {
    return parentCategoryId?.nameLocalization(context);
  }

  List<String>? getParentCategoryNameList(BuildContext context) {
    if (CategoriesMapping.categoriesMap(isIncome)[usageType] != null) {
      {
        return [
          for (var item in CategoriesMapping.categoriesMap(isIncome)[usageType]!
              .keys
              .toList())
            item.nameLocalization(context)
        ];
      }
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          creationTimeUtc == other.creationTimeUtc &&
          amount == other.amount &&
          merchantName == other.merchantName &&
          bankAccountName == other.bankAccountName &&
          lastFourDigits == other.lastFourDigits &&
          currency == other.currency &&
          categoryId == other.categoryId &&
          parentCategoryId == other.parentCategoryId &&
          usageType == other.usageType &&
          isInterest == other.isInterest &&
          isPending == other.isPending &&
          isIgnored == other.isIgnored &&
          note == other.note &&
          isChildOfSplit == other.isChildOfSplit &&
          splitChildren == other.splitChildren &&
          splitTransactionId == other.splitTransactionId;

  @override
  int get hashCode =>
      id.hashCode ^
      creationTimeUtc.hashCode ^
      amount.hashCode ^
      merchantName.hashCode ^
      bankAccountName.hashCode ^
      lastFourDigits.hashCode ^
      currency.hashCode ^
      categoryId.hashCode ^
      parentCategoryId.hashCode ^
      usageType.hashCode ^
      isInterest.hashCode ^
      isPending.hashCode ^
      isIgnored.hashCode ^
      note.hashCode ^
      isChildOfSplit.hashCode ^
      splitChildren.hashCode ^
      splitTransactionId.hashCode;
}

class TransactionListModel {
  final List<TransactionModel> transactions;
  final List<TransactionModel> splittedTransactions;
  final int pageNumber;
  final int totalPages;

  final String? budgetOwnerId;

  TransactionListModel({
    required this.transactions,
    required this.pageNumber,
    required this.totalPages,
    required this.splittedTransactions,
    required this.budgetOwnerId,
  });

  factory TransactionListModel.fromResponse(TransactionPageResponse response) {
    var transactions = <TransactionModel>[];
    for (var item in response.transactions) {
      transactions.add(TransactionModel.fromResponse(item));
    }
    var splittedTransactions = <TransactionModel>[];
    for (var item in response.splittedTransactions) {
      splittedTransactions.add(TransactionModel.fromResponse(item));
    }
    return TransactionListModel(
      transactions: transactions,
      splittedTransactions: splittedTransactions,
      pageNumber: response.pageNumber,
      totalPages: response.totalPages,
      budgetOwnerId: response.budgetOwnerId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionListModel &&
          runtimeType == other.runtimeType &&
          transactions == other.transactions &&
          splittedTransactions == other.splittedTransactions &&
          pageNumber == other.pageNumber &&
          totalPages == other.totalPages;

  @override
  int get hashCode =>
      transactions.hashCode ^
      splittedTransactions.hashCode ^
      pageNumber.hashCode ^
      totalPages.hashCode;
}

class SplitChildRequestModel {
  final double amount;
  final String categoryId;

  SplitChildRequestModel({required this.amount, required this.categoryId});

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'categoryId': categoryId,
      };
}
