import 'package:burgundy_budgeting_app/ui/screen/manage_users/manage_users_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/profile_overview/profile_overview_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/referral/referral_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/transactions/transactions_page.dart';
import 'package:intl/intl.dart';

class NotificationPageModel {
  final List<NotificationModel> notifications;
  final int? totalCount;

  bool get hasMore =>
      totalCount == null ||
      (totalCount != null &&
          (totalCount! > 10 && notifications.length < totalCount!));

  NotificationPageModel(
      {required this.notifications, required this.totalCount});

  factory NotificationPageModel.fromJson(Map<String, dynamic> json) {
    var notifications = <NotificationModel>[];
    if (json['notifications'] != null) {
      for (var item in json['notifications']) {
        notifications.add(NotificationModel.fromJson(item));
      }
    }
    return NotificationPageModel(
        notifications: notifications,
        totalCount: json['allNotificationsCount'] ?? notifications.length);
  }

  factory NotificationPageModel.mocked() {
    var notifications = [
      NotificationModel(
        isRead: false,
        message: 'Jane Smith confirmed your invitation',
        id: '1',
        notificationType: 1,
        dateTime: DateTime(2022, 3, 4),
      ),
      NotificationModel(
        isRead: false,
        message: 'John Ellington declined your invitation',
        id: '2',
        notificationType: 2,
        dateTime: DateTime(2022, 3, 4),
      ),
      NotificationModel(
        isRead: false,
        message: 'Ann Berg requests the access to your budget',
        id: '3',
        notificationType: 3,
        dateTime: DateTime(2022, 3, 3),
      ),
      NotificationModel(
        isRead: true,
        message: 'Graham Robertson confirmed your request',
        id: '4',
        notificationType: 4,
        dateTime: DateTime(2022, 3, 3),
      ),
      NotificationModel(
        isRead: true,
        message: 'Mia Miller declined your request',
        id: '5',
        notificationType: 5,
        dateTime: DateTime(2022, 3, 3),
      ),
      NotificationModel(
        isRead: true,
        message: 'Jenny A invited you to their budget',
        id: '6',
        notificationType: 6,
        dateTime: DateTime(2022, 3, 2),
      ),
      NotificationModel(
        isRead: true,
        message: 'Andrew Williams asking for changing access type',
        id: '7',
        notificationType: 7,
        dateTime: DateTime(2022, 3, 2),
      ),
      NotificationModel(
        isRead: true,
        message: 'John Carpenter changed the access type to their budget',
        id: '8',
        notificationType: 8,
        dateTime: DateTime(2022, 3, 2),
      ),
      NotificationModel(
        isRead: true,
        message: 'Karina J declined the access to their budget',
        id: '9',
        notificationType: 9,
        dateTime: DateTime(2022, 2, 1),
      ),
      NotificationModel(
        isRead: true,
        message:
            'Caroline Cano requests the access to your budget. Upgrade your subscription to Premium to share your budget',
        id: '10',
        notificationType: 10,
        dateTime: DateTime(2022, 2, 1),
      ),
      NotificationModel(
        isRead: true,
        message:
            'Bob Green invited you to their budget. Upgrade your subscription to Premium to view their budget',
        id: '11',
        notificationType: 11,
        dateTime: DateTime(2022, 2, 1),
      ),
      NotificationModel(
        isRead: true,
        message: 'Subscription expires in 3 days',
        id: '12',
        notificationType: 12,
        dateTime: DateTime(2022, 2, 1),
      ),
    ];
    return NotificationPageModel(
        notifications: notifications, totalCount: notifications.length);
  }

  factory NotificationPageModel.mockedShort(NotificationPageModel model) {
    var notifications = <NotificationModel>[];
    if (model.notifications.length > 10) {
      notifications = model.notifications.getRange(0, 9).toList();
    } else {
      notifications = model.notifications;
    }
    return NotificationPageModel(
        notifications: notifications, totalCount: model.totalCount);
  }
}

class NotificationModel {
  final String id;
  final DateTime dateTime;
  final bool isRead;
  final String message;
  final int notificationType;
  late final String destinationPage;

  NotificationModel(
      {required this.id,
      required this.dateTime,
      required this.isRead,
      required this.message,
      required this.notificationType}) {
    if (notificationType == 10 ||
        notificationType == 11 ||
        notificationType == 12) {
      destinationPage = ProfileOverviewPage.routeName;
    } else if (notificationType == 13) {
      destinationPage = TransactionsPage.routeName;
    } else if (notificationType == 16) {
      destinationPage = ReferralPage.routeName;
    } else {
      destinationPage = ManageUsersPage.routeName;
    }
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json,
      {bool fromNotification = false}) {
    if (fromNotification) {
      return NotificationModel(
          id: json['Id'],
          dateTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
              .parse(json['CreationDate'], true),
          isRead: json['IsRead'],
          message: json['Text'],
          notificationType: json['NotificationType']);
    } else {
      return NotificationModel(
          id: json['id'] as String,
          dateTime: DateFormat('yyyy-MM-ddTHH:mm:ss')
              .parse(json['creationDate'], true),
          isRead: json['isRead'] as bool,
          message: json['text'] as String,
          notificationType: json['notificationType'] as int);
    }
  }

  String get dateToString {
    var now = DateTime.now();
    var duration = now.difference(dateTime);
    var number = 0;
    var result = '';
    if (duration.inHours < 1) {
      number = duration.inMinutes;
      result = '$number min';
      return result;
    } else if (duration.inDays < 1) {
      number = duration.inHours;
      result = '$number hour';
    } else if (duration.inDays <= 30) {
      number = duration.inDays;
      result = '${duration.inDays} day';
    } else {
      number = (duration.inDays / 30).round();
      result = '$number month';
    }
    return number == 1 ? result : result + 's';
  }
}
