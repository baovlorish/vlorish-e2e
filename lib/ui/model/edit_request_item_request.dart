class EditRequestItemRequest {
  EditRequestItemRequest({
    required this.requestId,
    required this.accessType,
    this.note,
  });

  final String requestId;
  final int accessType;
  final String? note;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['accessType'] = accessType;
    data['note'] = note;
    return data;
  }
}
