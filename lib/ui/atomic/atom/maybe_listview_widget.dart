import 'package:flutter/material.dart';

class MaybeListViewWidget extends StatelessWidget {
  final bool scrollable;
  final List<Widget> children;

  const MaybeListViewWidget({
    Key? key,
    required this.scrollable,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return scrollable
        ? ListView(
            children: children,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          );
  }
}
