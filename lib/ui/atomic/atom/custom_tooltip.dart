import 'package:burgundy_budgeting_app/ui/atomic/atom/text_styles.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/version_two_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';

class CustomTooltip extends StatelessWidget {
  final String? message;
  final Widget child;
  final Color? color;
  final bool preferBelow;

  const CustomTooltip({
    Key? key,
    required this.message,
    required this.child,
    this.color,
    this.preferBelow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message == null || (message?.isEmpty ?? true)) return child;
    return Tooltip(
      message: message!,
      textStyle: CustomTextStyle.TooltipTextStyle(context),
      preferBelow: preferBelow,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: color ?? CustomColorScheme.mainDarkBackground,
      ),
      child: child,
    );
  }
}

class CustomOneTooltip extends StatefulWidget {
  final String message;
  final Widget child;

  const CustomOneTooltip({Key? key, required this.child, required this.message}) : super(key: key);

  @override
  _CustomOneTooltipState createState() => _CustomOneTooltipState();
}

class _CustomOneTooltipState extends State<CustomOneTooltip> with TickerProviderStateMixin {
  late GlobalKey key;
  late OverlayEntry overlayEntry;

  late double leftPosition;
  late double topPosition;
  @override
  void initState() {
    key = LabeledGlobalKey(widget.message);
    super.initState();
  }

  void getWidgetDetails() {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    topPosition = offset.dy + 24;
    leftPosition = offset.dx - 80;
  }

  OverlayEntry get _makeOverlay => OverlayEntry(
        builder: (context) => Positioned(
          top: topPosition,
          left: leftPosition,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: ClipPath(
                  clipper: _ArrowClip(),
                  child: Container(
                    height: 10,
                    width: 15,
                    decoration: BoxDecoration(
                      color: VersionTwoColorScheme.PurpleTooltipColor,
                    ),
                  ),
                ),
              ),
              Material(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  decoration: BoxDecoration(
                    color: VersionTwoColorScheme.PurpleTooltipColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    widget.message,
                    style: CustomTextStyle.LabelNewTextStyle(context)
                        .copyWith(color: VersionTwoColorScheme.White, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  void showOverlay() {
    getWidgetDetails();
    overlayEntry = _makeOverlay;
    Overlay.of(context).insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: key,
      child: widget.child,
      onHover: (isHover) {
        isHover ? showOverlay : overlayEntry.remove();
      },
    );
  }
}

class _ArrowClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
