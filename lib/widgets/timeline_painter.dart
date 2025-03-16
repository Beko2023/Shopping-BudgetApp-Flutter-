import 'package:flutter/material.dart';

class TimelinePainter extends CustomPainter {
  final double todayPosition;
  final String todayDate;
  final Color lineColor;
  final Color triangleColor;

  TimelinePainter({
    required this.todayPosition,
    required this.todayDate,
    required this.lineColor,
    required this.triangleColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3;

    final trianglePaint = Paint()
      ..color = triangleColor
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawLine(Offset(0, size.height / 7),
        Offset(size.width, size.height / 10), linePaint);

    final triangleX = size.width * todayPosition;
    final triangleY = size.height / 6;

    final path = Path();
    path.moveTo(triangleX, triangleY + 10);
    path.lineTo(triangleX - 5, triangleY);
    path.lineTo(triangleX + 5, triangleY);
    path.close();

    canvas.drawPath(path, trianglePaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: todayDate,
        style: TextStyle(
          color: triangleColor,
          fontSize: 16,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final textX = triangleX - (textPainter.width / 2);
    final textY = triangleY + 10;

    textPainter.paint(canvas, Offset(textX, textY));

    final dotRadius = 3.0;
    final leftDotX = 0.0;
    final rightDotX = size.width;
    final dotY = size.height / 8;

    canvas.drawCircle(Offset(leftDotX, dotY), dotRadius, dotPaint);

    canvas.drawCircle(Offset(rightDotX, dotY), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
