import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StrikeThroughDecoration extends BoxDecoration {
  @override
  Paint getPaint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, size.height / 2);
    canvas.drawPath(path, paint);
    return paint;
  }
}