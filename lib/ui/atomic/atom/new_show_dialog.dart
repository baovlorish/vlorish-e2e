import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:flutter/material.dart';

Future<T?> newShowDialog<T>(
  BuildContext context, {
  required Widget Function(BuildContext) builder,
  bool barrierDismissible = false,
}) =>
    showDialog(
      barrierColor: VersionTwoColorScheme.White.withOpacity(0.8),
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
