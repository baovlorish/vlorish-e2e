import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class SideMenuWidget extends StatelessWidget {
  final int currentTab;
  final List<SideMenuData> items;

  const SideMenuWidget({Key? key, this.currentTab = 0, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (index) {
          var selected = currentTab == index;
          return Container(
            decoration: BoxDecoration(
              color: selected
                  ? CustomColorScheme.purpleInkWell
                  : Colors.transparent,
              border: Border(
                left: BorderSide(
                    width: 3,
                    color: selected
                        ? CustomColorScheme.mainDarkBackground
                        : Colors.transparent),
              ),
            ),
            child: CustomMaterialInkWell(
              type: InkWellType.Purple,
              onTap: items[index].onTap,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Label(
                      text: items[index].name,
                      type: LabelType.General,
                      fontWeight: FontWeight.w600,
                      color: CustomColorScheme.mainDarkBackground,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class SideMenuData {
  final String name;
  final VoidCallback? onTap;

  SideMenuData({required this.name, this.onTap});
}
