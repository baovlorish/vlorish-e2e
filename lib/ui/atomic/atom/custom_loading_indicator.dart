import 'dart:math' as math;

import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class CustomLoadingIndicator extends StatefulWidget {
  final bool isExpanded;
  final Color? color;
  final double height;

  const CustomLoadingIndicator(
      {Key? key, this.isExpanded = true, this.color, this.height = 40})
      : super(key: key);

  @override
  State<CustomLoadingIndicator> createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  final int itemCount = 5;
  final double variationFactor = 0.35;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1600),
    vsync: this,
  )..repeat();

  double calculateHeight(int index, double maxItemHeight) {
    return maxItemHeight * (1-variationFactor) +
        maxItemHeight *
            variationFactor *
            math.sin(
                (_controller.value - (index + 1) / itemCount) * 2 * math.pi);
  }

  @override
  Widget build(BuildContext context) {
    return widget.isExpanded
        ? Expanded(
            child: _inner,
          )
        : _inner;
  }

  Widget get _inner => Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              itemCount,
              (index) => _AnimationItem(
                calculateHeight(index, widget.height),
                color: widget.color,
                widgetHeight: widget.height,
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _AnimationItem extends StatelessWidget {
  final double height;
  final Color? color;
  final double widgetHeight;

  _AnimationItem(this.height, {this.color, required this.widgetHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widgetHeight,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
            width: 8,
            height: height,
            decoration: BoxDecoration(
              color: color ?? CustomColorScheme.button,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
