class RequestsPageRequestModel {
  int pageNumber;
  int requestStatus;

  RequestsPageRequestModel(
      {required this.pageNumber, required this.requestStatus});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pageNumber'] = pageNumber;
    data['requestStatus'] = requestStatus;
    return data;
  }
}
