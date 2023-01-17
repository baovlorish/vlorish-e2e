import 'package:burgundy_budgeting_app/domain/model/request/transactions_page_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/model/transactions_filter_model.dart';
import 'package:dio/dio.dart';

abstract class ApiTransactionsService {
  ApiTransactionsService(HttpManager httpManager);

  Future<Response> getTransactionsPage(TransactionsPageRequest request);

  Future<Response> setTransactionCategory(
      String categoryId, List<String> transactionIds, bool shouldBeRemembered);

  Future<Response> getStatistics(
    TransactionFiltersModel request,
  );

  Future<Response> getFilterParameters();

  Future<Response> setTransactionNote(String note, String transactionId);

  Future<Response> deleteTransactionNote(String transactionId);

  Future<Response> splitTransaction(Map<String, dynamic> query);

  Future<Response> uniteTransactions(String splitTransactionId);

  Future<Response> refreshTransactions();

  Future<Response> addTransactionNoteReply(
      String note, String transactionNoteId);

  Future<Response> editTransactionNoteReply(
      String note, String transactionNoteReplyId);

  Future<Response> deleteTransactionNoteReply(String transactionNoteReplyId);

  Future<Response> fetchNote(String transactionId);
}
