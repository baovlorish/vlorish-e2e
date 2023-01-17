import 'package:burgundy_budgeting_app/domain/model/request/requests_page_request_model.dart';
import 'package:burgundy_budgeting_app/domain/model/request/send_request_request_model.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_request_service.dart';
import 'package:burgundy_budgeting_app/ui/model/edit_request_item_request.dart';
import 'package:burgundy_budgeting_app/ui/model/note_request_item_request.dart';
import 'package:dio/dio.dart';

class ApiRequestServiceImpl extends ApiRequestService {
  ApiRequestServiceImpl(this.httpManager);
  final HttpManager httpManager;
  final String requestsPageEndpoint = '/request/page';
  final String requestEndpoint = '/request';
  final String requestNoteEndpoint = '/request/note';
  final String requestEditEndpoint = '/request/edit';
  final String requestApproveEndpoint = '/request/approve';
  final String requestAcceptAccessTypeChangingEndpoint =
      '/request/access-type-changing/accept';
  final String requestDeclineAccessTypeChangingEndpoint =
      '/request/access-type-changing/decline';

  @override
  Future<Response> sendRequest(RequestSendRequestModel request) async {
    return await httpManager.dio.post(
      requestEndpoint,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> fetchRequestPage(RequestsPageRequestModel request) async {
    return await httpManager.dio.post(
      requestsPageEndpoint,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> deleteRequest(String requestId) async {
    return await httpManager.dio.delete(
      requestEndpoint,
      data: {'requestId': requestId},
    );
  }

  @override
  Future<Response> noteRequest(NoteRequestItemRequest request) async {
    return await httpManager.dio.put(
      requestNoteEndpoint,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> approveRequest(String requestId) async {
    return await httpManager.dio.post(
      requestApproveEndpoint,
      data: {'requestId': requestId},
    );
  }

  @override
  Future<Response> editRequest(EditRequestItemRequest request) async {
    return await httpManager.dio.post(
      requestEditEndpoint,
      data: request.toJson(),
    );
  }

  @override
  Future<Response> acceptAccessTypeChangingRequest(String requestId) async {
    return await httpManager.dio.post(
      requestAcceptAccessTypeChangingEndpoint,
      data: {'requestId': requestId},
    );
  }

  @override
  Future<Response> declineAccessTypeChangingRequest(String requestId) async {
    return await httpManager.dio.post(
      requestDeclineAccessTypeChangingEndpoint,
      data: {'requestId': requestId},
    );
  }
}
