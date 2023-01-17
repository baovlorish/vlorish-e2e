import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:flutter/material.dart';

class EmptyManageUsersCard extends StatelessWidget {
  const EmptyManageUsersCard({
    Key? key,
    required this.header,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  final String header;
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: CustomColorScheme.blockBackground,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: CustomColorScheme.tableBorder,
                    blurRadius: 5,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Label(
                        text: header,
                        type: LabelType.Header,
                        fontSize: 22,
                      ),
                    ),
                    Spacer(),
                    Flexible(
                      child: ImageIcon(
                        AssetImage('assets/images/icons/group.png'),
                        color: CustomColorScheme.groupBackgroundColor,
                        size: 124,
                      ),
                    ),
                    Flexible(
                      child:
                          Label(text: message, type: LabelType.HintLargeBold),
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 48,
                        width: 206,
                        child: ButtonItem(
                          context,
                          text: buttonText,
                          onPressed: onPressed,
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyManageUsersCardSmall extends StatelessWidget {
  const EmptyManageUsersCardSmall({
    Key? key,
    required this.message,
  }) : super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: ImageIcon(
            AssetImage('assets/images/icons/group.png'),
            color: CustomColorScheme.groupBackgroundColor,
            size: 124,
          ),
        ),
        SizedBox(height: 20),
        Flexible(
          child: Label(text: message, type: LabelType.HintLargeBold),
        ),
      ],
    );
  }
}
