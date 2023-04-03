import 'package:burgundy_budgeting_app/core/di_provider.dart';
import 'package:burgundy_budgeting_app/ui/screen/pass_recovery/password_is_set/password_is_set_layout.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class PasswordSetSuccessPage {
  static const String routeName = '/password_reset_success';

  static void initRoute(FluroRouter router, AuthContractor authContractor) {
    var handler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        return PasswordSetSuccessLayout();
      },
    );
    router.define(routeName, handler: handler);
  }
}