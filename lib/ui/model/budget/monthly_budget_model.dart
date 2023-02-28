import 'package:burgundy_budgeting_app/ui/model/arithmetic_expression.dart';
import 'package:burgundy_budgeting_app/ui/model/budget/annual_budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:collection/src/iterable_extensions.dart';

class MonthlyBudgetModel extends BaseBudgetModel {
  MonthlyBudgetModel({
    required this.monthYear,
    required this.income,
    required this.expenses,
    required this.expensesSeparated,
    required this.investments,
    required this.totalExpenses,
    required this.netIncome,
    required this.totalFreeCash,
    required this.totalUnplannedAmount,
    required MonthlyBudgetCalculatedRow totalCashReservesOnStartOfPeriod,
    required this.isPersonal,
    required this.businessId,
  }) : _totalCashReservesOnStartOfPeriod = totalCashReservesOnStartOfPeriod;

  final DateTime monthYear;
  final MonthlyBudgetCategory income;
  final List<MonthlyBudgetCategory> expenses;
  final MonthlyBudgetCategory? expensesSeparated;
  final MonthlyBudgetCategory? investments;
  final MonthlyBudgetCalculatedRow totalExpenses;
  final MonthlyBudgetCalculatedRow netIncome;
  final MonthlyBudgetCalculatedRow totalFreeCash;
  final MonthlyBudgetCalculatedRow _totalCashReservesOnStartOfPeriod;
  final int totalUnplannedAmount;
  final bool isPersonal;
  @override
  final String? businessId;

  factory MonthlyBudgetModel.fromJson(
    Map<String, dynamic> json, {
    required bool isPersonal,
    String? businessId,
  }) {
    var date = DateTime.parse(json['monthYear']);
    var expensesList = List.from(json['expenses'])
        .map(
          (e) => MonthlyBudgetCategory.fromJson(e,
              categoryType: CategoryGroupType.ExpenseGeneral,
              date: date,
              isPersonal: isPersonal),
        )
        .toList();
    return MonthlyBudgetModel(
        monthYear: date,
        isPersonal: isPersonal,
        businessId: businessId,
        income: MonthlyBudgetCategory.fromJson(json['income'],
            categoryType: CategoryGroupType.Income,
            date: date,
            isPersonal: isPersonal),
        expenses: expensesList,
        expensesSeparated: (json['goals'] ?? json['ownerDraw']) != null
            ? MonthlyBudgetCategory.fromJson(
                json['goals'] ?? json['ownerDraw'],
                categoryType: CategoryGroupType.ExpenseSeparated,
                date: date,
                isPersonal: isPersonal,
              )
            : null,
        investments: json['investments'] != null
            ? MonthlyBudgetCategory.fromJson(
                json['investments'],
                categoryType: CategoryGroupType.Investment,
                date: date,
                isPersonal: isPersonal,
              )
            : null,
        totalExpenses:
            MonthlyBudgetCalculatedRow.fromJson(json['totalExpenses']),
        netIncome: MonthlyBudgetCalculatedRow.fromJson(json['netIncome']),
        totalFreeCash: MonthlyBudgetCalculatedRow.fromJson(
            json['totalFreeCash'] ?? json['totalRetainedInBusiness']),
        totalUnplannedAmount: expensesList
            .firstWhere(
                (element) => element.parentCategoryName == 'Other Expenses')
            .categories
            .firstWhere((element) => element.name == 'Uncategorized Expenses')
            .actual
            .amount,
        totalCashReservesOnStartOfPeriod: MonthlyBudgetCalculatedRow.fromJson(
            json['totalCashReservesOnStartOfPeriod']));
  }

  MonthlyBudgetModel update(MonthlyBudgetSubcategory category) {
    var income = this.income;
    var expenses = this.expenses;
    var expensesSeparated = this.expensesSeparated;
    var investments = this.investments;
    var totalExpenses = this.totalExpenses;
    if (category.categoryType == CategoryGroupType.Income) {
      changeAndUpdateMonthlyBudgetCategory(income, category);
    } else if (category.categoryType == CategoryGroupType.ExpenseGeneral) {
      var expensesCategory = expenses
          .where((element) =>
              element.parentCategoryId == category.parentCategoryId)
          .toList()
          .first;
      changeAndUpdateMonthlyBudgetCategory(expensesCategory, category);
      expenses
          .where((element) =>
              element.parentCategoryId == category.parentCategoryId)
          .toList()
          .first
          .update();
      totalExpenses =
          MonthlyBudgetCalculatedRow.calculatedTotalExpenses(expenses);
    } else if (category.categoryType == CategoryGroupType.ExpenseSeparated) {
      changeAndUpdateMonthlyBudgetCategory(expensesSeparated, category);
    } else if (category.categoryType == CategoryGroupType.Investment) {
      changeAndUpdateMonthlyBudgetCategory(investments, category);
    }
    var netIncome =
        MonthlyBudgetCalculatedRow.calculatedNetIncome(income, totalExpenses);

    var newTotalFreeCash = isPersonal
        ? MonthlyBudgetCalculatedRow.calculatedPersonalFreeCash(
            netIncome, expensesSeparated, investments)
        : MonthlyBudgetCalculatedRow.calculatedBusinessFreeCash(
            netIncome, expensesSeparated);
    return MonthlyBudgetModel(
        isPersonal: isPersonal,
        monthYear: monthYear,
        businessId: businessId,
        income: income,
        expenses: expenses,
        expensesSeparated: expensesSeparated,
        investments: investments,
        totalExpenses: totalExpenses,
        netIncome: netIncome,
        totalFreeCash: newTotalFreeCash,
        totalUnplannedAmount: totalUnplannedAmount,
        totalCashReservesOnStartOfPeriod: _totalCashReservesOnStartOfPeriod);
  }

  void changeAndUpdateMonthlyBudgetCategory(
      MonthlyBudgetCategory? monthlyCategory,
      MonthlyBudgetSubcategory newCategory) {
    final index = monthlyCategory?.categories
        .indexWhere((element) => element.id == newCategory.id);

    if (index != null && index >= 0) {
      monthlyCategory?.categories.removeAt(index);
      monthlyCategory?.categories.insert(index, newCategory);
    }

    monthlyCategory?.update();
  }

  MonthlyBudgetModel hideCategory(
      {required String categoryIdToHide,
      String? categoryIdToMapTransactions,
      required BudgetSubcategory subcategoryToExclude}) {
    var income = this.income;
    var expenses = this.expenses;
    var expensesSeparated = this.expensesSeparated;
    var investments = this.investments;
    var totalExpenses = this.totalExpenses;

    var isIncome =
        subcategoryToExclude.categoryType == CategoryGroupType.Income;

    if (categoryIdToMapTransactions != null) {
      MonthlyBudgetSubcategory? subcategoryToMove;
      MonthlyBudgetCategory? parentCategoryToMove;
      if (isIncome) {
        subcategoryToMove = income.categories.firstWhereOrNull(
            (element) => element.id == categoryIdToMapTransactions);
        if (subcategoryToMove != null) {
          parentCategoryToMove = income;
        }
      } else {
        if (expensesSeparated != null) {
          subcategoryToMove = expensesSeparated.categories.firstWhereOrNull(
              (element) => element.id == categoryIdToMapTransactions);
          if (subcategoryToMove != null) {
            parentCategoryToMove = expensesSeparated;
          }
        }
        if (subcategoryToMove == null &&
            investments != null &&
            subcategoryToMove == null) {
          subcategoryToMove = investments.categories.firstWhereOrNull(
              (element) => element.id == categoryIdToMapTransactions);
          if (subcategoryToMove != null) {
            parentCategoryToMove = investments;
          }
        }
        if (subcategoryToMove == null) {
          for (var category in expenses) {
            subcategoryToMove = category.categories.firstWhereOrNull(
                (element) => element.id == categoryIdToMapTransactions);
            if (subcategoryToMove != null) {
              parentCategoryToMove = category;
              break;
            }
          }
        }
      }
      if (subcategoryToMove != null &&
          parentCategoryToMove != null &&
          subcategoryToExclude is MonthlyBudgetSubcategory) {
        subcategoryToMove = subcategoryToMove.copyWith(
            amount: subcategoryToMove.actual.amount +
                subcategoryToExclude.actual.amount,
            selectedType: TableType.Actual);
        parentCategoryToMove.update();
      }
    }
    if (isIncome) {
      income.categories
          .removeWhere((element) => element.id == categoryIdToHide);
      income.update();
    } else if (subcategoryToExclude.categoryType ==
        CategoryGroupType.ExpenseSeparated) {
      expensesSeparated!.categories
          .removeWhere((element) => element.id == categoryIdToHide);
      expensesSeparated.update();
    } else if (subcategoryToExclude.categoryType ==
        CategoryGroupType.Investment) {
      investments!.categories
          .removeWhere((element) => element.id == categoryIdToHide);
      investments.update();
    } else {
      var category = expenses
          .where((element) => element.categories
              .where((element) => element.id == categoryIdToHide)
              .isNotEmpty)
          .first;
      category.categories
          .removeWhere((element) => element.id == categoryIdToHide);
      if (category.categories.isEmpty) {
        expenses.removeWhere(
            (element) => element.parentCategoryId == category.parentCategoryId);
      } else {
        category.update();
      }
    }
    if (!isIncome) {
      totalExpenses =
          MonthlyBudgetCalculatedRow.calculatedTotalExpenses(expenses);
    }
    var netIncome =
        MonthlyBudgetCalculatedRow.calculatedNetIncome(income, totalExpenses);
    var newTotalFreeCash = isPersonal
        ? MonthlyBudgetCalculatedRow.calculatedPersonalFreeCash(
            netIncome, expensesSeparated, investments)
        : MonthlyBudgetCalculatedRow.calculatedBusinessFreeCash(
            netIncome, expensesSeparated);
    return MonthlyBudgetModel(
        isPersonal: isPersonal,
        monthYear: monthYear,
        businessId: businessId,
        income: income,
        expenses: expenses,
        expensesSeparated: expensesSeparated,
        investments: investments,
        totalExpenses: totalExpenses,
        netIncome: netIncome,
        totalFreeCash: newTotalFreeCash,
        totalUnplannedAmount: totalUnplannedAmount,
        totalCashReservesOnStartOfPeriod: _totalCashReservesOnStartOfPeriod);
  }
}

class MonthlyBudgetCategory {
  MonthlyBudgetCategory({
    required this.parentCategoryId,
    required this.parentCategoryName,
    required this.totalPlannedAmount,
    required this.totalActualAmount,
    required this.totalDifferenceAmount,
    required this.categories,
    required this.categoryType,
  });

  final CategoryGroupType categoryType;
  final String parentCategoryId;
  final String parentCategoryName;
  int totalPlannedAmount;
  int totalActualAmount;
  int totalDifferenceAmount;
  final List<MonthlyBudgetSubcategory> categories;

  List<int> get totals =>
      [totalPlannedAmount, totalActualAmount, totalDifferenceAmount];

  factory MonthlyBudgetCategory.fromJson(
    Map<String, dynamic> json, {
    required CategoryGroupType categoryType,
    required bool isPersonal,
    required DateTime date,
  }) {
    return MonthlyBudgetCategory(
        categoryType: categoryType,
        parentCategoryId: json['parentCategoryId'] ?? json['goalCategoryId'],
        parentCategoryName:
            json['parentCategoryName'] ?? json['goalCategoryName'],
        totalPlannedAmount: json['totalPlannedAmount'] ?? 0,
        totalActualAmount: json['totalActualAmount'] ?? 0,
        totalDifferenceAmount: json['totalDifferenceAmount'] ?? 0,
        categories: List.from(json['categories'] ?? json['goals'])
            .map(
              (e) => MonthlyBudgetSubcategory.fromJson(
                e,
                date: date,
                parentCategoryId:
                    json['parentCategoryId'] ?? json['goalCategoryId'],
                isPersonal: isPersonal,
                categoryType: categoryType,
              ),
            )
            .toList());
  }

  void update() {
    var newPlanned = 0;
    var newActual = 0;
    var newDiff = 0;
    for (var item in categories) {
      newPlanned += item.planned.amount;
      newActual += item.actual.amount;
      newDiff += item.difference.amount;
    }
    totalPlannedAmount = newPlanned;
    totalActualAmount = newActual;
    totalDifferenceAmount = newDiff;
  }
}

class MonthlyBudgetSubcategory extends BudgetSubcategory {
  MonthlyBudgetSubcategory({
    required this.parentCategoryId,
    required this.id,
    required this.name,
    required this.planned,
    required this.actual,
    required this.difference,
    required this.categoryType,
  });

  @override
  final String parentCategoryId;
  @override
  final String id;
  final String name;
  final MonthlyNode planned;
  final MonthlyNode actual;
  final MonthlyNode difference;
  @override
  final CategoryGroupType categoryType;

  List<MonthlyNode> get nodes => [planned, actual, difference];

  factory MonthlyBudgetSubcategory.fromJson(
    Map<String, dynamic> json, {
    required CategoryGroupType categoryType,
    required bool isPersonal,
    required DateTime date,
    required String parentCategoryId,
  }) {
    return MonthlyBudgetSubcategory(
      id: json['id'],
      parentCategoryId: parentCategoryId,
      name: json['name'],
      planned: MonthlyNode.fromJson(json['planned'],
          date: date, isPersonal: isPersonal, categoryType: categoryType),
      actual: MonthlyNode.fromJson(json['actual'],
          date: date, isPersonal: isPersonal, categoryType: categoryType),
      difference: MonthlyNode.fromJson(
        json['difference'],
        date: date,
        isPersonal: isPersonal,
        categoryType: categoryType,
      ),
      categoryType: categoryType,
    );
  }

  MonthlyBudgetSubcategory copyWith({
    int? amount,
    required TableType selectedType,
    ArithmeticExpression? expression,
  }) {
    if (selectedType == TableType.Budgeted) {
      if (amount != null) {
        planned.amount = amount;
      }
      if (expression != null) {
        planned.expression = expression;
      }
    } else {
      if (amount != null) {
        actual.amount = amount;
      }
      if (expression != null) {
        actual.expression = expression;
      }
    }

    var difference =
        MonthlyNode.calculatedDifference(planned, actual, this.difference);

    return MonthlyBudgetSubcategory(
        id: id,
        name: name,
        planned: planned,
        actual: actual,
        difference: difference,
        parentCategoryId: parentCategoryId,
        categoryType: categoryType);
  }

  static MonthlyBudgetSubcategory from(MonthlyBudgetSubcategory subcategory) =>
      MonthlyBudgetSubcategory(
        id: subcategory.id,
        parentCategoryId: subcategory.parentCategoryId,
        name: subcategory.name,
        actual: MonthlyNode(
            amount: subcategory.actual.amount,
            notes: subcategory.actual.notes,
            expression: subcategory.actual.expression),
        planned: MonthlyNode(
            amount: subcategory.planned.amount,
            notes: subcategory.planned.notes,
            expression: subcategory.planned.expression),
        difference: MonthlyNode(
            amount: subcategory.difference.amount,
            notes: subcategory.difference.notes,
            expression: subcategory.difference.expression),
        categoryType: subcategory.categoryType,
      );
}

class MonthlyNode {
  MonthlyNode({
    required this.amount,
    this.expression,
    required this.notes,
  });

  int amount;
  ArithmeticExpression? expression;
  final List<MemoNoteModel> notes;

  factory MonthlyNode.fromJson(
    Map<String, dynamic>? json, {
    required CategoryGroupType categoryType,
    required bool isPersonal,
    required DateTime date,
  }) {
    var notes = <MemoNoteModel>[];
    var isGoal =
        isPersonal && categoryType == CategoryGroupType.ExpenseSeparated;
    if (json?['notes'] != null) {
      for (var item in json?['notes']) {
        notes.add(MemoNoteModel.fromJson(item, isGoal, date));
      }
    }
    return MonthlyNode(
        amount: (json?['amount'] as num?)?.round() ?? 0,
        expression: json?['expression'] != null
            ? ArithmeticExpression(
                expression: json!['expression'],
                isValid: json['isExpressionValid'] ?? true)
            : null,
        notes: notes);
  }

  static MonthlyNode calculatedDifference(
      MonthlyNode planned, MonthlyNode actual, MonthlyNode difference) {
    return MonthlyNode(
        amount: planned.amount - actual.amount, notes: difference.notes);
  }

  void addNote({
    required String noteId,
    required String? transactionId,
    required String note,
    required bool isGoal,
    required double? transactionAmount,
    required bool isTransaction,
    required DateTime? creationDate,
    required DateTime monthYear,
    required ProfileOverviewModel currentUser,
    MemoNoteModel? newReply,
  }) {
    var replies =
        notes.firstWhereOrNull((element) => element.id == noteId)?.replies ??
            [];
    if (newReply != null) {
      replies.removeWhere((element) => element.id == newReply.id);
      replies.add(newReply);
    }
    notes.removeWhere((element) => element.id == noteId);
    notes.insert(
      0,
      MemoNoteModel(
        id: noteId,
        transactionId: transactionId,
        note: note,
        isTransaction: isTransaction,
        transactionAmount: transactionAmount,
        isGoal: isGoal,
        creationDate: creationDate,
        monthYear: monthYear,
        authorFirstName: currentUser.firstName,
        authorUserId: currentUser.userId,
        authorLastName: currentUser.lastName,
        authorImageUrl: currentUser.imageUrl,
        isReply: false,
        replies: replies,
        canShowMore: replies.isNotEmpty,
        canAddReply: replies.length < 3,
      ),
    );
  }

  void deleteNote({
    required MemoNoteModel note,
  }) {
    notes.removeWhere((element) => element.id == note.id);
  }

  MemoNotesPage getNotesPage(bool isGoal, {required DateTime monthYear}) {
    return MemoNotesPage.fromNotesList(
        list: notes, isGoal: isGoal, monthYear: monthYear);
  }

  void addNoteReply({
    required MemoNoteModel noteModel,
    required MemoNoteModel newReply,
  }) {
    var replies = noteModel.replies;
    var index = replies.indexWhere((element) => element.id == newReply.id);
    if (index >= 0) {
      replies[index] = newReply;
    } else {
      replies.add(newReply);
    }
    var noteIndex = notes.indexWhere((element) => element.id == noteModel.id);
    if (noteIndex >= 0) {
      notes[noteIndex] = noteModel.copyWith(replies: replies);
    } else {
      notes.add(noteModel.copyWith(replies: replies));
    }
  }

  void deleteNoteReply(
      {required MemoNoteModel noteModel, required String replyId}) {
    var replies = noteModel.replies;
    replies.removeWhere((element) => element.id == replyId);
    var noteIndex = notes.indexWhere((element) => element.id == noteModel.id);
    if (noteIndex >= 0) {
      notes[noteIndex] = noteModel.copyWith(replies: replies);
    } else {
      notes.add(noteModel.copyWith(replies: replies));
    }
  }
}

class MonthlyBudgetCalculatedRow {
  MonthlyBudgetCalculatedRow({
    required this.plannedAmount,
    required this.actualAmount,
    required this.differenceAmount,
  });

  final int plannedAmount;
  final int actualAmount;
  final int differenceAmount;

  List<int> get row => [plannedAmount, actualAmount, differenceAmount];

  factory MonthlyBudgetCalculatedRow.fromJson(Map<String, dynamic>? json) {
    return MonthlyBudgetCalculatedRow(
        plannedAmount: json?['plannedAmount'] ?? 0,
        actualAmount: json?['actualAmount'] ?? 0,
        differenceAmount: json?['differenceAmount'] ?? 0);
  }

  factory MonthlyBudgetCalculatedRow.calculatedTotalExpenses(
      List<MonthlyBudgetCategory> expenses) {
    var plannedAmount = 0;
    var actualAmount = 0;
    var differenceAmount = 0;
    for (var item in expenses) {
      plannedAmount += item.totalPlannedAmount;
      actualAmount += item.totalActualAmount;
      differenceAmount += item.totalDifferenceAmount;
    }
    return MonthlyBudgetCalculatedRow(
        plannedAmount: plannedAmount,
        actualAmount: actualAmount,
        differenceAmount: differenceAmount);
  }

  factory MonthlyBudgetCalculatedRow.calculatedNetIncome(
      MonthlyBudgetCategory income, MonthlyBudgetCalculatedRow totalExpenses) {
    return MonthlyBudgetCalculatedRow(
      plannedAmount: income.totalPlannedAmount - totalExpenses.plannedAmount,
      actualAmount: income.totalActualAmount - totalExpenses.actualAmount,
      differenceAmount:
          income.totalDifferenceAmount - totalExpenses.differenceAmount,
    );
  }

  factory MonthlyBudgetCalculatedRow.calculatedPersonalFreeCash(
    MonthlyBudgetCalculatedRow netIncome,
    MonthlyBudgetCategory? expensesSeparated,
    MonthlyBudgetCategory? investments,
  ) {
    return MonthlyBudgetCalculatedRow(
      plannedAmount: netIncome.plannedAmount -
          (expensesSeparated?.totalPlannedAmount ?? 0) -
          (investments?.totalPlannedAmount ?? 0),
      actualAmount: netIncome.actualAmount -
          (expensesSeparated?.totalActualAmount ?? 0) -
          (investments?.totalActualAmount ?? 0),
      differenceAmount: netIncome.differenceAmount -
          (expensesSeparated?.totalDifferenceAmount ?? 0) -
          (investments?.totalDifferenceAmount ?? 0),
    );
  }

  factory MonthlyBudgetCalculatedRow.calculatedBusinessFreeCash(
    MonthlyBudgetCalculatedRow netIncome,
    MonthlyBudgetCategory? expensesSeparated,
  ) {
    return MonthlyBudgetCalculatedRow(
      plannedAmount: netIncome.plannedAmount -
          (expensesSeparated?.totalPlannedAmount ?? 0),
      actualAmount:
          netIncome.actualAmount - (expensesSeparated?.totalActualAmount ?? 0),
      differenceAmount: netIncome.differenceAmount -
          (expensesSeparated?.totalDifferenceAmount ?? 0),
    );
  }
}
