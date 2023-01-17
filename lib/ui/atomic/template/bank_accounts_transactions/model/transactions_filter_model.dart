import 'package:burgundy_budgeting_app/ui/model/filter_parameters_model.dart';

class TransactionFiltersModel {
  final bool unbudgeted;
  final int usageType;
  final int sortingBy;
  final int sortingOrder;
  final String? selectedBankAccountId;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final FilterCategory? category;
  final FilterCategory? subCategory;
  final String? textSearch;
  final int? dateTimeFilter;

  TransactionFiltersModel({
    required this.sortingBy,
    required this.sortingOrder,
    required this.usageType,
    required this.unbudgeted,
    this.selectedBankAccountId,
    this.periodStart,
    this.periodEnd,
    this.category,
    this.subCategory,
    this.textSearch,
    this.dateTimeFilter,
  });

  factory TransactionFiltersModel.initial() => TransactionFiltersModel(
        unbudgeted: false,
        usageType: 0,
        sortingBy: 1,
        sortingOrder: 2,
      );

  TransactionFiltersModel copyWith({
    bool? unbudgeted,
    int? usageType,
    DateTime? periodStart,
    DateTime? periodEnd,
    int? sortingBy,
    int? sortingOrder,
    FilterCategory? category,
    FilterCategory? subCategory,
    String? textSearch,
    String? selectedBankAccountId,
    bool shouldEraseUsageType = false,
    bool shouldEraseCategories = false,
    bool shouldEraseSubcategory = false,
    bool shouldUnselectBankAccount = false,
    int? dateTimeFilter,
  }) {
    return TransactionFiltersModel(
      unbudgeted: unbudgeted ?? this.unbudgeted,
      usageType: shouldEraseUsageType ? 0 : usageType ?? this.usageType,
      selectedBankAccountId: shouldUnselectBankAccount
          ? null
          : selectedBankAccountId ?? this.selectedBankAccountId,
      periodStart: periodStart ?? this.periodStart,
      periodEnd: periodEnd ?? this.periodEnd,
      sortingBy: sortingBy ?? this.sortingBy,
      sortingOrder: sortingOrder ?? this.sortingOrder,
      category: shouldEraseCategories ? null : category ?? this.category,
      subCategory: shouldEraseCategories || shouldEraseSubcategory
          ? null
          : subCategory ?? this.subCategory,
      textSearch: textSearch ?? this.textSearch,
      dateTimeFilter: dateTimeFilter ?? this.dateTimeFilter,
    );
  }

  @override
  String toString() {
    return '''TransactionFiltersModel
    {
    unbudgeted: $unbudgeted,
    usageType: $usageType,
    periodStart: $periodStart,
    periodEnd: $periodEnd,
    sortingBy: $sortingBy,
    sortingOrder: $sortingOrder,
    categoryId: ${category?.id},
    subCategoryId: ${subCategory?.id},
    textSearch: $textSearch,
    selectedBankId: $selectedBankAccountId
    }''';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionFiltersModel &&
          runtimeType == other.runtimeType &&
          unbudgeted == other.unbudgeted &&
          usageType == other.usageType &&
          periodStart == other.periodStart &&
          periodEnd == other.periodEnd &&
          sortingBy == other.sortingBy &&
          sortingOrder == other.sortingOrder &&
          category == other.category &&
          subCategory == other.subCategory &&
          textSearch == other.textSearch;

  @override
  int get hashCode =>
      unbudgeted.hashCode ^
      usageType.hashCode ^
      periodStart.hashCode ^
      periodEnd.hashCode ^
      sortingBy.hashCode ^
      sortingOrder.hashCode ^
      category.hashCode ^
      subCategory.hashCode ^
      textSearch.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'isUnbudgeted': unbudgeted,
      'usageType': usageType,
      'sortingBy': sortingBy,
      'sortingOrder': sortingOrder,
      if (periodStart != null) 'periodStart': periodStart!.toIso8601String(),
      if (category != null) 'parentCategoryIds': category!.id,
      if (subCategory != null) 'subcategoryIds': subCategory!.id,
      'periodEnd':
          periodEnd?.toIso8601String() ?? DateTime.now().toIso8601String(),
      if (selectedBankAccountId != null) 'bankAccountId': selectedBankAccountId,
      if (textSearch != null) 'textSearch': textSearch,
    };
  }
}
