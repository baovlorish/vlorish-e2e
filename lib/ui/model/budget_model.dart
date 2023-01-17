import 'package:burgundy_budgeting_app/ui/model/arithmetic_expression.dart';
import 'package:burgundy_budgeting_app/ui/model/memo_note_model.dart';
import 'package:burgundy_budgeting_app/ui/model/period.dart';
import 'package:collection/collection.dart';

enum TableType { Budgeted, Actual, Difference }
enum CategoryGroupType { Income, ExpenseGeneral, ExpenseSeparated, Investment }

class BudgetNode {
  final int budgetedFunds;
  final int actualFunds;
  final DateTime date;
  final bool isStub;
  final CategoryGroupType type;
  final ArithmeticExpression arithmeticExpressionForBudgeted;
  final ArithmeticExpression arithmeticExpressionForActual;
  List<MemoNoteModel> notesInBudgeted;
  List<MemoNoteModel> notesInActual;
  List<MemoNoteModel> notesInDifference;
  String categoryId;

  BudgetNode({
    required this.budgetedFunds,
    required this.actualFunds,
    required this.date,
    required this.categoryId,
    this.isStub = false,
    required this.type,
    required this.arithmeticExpressionForBudgeted,
    required this.notesInBudgeted,
    required this.notesInActual,
    required this.notesInDifference,
    required this.arithmeticExpressionForActual,
  });

  bool hasNote(TableType selectedType) => selectedType == TableType.Budgeted
      ? notesInBudgeted.isNotEmpty
      : selectedType == TableType.Actual
          ? notesInActual.isNotEmpty
          : notesInDifference.isNotEmpty;

  int get diffFunds =>
      date.isAfter(DateTime.now()) ? 0 : budgetedFunds - actualFunds;

  bool hasFormula(TableType selectedType) => selectedType == TableType.Budgeted
      ? arithmeticExpressionForBudgeted.expression.isNotEmpty
      : selectedType == TableType.Actual
          ? arithmeticExpressionForActual.expression.isNotEmpty
          : false;

  @override
  String toString() {
    return 'planned $budgetedFunds actual $actualFunds difference $diffFunds date ${date.month}/${date.year}';
  }

  ArithmeticExpression? arithmeticExpression(TableType type) =>
      type == TableType.Budgeted
          ? arithmeticExpressionForBudgeted
          : type == TableType.Actual
              ? arithmeticExpressionForActual
              : null;

  factory BudgetNode.fromJson(Map<String, dynamic> json, CategoryGroupType type,
      bool isGoal, String category) {
    var date = DateTime.parse(
      json['monthYear'],
    );
    var notesInBudgeted = <MemoNoteModel>[];
    if (json['notesInBudgeted'] != null) {
      for (var item in json['notesInBudgeted']) {
        notesInBudgeted.add(MemoNoteModel.fromJson(item, isGoal, date));
      }
    }
    var notesInActual = <MemoNoteModel>[];
    if (json['notesInActual'] != null) {
      for (var item in json['notesInActual']) {
        notesInActual.add(MemoNoteModel.fromJson(item, isGoal, date));
      }
    }
    var notesInDifference = <MemoNoteModel>[];
    if (json['notesInDifference'] != null) {
      for (var item in json['notesInDifference']) {
        notesInDifference.add(MemoNoteModel.fromJson(item, isGoal, date));
      }
    }
    return BudgetNode(
      budgetedFunds: (json['budgetedFunds'] as double).toInt(),
      actualFunds: (json['actualFunds'] as double).toInt(),
      date: DateTime.parse(
        json['monthYear'],
      ),
      arithmeticExpressionForBudgeted: ArithmeticExpression.fromJson(
          json['arithmeticExpressionForBudgeted']),
      type: type,
      notesInBudgeted: notesInBudgeted,
      notesInActual: notesInActual,
      notesInDifference: notesInDifference,
      arithmeticExpressionForActual:
          ArithmeticExpression.fromJson(json['arithmeticExpressionForActual']),
      categoryId: category,
    );
  }

  BudgetNode copyWith({
    int? budgetedFunds,
    int? actualFunds,
    DateTime? date,
    String? arithmeticExpressionForBudgeted,
    String? arithmeticExpressionForActual,
    List<MemoNoteModel>? notesInBudgeted,
    List<MemoNoteModel>? notesInActual,
    List<MemoNoteModel>? notesInDifference,
  }) {
    return BudgetNode(
      budgetedFunds: budgetedFunds ?? this.budgetedFunds,
      actualFunds: actualFunds ?? this.actualFunds,
      date: date ?? this.date,
      type: type,
      arithmeticExpressionForBudgeted:
          (arithmeticExpressionForBudgeted == null && budgetedFunds != null)
              ? ArithmeticExpression.empty
              : arithmeticExpressionForBudgeted != null
                  ? ArithmeticExpression.fromExpression(
                      arithmeticExpressionForBudgeted)
                  : this.arithmeticExpressionForBudgeted,
      notesInBudgeted: notesInBudgeted ?? this.notesInBudgeted,
      notesInActual: notesInActual ?? this.notesInActual,
      notesInDifference: notesInDifference ?? this.notesInDifference,
      arithmeticExpressionForActual:
          (arithmeticExpressionForActual == null && actualFunds != null)
              ? ArithmeticExpression.empty
              : arithmeticExpressionForActual != null
                  ? ArithmeticExpression.fromExpression(
                      arithmeticExpressionForActual)
                  : this.arithmeticExpressionForActual,
      categoryId: categoryId,
    );
  }

  factory BudgetNode.stub(
      DateTime date, CategoryGroupType type, String category) {
    return BudgetNode(
      budgetedFunds: 0,
      actualFunds: 0,
      date: date,
      isStub: true,
      type: type,
      arithmeticExpressionForBudgeted: ArithmeticExpression.empty,
      arithmeticExpressionForActual: ArithmeticExpression.empty,
      notesInBudgeted: [],
      notesInActual: [],
      notesInDifference: [],
      categoryId: category,
    );
  }

  void addNote({
    required TableType selectedType,
    required String noteId,
    required String note,
    required bool isGoal,
    required double? transactionAmount,
    required bool isTransaction,
    required DateTime? creationDate,
  }) {
    if (selectedType == TableType.Budgeted) {
      notesInBudgeted.removeWhere((element) => element.id == noteId);
/*      notesInBudgeted.insert(
        0,
        MemoNoteModel(
            id: noteId,
            note: note,
            isTransaction: isTransaction,
            transactionAmount: transactionAmount,
            isGoal: isGoal,
            creationDate: creationDate,
            monthYear: date),
      );*/
    } else if (selectedType == TableType.Actual) {
      notesInActual.removeWhere((element) => element.id == noteId);
/*       notesInActual.insert(
        0,
       MemoNoteModel(
          id: noteId,
          note: note,
          isTransaction: isTransaction,
          transactionAmount: transactionAmount,
          isGoal: isGoal,
          monthYear: date,
          creationDate: creationDate,
        ),
      );*/
    } else {
      notesInDifference.removeWhere((element) => element.id == noteId);
/*      notesInDifference.insert(
        0,
        MemoNoteModel(
            id: noteId,
            note: note,
            isTransaction: isTransaction,
            transactionAmount: transactionAmount,
            isGoal: isGoal,
            creationDate: creationDate,
            monthYear: date),
      );*/
    }
  }

  void deleteNote({
    required TableType selectedType,
    required MemoNoteModel note,
  }) {
    if (selectedType == TableType.Budgeted) {
      notesInBudgeted.removeWhere((element) => element.id == note.id);
    } else if (selectedType == TableType.Actual) {
      notesInActual.removeWhere((element) => element.id == note.id);
    } else {
      notesInDifference.removeWhere((element) => element.id == note.id);
    }
  }

  MemoNotesPage getNotesPage(TableType selectedType, bool isGoal) {
    if (selectedType == TableType.Budgeted) {
      return MemoNotesPage.fromNotesList(
          list: notesInBudgeted, isGoal: isGoal, monthYear: date);
    } else if (selectedType == TableType.Actual) {
      return MemoNotesPage.fromNotesList(
          list: notesInActual, isGoal: isGoal, monthYear: date);
    } else {
      return MemoNotesPage.fromNotesList(
          list: notesInDifference, isGoal: isGoal, monthYear: date);
    }
  }
}

class BudgetCategory {
  final String id;
  final String name;
  final List<BudgetNode> nodes;
  final CategoryGroupType type;

  BudgetCategory({
    required this.nodes,
    required this.id,
    required this.name,
    required this.type,
  });

  factory BudgetCategory.fromJson(Map<String, dynamic> json,
      {required Period period,
      required CategoryGroupType type,
      required bool isPersonal,
      required bool isGoal}) {
    //unique json fields naming on backend
    var idJsonKey = 'id';
    var nameJsonKey = 'name';
    if (isPersonal && type == CategoryGroupType.ExpenseSeparated) {
      idJsonKey = 'goalId';
      nameJsonKey = 'goalName';
    }
    var nodes = <BudgetNode>[];
    for (var item in json['nodes']) {
      nodes.add(BudgetNode.fromJson(item, type, isGoal, json[idJsonKey]));
    }

    for (var month in period.months) {
      if (!(nodes.any((element) =>
          element.date.year == month.year &&
          element.date.month == month.month))) {
        nodes.add(BudgetNode.stub(month, type, json[idJsonKey]));
      }
    }

    nodes.sort((a, b) => (a.date).compareTo(b.date));

    if (nodes.length > period.months.length) {
      var correctedNodes = <BudgetNode>[];
      for (var month in period.months) {
        correctedNodes
            .add(nodes.firstWhere((element) => element.date == month));
      }
      nodes = correctedNodes;
    }

    return BudgetCategory(
      id: json[idJsonKey],
      name: json[nameJsonKey],
      nodes: nodes,
      type: type,
    );
  }

  @override
  String toString() => 'Category $name id: $id length: ${nodes.length}';

  // sums in category per period
  int get budgetedSumInCategory {
    var result = 0;
    for (var node in nodes) {
      result += node.budgetedFunds;
    }
    return result;
  }

  int get actualSumInCategory {
    var result = 0;
    for (var node in nodes) {
      result += node.actualFunds;
    }
    return result;
  }

  int get diffSumInCategory {
    var result = 0;
    for (var node in nodes) {
      result += node.diffFunds;
    }
    return result;
  }
}

class BudgetCategoryGroup {
  final String id;
  final String name;
  final CategoryGroupType type;
  final List<BudgetCategory> categories;

  int get nodeCount => categories.isNotEmpty ? categories[0].nodes.length : 0;

  BudgetCategoryGroup({
    required this.categories,
    required this.id,
    required this.name,
    required this.type,
  });

  factory BudgetCategoryGroup.fromJson(
    Map<String, dynamic> json, {
    required Period period,
    required CategoryGroupType type,
    required bool isPersonal,
  }) {
    var categories = <BudgetCategory>[];
    //unique json fields naming on backend
    var jsonKey = 'categories';
    if (isPersonal && type == CategoryGroupType.ExpenseSeparated) {
      jsonKey = 'goals';
    }
    for (var item in json[jsonKey]) {
      categories.add(BudgetCategory.fromJson(
        item,
        type: type,
        isPersonal: isPersonal,
        period: period,
        isGoal: isPersonal && type == CategoryGroupType.ExpenseSeparated,
      ));
    }

    return BudgetCategoryGroup(
      id: json['id'],
      name: json['name'],
      categories: categories,
      type: type,
    );
  }

  //sums in categoryGroup per node
  List<int> get budgetedInCategoryGroupPerNode {
    var sums = List.generate(nodeCount, (index) => 0);
    for (var index = 0; index < nodeCount; index++) {
      for (var category in categories) {
        if (category.nodes.isNotEmpty) {
          sums[index] += category.nodes[index].budgetedFunds;
        }
      }
    }
    return sums;
  }

  List<int> get actualInCategoryGroupPerNode {
    var sums = List.generate(nodeCount, (index) => 0);
    if (categories.isNotEmpty) {
      for (var index = 0; index < nodeCount; index++) {
        for (var category in categories) {
          if (category.nodes.isNotEmpty) {
            sums[index] += category.nodes[index].actualFunds;
          }
        }
      }
    }
    return sums;
  }

  List<int> get diffInCategoryGroupPerNode {
    var sums = List.generate(nodeCount, (index) => 0);
    for (var index = 0; index < nodeCount; index++) {
      for (var category in categories) {
        if (category.nodes.isNotEmpty) {
          sums[index] += category.nodes[index].diffFunds;
        }
      }
    }
    return sums;
  }

  //total sum per category group
  int get budgetedInCategoryGroup {
    var result = 0;
    for (var nodeSum in budgetedInCategoryGroupPerNode) {
      result += nodeSum;
    }
    return result;
  }

  int get actualInCategoryGroup {
    var result = 0;
    for (var nodeSum in actualInCategoryGroupPerNode) {
      result += nodeSum;
    }
    return result;
  }

  int get diffInCategoryGroup {
    var result = 0;
    for (var nodeSum in diffInCategoryGroupPerNode) {
      result += nodeSum;
    }
    return result;
  }
}

class BudgetModel {
  final List<BudgetCategoryGroup> expenses;
  final List<BudgetCategoryGroup> income;
  final BudgetCategoryGroup? investments;
  final Period period;
  final int budgetedStartPeriodReserves;
  final int actualStartPeriodReserves;

  BudgetModel({
    required this.expenses,
    required this.income,
    required this.investments,
    required this.period,
    required this.budgetedStartPeriodReserves,
    required this.actualStartPeriodReserves,
  });

  BudgetModel getMonth(DateTime dateTime) {
    assert(period.months.contains(dateTime));
    var monthIndex = period.months.indexOf(dateTime);

    var monthExpenses = <BudgetCategoryGroup>[];
    var monthIncome = <BudgetCategoryGroup>[];

    for (var categoryGroup in income) {
      var monthCategoryGroup = BudgetCategoryGroup(
          categories: [],
          id: categoryGroup.id,
          name: categoryGroup.name,
          type: categoryGroup.type);
      for (var category in categoryGroup.categories) {
        monthCategoryGroup.categories.add(
          BudgetCategory(
              nodes: [category.nodes[monthIndex]],
              id: category.id,
              name: category.name,
              type: CategoryGroupType.Income),
        );
      }
      monthIncome.add(monthCategoryGroup);
    }

    for (var categoryGroup in expenses) {
      var monthCategoryGroup = BudgetCategoryGroup(
          categories: [],
          id: categoryGroup.id,
          name: categoryGroup.name,
          type: categoryGroup.type);
      for (var category in categoryGroup.categories) {
        monthCategoryGroup.categories.add(
          BudgetCategory(nodes: [
            category.nodes.firstWhere((element) => element.date == dateTime)
          ], id: category.id, name: category.name, type: categoryGroup.type),
        );
      }
      monthExpenses.add(monthCategoryGroup);
    }

    var monthInvestments;
    if (investments != null) {
      monthInvestments = BudgetCategoryGroup(
          categories: [],
          id: investments!.id,
          name: investments!.name,
          type: investments!.type);
      for (var category in investments!.categories) {
        monthInvestments.categories.add(
          BudgetCategory(nodes: [
            category.nodes.firstWhere((element) => element.date == dateTime)
          ], id: category.id, name: category.name, type: investments!.type),
        );
      }
    }

    return BudgetModel(
      period: Period(dateTime, 1),
      expenses: monthExpenses,
      income: monthIncome,
      investments: monthInvestments,
      actualStartPeriodReserves: actualStartPeriodReserves,
      budgetedStartPeriodReserves: budgetedStartPeriodReserves,
    );
  }

  BudgetModel updateBudget(
      BudgetNode newNode, String categoryId, BudgetModel model) {
    var updatedMonthIndex = period.months.indexOf(newNode.date);

    var updatedExpenses = <BudgetCategoryGroup>[];
    var updatedIncome = <BudgetCategoryGroup>[];
    if (newNode.type == CategoryGroupType.Income) {
      for (var categoryGroup in income) {
        var updatedCategoryGroup = BudgetCategoryGroup(
            categories: [],
            id: categoryGroup.id,
            name: categoryGroup.name,
            type: categoryGroup.type);
        for (var category in categoryGroup.categories) {
          var updatedCategory = BudgetCategory(
              nodes: [],
              id: category.id,
              name: category.name,
              type: category.type);
          for (var node in category.nodes) {
            if (category.nodes.indexOf(node) == updatedMonthIndex &&
                category.id == categoryId) {
              updatedCategory.nodes.add(newNode);
            } else {
              updatedCategory.nodes.add(node);
            }
          }
          updatedCategoryGroup.categories.add(updatedCategory);
        }
        updatedIncome.add(updatedCategoryGroup);
      }
    } else {
      updatedIncome = income;
    }
    if (newNode.type == CategoryGroupType.ExpenseGeneral ||
        newNode.type == CategoryGroupType.ExpenseSeparated) {
      for (var categoryGroup in expenses) {
        var updatedCategoryGroup = BudgetCategoryGroup(
            categories: [],
            id: categoryGroup.id,
            name: categoryGroup.name,
            type: categoryGroup.type);
        for (var category in categoryGroup.categories) {
          var updatedCategory = BudgetCategory(
              nodes: [],
              id: category.id,
              name: category.name,
              type: category.type);
          for (var node in category.nodes) {
            if (category.nodes.indexOf(node) == updatedMonthIndex &&
                category.id == categoryId) {
              updatedCategory.nodes.add(newNode);
            } else {
              updatedCategory.nodes.add(node);
            }
          }
          updatedCategoryGroup.categories.add(updatedCategory);
        }
        updatedExpenses.add(updatedCategoryGroup);
      }
    } else {
      updatedExpenses = expenses;
    }

    var updatedInvestments;
    if (newNode.type == CategoryGroupType.Investment) {
      updatedInvestments = BudgetCategoryGroup(
          categories: [],
          id: investments!.id,
          name: investments!.name,
          type: investments!.type);
      for (var category in investments!.categories) {
        var updatedCategory = BudgetCategory(
            nodes: [],
            id: category.id,
            name: category.name,
            type: category.type);
        for (var node in category.nodes) {
          if (category.nodes.indexOf(node) == updatedMonthIndex &&
              category.id == categoryId) {
            updatedCategory.nodes.add(newNode);
          } else {
            updatedCategory.nodes.add(node);
          }
        }
        updatedInvestments.categories.add(updatedCategory);
      }
    } else {
      updatedInvestments = investments;
    }
    return BudgetModel(
      period: period,
      expenses: updatedExpenses,
      income: updatedIncome,
      investments: updatedInvestments,
      actualStartPeriodReserves: actualStartPeriodReserves,
      budgetedStartPeriodReserves: budgetedStartPeriodReserves,
    );
  }

  factory BudgetModel.fromJson(
    Map<String, dynamic> data, {
    required bool isPersonal,
    required Period period,
  }) {
    var income = <BudgetCategoryGroup>[];
    var expenses = <BudgetCategoryGroup>[];
    income.add(
      BudgetCategoryGroup.fromJson(data['income'],
          type: CategoryGroupType.Income,
          isPersonal: isPersonal,
          period: period),
    );

    for (var group in data['expenses']) {
      expenses.add(
        BudgetCategoryGroup.fromJson(group,
            type: CategoryGroupType.ExpenseGeneral,
            isPersonal: isPersonal,
            period: period),
      );
    }

    var expenseSeparatedKey = isPersonal ? 'goals' : 'ownerDraw';

    expenses.add(
      BudgetCategoryGroup.fromJson(data[expenseSeparatedKey],
          type: CategoryGroupType.ExpenseSeparated,
          isPersonal: isPersonal,
          period: period),
    );

    var investments;
    if (data['investments'] != null) {
      investments = BudgetCategoryGroup.fromJson(data['investments'],
          period: period,
          type: CategoryGroupType.Investment,
          isPersonal: isPersonal);
    } else if (isPersonal) {
      investments = BudgetCategoryGroup(
          categories: [],
          id: 'ef6691dd-397f-4b73-834a-0d25d966dfdc',
          name: 'Investments',
          type: CategoryGroupType.Investment);
    }

    var actualStartPeriodReserves = (isPersonal
            ? data['actualTotalCashReserves']
            : data['actualEndingCashReserves'] as double)
        .toInt();
    var budgetedStartPeriodReserves = (isPersonal
            ? data['budgetedTotalCashReserves']
            : data['budgetedEndingCashReserves'] as double)
        .toInt();

    return BudgetModel(
      expenses: expenses,
      income: income,
      period: period,
      investments: investments,
      actualStartPeriodReserves: actualStartPeriodReserves,
      budgetedStartPeriodReserves: budgetedStartPeriodReserves,
    );
  }
}

extension Calculations on BudgetModel {
  List<int> totalCashReserves(isPersonal, TableType type) {
    var startPeriodReserves = type == TableType.Budgeted
        ? budgetedStartPeriodReserves
        : actualStartPeriodReserves;
    var values = <int>[];
    if (isPersonal) {
      values = type == TableType.Budgeted
          ? budgetedNetIncome
          : type == TableType.Actual
              ? actualNetIncome
              : diffNetIncome;
    } else {
      values = freeCash(isPersonal, type);
    }

    var result = List.generate(nodeCount, (index) => 0);
    for (var index = 0; index < nodeCount; index++) {
      if (period.months[index].isAfter(DateTime.now()) &&
          type != TableType.Budgeted) {
        result[index] = 0;
      } else {
        if (index == 0) {
          result[index] = startPeriodReserves + values[index];
        } else {
          result[index] = result[index - 1] + values[index];
        }
      }
    }
    return result;
  }

  int getPeriodSum(List<int> values) {
    var sum = 0;
    for (var item in values) {
      sum += item;
    }
    return sum;
  }

  // for budget annual table percent is sum in category divided by total income
  String getPercent(int value, int totalIncome) {
    if (totalIncome == 0) {
      return '0%';
    } else {
      var result = value * 100 / totalIncome;
      if (result.abs() < 0.01) return '0%';
      return '${double.parse((result).toStringAsFixed(2))}%';
    }
  }

  ///total budgeted income for period
  int get totalBudgetedIncome {
    var result = 0;
    for (var categoryGroup in income) {
      result += categoryGroup.budgetedInCategoryGroup;
    }
    return result;
  }

  ///total actual income for period
  int get totalActualIncome {
    var result = 0;
    for (var categoryGroup in income) {
      result += categoryGroup.actualInCategoryGroup;
    }
    return result;
  }

  ///total difference income for period
  int get totalDifferenceIncome {
    var result = 0;
    for (var categoryGroup in income) {
      result += categoryGroup.diffInCategoryGroup;
    }
    return result;
  }

  int get nodeCount => expenses.first.nodeCount;

  ///budgeted expenses per node without goals
  List<int> get totalBudgetedExpensesPerNode {
    var result = List.generate(nodeCount, (index) => 0);
    var list = expenses.getRange(0, expenses.length - 1).toList();
    for (var index = 0; index < nodeCount; index++) {
      for (var categoryGroup in list) {
        result[index] += categoryGroup.budgetedInCategoryGroupPerNode[index];
      }
    }
    return result;
  }

  List<int> get totalActualExpensesPerNode {
    var result = List.generate(nodeCount, (index) => 0);
    var list = expenses.getRange(0, expenses.length - 1).toList();
    for (var index = 0; index < nodeCount; index++) {
      for (var categoryGroup in list) {
        result[index] += categoryGroup.actualInCategoryGroupPerNode[index];
      }
    }
    return result;
  }

  List<int> get totalDiffExpensesPerNode {
    var result = List.generate(nodeCount, (index) => 0);
    var list = expenses.getRange(0, expenses.length - 1).toList();
    for (var index = 0; index < nodeCount; index++) {
      for (var categoryGroup in list) {
        result[index] += categoryGroup.diffInCategoryGroupPerNode[index];
      }
    }
    return result;
  }

  int get totalBudgetedExpensesPeriod {
    var result = 0;
    for (var item in totalBudgetedExpensesPerNode) {
      result += item;
    }
    return result;
  }

  int get totalActualExpensesPeriod {
    var result = 0;
    for (var item in totalActualExpensesPerNode) {
      result += item;
    }
    return result;
  }

  int get totalDiffExpensesPeriod {
    var result = 0;
    for (var item in totalDiffExpensesPerNode) {
      result += item;
    }
    return result;
  }

  List<int> get budgetedNetIncome {
    var result = List.generate(nodeCount, (index) => 0);
    for (var index = 0; index < nodeCount; index++) {
      for (var categoryGroup in income) {
        if (categoryGroup.categories.isNotEmpty) {
          result[index] += categoryGroup.budgetedInCategoryGroupPerNode[index];
        }
      }
      result[index] -= totalBudgetedExpensesPerNode[index];
    }
    return result;
  }

  int get budgetedNetIncomeSum {
    var result = 0;
    for (var item in budgetedNetIncome) {
      result += item;
    }
    return result;
  }

  List<int> get actualNetIncome {
    var result = List.generate(nodeCount, (index) => 0);
    for (var index = 0; index < nodeCount; index++) {
      for (var categoryGroup in income) {
        if (categoryGroup.categories.isNotEmpty) {
          result[index] += categoryGroup.actualInCategoryGroupPerNode[index];
        }
      }
      result[index] -= totalActualExpensesPerNode[index];
    }
    return result;
  }

  int get actualNetIncomeSum {
    var result = 0;
    for (var item in actualNetIncome) {
      result += item;
    }
    return result;
  }

  List<int> get diffNetIncome {
    var result = List.generate(nodeCount, (index) => 0);
    for (var index = 0; index < nodeCount; index++) {
      for (var categoryGroup in income) {
        if (categoryGroup.categories.isNotEmpty) {
          result[index] += categoryGroup.diffInCategoryGroupPerNode[index];
        }
      }
      result[index] -= totalDiffExpensesPerNode[index];
    }
    return result;
  }

  int get diffNetIncomeSum {
    var result = 0;
    for (var item in diffNetIncome) {
      result += item;
    }
    return result;
  }

  List<int> freeCash(isPersonal, TableType type) {
    var result = List.generate(nodeCount, (index) => 0);
    if (isPersonal) {
      var _totalCashReserves = totalCashReserves(isPersonal, type);
      var investmentsValues = List.generate(nodeCount, (index) => 0);
      if (investments?.categories.isNotEmpty == true) {
        investmentsValues = type == TableType.Budgeted
            ? investments!.budgetedInCategoryGroupPerNode
            : type == TableType.Actual
                ? investments!.actualInCategoryGroupPerNode
                : investments!.diffInCategoryGroupPerNode;
      }
      var goalsValues = List.generate(nodeCount, (index) => 0);
      if (expenses.last.categories.isNotEmpty) {
        goalsValues = type == TableType.Budgeted
            ? expenses.last.budgetedInCategoryGroupPerNode
            : type == TableType.Actual
                ? expenses.last.actualInCategoryGroupPerNode
                : expenses.last.diffInCategoryGroupPerNode;
      }
      for (var index = 0; index < nodeCount; index++) {
        result[index] = _totalCashReserves[index] -
            investmentsValues[index] -
            goalsValues[index];
      }
    } else {
      var netIncome = type == TableType.Budgeted
          ? budgetedNetIncome
          : type == TableType.Actual
              ? actualNetIncome
              : diffNetIncome;
      for (var index = 0; index < nodeCount; index++) {
        result[index] += netIncome[index];
        if (expenses.last.categories.isNotEmpty) {
          var value = type == TableType.Budgeted
              ? expenses.last.budgetedInCategoryGroupPerNode[index]
              : type == TableType.Actual
                  ? expenses.last.actualInCategoryGroupPerNode[index]
                  : expenses.last.diffInCategoryGroupPerNode[index];
          result[index] -= value;
        }
      }
    }

    return result;
  }

  ///For monthly dashboards
  ///Total budgeted value should show sum by all rows in Budgeted expenses column for current month
  int get totalBudgetedExpenses {
    var result = 0;
    for (var categoryGroup in expenses
        .where((element) => element.type == CategoryGroupType.ExpenseGeneral)) {
      for (var node in categoryGroup.budgetedInCategoryGroupPerNode) {
        result += node;
      }
    }
    return result;
  }

  ///For monthly dashboards
  ///  Total spent value should show sum by all rows in Actual expenses column for current month
  int get totalActualExpenses {
    var result = 0;
    for (var categoryGroup in expenses
        .where((element) => element.type == CategoryGroupType.ExpenseGeneral)) {
      for (var node in categoryGroup.actualInCategoryGroupPerNode) {
        result += node;
      }
    }
    return result;
  }

  ///For monthly dashboards
  ///  Difference value should show sum by all rows in Difference expenses column for current month
  int get totalDifferenceExpenses {
    var result = 0;
    for (var categoryGroup in expenses
        .where((element) => element.type == CategoryGroupType.ExpenseGeneral)) {
      for (var node in categoryGroup.diffInCategoryGroupPerNode) {
        result += node;
      }
    }
    return result;
  }

  ///For monthly dashboards
  int get totalUnbudgeted {
    var result = 0;
    for (var categoryGroup in expenses.where((element) =>
        element.id == '941435d2-313b-4a99-b62c-e17fc9d52d4e' ||
        element.id == '5305617c-0bd4-4dd7-8a05-b4202ccf4297')) {
      var unbudgetedExpenses = categoryGroup.categories.firstWhereOrNull(
          (element) =>
              element.id == '2a3c8f8d-7401-466b-a8ec-e6f5bfe75870' ||
              element.id == '824e6410-7355-4152-bacf-ddb615648758');
      if (unbudgetedExpenses != null) {
        for (var node in unbudgetedExpenses.nodes) {
          result += node.actualFunds;
        }
      }
    }
    return result;
  }

  int get totalDiffIncome {
    var result = 0;
    for (var categoryGroup in income) {
      for (var node in categoryGroup.diffInCategoryGroupPerNode) {
        result += node;
      }
    }
    return result;
  }
}
