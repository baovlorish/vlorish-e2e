import 'package:burgundy_budgeting_app/domain/model/request/edit_approved_invitation_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/edit_pending_invitation_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/invitations_page_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/note_invitation_request.dart';
import 'package:burgundy_budgeting_app/domain/model/request/send_invitation_request_model.dart';
import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_invites_service.dart';
import 'package:dio/dio.dart';

class ApiInviteServiceImpl extends ApiInviteService {
  ApiInviteServiceImpl(this.httpManager);
  final HttpManager httpManager;

  final String invitesPageEndpoint = '/invitation/page';
  final String invitationEndpoint = '/invitation';
  final String invitationNoteEndpoint = '/invitation/note';
  final String invitationApproveEndpoint = '/invitation/approve';
  final String invitationEditPendingEndpoint = '/invitation/edit/pending';
  final String invitationEditApprovedEndpoint = '/invitation/edit/approved';
  final String invitationAcceptAccessTypeChanging =
      '/invitation/access-type-changing/accept';
  final String invitationDeclineAccessTypeChanging =
      '/invitation/access-type-changing/decline';

  @override
  Future<Response> sendInvite(InvitationSendRequestModel invite) async {
    return await httpManager.dio.post(
      invitationEndpoint,
      data: invite.toJson(),
    );
  }

  @override
  Future<Response> fetchInvitationPage(InvitationsPageRequest invite) async {
    return await httpManager.dio.post(
      invitesPageEndpoint,
      data: invite.toJson(),
    );
  }

  @override
  Future<Response> deleteInvitation(String invitationId) async {
    return await httpManager.dio.delete(
      invitationEndpoint,
      data: {'invitationId': invitationId},
    );
  }

  @override
  Future<Response> noteInvitation(NoteInvitationRequest note) async {
    return await httpManager.dio.put(
      invitationNoteEndpoint,
      data: note.toJson(),
    );
  }

  @override
  Future<Response> approveInvitation(String invitationId) async {
    return await httpManager.dio.post(
      invitationApproveEndpoint,
      data: {'invitationId': invitationId},
    );
  }

  @override
  Future<Response> editPendingInvitation(
      EditPendingInvitationRequest editPendingRequest) async {
    return await httpManager.dio.post(
      invitationEditPendingEndpoint,
      data: editPendingRequest.toJson(),
    );
  }

  @override
  Future<Response> editApprovedInvitation(
      EditApprovedInvitationRequest editApprovedInvitationRequest) async {
    return await httpManager.dio.post(
      invitationEditApprovedEndpoint,
      data: editApprovedInvitationRequest.toJson(),
    );
  }

  @override
  Future<Response> acceptAccessTypeChanging(String invitationId) async {
    return await httpManager.dio.post(
      invitationAcceptAccessTypeChanging,
      data: {'invitationId': invitationId},
    );
  }

  @override
  Future<Response> declineAccessTypeChanging(String invitationId) async {
    return await httpManager.dio.post(
      invitationDeclineAccessTypeChanging,
      data: {'invitationId': invitationId},
    );
  }
}
