import 'package:burgundy_budgeting_app/domain/error/custom_error.dart';
import 'package:burgundy_budgeting_app/domain/model/request/edit_approved_invitation_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/edit_pending_invitation_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/invitations_page_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/note_invitation_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/requests_page_request_model.dart';
import 'package:burgundy_budgeting_app/domain/model/request/send_invitation_request_model.dart';
import 'package:burgundy_budgeting_app/domain/model/request/send_request_request_model.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_invites_service.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_request_service.dart';
import 'package:burgundy_budgeting_app/ui/model/edit_request_item_request.dart';
import 'package:burgundy_budgeting_app/ui/model/invitations_page_model.dart';
import 'package:burgundy_budgeting_app/ui/model/note_request_item_request.dart';
import 'package:burgundy_budgeting_app/ui/model/requests_page_model.dart';

abstract class ManageUsersRepository {
  Future<bool> sendInvite(
      int? accessType, String email, int role, String? note);

  Future<bool> sendRequest(int accessType, String email, String? note);

  Future<RequestsPageModel> fetchRequestsPage(
      int pageNumber, int requestStatus);

  Future<InvitationsPageModel> fetchInvitationPage(
      int pageNumber, int invitationStatus);

  Future<bool> deleteRequest(String requestId);

  Future<bool> noteRequest(String requestId, String? note);

  Future<bool> approveRequest(String requestId);

  Future<bool> editRequest(String requestId, int accessType, {String? note});

  Future<bool> acceptAccessTypeChangingRequest(String requestId);

  Future<bool> declineAccessTypeChangingRequest(String requestId);

  Future<bool> deleteInvitation(String id);

  Future<bool> noteInvitation(String invitationId, String? note);

  Future<bool> approveInvitation(String invitationId);

  Future<bool> invitationEditPending(
      int role, String invitationId, int? accessType, String? note);

  Future<bool> invitationEditApproved(
      String invitationId, int? accessType, String? note);

  Future<bool> acceptAccessTypeChangingInvitation(String invitationId);

  Future<bool> declineAccessTypeChangingInvitation(String invitationId);
}

class ManageUsersRepositoryImpl implements ManageUsersRepository {
  final ApiInviteService inviteService;
  final ApiRequestService requestService;

  ManageUsersRepositoryImpl(this.inviteService, this.requestService);

  final String generalErrorMessage = 'Sorry, something went wrong';

  @override
  Future<bool> sendInvite(
      int? accessType, String email, int role, String? note) async {
    var response = await inviteService.sendInvite(
      InvitationSendRequestModel(
          accessType: accessType, email: email, note: note, role: role),
    );

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else if (response.statusCode == 400) {
      throw CustomException(response.data['message'],
          type: CustomExceptionType.Inform);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> sendRequest(int accessType, String email, String? note) async {
    var response = await requestService.sendRequest(RequestSendRequestModel(
        accessType: accessType, email: email, note: note));

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else if (response.statusCode == 400) {
      throw CustomException(response.data['message'],
          type: CustomExceptionType.Inform);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<RequestsPageModel> fetchRequestsPage(
      int pageNumber, int requestStatus) async {
    var response = await requestService.fetchRequestPage(
        RequestsPageRequestModel(
            pageNumber: pageNumber, requestStatus: requestStatus));
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return RequestsPageModel.fromJson(
          response.data, pageNumber, requestStatus);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> deleteRequest(String requestId) async {
    var response = await requestService.deleteRequest(requestId);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> noteRequest(String requestId, String? note) async {
    var response = await requestService
        .noteRequest(NoteRequestItemRequest(requestId: requestId, note: note));

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> approveRequest(String requestId) async {
    var response = await requestService.approveRequest(requestId);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> editRequest(String requestId, int accessType,
      {String? note}) async {
    var response = await requestService.editRequest(EditRequestItemRequest(
        requestId: requestId, accessType: accessType, note: note));

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else if (response.statusCode == 400) {
      throw CustomException(response.data['message'],
          type: CustomExceptionType.Inform);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> acceptAccessTypeChangingRequest(String requestId) async {
    var response =
        await requestService.acceptAccessTypeChangingRequest(requestId);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> declineAccessTypeChangingRequest(String requestId) async {
    var response =
        await requestService.declineAccessTypeChangingRequest(requestId);

    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<InvitationsPageModel> fetchInvitationPage(
      int pageNumber, int invitationStatus) async {
    var response = await inviteService.fetchInvitationPage(
      InvitationsPageRequest(
          pageNumber: pageNumber, invitationStatus: invitationStatus),
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return InvitationsPageModel.fromJson(
          response.data, pageNumber, invitationStatus);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> deleteInvitation(String invitationId) async {
    var response = await inviteService.deleteInvitation(invitationId);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> noteInvitation(String invitationId, String? note) async {
    var response = await inviteService.noteInvitation(
        NoteInvitationRequest(invitationId: invitationId, note: note));
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> approveInvitation(String invitationId) async {
    var response = await inviteService.approveInvitation(invitationId);
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> invitationEditPending(
      int role, String invitationId, int? accessType, String? note) async {
    var response =
        await inviteService.editPendingInvitation(EditPendingInvitationRequest(
      role: role,
      invitationId: invitationId,
      accessType: accessType,
      note: note,
    ));
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else if (response.statusCode == 400) {
      throw CustomException(response.data['message'],
          type: CustomExceptionType.Inform);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> invitationEditApproved(
      String invitationId, int? accessType, String? note) async {
    var response = await inviteService.editApprovedInvitation(
        EditApprovedInvitationRequest(
            invitationId: invitationId, accessType: accessType, note: note));
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else if (response.statusCode == 400) {
      throw CustomException(response.data['message'],
          type: CustomExceptionType.Inform);
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> acceptAccessTypeChangingInvitation(String invitationId) async {
    var response = await inviteService.acceptAccessTypeChanging(
      invitationId,
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }

  @override
  Future<bool> declineAccessTypeChangingInvitation(String invitationId) async {
    var response = await inviteService.declineAccessTypeChanging(
      invitationId,
    );
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return true;
    } else {
      throw CustomException(response.data['message'] ?? generalErrorMessage);
    }
  }
}
