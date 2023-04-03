import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:flutter/material.dart';

mixin InputDecorationMixin {
  late final border = OutlineInputBorder(borderSide: BorderSide(color: borderColor), borderRadius: borderRadius);
  late final enabledBorder = OutlineInputBorder(borderSide: BorderSide(color: borderColor), borderRadius: borderRadius);
  late final focusedBorder = OutlineInputBorder(borderSide: BorderSide(color: hoverColor), borderRadius: borderRadius);
  late final errorBorder = OutlineInputBorder(borderSide: BorderSide(color: errorColor), borderRadius: borderRadius);
  late final focusedErrorBorder =
      OutlineInputBorder(borderSide: BorderSide(color: errorColor), borderRadius: borderRadius);

  final defaultBorderColor = VersionTwoColorScheme.Grey;

  final hoverColor = VersionTwoColorScheme.PurpleColor;

  final completedBorderColor = VersionTwoColorScheme.LightGreen;

  final errorColor = VersionTwoColorScheme.PrimaryColor;

  final fillColor = VersionTwoColorScheme.White;

  final focusColor = Colors.transparent;

  Color get borderColor {
    if (isValid) return completedBorderColor;
    if (isHovered) return hoverColor;
    return defaultBorderColor;
  }

  TextStyle errorStyle(BuildContext context) => CustomTextStyle.ErrorTextStyle(context);

  TextStyle hintStyle(BuildContext context) => CustomTextStyle.HintNewTextStyle(context);

  static const contentPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);

  final borderRadius = BorderRadius.circular(5);

  bool isValid = false;

  bool isHovered = false;
}
