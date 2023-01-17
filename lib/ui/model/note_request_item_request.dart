class NoteRequestItemRequest {
  NoteRequestItemRequest({required this.requestId, this.note});
  final String requestId;
  final String? note;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['note'] = note;
    return data;
  }
}
