import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomIndicatorWidget extends StatefulWidget {

  final Color? color;
  final double size;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  const CustomIndicatorWidget(
      {Key? key,
        required this.color,
        this.size = 20,
        required this.child,
        this.padding = const EdgeInsets.only(right: 4)})
      : super(key: key);

  @override
  _CustomIndicatorWidgetState createState() => _CustomIndicatorWidgetState();
}

class _CustomIndicatorWidgetState extends State<CustomIndicatorWidget> {

  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Container(
        height: widget.size,
        width: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.size/2),
        ),
        child: Center(
          child: widget.child,
        ),
      ),
    );
  }
}