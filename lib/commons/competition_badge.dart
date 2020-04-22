

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CompetitionBadge extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: _CompetitionBadgePainter(label: "4", leftColor: Colors.blue, rightColor: Colors.pinkAccent),
    );
  }
}

class _CompetitionBadgePainter extends CustomPainter {

  final String label;
  final Color leftColor;
  final Color rightColor;

  _CompetitionBadgePainter({@required this.label, @required this.leftColor, Color rightColor}) : this.rightColor = rightColor ?? leftColor;

  @override
  void paint(Canvas canvas, Size size) {
    double height = 2;
    double radius = 8;
    Paint left = new Paint()
      ..color = leftColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = height;
    Paint right = new Paint()
      ..color = rightColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = height;

    canvas.drawCircle(Offset(size.width/4-3, 0-0.0), radius, left);
    canvas.drawCircle(Offset(3*size.width/4+3, 0-0.0), radius, right);

    final textStyle = ui.TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    final paragraphStyle = ui.ParagraphStyle(
      textDirection: TextDirection.ltr,
    );
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(label);
    final constraints = ui.ParagraphConstraints(width: 300);
    final paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);
    canvas.drawParagraph(paragraph, Offset(0-2.0, -7.0));
    canvas.drawParagraph(paragraph, Offset(3*size.width/4-1, -7.0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}