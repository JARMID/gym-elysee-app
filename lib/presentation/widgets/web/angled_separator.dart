import 'package:flutter/material.dart';

class AngledSeparator extends StatelessWidget {
  final Color color;
  final double height;
  final bool inverted;

  const AngledSeparator({
    super.key,
    required this.color,
    this.height = 50,
    this.inverted = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _AngledPainter(color, inverted),
        size: Size.infinite,
      ),
    );
  }
}

class _AngledPainter extends CustomPainter {
  final Color color;
  final bool inverted;

  _AngledPainter(this.color, this.inverted);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();

    // Fill the triangle
    if (inverted) {
      // Top Left to Bottom Right diagonal, filling top part
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, 0);
    } else {
      // Bottom Left to Top Right diagonal, filling top part?
      // No, usually we want to fill the "separator" space.
      // Let's assume this widget is placed BETWEEN sections.
      // It draws a triangle.

      // Standard: Top Left to Bottom Right
      path.moveTo(0, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
