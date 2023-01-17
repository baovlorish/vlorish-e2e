import 'package:burgundy_budgeting_app/ui/model/filter_parameters_model.dart';
import 'package:burgundy_budgeting_app/ui/model/transaction_model.dart';

abstract class BankAccountsAndStatisticsEvent {}

class BankAccountInitialLoadingEvent extends BankAccountsAndStatisticsEvent {}

class BankAccountSelectedEvent extends BankAccountsAndStatisticsEvent {
  final String bankAccountId;

  BankAccountSelectedEvent(this.bankAccountId);
}

class ToggleUnbudgetedEvent extends BankAccountsAndStatisticsEvent {
  final bool unbudgeted;

  ToggleUnbudgetedEvent(this.unbudgeted);
}

class SearchTransactionEvent extends BankAccountsAndStatisticsEvent {
  final String searchText;

  SearchTransactionEvent(this.searchText);
}

class ChangeUsageTypeEvent extends BankAccountsAndStatisticsEvent {
  final int usageType;

  ChangeUsageTypeEvent(this.usageType);
}

class SortByEvent extends BankAccountsAndStatisticsEvent {
  late final int sortBy;
  late final int sortOrder;

  SortByEvent(int sortByDropdownValue) {
    if (sortByDropdownValue == 0) {
      // newest
      sortBy = 1;
      sortOrder = 2;
    } else if (sortByDropdownValue == 1) {
      // oldest
      sortBy = 1;
      sortOrder = 1;
    } else if (sortByDropdownValue == 2) {
      // biggest
      sortBy = 2;
      sortOrder = 2;
    } else if (sortByDropdownValue == 3) {
      // smallest
      sortBy = 2;
      sortOrder = 1;
    }
  }
}

class SetStartDate extends BankAccountsAndStatisticsEvent {
  final DateTime startDate;

  SetStartDate(this.startDate);
}

class SetEndDate extends BankAccountsAndStatisticsEvent {
  final DateTime endDate;

  SetEndDate(this.endDate);
}

class SelectParentCategoryFilterEvent extends BankAccountsAndStatisticsEvent {
  final FilterCategory parentCategory;

  SelectParentCategoryFilterEvent(this.parentCategory);
}

class SelectChildCategoryFilterEvent extends BankAccountsAndStatisticsEvent {
  final FilterCategory childCategory;

  SelectChildCategoryFilterEvent(this.childCategory);
}

class ClearAllFiltersEvent extends BankAccountsAndStatisticsEvent {}

class TransactionPageChanged extends BankAccountsAndStatisticsEvent {
  final int newPageNumber;

  TransactionPageChanged(this.newPageNumber);
}

class TransactionCategoryChanged extends BankAccountsAndStatisticsEvent {
  final String categoryId;
  final String? previousCategoryId;
  final String transactionId;
  final bool shouldBeRemembered;

  TransactionCategoryChanged(
      {required this.transactionId,
      required this.categoryId,
      required this.shouldBeRemembered,
      required this.previousCategoryId});
}

class SetTransactionNoteEvent extends BankAccountsAndStatisticsEvent {
  final String note;
  final String transactionId;

  final bool shouldFetch;

  SetTransactionNoteEvent({
    required this.note,
    required this.transactionId,
    this.shouldFetch = false,
  });
}

class UniteTransactionsEvent extends BankAccountsAndStatisticsEvent {
  final String splitTransactionId;

  UniteTransactionsEvent({
    required this.splitTransactionId,
  });
}

class SplitTransactionEvent extends BankAccountsAndStatisticsEvent {
  final String transactionIdToSplit;
  final List<SplitChildRequestModel> childsOfSplit;
  final bool shouldBeRemembered;

  SplitTransactionEvent(
      {required this.transactionIdToSplit,
      required this.childsOfSplit,
      required this.shouldBeRemembered});
}

class DeleteTransactionNoteEvent extends BankAccountsAndStatisticsEvent {
  final String transactionId;

  DeleteTransactionNoteEvent({
    required this.transactionId,
  });
}

class TransactionNoteErrorEvent extends BankAccountsAndStatisticsEvent {
  final String error;

  TransactionNoteErrorEvent(this.error);
}

class TransactionPageRebuildsEvent extends BankAccountsAndStatisticsEvent {}

class DateFilterTransactionEvent extends BankAccountsAndStatisticsEvent {
  DateFilterTransactionEvent(this.dateFilter, this.periodEndDate);

  final int dateFilter;
  final DateTime? periodEndDate;
}
