import 'package:burgundy_budgeting_app/ui/atomic/atom/avatar_widget.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_tooltip.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:burgundy_budgeting_app/ui/model/client_menu_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientsDashboardMenu extends StatefulWidget {
  const ClientsDashboardMenu(
      {Key? key,
      required this.clientsList,
      required this.onTapItem,
      required this.onTapButton})
      : super(key: key);

  final Future<List<ClientMenuItemModel>> Function(int) clientsList;
  final Function(BuildContext, String, int, String?, String?) onTapItem;
  final Function() onTapButton;

  @override
  _ClientsDashboardMenuState createState() => _ClientsDashboardMenuState();
}

class _ClientsDashboardMenuState extends State<ClientsDashboardMenu> {
  String? nameInitials(String? firstName, String? lastName) {
    var initials = '';
    if (firstName != null && firstName.isNotEmpty == true) {
      initials = firstName[0];
      if ((lastName != null && lastName.isNotEmpty == true)) {
        initials += '${lastName[0]}';
        return initials;
      }
    } else {
      if ((lastName != null && lastName.isNotEmpty == true)) {
        initials = lastName[0];
      }
      return initials;
    }
  }

  double rightPadding(
      int index, int countOfChildren, double minPadding, double maxPadding) {
    if (index % 5 == 4) {
      return maxPadding;
    } else {
      return minPadding;
    }
  }

  double leftPadding(
      int index, int countOfChildren, double minPadding, double maxPadding) {
    if (index == 0 || index % 5 == 0) {
      return maxPadding;
    } else {
      return minPadding;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClientMenuItemModel>>(
        future: widget.clientsList(15),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  width: widthSize(snapshot.data!.length),
                  color: CustomColorScheme.mainDarkBackground,
                  child: Wrap(
                    children: [
                      for (var item in snapshot.data!)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 5.0,
                            top: 5.0,
                            right: rightPadding(
                              snapshot.data!.indexOf(item),
                              snapshot.data!.length,
                              5,
                              10,
                            ),
                            left: leftPadding(
                              snapshot.data!.indexOf(item),
                              snapshot.data!.length,
                              5,
                              10,
                            ),
                          ),
                          child: CustomTooltip(
                            color: Colors.black87,
                            message:
                                '${item.firstName ?? ''} ${item.lastName ?? ''}',
                            child: CustomMaterialInkWell(
                              type: InkWellType.Transparent,
                              onTap: () {
                                removeModal();
                                widget.onTapItem(
                                    context,
                                    item.userId,
                                    item.accessType,
                                    item.firstName,
                                    item.lastName);
                              },
                              child: AvatarWidget(
                                initials:
                                    nameInitials(item.firstName, item.lastName),
                                imageUrl: item.imageUrl,
                                colorGeneratorKey: item.email,
                              ),
                            ),
                          ),
                        ),
                      ButtonItem(
                        context,
                        text: AppLocalizations.of(context)!.clientsDashboard,
                        onPressed: () {
                          removeModal();
                          widget.onTapButton();
                        },
                      ),
                    ],
                  ),
                )
              : Container();
        });
  }

  double widthSize(int itemCount) {
    if (itemCount < 3) {
      return 192;
    } else {
      return itemCount < 5 ? itemCount * 64 : 320;
    }
  }
}
