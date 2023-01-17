import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class SideMenuButtonItem extends TextButton {
  final String? text;
  final BuildContext context;
  final bool isSmall;
  @override
  final VoidCallback onPressed;
  final bool isSelected;
  final String? assetUrl;
  final double order;

  SideMenuButtonItem(
    this.context, {
    Key? key,
    this.text,
    required this.onPressed,
    this.isSelected = false,
    this.assetUrl,
    this.isSmall = false,
    required this.order,
  }) : super(
          key: key,
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
            overlayColor: MaterialStateProperty.all<Color>(
              CustomColorScheme.whiteInkWell,
            ),
          ),
          onPressed: () => onPressed,
          child: FocusTraversalOrder(
            order: NumericFocusOrder(order),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: isSelected && !isSmall
                    ? CustomColorScheme.menuBackgroundActive
                    : Colors.transparent,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      color: (isSelected && !isSmall)
                          ? CustomColorScheme.textSelectedColorMenu
                          : Colors.transparent,
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    assetUrl == null
                        ? SizedBox(
                            width: 44,
                          )
                        : Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: isSelected
                                  ? CustomColorScheme.menuBackgroundActive
                                  : Colors.transparent,
                            ),
                            child: Center(
                              child: ImageIcon(
                                AssetImage(assetUrl),
                                color: isSelected
                                    ? CustomColorScheme.textSelectedColorMenu
                                    : CustomColorScheme.textColorMenu,
                                size: 24,
                              ),
                            ),
                          ),
                    SizedBox(
                      width: 8,
                    ),
                    if (text != null && !isSmall)
                      Label(
                        text: text,
                        color: isSelected
                            ? CustomColorScheme.textSelectedColorMenu
                            : CustomColorScheme.textColorMenu,
                        type: LabelType.GeneralBold,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
}
