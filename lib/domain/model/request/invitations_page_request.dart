class InvitationsPageRequest {
  int pageNumber;
  int invitationStatus;

  InvitationsPageRequest(
      {required this.pageNumber, required this.invitationStatus});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pageNumber'] = pageNumber;
    data['invitationStatus'] = invitationStatus;
    return data;
  }
}
