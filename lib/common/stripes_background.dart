import 'dart:math';

import 'package:flutter/material.dart';

class StripesBackground extends CustomPainter {
  const StripesBackground({
    super.repaint,
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    paint.strokeWidth = strokeWidth;
    paint.isAntiAlias = true;

    // Paint paint2 = Paint();
    // paint2.color = Colors.orange;
    // paint2.strokeWidth = 100;
    // paint2.isAntiAlias = true;

    const angle = pi / 4;
    final step = paint.strokeWidth * (2 + cos(angle));

    var curPaint = paint;

    var x1 = -size.width;
    var y1 = size.width * 2;
    var x2 = size.width * 2;
    var y2 = -size.width;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), curPaint);

    while (y1 > 0) {
      y2 -= step;
      y1 -= step;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), curPaint);
    }

    x1 = -size.width;
    y1 = size.width * 2;
    x2 = size.width * 2;
    y2 = -size.width;

    while (y2 < size.height) {
      y1 += step;
      y2 += step;
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), curPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
