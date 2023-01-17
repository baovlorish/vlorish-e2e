import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:burgundy_budgeting_app/domain/service/http/api_notification_service.dart';
import 'package:dio/src/response.dart';

class ApiNotificationServiceImpl extends ApiNotificationService {
  ApiNotificationServiceImpl(this.httpManager) : super(httpManager);
  final HttpManager httpManager;
  final String fetchEndpoint = '/notification/get-last';
  final String fetchAllEndpoint = '/notification/get-all';
  final String deleteEndpoint = '/notification/set-deleted';
  final String markAsReadEndpoint = '/notification/set-read';
  final String deleteAllEndpoint = '/notification/set-deleted-all';

  @override
  Future<Response> clearNotifications() async {
    return await httpManager.dio.post(
      deleteAllEndpoint,
    );
  }

  @override
  Future<Response> deleteNotification(String id) async {
    return await httpManager.dio.post(
      deleteEndpoint,
      data: {'notificationId': id},
    );
  }

  @override
  Future<Response> markAsRead(List<String> ids) async {
    return await httpManager.dio.post(
      markAsReadEndpoint,
      data: {'notificationIds': ids},
    );
  }

  @override
  Future<Response> fetchNotifications({required bool all}) async {
    return await httpManager.dio.post(
      all ? fetchAllEndpoint : fetchEndpoint,
      data: all ? null : {'lastNotificationsCount': 10},
    );
  }
}
