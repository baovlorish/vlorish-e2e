import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:burgundy_budgeting_app/utils/extensions.dart';
import 'package:flutter/material.dart';

enum ColoredButtonStyle {
  Green,
  Pink,
  PrimaryColor,
  Grey,
  Red,
  Purple,
}

class ColoredButton extends StatelessWidget {
  final FocusNode? focusNode;
  final bool isTransparent;
  final ColoredButtonStyle buttonStyle;
  final Widget child;
  final void Function()? onPressed;
  final bool enabled;

  const ColoredButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.buttonStyle,
    this.focusNode,
    this.isTransparent = false,
    this.enabled = true,
  }) : super(key: key);

  Color get _accentColor {
    switch (buttonStyle) {
      case ColoredButtonStyle.Green:
        return VersionTwoColorScheme.Green;
      case ColoredButtonStyle.Pink:
        return VersionTwoColorScheme.Pink;
      case ColoredButtonStyle.PrimaryColor:
        return VersionTwoColorScheme.PrimaryColor;
      case ColoredButtonStyle.Grey:
        return VersionTwoColorScheme.Grey;
      case ColoredButtonStyle.Red:
        return VersionTwoColorScheme.Red;
      case ColoredButtonStyle.Purple:
        return VersionTwoColorScheme.PinkBackground;
    }
  }

  Color get accentColorProperty => isTransparent ? VersionTwoColorScheme.White : _accentColor;

  Color get secondaryColorProperty => isTransparent ? _accentColor : VersionTwoColorScheme.White;

  @override
  Widget build(BuildContext context) => ElevatedButton(
        focusNode: focusNode,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.hasDisabled) return secondaryColorProperty.halfTransparent;
            return secondaryColorProperty;
          }),
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.hasDisabled) return accentColorProperty.halfTransparent;
            return accentColorProperty;
          }),
          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: isTransparent ? BorderSide(color: _accentColor) : BorderSide.none,
          )),
          padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
        ),
        onPressed: onPressed,
        child: child,
      );
}

///New transparent button with border and HOVER color
class NewOutlinedButton extends StatelessWidget {
  final FocusNode? focusNode;
  final bool isTransparent;
  final ColoredButtonStyle buttonStyle;
  final Widget child;
  final void Function()? onPressed;
  final bool enabled;

  const NewOutlinedButton({
    required this.onPressed,
    required this.child,
    required this.buttonStyle,
    this.focusNode,
    this.isTransparent = false,
    this.enabled = true,
    this.onlyIcon = false,
  });

  Color get _accentColor {
    switch (buttonStyle) {
      case ColoredButtonStyle.Green:
        return VersionTwoColorScheme.Green;
      case ColoredButtonStyle.Pink:
        return VersionTwoColorScheme.Pink;
      case ColoredButtonStyle.PrimaryColor:
        return VersionTwoColorScheme.PrimaryColor;
      case ColoredButtonStyle.Grey:
        return VersionTwoColorScheme.Grey;
      case ColoredButtonStyle.Red:
        return VersionTwoColorScheme.Red;
      case ColoredButtonStyle.Purple:
        return VersionTwoColorScheme.PinkBackground;
    }
  }

  final bool onlyIcon;

  BorderSide get side => isTransparent ? BorderSide(color: _accentColor) : BorderSide.none;

  OutlinedBorder get shape => onlyIcon
      ? CircleBorder(side: side)
      : RoundedRectangleBorder(borderRadius: BorderRadius.circular(100), side: side);

  Color get accentColorProperty => isTransparent ? VersionTwoColorScheme.White : _accentColor;

  Color get secondaryColorProperty => isTransparent ? _accentColor : VersionTwoColorScheme.White;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      focusNode: focusNode,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith((states) {
          if (states.hasDisabled) return secondaryColorProperty.halfTransparent;
          return secondaryColorProperty;
        }),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.hasDisabled) return secondaryColorProperty.halfTransparent;
          return secondaryColorProperty;
        }),
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.hasDisabled) return accentColorProperty.halfTransparent;
          return accentColorProperty;
        }),
        shape: MaterialStatePropertyAll(shape),
        padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
