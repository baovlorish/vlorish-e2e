import 'package:burgundy_budgeting_app/core/navigator_manager.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/label.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item.dart';
import 'package:burgundy_budgeting_app/ui/atomic/molecula/button_item_transparent.dart';
import 'package:burgundy_budgeting_app/ui/screen/auth/signin/signin_page.dart';
import 'package:burgundy_budgeting_app/ui/screen/budget/personal/budget_personal_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotFoundLayout extends StatelessWidget {
  final bool sessionExist;

  NotFoundLayout({Key? key, required this.sessionExist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 16,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 430,
                  maxWidth: 441,
                ),
                child: Image.asset(
                  'assets/images/404.png',
                  fit: BoxFit.scaleDown,
                ),
              ),
              Label(
                text: AppLocalizations.of(context)!.errorPageHeader,
                type: LabelType.HeaderBold,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 24,
              ),
              Label(
                text: AppLocalizations.of(context)!.couldNotFindPage,
                type: LabelType.General,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 24,
              ),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    height: 56,
                    width: 220,
                    child: ButtonItemTransparent(
                      context,
                      text: sessionExist
                          ? AppLocalizations.of(context)!.home
                          : AppLocalizations.of(context)!.signIn,
                      onPressed: () {
                        NavigatorManager.navigateTo(
                          context,
                          sessionExist
                              ? BudgetPersonalPage.routeName
                              : SigninPage.routeName,
                          transition: sessionExist
                              ? TransitionType.fadeIn
                              : TransitionType.material,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 56,
                    width: 220,
                    child: ButtonItem(
                      context,
                      text: AppLocalizations.of(context)!.goBack,
                      onPressed: () {
                        NavigatorManager.navigateBack(context);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
