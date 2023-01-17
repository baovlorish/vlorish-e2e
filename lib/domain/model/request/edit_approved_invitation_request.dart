class EditApprovedInvitationRequest {
  EditApprovedInvitationRequest(
      {required this.invitationId,
        this.accessType,
         this.note});

  String invitationId;
  int? accessType;
  String? note;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['invitationId'] = invitationId;
    data['accessType'] = accessType;
    data['note'] = note;
    return data;
  }
}
