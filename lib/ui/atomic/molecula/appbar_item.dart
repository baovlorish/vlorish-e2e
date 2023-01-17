import 'dart:async';

import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/organizm/overlay_menu.dart';
import 'package:flutter/material.dart';

class AppBarItem extends StatefulWidget {
  final bool isSelected;
  final String iconUrl;
  final VoidCallback? onTap;
  final bool showMenuOnHover;
  final Widget? hoverMenuWidget;
  final bool isSmall;
  final double minPadding;
  final double maxPadding;

  final Alignment modalAlignment;
  final Alignment anchorAlignment;

  final int? notificationCount;

  final bool usesAlignedMenu;

  const AppBarItem({
    this.isSelected = false,
    required this.iconUrl,
    this.onTap,
    this.hoverMenuWidget,
    this.showMenuOnHover = false,
    this.notificationCount,
    required this.isSmall,
    required this.minPadding,
    required this.maxPadding,
    this.modalAlignment = Alignment.topLeft,
    this.anchorAlignment = Alignment.bottomLeft,
    this.usesAlignedMenu = false,
  });

  @override
  State<AppBarItem> createState() => _AppBarItemState();
}

class _AppBarItemState extends State<AppBarItem> {
  bool isMenuVisible = false;
  bool isMenuFocused = false;
  bool isItemFocused = false;

  @override
  Widget build(BuildContext context) {
    var notificationLabelText = widget.notificationCount == null
        ? ''
        : widget.notificationCount! > 99
            ? '99+'
            : ' ${widget.notificationCount} ';
    return ModalAnchor(
      tag: widget.iconUrl,
      child: MouseRegion(
        onEnter: widget.showMenuOnHover
            ? (_) {
                isItemFocused = true;
                if (widget.hoverMenuWidget != null) {
                  if (!isMenuVisible) {
                    showMenu('menu${widget.iconUrl}');
                  }
                }
              }
            : (_) {
                isItemFocused = true;
              },
        onExit: widget.showMenuOnHover
            ? (_) async {
                isItemFocused = false;
                if (widget.hoverMenuWidget != null) {
                  if (isMenuVisible) {
                    Timer(Duration(milliseconds: 100), () {
                      if (!isMenuFocused) {
                        removeMenu();
                      }
                    });
                  }
                }
              }
            : (_) {
                if (!widget.showMenuOnHover) {
                  isMenuVisible = false;
                  isMenuFocused = false;
                }
              },
        child: Padding(
          key: UniqueKey(),
          padding: EdgeInsets.symmetric(
              horizontal:
                  widget.isSmall ? widget.minPadding : widget.maxPadding),
          child: Center(
            child: CustomMaterialInkWell(
              border: CircleBorder(),
              onTap: !widget.showMenuOnHover
                  ? () {
                      if (widget.hoverMenuWidget != null) {
                        if (!isMenuVisible) {
                          showMenu('menu${widget.iconUrl}');
                        }
                      }
                      widget.onTap != null ? widget.onTap!() : null;
                    }
                  : widget.onTap,
              type: InkWellType.White,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? CustomColorScheme.menuBackgroundActive
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: ImageIcon(
                        AssetImage(widget.iconUrl),
                        size: 24,
                        color: Color.fromRGBO(253, 248, 253, 1),
                      ),
                    ),
                    if (widget.notificationCount != null)
                      Align(
                        alignment: Alignment.topRight,
                        key: Key(widget.notificationCount.toString()),
                        child: widget.notificationCount! > 0
                            ? Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: CustomColorScheme
                                      .inputErrorBorder,
                                ),
                                child: Label(
                                  text: notificationLabelText,
                                  fontSize: 10,
                                  color: Colors.white,
                                  type: LabelType.GeneralBold,
                                ),
                              )
                            : SizedBox(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void removeMenu() {
    isMenuFocused = false;
    isMenuVisible = false;
    removeModal();
  }

  void showMenu(String tag) {
    isMenuVisible = true;
    var menuItem = MouseRegion(
      onEnter: (_) {
        isMenuFocused = true;
      },
      onExit: (_) {
        isMenuFocused = false;
        Timer(Duration(milliseconds: 100), () {
          if (!isItemFocused) {
            removeMenu();
          }
        });
        if (!widget.showMenuOnHover) {
          isMenuVisible = false;
          isMenuFocused = false;
        }
      },
      child: widget.hoverMenuWidget,
    );
    showModal(
      widget.usesAlignedMenu
          ? ModalEntry.aligned(
              context,
              barrierDismissible: !widget.showMenuOnHover,
              alignment: Alignment.topRight,
              tag: tag,
              offset: Offset(0, 76),
              child: menuItem,
            )
          : ModalEntry.anchored(
              context,
              barrierDismissible: !widget.showMenuOnHover,
              tag: 'menu${widget.iconUrl}',
              anchorTag: widget.iconUrl,
              modalAlignment: widget.modalAlignment,
              anchorAlignment: widget.anchorAlignment,
              child: menuItem,
            ),
    );
    setState(() {});
  }
}
