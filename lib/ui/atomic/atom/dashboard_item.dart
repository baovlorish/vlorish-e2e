import 'package:burgundy_budgeting_app/ui/atomic/atom/custom_inkwell.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class DashboardItem extends StatelessWidget {
  final String sumString;
  final String text;
  final String iconUrl;
  final double textSize;
  final bool isSmall;
  final VoidCallback? onTap;

  const DashboardItem({
    required this.text,
    required this.sumString,
    required this.iconUrl,
    required this.textSize,
    this.isSmall = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Container(
        width: 350,
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColorScheme.tableBorder,
          ),
          borderRadius: BorderRadius.circular(4.0),
          color: CustomColorScheme.blockBackground,
        ),
        child: CustomMaterialInkWell(
          borderRadius: BorderRadius.circular(4.0),
          materialColor: CustomColorScheme.blockBackground,
          type: InkWellType.Purple,
          onTap: onTap,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  iconUrl,
                  color: Color.fromRGBO(243, 234, 239, 1),
                  height: 60,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: isSmall ? 5.0 : 30.0,
                  ),
                  Label(
                    type: LabelType.Header3,
                    text: sumString,
                    fontSize: textSize,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Label(
                    type: LabelType.TableHeader,
                    text: text,
                  ),
                  SizedBox(
                    height: isSmall ? 5.0 : 30.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
