import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  final double circleRadius;
  final double lineWidth;
  final double circleLineWidth;
  final Color circleColor;

  Line(
      {this.circleRadius = 4,
      this.lineWidth,
      this.circleLineWidth = 2,
      this.circleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(width: 12),
      child: CustomPaint(
        painter: _LinePainter(
          color: Theme.of(context).accentColor,
          circleRadius: circleRadius,
          lineWidth: lineWidth,
          circleLineWidth: circleLineWidth,
          circleColor: circleColor,
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  final Color color;
  final double circleRadius;
  final double circleLineWidth;
  final Color circleColor;
  final double lineWidth;

  _LinePainter(
      {@required this.color,
      this.circleRadius = 10.0,
      this.lineWidth = 4,
      this.circleLineWidth = 2,
      this.circleColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint circlePaint = Paint()
      ..color = circleColor ?? color
      ..strokeWidth = circleLineWidth ?? lineWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
        Offset((size.width) / 2, 0),
        Offset((size.width) / 2, (size.height / 2) - circleRadius),
        linePaint);
    canvas.drawLine(
        Offset((size.width) / 2, size.height),
        Offset((size.width) / 2, (size.height / 2) + circleRadius),
        linePaint);
    canvas.drawCircle(
        Offset((size.width) / 2, size.height / 2), circleRadius, circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DashedLine extends StatelessWidget {
  final double lineWidth;

  DashedLine(this.lineWidth);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(width: 12),
        child: CustomPaint(
          painter: _DashedLinePainter(
            lineWidth,
            Theme.of(context).accentColor,
          ),
        ));
  }
}

class _DashedLinePainter extends CustomPainter {
  final double lineWidth;
  final Color lineColor;

  _DashedLinePainter(this.lineWidth, this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double dashHeight = 5;
    double spaceHeight = 5;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset((size.width) / 2, startY),
          Offset((size.width) / 2, startY + dashHeight), linePaint);
      startY = startY + dashHeight + spaceHeight;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
