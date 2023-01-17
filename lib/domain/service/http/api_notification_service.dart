import 'package:burgundy_budgeting_app/domain/network/http_manager.dart';
import 'package:dio/dio.dart';

abstract class ApiNotificationService {
  ApiNotificationService(HttpManager httpManager);

  Future<Response> deleteNotification(String id);

  Future<Response> clearNotifications();

  Future<Response> fetchNotifications({required bool all});

  Future<Response> markAsRead(List<String> ids);
}
