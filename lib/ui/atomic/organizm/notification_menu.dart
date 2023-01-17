import 'dart:math';

import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_divider.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/two_buttons_alert_dialog.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/atomic/template/home_screen/home_screen_cubit.dart';
import 'package:burgundy_budgeting_app/ui/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationMenu extends StatefulWidget {
  final double maxHeight;
  final Future<NotificationPageModel> Function({bool all})
      fetchNotificationPage;
  final VoidCallback clearAll;
  final Future<void> Function(String id) deleteNotification;
  final HomeScreenCubit homeScreenCubit;
  final double width;

  const NotificationMenu({
    Key? key,
    required this.maxHeight,
    required this.fetchNotificationPage,
    required this.deleteNotification,
    required this.homeScreenCubit,
    required this.clearAll,
    required this.width,
  }) : super(key: key);

  @override
  State<NotificationMenu> createState() => _NotificationMenuState();
}

class _NotificationMenuState extends State<NotificationMenu> {
  NotificationPageModel? page;
  var all = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FutureBuilder<NotificationPageModel>(
          future: widget.fetchNotificationPage(all: all),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              page = snapshot.data;
              var notifications = page!.notifications;
              var additionalHeight = snapshot.data!.hasMore ? 95 : 30;
              var height = notifications.isEmpty
                  ? 168.0
                  : min(notifications.length * 65 + additionalHeight,
                          widget.maxHeight)
                      .toDouble();
              return Container(
                height: height,
                width: widget.width,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 5,
                      color: Colors.black26),
                ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 30,
                      color: CustomColorScheme.mainDarkBackground,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Label(
                              type: LabelType.GeneralBold,
                              text:
                                  '${AppLocalizations.of(context)!.notificationList} (${page!.totalCount})',
                              color: Colors.white,
                            ),
                          ),
                          if (notifications.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: CustomMaterialInkWell(
                                type: InkWellType.White,
                                borderRadius: BorderRadius.circular(4),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4),
                                  child: Label(
                                    type: LabelType.Link,
                                    text:
                                        AppLocalizations.of(context)!.clearAll,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () async {
                                  removeModal();
                                  await showDialog(
                                      context: context,
                                      builder: (context) => TwoButtonsDialog(
                                            context,
                                            title: AppLocalizations.of(context)!
                                                .deleteAllNotifications,
                                            message: AppLocalizations.of(
                                                    context)!
                                                .theNotificationsListWillBeEmptyAfterDeleting,
                                            mainButtonText:
                                                AppLocalizations.of(context)!
                                                    .delete,
                                            onMainButtonPressed:
                                                widget.clearAll,
                                            dismissButtonText:
                                                AppLocalizations.of(context)!
                                                    .cancel,
                                          ));
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                    notifications.isEmpty
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ImageIcon(
                                  AssetImage('assets/images/icons/bell.png'),
                                  color: CustomColorScheme.groupBackgroundColor,
                                  size: 64,
                                ),
                                Label(
                                    text: AppLocalizations.of(context)!
                                        .notificationListEmpty,
                                    type: LabelType.Hint),
                              ],
                            ),
                          )
                        : ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: height - additionalHeight,
                                maxWidth: widget.width),
                            child: ListView.builder(
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                return NotificationItem(
                                  key: Key(notifications[index].id),
                                  notification: notifications[index],
                                  onDelete: (id) async => await widget
                                      .deleteNotification(id)
                                      .whenComplete(() => setState(() {})),
                                  homeScreenCubit: widget.homeScreenCubit,
                                );
                              },
                            ),
                          ),
                    if (snapshot.data!.hasMore)
                      SizedBox(
                        height: 65,
                        child: Center(
                          child: CustomMaterialInkWell(
                            type: InkWellType.Purple,
                            borderRadius: BorderRadius.circular(4),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4),
                              child: Label(
                                type: LabelType.Link,
                                text: AppLocalizations.of(context)!.seeAll,
                              ),
                            ),
                            onTap: () async {
                              all = true;
                              setState(() {});
                            },
                          ),
                        ),
                      )
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
          }),
    );
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    Key? key,
    required this.notification,
    required this.onDelete,
    required this.homeScreenCubit,
  }) : super(key: key);

  final NotificationModel notification;
  final Function(String id) onDelete;
  final HomeScreenCubit homeScreenCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        right: 16,
        left: 16,
      ),
      height: 65,
      child: CustomMaterialInkWell(
        type: InkWellType.Transparent,
        onTap: () {
          removeModal();
          homeScreenCubit.stopForeignSession();
          NavigatorManager.navigateTo(context, notification.destinationPage);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                notificationIcon(context, notification.notificationType),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            text: notification.message,
                            type: LabelType.General,
                            fontSize:
                                notification.message.length < 80 ? 14 : 13,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Label(
                                text: notification.dateToString,
                                type: LabelType.Hint,
                                fontSize: 12,
                              ),
                              !notification.isRead
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        height: 8,
                                        width: 8,
                                        decoration: BoxDecoration(
                                          color: CustomColorScheme.button,
                                          borderRadius:
                                              BorderRadius.circular(8 / 2),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          )
                        ]),
                  ),
                ),
                // Spacer(),
                CustomMaterialInkWell(
                  type: InkWellType.Purple,
                  onTap: () {
                    onDelete(notification.id);
                  },
                  child: Icon(Icons.close),
                )
              ],
            ),
            CustomDivider()
          ],
        ),
      ),
    );
  }

  Widget notificationIcon(BuildContext context, int notificationType) {
    //  info = 1
    //  confirm = 2
    //  decline = 3
    //  warning = 4
    return notificationType == 3 ||
            notificationType == 6 ||
            notificationType == 7 ||
            notificationType == 8 ||
            notificationType == 10 ||
            notificationType == 11 ||
            notificationType == 16
        ? Icon(
            Icons.info_rounded,
            color: CustomColorScheme.pendingStatusColor,
          )
        : notificationType == 1 ||
                notificationType == 4 ||
                notificationType == 13
            ? Icon(
                Icons.check_circle,
                color: CustomColorScheme.successPopupButton,
              )
            : notificationType == 2 ||
                    notificationType == 4 ||
                    notificationType == 5 ||
                    notificationType == 9 ||
                    notificationType == 14 ||
                    notificationType == 15
                ? Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CustomColorScheme.inputErrorBorder),
                    child: Center(
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  )
                : Icon(
                    Icons.warning,
                    color: CustomColorScheme.goalColor3,
                  );
  }
}
