import 'package:burgundy_budgeting_app/ui/model/manage_users_item_model.dart';
import 'manage_users_page.dart';

class RequestsPageModel extends ManageUsersPage implements _RequestParameters {
  RequestsPageModel({
    required this.pageCount,
    required this.pageNumber,
    required this.requests,
    required this.hasRequestSlots,
    required this.canRequestToday,
    required this.requestsStatus,
  });

  @override
  int pageCount;
  @override
  int pageNumber;
  List<ManageUsersItemModel> requests;
  @override
  bool hasRequestSlots;
  @override
  bool canRequestToday;
  @override
  int requestsStatus;

  factory RequestsPageModel.fromJson(
          Map<String, dynamic> json, int pageNumber, int requestStatus) =>
      RequestsPageModel(
        pageCount: json['pageCount'],
        pageNumber: pageNumber,
        requests: [
          for (var item in json['requests'])
            ManageUsersItemModel.fromJson(item, isInvitation: false)
        ],
        hasRequestSlots: json['hasRequestSlots'] ?? false,
        canRequestToday: json['canRequestToday'] ?? false,
        requestsStatus: requestStatus,
      );

  @override
  List<ManageUsersItemModel> get items => requests;

  @override
  String toString() => '''
  -----RequestsPageModel-----
  {pageCount: $pageCount,
  pageNumber: $pageNumber,
  requests: ${requests.toString()} 
  hasRequestSlots: $hasRequestSlots,
  canRequestToday: $canRequestToday}\n''';
}

abstract class _RequestParameters {
  abstract bool hasRequestSlots;
  abstract bool canRequestToday;
  abstract int requestsStatus;
}
