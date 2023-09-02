import 'package:flutter/material.dart';

class BubbleTriangle extends CustomPainter {
  final Color bgColor = Colors.white;

  BubbleTriangle();

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-20, 0);
    path.lineTo(0, -8);
    path.lineTo(8, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
