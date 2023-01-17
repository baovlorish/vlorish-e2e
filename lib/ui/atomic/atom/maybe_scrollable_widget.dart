import 'package:flutter/material.dart';

class MaybeScrollableWidget extends StatelessWidget {
  final Widget child;
  final bool shouldScrollWhen;
  final Axis scrollDirection;

  const MaybeScrollableWidget(
      {Key? key,
      required this.shouldScrollWhen,
      required this.scrollDirection,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return shouldScrollWhen
        ? SingleChildScrollView(
            scrollDirection: scrollDirection,
            child: child,
          )
        : child;
  }
}
