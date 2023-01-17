import 'package:burgundy_budgeting_app/ui/atomic/atom/theme.dart';
import 'package:flutter/material.dart';

class CommentIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(20, 20),
      painter: _DrawTriangleShape(
        CustomColorScheme.clipElementInactive,
      ),
    );
  }
}

class _DrawTriangleShape extends CustomPainter {
  final Color color;

  late final Paint painter;

  _DrawTriangleShape(this.color) {
    painter = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
