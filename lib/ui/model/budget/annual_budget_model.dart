import 'package:burgundy_budgeting_app/ui/model/arithmetic_expression.dart';
import 'package:burgundy_budgeting_app/ui/model/budget_model.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';
import 'package:burgundy_budgeting_app/ui/model/proflie_overview_model.dart';
import 'package:collection/src/iterable_extensions.dart';

abstract class BaseBudgetModel {
  abstract final String? businessId;
}

class AnnualBudgetModel extends BaseBudgetModel {
  AnnualBudgetModel({
    required this.type,
    required this.isPersonal,
    required this.year,
    required this.income,
    required this.expenses,
    required this.expensesSeparated,
    required this.investments,
    required this.totalExpenses,
    required this.netIncome,
    required this.freeCash,
    required this.totalCashReserves,
    required this.totalCashReservesOnStartOfPeriod,
    required this.yearIncomeTotalSum,
    this.businessId,
  }) : period = Period.year(year);

  final TableType type;
  final bool isPersonal;
  final int year;
  final BudgetAnnualCategory income;
  final List<BudgetAnnualCategory> expenses;
  final BudgetAnnualCategory? expensesSeparated;
  final BudgetAnnualCategory? investments;
  final BudgetAnnualCalculatedRow totalExpenses;
  final BudgetAnnualCalculatedRow netIncome;
  final BudgetAnnualCalculatedRow freeCash;
  final BudgetAnnualCalculatedRow totalCashReserves;
  final int totalCashReservesOnStartOfPeriod;
  int yearIncomeTotalSum;

  @override
  final String? businessId;

  late Period period;

  factory AnnualBudgetModel.fromJson(
    Map<String, dynamic> json, {
    required bool isPersonal,
    required TableType type,
    String? businessId,
  }) {
    var period = Period.year(json['year']);
    var expenses = <BudgetAnnualCategory>[];
    for (var subcategory in json['expenses']) {
      expenses.add(
        BudgetAnnualCategory.fromJson(
          subcategory,
          isPersonal: isPersonal,
          type: type,
          categoryType: CategoryGroupType.ExpenseGeneral,
          period: period,
          incomeTotalYear: json['income']['totalByYear'],
        ),
      );
    }

    BudgetAnnualCategory? expensesSeparated;
    if (json['goals'] != null || json['ownerDraw'] != null) {
      expensesSeparated = BudgetAnnualCategory.fromJson(
          json['goals'] ?? json['ownerDraw'],
          isPersonal: isPersonal,
          type: type,
          categoryType: CategoryGroupType.ExpenseSeparated,
          period: period,
          incomeTotalYear: json['income']['totalByYear']);
    }

    BudgetAnnualCategory? investments;
    if (json['investments'] != null) {
      investments = BudgetAnnualCategory.fromJson(
        json['investments'],
        isPersonal: isPersonal,
        type: type,
        categoryType: CategoryGroupType.Investment,
        period: period,
        incomeTotalYear: json['income']['totalByYear'],
      );
    }
    return AnnualBudgetModel(
        year: json['year'],
        income: BudgetAnnualCategory.fromJson(
          json['income'],
          isPersonal: isPersonal,
          type: type,
          categoryType: CategoryGroupType.Income,
          period: period,
          incomeTotalYear: json['income']['totalByYear'],
        ),
        expenses: expenses,
        expensesSeparated: expensesSeparated,
        investments: investments,
        totalExpenses:
            BudgetAnnualCalculatedRow.fromJson(json['totalExpenses'], period),
        netIncome:
            BudgetAnnualCalculatedRow.fromJson(json['netIncome'], period),
        freeCash: BudgetAnnualCalculatedRow.fromJson(
            json['freeCash'] ?? json['retainedInBusiness'], period),
        totalCashReserves: BudgetAnnualCalculatedRow.fromJson(
            json['totalCashReserves'] ?? json['endingCashReserves'], period),
        totalCashReservesOnStartOfPeriod:
            (json['totalCashReservesOnStartOfPeriod'] as num?)?.round() ??
                (json['endingCashReservesOnStartOfPeriod'] as num?)?.round() ??
                0,
        yearIncomeTotalSum: (json['yearIncomeTotalSum'] as num?)?.round() ?? 0,
        isPersonal: isPersonal,
        type: type,
        businessId: businessId);
  }

  AnnualBudgetModel update(
      BudgetAnnualNode node, BudgetAnnualSubcategory category) {
    var income = this.income;
    var expenses = this.expenses;
    var expensesSeparated = this.expensesSeparated;
    var investments = this.investments;
    var totalExpenses = this.totalExpenses;
    if (category.categoryType == CategoryGroupType.Income) {
      income.categories
          .where((element) => element.id == category.id)
          .first
          .nodes[node.monthYear.month - 1] = node;
      income.updateSubcategory(category.id);

      ///when update Income value then update other categories locally for actual percentage
      for (var value in expenses) {
        value.updateCategoriesTotalIncomeByYear(income.totalByYear);
      }

      investments?.updateCategoriesTotalIncomeByYear(income.totalByYear);
      expensesSeparated?.updateCategoriesTotalIncomeByYear(income.totalByYear);

      totalExpenses = BudgetAnnualCalculatedRow.calculatedTotalExpenses(
          expenses, income.totalByYear);
    } else if (category.categoryType == CategoryGroupType.ExpenseGeneral) {
      expenses
          .where((element) =>
              element.parentCategoryId == category.parentCategoryId)
          .first
          .categories
          .where((element) => element.id == category.id)
          .first
          .nodes[node.monthYear.month - 1] = node;
      expenses
          .where((element) =>
              element.parentCategoryId == category.parentCategoryId)
          .first
          .updateSubcategory(category.id);
      totalExpenses = BudgetAnnualCalculatedRow.calculatedTotalExpenses(
          expenses, income.totalByYear);
    } else if (category.categoryType == CategoryGroupType.ExpenseSeparated) {
      expensesSeparated!.categories
          .where((element) => element.id == category.id)
          .first
          .nodes[node.monthYear.month - 1] = node;
      expensesSeparated.updateSubcategory(category.id);
    } else if (category.categoryType == CategoryGroupType.Investment) {
      investments!.categories
          .where((element) => element.id == category.id)
          .first
          .nodes[node.monthYear.month - 1] = node;
      investments.updateSubcategory(category.id);
    }

    var netIncome = BudgetAnnualCalculatedRow(
      totalByYear: income.totalByYear - totalExpenses.totalByYear,
      percentage: BudgetAnnualCalculatedRow.percent(
          income.totalByYear - totalExpenses.totalByYear, income.totalByYear),
      totalByMonth: TotalByMonth.subtract(
          income.totalByMonth, totalExpenses.totalByMonth),
    );
    var freeCash;
    var totalCashReserves;
    if (isPersonal) {
      freeCash = BudgetAnnualCalculatedRow.freeCashPersonalCalculated(
          netIncome,
          expensesSeparated!.totalByMonth.amount,
          investments!.totalByMonth.amount,
          period,
          yearIncomeTotalSum,
          type);
      totalCashReserves =
          BudgetAnnualCalculatedRow.totalCashReservesPersonalCalculated(
              freeCash,
              totalCashReservesOnStartOfPeriod,
              period,
              yearIncomeTotalSum,
              type);
    } else {
      freeCash = BudgetAnnualCalculatedRow.freeCashBusinessCalculated(
          netIncome,
          expensesSeparated!.totalByMonth.amount,
          period,
          yearIncomeTotalSum,
          type);
      totalCashReserves =
          BudgetAnnualCalculatedRow.totalCashReservesBusinessCalculated(
              freeCash,
              totalCashReservesOnStartOfPeriod,
              period,
              yearIncomeTotalSum,
              type);
    }
    return AnnualBudgetModel(
        type: type,
        isPersonal: isPersonal,
        year: year,
        income: income,
        expenses: expenses,
        expensesSeparated: expensesSeparated,
        investments: investments,
        totalExpenses: totalExpenses,
        netIncome: netIncome,
        freeCash: freeCash,
        businessId: businessId,
        totalCashReserves: totalCashReserves,
        totalCashReservesOnStartOfPeriod: totalCashReservesOnStartOfPeriod,
        yearIncomeTotalSum: income.totalByYear);
  }

  AnnualBudgetModel hideCategory(
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
      BudgetAnnualSubcategory? subcategoryToMove;
      BudgetAnnualCategory? parentCategoryToMove;
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
          subcategoryToExclude is BudgetAnnualSubcategory) {
        for (var nodeIndex = 0;
            nodeIndex < subcategoryToMove.nodes.length;
            nodeIndex++) {
          subcategoryToMove.nodes[nodeIndex] =
              subcategoryToMove.nodes[nodeIndex].copyWith(
                  amount: subcategoryToMove.nodes[nodeIndex].amount +
                      subcategoryToExclude.nodes[nodeIndex].amount);
        }
        parentCategoryToMove.updateSubcategory(subcategoryToMove.id);
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
      totalExpenses = BudgetAnnualCalculatedRow.calculatedTotalExpenses(
          expenses, income.totalByYear);
    }
    var netIncome = BudgetAnnualCalculatedRow(
      totalByYear: income.totalByYear - totalExpenses.totalByYear,
      percentage: BudgetAnnualCalculatedRow.percent(
          income.totalByYear - totalExpenses.totalByYear, income.totalByYear),
      totalByMonth: TotalByMonth.subtract(
          income.totalByMonth, totalExpenses.totalByMonth),
    );
    var freeCash;
    var totalCashReserves;
    if (isPersonal) {
      totalCashReserves =
          BudgetAnnualCalculatedRow.totalCashReservesPersonalCalculated(
              netIncome,
              totalCashReservesOnStartOfPeriod,
              period,
              yearIncomeTotalSum,
              type);
      freeCash = BudgetAnnualCalculatedRow.freeCashPersonalCalculated(
          totalCashReserves,
          expensesSeparated!.totalByMonth.amount,
          investments!.totalByMonth.amount,
          period,
          yearIncomeTotalSum,
          type);
    } else {
      freeCash = BudgetAnnualCalculatedRow.freeCashBusinessCalculated(
          netIncome,
          expensesSeparated!.totalByMonth.amount,
          period,
          yearIncomeTotalSum,
          type);
      totalCashReserves =
          BudgetAnnualCalculatedRow.totalCashReservesBusinessCalculated(
              freeCash,
              totalCashReservesOnStartOfPeriod,
              period,
              yearIncomeTotalSum,
              type);
    }
    return AnnualBudgetModel(
        type: type,
        isPersonal: isPersonal,
        businessId: businessId,
        year: year,
        income: income,
        expenses: expenses,
        expensesSeparated: expensesSeparated,
        investments: investments,
        totalExpenses: totalExpenses,
        netIncome: netIncome,
        freeCash: freeCash,
        totalCashReserves: totalCashReserves,
        totalCashReservesOnStartOfPeriod: totalCashReservesOnStartOfPeriod,
        yearIncomeTotalSum: income.totalByYear);
  }
}

class BudgetAnnualCategory {
  BudgetAnnualCategory({
    required this.parentCategoryId,
    required this.parentCategoryName,
    required this.totalByYear,
    required this.percentage,
    required this.totalByMonth,
    required this.categories,
    required this.tableType,
    required this.categoryType,
    required this.isPersonal,
    required this.period,
    required this.incomeTotalByYear,
  });

  final TableType tableType;
  final CategoryGroupType categoryType;
  final bool isPersonal;
  final String parentCategoryId;
  final String parentCategoryName;
  int totalByYear;
  double percentage;
  TotalByMonth totalByMonth;
  final List<BudgetAnnualSubcategory> categories;
  final Period period;
  int incomeTotalByYear;

  factory BudgetAnnualCategory.fromJson(
    Map<String, dynamic> json, {
    required bool isPersonal,
    required TableType type,
    required CategoryGroupType categoryType,
    required Period period,
    required int incomeTotalYear,
  }) {
    var totalByMonth = TotalByMonth.fromJson(json['totalByMonth'], period);
    var categories = List.from(json['categories'] ?? json['goals'])
        .map((e) => BudgetAnnualSubcategory.fromJson(
              e,
              categoryType: categoryType,
              tableType: type,
              isPersonal: isPersonal,
              parentCategoryId:
                  json['parentCategoryId'] ?? json['goalCategoryId'],
              period: period,
            ))
        .toList();

    return BudgetAnnualCategory(
      parentCategoryId: json['parentCategoryId'] ?? json['goalCategoryId'],
      parentCategoryName:
          json['parentCategoryName'] ?? json['goalCategoryName'],
      totalByYear: json['totalByYear'],
      percentage: json['percentage'],
      totalByMonth: totalByMonth,
      categories: categories,
      categoryType: categoryType,
      isPersonal: isPersonal,
      tableType: type,
      period: period,
      incomeTotalByYear: incomeTotalYear,
    );
  }

  void updateSubcategory(String categoryId) {
    categories
        .where((element) => element.id == categoryId)
        .first
        .updateTotals();
    update();
  }

  void updateCategoriesTotalIncomeByYear(int newIncomeTotalByYear) {
    incomeTotalByYear = newIncomeTotalByYear;
    updateExpensesAndGoals(incomeTotalByYear, percentage);
  }

  void update() {
    if (categoryType == CategoryGroupType.Income) {
      totalByYear = 0;
      for (var item in categories) {
        totalByYear += item.totalByYear;
      }
      for (var item in categories) {
        item.updatePercent(totalByYear);
      }
    } else {
      updateExpensesAndGoals(incomeTotalByYear, percentage);
    }
    totalByMonth = TotalByMonth.calculateForCategory(categories);
  }

  void updateExpensesAndGoals(int totalByYearCategory, double totalPercentage) {
    totalByYear = 0;
    var totalPercentageByYear = 0.0;
    for (var item in categories) {
      totalByYear += item.totalByYear;
    }
    for (var item in categories) {
      item.updatePercent(totalByYearCategory);
      totalPercentageByYear += item.percentage;
    }
    percentage = double.parse((totalPercentageByYear).toStringAsFixed(2));
  }
}

class TotalByMonth {
  TotalByMonth({
    required this.amount,
  });

  final List<int> amount;

  factory TotalByMonth.fromJson(List<dynamic> json, Period period) {
    var result = List.filled(12, 0);
    for (var item in json) {
      double amount = item['amount'];
      var monthYear = DateTime.parse(item['monthYear']);
      result[monthYear.month - 1] = amount.round();
    }
    return TotalByMonth(amount: result);
  }

  factory TotalByMonth.calculateForCategory(
      List<BudgetAnnualSubcategory> values) {
    var result = List.filled(12, 0);
    for (var subcategory in values) {
      for (var node in subcategory.nodes) {
        result[node.monthYear.month - 1] += node.amount;
      }
    }
    return TotalByMonth(amount: result);
  }

  factory TotalByMonth.subtract(
      TotalByMonth totalByMonth, TotalByMonth totalByMonth2) {
    var amount = List.filled(12, 0);
    for (var i = 0; i < 12; i++) {
      amount[i] = totalByMonth.amount[i] - totalByMonth2.amount[i];
    }
    return TotalByMonth(amount: amount);
  }
}

abstract class BudgetSubcategory {
  abstract final String id;
  abstract final String parentCategoryId;
  abstract final CategoryGroupType categoryType;
}

class BudgetAnnualSubcategory extends BudgetSubcategory {
  BudgetAnnualSubcategory({
    required this.id,
    required this.name,
    required this.totalByYear,
    required this.percentage,
    required this.nodes,
    required this.tableType,
    required this.categoryType,
    required this.isPersonal,
    required this.parentCategoryId,
    required this.period,
  });

  @override
  final String id;
  @override
  final String parentCategoryId;
  final String name;
  int totalByYear;
  double percentage;
  final List<BudgetAnnualNode> nodes;
  final TableType tableType;
  @override
  final CategoryGroupType categoryType;
  final bool isPersonal;
  final Period period;

  factory BudgetAnnualSubcategory.fromJson(
    Map<String, dynamic> json, {
    required String parentCategoryId,
    required TableType tableType,
    required CategoryGroupType categoryType,
    required bool isPersonal,
    required Period period,
  }) {
    var nodes = List.from(json['nodes'])
        .map((e) => BudgetAnnualNode.fromJson(e,
            categoryId: json['id'],
            categoryType: categoryType,
            tableType: tableType,
            isPersonal: isPersonal))
        .toList();

    if (nodes.length < 12) {
      for (var month in period.months) {
        if (!(nodes.any((element) => element.monthYear.month == month.month))) {
          nodes.insert(
              month.month - 1,
              BudgetAnnualNode.stub(
                  monthYear: month,
                  categoryId: json['id'],
                  tableType: tableType,
                  categoryType: categoryType,
                  isPersonal: isPersonal));
        }
      }
    }
    // protection from extra nodes that came from BE
    if (nodes.length >= 12) {
      var correctedNodes = <BudgetAnnualNode>[];
      for (var month in period.months) {
        correctedNodes.add(nodes
            .firstWhere((element) => element.monthYear.month == month.month));
      }
      nodes = correctedNodes;
    }

    return BudgetAnnualSubcategory(
      id: json['id'],
      name: json['name'],
      totalByYear: json['totalByYear'],
      percentage: json['percentage'],
      nodes: nodes,
      tableType: tableType,
      categoryType: categoryType,
      isPersonal: isPersonal,
      parentCategoryId: parentCategoryId,
      period: period,
    );
  }

  void updatePercent(int totalIncome) {
    if (totalIncome == 0) {
      percentage = 0;
    } else {
      var result = totalByYear * 100 / totalIncome;
      if (result.abs() < 0.01) {
        percentage = 0;
      } else {
        percentage = double.parse((result).toStringAsFixed(2));
      }
    }
  }

  void updateTotals() {
    totalByYear = 0;
    for (var item in nodes) {
      totalByYear += item.amount;
    }
  }
}

class BudgetAnnualNode {
  BudgetAnnualNode({
    required this.monthYear,
    required this.amount,
    required this.notes,
    required this.expression,
    required this.categoryId,
    required this.tableType,
    required this.categoryType,
    required this.isPersonal,
    required this.isStub,
  });

  final DateTime monthYear;
  final int amount;
  final bool isStub;
  final List<MemoNoteModel> notes;
  final ArithmeticExpression? expression;
  final String categoryId;
  final TableType tableType;
  final CategoryGroupType categoryType;
  final bool isPersonal;

  factory BudgetAnnualNode.fromJson(
    Map<String, dynamic> json, {
    required String categoryId,
    required TableType tableType,
    required CategoryGroupType categoryType,
    required bool isPersonal,
  }) {
    var date = DateTime.parse(json['monthYear']);
    var notes = <MemoNoteModel>[];
    var isGoal =
        isPersonal && categoryType == CategoryGroupType.ExpenseSeparated;
    if (json['notes'] != null) {
      for (var item in json['notes']) {
        notes.add(MemoNoteModel.fromJson(item, isGoal, date));
      }
    }
    return BudgetAnnualNode(
        monthYear: date,
        amount: (json['amount'] as num?)?.round() ?? 0,
        notes: notes,
        expression: json['expression'] != null
            ? ArithmeticExpression(
                expression: json['expression'],
                isValid: json['isExpressionValid'] ?? true)
            : null,
        isPersonal: isPersonal,
        categoryId: categoryId,
        categoryType: categoryType,
        isStub: false,
        tableType: tableType);
  }

  factory BudgetAnnualNode.stub({
    required DateTime monthYear,
    required String categoryId,
    required TableType tableType,
    required CategoryGroupType categoryType,
    required bool isPersonal,
  }) {
    return BudgetAnnualNode(
      amount: 0,
      monthYear: monthYear,
      isStub: true,
      categoryType: categoryType,
      expression: null,
      notes: [],
      isPersonal: isPersonal,
      categoryId: categoryId,
      tableType: tableType,
    );
  }

  void addNote({
    required String noteId,
    required String note,
    required String? transactionId,
    required bool isGoal,
    required double? transactionAmount,
    required bool isTransaction,
    required DateTime? creationDate,
    required ProfileOverviewModel currentUser,
  }) {
    var replies =
        notes.firstWhereOrNull((element) => element.id == noteId)?.replies ??
            [];
    notes.removeWhere((element) => element.id == noteId);
    notes.insert(
      0,
      MemoNoteModel(
        id: noteId,
        note: note,
        transactionId: transactionId,
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

  MemoNotesPage getNotesPage(bool isGoal) {
    return MemoNotesPage.fromNotesList(
        list: notes, isGoal: isGoal, monthYear: monthYear);
  }

  BudgetAnnualNode copyWith({
    int? amount,
    String? expression,
    List<MemoNoteModel>? notes,
  }) {
    return BudgetAnnualNode(
      amount: amount ?? this.amount,
      monthYear: monthYear,
      tableType: tableType,
      categoryType: categoryType,
      expression: (expression == null && amount != null)
          ? null
          : expression != null
              ? ArithmeticExpression.fromExpression(expression)
              : this.expression,
      notes: notes ?? this.notes,
      categoryId: categoryId,
      isPersonal: isPersonal,
      isStub: false,
    );
  }

  void addNoteReply(
      {required MemoNoteModel noteModel, required MemoNoteModel newReply}) {
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

class BudgetAnnualCalculatedRow {
  BudgetAnnualCalculatedRow({
    required this.totalByYear,
    required this.percentage,
    required this.totalByMonth,
  });

  final int totalByYear;
  final double percentage;
  final TotalByMonth totalByMonth;

  factory BudgetAnnualCalculatedRow.fromJson(
      Map<String, dynamic> json, Period period) {
    double? amount = json['totalByYear'];
    return BudgetAnnualCalculatedRow(
        totalByYear: amount?.round() ?? 0,
        percentage: json['percentage'] ?? 0,
        totalByMonth: TotalByMonth.fromJson(json['totalByMonth'], period));
  }

  factory BudgetAnnualCalculatedRow.calculatedTotalExpenses(
      List<BudgetAnnualCategory> expenses, int totalIncome) {
    var subcategories = <BudgetAnnualSubcategory>[];
    for (var item in expenses) {
      subcategories.addAll(item.categories);
    }
    var totalByMonth = TotalByMonth.calculateForCategory(subcategories);
    var totalByYear = 0;
    totalByMonth.amount.forEach((e) {
      totalByYear += e;
    });
    return BudgetAnnualCalculatedRow(
        totalByYear: totalByYear,
        percentage: percent(totalByYear, totalIncome),
        totalByMonth: totalByMonth);
  }

  static double percent(num totalByYear, int totalIncome) {
    if (totalIncome == 0) {
      return 0;
    } else {
      var result = totalByYear * 100 / totalIncome;
      if (result.abs() < 0.01) {
        return 0;
      } else {
        return double.parse((result).toStringAsFixed(2));
      }
    }
  }

  factory BudgetAnnualCalculatedRow.totalCashReservesBusinessCalculated(
      BudgetAnnualCalculatedRow freeCash,
      int totalCashReservesOnStartOfPeriod,
      Period period,
      int totalIncome,
      TableType type) {
    var values = List.filled(12, 0);
    var totalByYear = 0;
    for (var i = 0; i < 12; i++) {
      if (period.months[i].isAfter(DateTime.now()) &&
          type != TableType.Budgeted) {
        break;
      } else {
        if (i == 0) {
          values[i] = totalCashReservesOnStartOfPeriod +
              freeCash.totalByMonth.amount[i];
        } else {
          values[i] = values[i - 1] + freeCash.totalByMonth.amount[i];
        }
        totalByYear = values[i];
      }
    }
    return BudgetAnnualCalculatedRow(
        totalByYear: totalByYear,
        percentage: BudgetAnnualCalculatedRow.percent(totalByYear, totalIncome),
        totalByMonth: TotalByMonth(amount: values));
  }

  factory BudgetAnnualCalculatedRow.freeCashPersonalCalculated(
      BudgetAnnualCalculatedRow totalCashReserves,
      List<int> goals,
      List<int> investments,
      Period period,
      int totalIncome,
      TableType type) {
    var values = totalCashReserves.totalByMonth.amount.toList();

    var totalByYear = 0;
    for (var i = 0; i < 12; i++) {
      if (period.months[i].isAfter(DateTime.now()) &&
          type != TableType.Budgeted) {
        break;
      } else {
        values[i] = values[i] - goals[i] - investments[i];
        totalByYear += values[i];
      }
    }
    return BudgetAnnualCalculatedRow(
        totalByYear: totalByYear,
        percentage: BudgetAnnualCalculatedRow.percent(totalByYear, totalIncome),
        totalByMonth: TotalByMonth(amount: values));
  }

  factory BudgetAnnualCalculatedRow.freeCashBusinessCalculated(
      BudgetAnnualCalculatedRow netIncome,
      List<int> ownerDraw,
      Period period,
      int totalIncome,
      TableType type) {
    var values = netIncome.totalByMonth.amount;
    var totalByYear = 0;
    for (var i = 0; i < 12; i++) {
      if (period.months[i].isAfter(DateTime.now()) &&
          type != TableType.Budgeted) {
        break;
      } else {
        values[i] -= ownerDraw[i];
        totalByYear += values[i];
      }
    }
    return BudgetAnnualCalculatedRow(
        totalByYear: totalByYear,
        percentage: BudgetAnnualCalculatedRow.percent(totalByYear, totalIncome),
        totalByMonth: TotalByMonth(amount: values));
  }

  factory BudgetAnnualCalculatedRow.totalCashReservesPersonalCalculated(
      BudgetAnnualCalculatedRow netIncome,
      int totalCashReservesOnStartOfPeriod,
      Period period,
      int totalIncome,
      TableType type) {
    var values = List.filled(12, 0);
    values[0] = totalCashReservesOnStartOfPeriod;
    var totalByYear = 0;
    for (var i = 0; i < 12; i++) {
      if (period.months[i].isAfter(DateTime.now()) &&
          type != TableType.Budgeted) {
        break;
      } else {
        if (i == 0) {
          values[i] = totalCashReservesOnStartOfPeriod +
              netIncome.totalByMonth.amount[i];
        } else {
          values[i] = values[i - 1] + netIncome.totalByMonth.amount[i];
        }
        totalByYear = values[i];
      }
    }
    return BudgetAnnualCalculatedRow(
        totalByYear: totalByYear,
        percentage: BudgetAnnualCalculatedRow.percent(totalByYear, totalIncome),
        totalByMonth: TotalByMonth(amount: values));
  }
}
