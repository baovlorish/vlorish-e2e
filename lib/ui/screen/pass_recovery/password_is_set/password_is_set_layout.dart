import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/colored_button.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/column_item.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/auth_screen/auth_screen.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordSetSuccessLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      title: AppLocalizations.of(context)!.passwordSet,
      availableIndex: 0,
      centerWidget: ColumnItem(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/success_icon_green.png',
            width: 100,
          ),
          Label(
            text: AppLocalizations.of(context)!.newPasswordIsSetSuccessMessage,
            type: LabelType.Header,
            color: Colors.white,
          ),
          SizedBox(
            height: 15.0,
          ),
          Label(
            text: AppLocalizations.of(context)!.letsGoToSigninMessage,
            type: LabelType.General,
            color: Colors.white,
          ),
          SizedBox(
            height: 25.0,
          ),
          ColoredButton(
            buttonStyle: ColoredButtonStyle.Pink,
            focusNode: FocusNode(),
            onPressed: () {
              // navigate to sign in
              NavigatorManager.navigateTo(
                context,
                SigninPage.routeName,
                transition: TransitionType.material,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.signIn,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 15,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
