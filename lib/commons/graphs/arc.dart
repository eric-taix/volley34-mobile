import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

typedef Widget ValueBuilder(double value, double min, double max);

class ArcGraph extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final double value;
  final double lineWidth;
  final double openedAngle;
  final LeftTitle leftTitle;
  final List<Color> colors;
  final List<double> stops;
  final ValueBuilder? valueBuilder;

  ArcGraph({
    required this.minValue,
    required this.maxValue,
    required this.value,
    this.lineWidth = 4,
    this.openedAngle = math.pi / 4,
    LeftTitle? leftTitle,
    List<Color>? colors,
    List<double>? stops,
    this.valueBuilder,
  })  : assert(minValue != null),
        assert(maxValue != null),
        assert(value != null),
        assert(maxValue >= minValue),
        assert(value >= minValue && value <= maxValue),
        assert((colors == null && stops == null) || (colors!.length == stops!.length)),
        this.leftTitle = leftTitle ?? LeftTitle(show: false),
        this.colors = colors ?? [Colors.redAccent, Colors.orangeAccent, Colors.greenAccent],
        this.stops = stops ?? [0.1, 0.5, 0.95];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      fit: StackFit.expand,
      children: [
        Transform.rotate(
          angle: math.pi / 2,
          child: CustomPaint(
            painter: _ArcPainter(
              (maxValue - minValue) != 0 ? (value - minValue) / (maxValue - minValue): null,
              lineWidth,
              openedAngle,
              Theme.of(context).primaryColor,
              leftTitle,
              colors,
              stops,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: valueBuilder != null ? valueBuilder!(value, minValue, maxValue) : Text("$value"),
          ),
        ),
      ],
    );
  }
}

class LeftTitle {
  final bool? show;
  final String? text;
  final TextStyle? style;

  LeftTitle({this.show, this.text, this.style}) : assert(show == true || (text != null && text.isNotEmpty));
}

class _ArcPainter extends CustomPainter {
  final double lineWidth;
  final double openedAngle;
  final double? value;
  final Color pointBackground;
  final LeftTitle leftTitle;
  final List<Color> colors;
  final List<double> stops;
  _ArcPainter(this.value, this.lineWidth, this.openedAngle, this.pointBackground, this.leftTitle, this.colors, this.stops);

  @override
  void paint(Canvas canvas, Size size) {
    var min = math.min(size.width, size.height);
    Rect rect = new Rect.fromLTWH(0.0 + (size.width - min) / 2, 0.0, min, min);

    var startAngle = openedAngle;
    var endAngle = 2 * math.pi - openedAngle;
    final gradient = new SweepGradient(startAngle: startAngle, endAngle: endAngle, tileMode: TileMode.clamp, colors: colors, stops: stops);

    Paint arcPaint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    Color pointColor = lerpGradient(gradient.colors, gradient.stops!, value ?? 0)!;

    Paint valueForegroundPaint = new Paint()
      ..color = pointColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = lineWidth;
    Paint valueBackgroundPaint = new Paint()
      ..color = pointBackground
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = lineWidth;

    var radius = min / 2;
    var valueAngle = (endAngle - startAngle) * (value ?? 0) + startAngle;
    var dx = math.sin(valueAngle) * radius;
    var dy = math.cos(valueAngle) * radius;

    final TextSpan leftSpan = TextSpan(text: leftTitle.text, style: leftTitle.style);
    final TextPainter leftTp = TextPainter(
      text: leftSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      textScaleFactor: 1.1,
    )..layout();

    canvas.save();
    canvas.translate(0, -leftTp.height / 2);
    canvas.drawArc(rect, startAngle, endAngle - openedAngle, false, arcPaint);
    canvas.drawCircle(Offset(0 + size.width / 2 + dy, 0 + size.height / 2 + dx), 8, valueBackgroundPaint);
    canvas.drawCircle(Offset(0 + size.width / 2 + dy, 0 + size.height / 2 + dx), 6, valueForegroundPaint);
    canvas.restore();

    canvas.save();
    canvas.translate(size.width / 2, 0);
    canvas.rotate(-math.pi);
    canvas.translate(-leftTp.width / 2, -min / 2 - leftTp.height - size.width / 2);
    leftTp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Color? lerpGradient(List<Color> colors, List<double> stops, double t) {
    for (var s = 0; s < stops.length - 1; s++) {
      final leftStop = stops[s], rightStop = stops[s + 1];
      final leftColor = colors[s], rightColor = colors[s + 1];
      if (t <= leftStop) {
        return leftColor;
      } else if (t < rightStop) {
        final sectionT = (t - leftStop) / (rightStop - leftStop);
        return Color.lerp(leftColor, rightColor, sectionT);
      }
    }
    return colors.last;
  }
}
