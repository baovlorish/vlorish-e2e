import 'package:burgundy_budgeting_app/domain/model/request/transactions_page_request.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_transactions_service.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/bank_accounts_transactions/model/transactions_filter_model.dart';
import 'package:dio/src/response.dart';

class ApiTransactionsServiceImpl extends ApiTransactionsService {
  final String transactionsPageEndpoint = '/transaction/page';
  final String setCategoryEndpoint = '/transaction/category';
  final String statisticsEndpoint = '/transaction/statistics';
  final String filterParametersEndpoint = '/transaction/filter-parameters';
  final String transactionNoteEndpoint = '/transaction/note';
  final String transactionNoteReplyEndpoint = '/transaction/note-reply';
  final String splitEndpoint = '/transaction/split';
  final String uniteEndpoint = '/transaction/unite';
  final String refreshEndpoint = '/transaction/refresh';
  final String getTransactionNoteEndpoint = '/transaction/get-note';
  final HttpManager httpManager;

  ApiTransactionsServiceImpl(this.httpManager) : super(httpManager);

  @override
  Future<Response> getTransactionsPage(TransactionsPageRequest request) async {
    return await httpManager.dio.post(
      transactionsPageEndpoint,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> setTransactionCategory(
      String categoryId, List<String> transactionIds, bool shouldBeRemembered) async {
    return await httpManager.dio.put(
      setCategoryEndpoint,
      data: {
        'categoryId': categoryId,
        'transactionIds': transactionIds,
        'shouldBeRemembered': shouldBeRemembered
      },
    );
  }

  @override
  Future<Response> getStatistics(
    TransactionFiltersModel request,
  ) async {
    return await httpManager.dio.post(
      statisticsEndpoint,
      data: request.toMap(),
    );
  }

  @override
  Future<Response> getFilterParameters() async {
    return await httpManager.dio.get(
      filterParametersEndpoint,
    );
  }

  @override
  Future<Response> setTransactionNote(String note, String transactionId) async {
    return await httpManager.dio.put(transactionNoteEndpoint, data: {
      'note': note,
      'transactionId': transactionId,
    });
  }

  @override
  Future<Response> deleteTransactionNote(String transactionId) async {
    return await httpManager.dio.delete(transactionNoteEndpoint, data: {
      'transactionId': transactionId,
    });
  }

  @override
  Future<Response> splitTransaction(Map<String, dynamic> query) async {
    return await httpManager.dio.post(splitEndpoint, data: query);
  }

  @override
  Future<Response> uniteTransactions(String splitTransactionId) async {
    return await httpManager.dio.post(uniteEndpoint, data: {
      'splitTransactionId': splitTransactionId,
    });
  }

  @override
  Future<Response> refreshTransactions() async {
    return await httpManager.dio.post(refreshEndpoint);
  }

  @override
  Future<Response> addTransactionNoteReply(
      String note, String transactionNoteId) async {
    return await httpManager.dio.post(transactionNoteReplyEndpoint, data: {
      'transactionNoteId': transactionNoteId,
      'note': note,
    });
  }

  @override
  Future<Response> deleteTransactionNoteReply(
      String transactionNoteReplyId) async {
    return await httpManager.dio.delete(transactionNoteReplyEndpoint, data: {
      'transactiionNoteReplyId': transactionNoteReplyId,
    });
  }

  @override
  Future<Response> editTransactionNoteReply(
      String note, String transactionNoteReplyId) async {
    return await httpManager.dio.put(transactionNoteReplyEndpoint, data: {
      'transactiionNoteReplyId': transactionNoteReplyId,
      'note': note,
    });
  }

  @override
  Future<Response> fetchNote(String transactionId) async {
    return await httpManager.dio.post(getTransactionNoteEndpoint, data: {
      'transactionId': transactionId,
    });
  }
}
