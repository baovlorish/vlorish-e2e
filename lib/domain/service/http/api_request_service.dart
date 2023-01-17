import 'package:burgundy_budgeting_app/domain/model/request/requests_page_request_model.dart';
import 'package:burgundy_budgeting_app/domain/model/request/send_request_request_model.dart';
import 'package:burgundy_budgeting_app/ui/model/edit_request_item_request.dart';
import 'package:burgundy_budgeting_app/ui/model/note_request_item_request.dart';
import 'package:dio/dio.dart';

abstract class ApiRequestService {
  Future<Response> fetchRequestPage(RequestsPageRequestModel request);

  Future<Response> sendRequest(RequestSendRequestModel request);

  Future<Response> deleteRequest(String invitationId);

  Future<Response> noteRequest(NoteRequestItemRequest request);

  Future<Response> approveRequest(String requestId);

  Future<Response> editRequest(EditRequestItemRequest request);

  Future<Response> acceptAccessTypeChangingRequest(String requestId);

  Future<Response> declineAccessTypeChangingRequest(String requestId);
}
