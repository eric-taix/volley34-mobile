

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CompetitionBadge extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 20,
      child: CustomPaint(
          painter: _CompetitionBadgePainter(label: "4", leftColor: Colors.blue, rightColor: Colors.pinkAccent),
      ),
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

    var space = 2.5;

    double height = size.height;
    Paint left = new Paint()
      ..color = leftColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = height;
    Paint leftSquare = new Paint()
      ..color = leftColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill
      ..strokeWidth = height;
    Paint right = new Paint()
      ..color = rightColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = height;
    Paint rightSquare = new Paint()
      ..color = rightColor
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.fill
      ..strokeWidth = height;

    canvas.drawLine(Offset(0, 0), Offset(size.width/10, 0), left);
    canvas.drawLine(Offset(size.width/10, 0), Offset((size.width/2)-space, 0), leftSquare);

    canvas.drawLine(Offset((size.width/2)+space, 0), Offset(9*size.width/10, 0), rightSquare);
    canvas.drawLine(Offset(9*size.width/10, 0), Offset(size.width, 0), right);

    final textStyle = ui.TextStyle(
      color: Colors.white,
      fontSize: 14,
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
    canvas.drawParagraph(paragraph, Offset(0-2.0, -8.0));
    canvas.drawParagraph(paragraph, Offset(size.width-6, -8.0));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}