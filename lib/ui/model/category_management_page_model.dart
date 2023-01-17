import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';

class CategoryManagementPageModel {
  final CategoryManagementUsageType personal;
  final CategoryManagementUsageType business;

  CategoryManagementPageModel({required this.personal, required this.business});

  factory CategoryManagementPageModel.fromJson(Map<String, dynamic> json) {
    return CategoryManagementPageModel(
        personal: CategoryManagementUsageType.fromJson(json['personal'], true),
        business:
            CategoryManagementUsageType.fromJson(json['business'], false));
  }

  CategoryManagementUsageType usageType(bool isPersonal) =>
      isPersonal ? personal : business;
}

class CategoryManagementUsageType {
  final ManagementCategory? income;
  final List<ManagementCategory> expenses;
  final bool isPersonal;

  int get usageType => isPersonal ? 1 : 2;

  const CategoryManagementUsageType(
      {required this.income, required this.expenses, required this.isPersonal});

  factory CategoryManagementUsageType.fromJson(
      Map<String, dynamic> json, bool isPersonal) {
    var income = json['income'] != null
        ? ManagementCategory.fromJson(json['income'], true)
        : null;
    var expenses = <ManagementCategory>[];
    if (json['expenses'] != null) {
      json['expenses'].forEach((v) {
        expenses.add(ManagementCategory.fromJson(v, false));
      });
    }
    return CategoryManagementUsageType(
        income: income, expenses: expenses, isPersonal: isPersonal);
  }

  List<ManagementCategory> get inUse {
    var expensesInUse = <ManagementCategory>[];
    expenses.forEach((element) {
      if (element.inUseCategories.isNotEmpty) {
        expensesInUse.add(element.inUse());
      }
    });

    return (income != null && income!.inUseCategories.isNotEmpty
            ? [income!.inUse()]
            : <ManagementCategory>[]) +
        expensesInUse;
  }

  List<ManagementCategory> get available {
    var expensesAvailable = <ManagementCategory>[];
    expenses.forEach((element) {
      if (element.availableCategories.isNotEmpty) {
        expensesAvailable.add(element.available());
      }
    });

    return (income != null && income!.availableCategories.isNotEmpty
            ? [income!.available()]
            : <ManagementCategory>[]) +
        expensesAvailable;
  }

  // map of categories that don't take part in category management
  // they can't be removed by user, but user can map transactions to them
  // so they have to be in dropdowns for any category reassignment
  Map<String, List<String>> _nonExcluding(isIncome) {
    var resultMap = <String, List<String>>{};
    resultMap.addAll(CategoriesMapping.categoriesMap(isIncome)[usageType]!);
    var categories = isIncome ? [income] : expenses;
    for (var category in categories) {
      if (category != null) {
        var newEntry = <String>[];
        if (resultMap[category.id] != null) {
          newEntry = resultMap[category.id]!;
        }
        for (var subcategory in category.categories) {
          newEntry.removeWhere((element) => element == subcategory.id);
        }
        if (newEntry.isEmpty) {
          resultMap.removeWhere((key, value) => key == category.id);
        } else {
          resultMap[category.id] = newEntry;
        }
      }
    }
    return resultMap;
  }

  Map<String, List<String>> possibleParentCategoriesMap(
      ManagementSubcategory subcategory,
      {bool excludeSelf = true}) {
    var resultMap = <String, List<String>>{};
    for (var category
        in inUse.where((element) => element.isIncome == subcategory.isIncome)) {
      var children = <String>[];
      //if not debts
      if ((category.id != 'd23427c2-79e8-4ef4-ba6c-54190e107eff' &&
          category.id != 'a6050bc7-7fd5-4186-bbb2-66ba5f25888d')) {
        //add category and its children to map
        for (var item in category.inUseCategories) {
          children.add(item.id);
        }
        resultMap[category.id] = children;
      }
    }

    if (excludeSelf) {
      resultMap[subcategory.parentCategoryId]
          ?.removeWhere((value) => value == subcategory.id);
    }
    var nonExcludingCategoriesMap = _nonExcluding(subcategory.isIncome);
    for (var key in nonExcludingCategoriesMap.keys) {
      if (resultMap.containsKey(key)) {
        var children = resultMap[key];
        resultMap[key] =
            (children! + nonExcludingCategoriesMap[key]!).toSet().toList();
      } else {
        resultMap[key] = nonExcludingCategoriesMap[key]!;
      }
    }
    return resultMap;
  }

  List<String> possibleParentCategoriesIds(ManagementSubcategory subcategory,
      {bool excludeSelf = true}) {
    return possibleParentCategoriesMap(subcategory, excludeSelf: excludeSelf)
        .keys
        .toList();
  }

  List<String> possibleParentCategoriesNames(
      BuildContext context, ManagementSubcategory subcategory,
      {bool excludeSelf = true}) {
    var list = <String>[];
    possibleParentCategoriesMap(subcategory, excludeSelf: excludeSelf)
        .keys
        .toList()
        .forEach((element) {
      list.add(element.nameLocalization(context));
    });
    return list;
  }

  List<String> possibleSubcategoriesToMoveIds(
      ManagementSubcategory subcategory, String parentId,
      {bool excludeSelf = true}) {
    return possibleParentCategoriesMap(subcategory,
            excludeSelf: excludeSelf)[parentId]!
        .toList();
  }

  List<String> possibleSubcategoriesToMove(
      BuildContext context, ManagementSubcategory subcategory, String parentId,
      {bool excludeSelf = true}) {
    var list = <String>[];
    possibleParentCategoriesMap(subcategory,
            excludeSelf: excludeSelf)[parentId]!
        .toList()
        .forEach((element) {
      list.add(element.nameLocalization(context));
    });
    return list;
  }
}

class ManagementCategory {
  final String id;
  final String name;
  final bool isIncome;
  final bool isDebt;
  final List<ManagementSubcategory> categories;
  final bool hasTransactions;
  final bool cannotBeHidden;

  const ManagementCategory({
    required this.id,
    required this.name,
    required this.categories,
    required this.hasTransactions,
    required this.isIncome,
    required this.isDebt,
    required this.cannotBeHidden,
  });

  factory ManagementCategory.fromJson(
      Map<String, dynamic> json, bool isIncome) {
    var categories = <ManagementSubcategory>[];
    var hasTransactions = false;
    var cannotBeHidden = false;
    if (json['categories'] != null) {
      json['categories'].forEach((v) {
        var subcategory =
            ManagementSubcategory.fromJson(v, json['id'], isIncome);
        categories.add(subcategory);
        if (subcategory.hasTransactions) hasTransactions = true;
        if (subcategory.cannotBeHidden) cannotBeHidden = true;
      });
    }

    return ManagementCategory(
      id: json['id'],
      name: json['name'],
      categories: categories,
      hasTransactions: hasTransactions,
      isIncome: isIncome,
      isDebt: json['isDebt'],
      cannotBeHidden: cannotBeHidden,
    );
  }

  ManagementCategory inUse() {
    return ManagementCategory(
      id: id,
      name: name,
      categories: inUseCategories,
      hasTransactions: hasTransactions,
      isIncome: isIncome,
      isDebt: isDebt,
      cannotBeHidden: cannotBeHidden,
    );
  }

  ManagementCategory available() {
    return ManagementCategory(
      id: id,
      name: name,
      categories: availableCategories,
      hasTransactions: hasTransactions,
      isIncome: isIncome,
      isDebt: isDebt,
      cannotBeHidden: cannotBeHidden,
    );
  }

  List<ManagementSubcategory> get inUseCategories =>
      categories.where((element) => !element.isHidden).toList();

  List<ManagementSubcategory> get availableCategories =>
      categories.where((element) => element.isHidden).toList();
}

class ManagementSubcategory {
  final String id;
  final String name;
  final bool hasTransactions;
  final bool isHidden;
  final bool isIncome;
  final String parentCategoryId;
  final bool isDebt;
  final bool cannotBeHidden;

  ManagementSubcategory({
    required this.id,
    required this.name,
    required this.hasTransactions,
    required this.isHidden,
    required this.isIncome,
    required this.parentCategoryId,
    required this.isDebt,
    required this.cannotBeHidden,
  });

  factory ManagementSubcategory.fromJson(
      Map<String, dynamic> json, String parentCategoryId, bool isIncome) {
    return ManagementSubcategory(
      id: json['id'],
      name: json['name'],
      hasTransactions: json['hasTransactions'],
      isHidden: json['isHidden'],
      parentCategoryId: parentCategoryId,
      isIncome: isIncome,
      isDebt: json['isDebt'],
      cannotBeHidden: json['cannotBeHidden'],
    );
  }

  String? getParentCategoryName(BuildContext context) {
    return parentCategoryId.nameLocalization(context);
  }
}
