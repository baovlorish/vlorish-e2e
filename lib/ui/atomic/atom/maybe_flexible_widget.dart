import 'package:flutter/cupertino.dart';

class MaybeFlexibleWidget extends StatelessWidget {
  final bool flexibleWhen;
  final bool expand;
  final int flex;
  final Widget child;

  const MaybeFlexibleWidget({
    Key? key,
    required this.flexibleWhen,
    required this.child,
    this.flex = 1,
    this.expand = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return flexibleWhen
        ? Flexible(
            flex: flex,
            fit: expand ? FlexFit.tight : FlexFit.loose,
            child: child,
          )
        : child;
  }
}
