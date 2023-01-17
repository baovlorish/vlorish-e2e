import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';

class UserSupportService {
  final String _ticketEndpoint = '/tickets.json';
  final HttpManager _httpManager;

  UserSupportService(this._httpManager);

  Future<Response> createTicket(Map<String, dynamic> data) async {
    return await _httpManager.dioSupport.post(
      _ticketEndpoint,
      data: data,
    );
  }
}
