import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/model/transactions_filter_model.dart';
import 'package:burgundy_budgeting_app/ui/model/bank_account.dart';
import 'package:burgundy_budgeting_app/ui/model/category_management_page_model.dart';
import 'package:burgundy_budgeting_app/ui/model/filter_parameters_model.dart';
import 'package:burgundy_budgeting_app/ui/model/transaction_model.dart';
import 'package:burgundy_budgeting_app/ui/model/transactions_statistics_model.dart';
import 'package:equatable/equatable.dart';

abstract class BankAccountsAndStatisticsState extends Equatable {
  const BankAccountsAndStatisticsState();
}

class BankAccountsAndStatisticsInitial extends BankAccountsAndStatisticsState {
  BankAccountsAndStatisticsInitial();

  @override
  List<Object> get props => [];
}

class BankAccountsAndStatisticsError extends BankAccountsAndStatisticsState {
  final String error;
  final void Function()? callback;

  BankAccountsAndStatisticsError(this.error, {this.callback});

  @override
  List<Object> get props => [error];
}

class BankAccountsAndStatisticsLoaded extends BankAccountsAndStatisticsState {
  final List<BankAccount> accounts;
  final TransactionsStatisticsModel statisticsModel;
  final TransactionFiltersModel transactionFiltersModel;
  final TransactionListModel transactionList;
  final int transactionPageNumber;
  final CategoryManagementPageModel categoriesModel;
  final FilterParametersModel filterParametersModel;

  BankAccountsAndStatisticsLoaded(
    this.accounts,
    this.statisticsModel, {
    required this.transactionFiltersModel,
    required this.transactionList,
    required this.categoriesModel,
    this.transactionPageNumber = 1,
    required this.filterParametersModel,
  });

  @override
  List<Object?> get props => [
        accounts,
        statisticsModel,
        transactionFiltersModel,
        categoriesModel,
        transactionList,
        transactionPageNumber,
        filterParametersModel,
      ];

  BankAccountsAndStatisticsLoaded copyWith({
    List<BankAccount>? accounts,
    TransactionsStatisticsModel? statisticsModel,
    TransactionFiltersModel? transactionFiltersModel,
    TransactionListModel? transactionList,
    int? transactionPageNumber,
    CategoryManagementPageModel? categoriesModel,
    FilterParametersModel? filterParametersModel,
  }) =>
      BankAccountsAndStatisticsLoaded(
        accounts ?? this.accounts,
        statisticsModel ?? this.statisticsModel,
        transactionFiltersModel:
            transactionFiltersModel ?? this.transactionFiltersModel,
        categoriesModel: categoriesModel ?? this.categoriesModel,
        filterParametersModel:
            filterParametersModel ?? this.filterParametersModel,
        transactionList: transactionList ?? this.transactionList,
      );
}

abstract class BankAccountsAndStatisticsLoading
    extends BankAccountsAndStatisticsState {}
