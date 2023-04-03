import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:flutter/material.dart';

class FormDecoration extends StatelessWidget {
  const FormDecoration({
    Key? key,
    required this.child,
    this.paddingAll = 30,
    this.bottomFormPadding = 30,
    this.color = Colors.white,
    this.circularBorderRadius = 15.0,
    required this.errorTitle,
    required this.errorDetail,
    required this.isErrorState,
  }) : super(key: key);

  final Widget child;
  final double paddingAll;
  final double bottomFormPadding;
  final Color color;
  final double circularBorderRadius;
  final String errorTitle;
  final String errorDetail;
  final bool isErrorState;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(paddingAll),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(circularBorderRadius)),
          child: Column(
            children: [
              child,
              if (isErrorState)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: FormErrorView(
                    errorTitle: errorTitle,
                    errorDetail: errorDetail,
                  ),
                )
            ],
          ),
        ),
        SizedBox(height: bottomFormPadding)
      ],
    );
  }
}

class FormErrorView extends StatelessWidget {
  final String errorTitle;
  final String errorDetail;

  const FormErrorView({Key? key, required this.errorTitle, required this.errorDetail}) : super(key: key);

  static const padding = EdgeInsets.all(10);
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: VersionTwoColorScheme.RedBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.error_rounded,
                      color: VersionTwoColorScheme.Red,
                      size: 15.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      errorTitle,
                      style: TextStyle(color: VersionTwoColorScheme.Red, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              errorDetail,
              style: TextStyle(color: VersionTwoColorScheme.Red, fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
