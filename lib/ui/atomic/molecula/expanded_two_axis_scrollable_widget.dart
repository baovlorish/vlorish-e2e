import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class ExpandedTwoAxisScrollableWidget extends StatefulWidget {
  final double padding;
  final Widget child;
  final bool hasBackground;
  final double? verticalScrollOffset;
  final double? horizontalScrollOffset;
  final Function(double) onVerticalScrollOffset;

  final Function(double) onHorizontalScrollOffset;

  const ExpandedTwoAxisScrollableWidget(
      {this.padding = 0,
      required this.child,
      this.hasBackground = false,
      this.horizontalScrollOffset,
      this.verticalScrollOffset,
      required this.onVerticalScrollOffset,
      required this.onHorizontalScrollOffset});

  @override
  _ExpandedTwoAxisScrollableWidgetState createState() =>
      _ExpandedTwoAxisScrollableWidgetState();
}

class _ExpandedTwoAxisScrollableWidgetState
    extends State<ExpandedTwoAxisScrollableWidget> {
  late ScrollController verticalScrollController;
  late ScrollController horizontalScrollController;

  @override
  void dispose() {
    super.dispose();
    verticalScrollController.dispose();
    horizontalScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  can't move controllers creation to init state
    //  because they can't init with offset if not attached to widget
    //  and start offset will always be 0
    verticalScrollController =
        ScrollController(initialScrollOffset: widget.verticalScrollOffset ?? 0);
    verticalScrollController.addListener(() {
      widget.onVerticalScrollOffset(verticalScrollController.offset);
    });
    horizontalScrollController = ScrollController(
        initialScrollOffset: widget.horizontalScrollOffset ?? 0);
    horizontalScrollController.addListener(() {
      widget.onHorizontalScrollOffset(horizontalScrollController.offset);
    });

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(widget.padding),
        child: Container(
          decoration: BoxDecoration(
              color: widget.hasBackground ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10.0,
                  color: widget.hasBackground
                      ? CustomColorScheme.tableBorder
                      : Colors.transparent,
                ),
              ]),
          child: SingleChildScrollView(
            controller: verticalScrollController,
//            physics: CustomScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              controller: horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

//causes infinite drag bug
class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final tolerance = this.tolerance;
    if ((velocity.abs() < tolerance.velocity) ||
        (velocity > 0.0 && position.pixels >= position.maxScrollExtent) ||
        (velocity < 0.0 && position.pixels <= position.minScrollExtent)) {
      return null;
    }
    return ClampingScrollSimulation(
      position: position.pixels,
      velocity: velocity,
      friction: 0.8,
      tolerance: tolerance,
    );
  }
}
