import 'dart:math' as math;

import 'package:flutter/material.dart';

typedef Widget ValueBuilder(double value, double min, double max);

class ArcGraph extends StatefulWidget {
  final double minValue;
  final double maxValue;
  final double? value;
  final double lineWidth;
  final double openedAngle;
  final LeftTitle leftTitle;
  final List<Color> colors;
  final List<double> stops;
  final ValueBuilder? valueBuilder;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final Color? backgroundColor;

  ArcGraph({
    required this.minValue,
    required this.maxValue,
    required this.value,
    this.lineWidth = 10,
    this.openedAngle = math.pi / 4,
    LeftTitle? leftTitle,
    List<Color>? colors,
    List<double>? stops,
    this.animationDuration,
    this.animationCurve,
    this.valueBuilder,
    this.backgroundColor,
  })  : assert(maxValue >= minValue),
        assert((value ?? minValue) >= minValue && (value ?? maxValue) <= maxValue),
        assert((colors == null && stops == null) ||
            (colors ?? [Colors.red, Colors.orangeAccent, Colors.green]).length == (stops ?? [0.1, 0.5, 0.95]).length),
        this.leftTitle = leftTitle ?? LeftTitle(show: false),
        this.colors = colors ?? [Colors.red, Colors.yellow, Colors.green],
        this.stops = stops ?? [0.1, 0.5, 0.9];

  @override
  _ArcGraphState createState() => _ArcGraphState();
}

class _ArcGraphState extends State<ArcGraph> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, lowerBound: 0, upperBound: 1, duration: widget.animationDuration ?? Duration(milliseconds: 800));
    _animationController.addListener(() {
      setState(() {});
    });
    Future.delayed(Duration(milliseconds: 500), () {
      _animateTo(widget.value ?? 0);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateTo(double value) {
    if (mounted) {
      double arcValue = (widget.maxValue - widget.minValue) != 0 ? (value) / (widget.maxValue - widget.minValue) : 0;
      _animationController.animateTo(arcValue);
    }
  }

  @override
  void didUpdateWidget(ArcGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value ||
        oldWidget.minValue != widget.minValue ||
        oldWidget.maxValue != widget.maxValue) {
      _animateTo(widget.value ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      children: [
        Transform.rotate(
          angle: math.pi / 2,
          child: CustomPaint(
            painter: _ArcPainter(
              _animationController.value,
              widget.lineWidth,
              widget.openedAngle,
              widget.backgroundColor ?? Theme.of(context).cardTheme.color ?? Colors.white38,
              widget.leftTitle,
              widget.colors,
              widget.stops,
            ),
          ),
        ),
        Center(
          child: widget.valueBuilder != null
              ? widget.valueBuilder!(_animationController.value, widget.minValue, widget.maxValue)
              : Text("${_animationController.value}"),
        ),
      ],
    );
  }
}

class LeftTitle {
  final bool show;
  final String? text;
  final TextStyle? style;

  LeftTitle({this.show = false, this.text, this.style}) : assert((show && text!.isNotEmpty) || !show);
}

class _ArcPainter extends CustomPainter {
  final double lineWidth;
  final double openedAngle;
  final double? value;
  final Color pointBackground;
  final LeftTitle leftTitle;
  final List<Color> colors;
  final List<double> stops;
  _ArcPainter(
      this.value, this.lineWidth, this.openedAngle, this.pointBackground, this.leftTitle, this.colors, this.stops);

  @override
  void paint(Canvas canvas, Size size) {
    var min = math.min(size.width - lineWidth, size.height - lineWidth);
    Rect rect = new Rect.fromLTWH(0.0 + (size.width - min) / 2, (size.height - min) / 2, min, min);
    var startAngle = openedAngle;
    var endAngle = 2 * math.pi - openedAngle;
    final gradient = new SweepGradient(
        startAngle: startAngle, endAngle: endAngle, tileMode: TileMode.clamp, colors: colors, stops: stops);

    Paint arcPaint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    Color pointColor = lerpGradient(gradient.colors, gradient.stops, value);

    Paint valueForegroundPaint = Paint()
      ..color = pointColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = lineWidth;
    Paint valueBackgroundPaint = Paint()
      ..color = pointBackground
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = lineWidth;

    /*Paint arcBackgroundPaint = Paint()
      ..color = Colors.grey
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;*/

    var radius = min / 2;
    var maxAngle = endAngle - startAngle;
    var valueAngle = maxAngle * (value ?? 0) + startAngle;

    var dx = math.sin(valueAngle) * radius;
    var dy = math.cos(valueAngle) * radius;

    final TextSpan leftSpan = TextSpan(text: leftTitle.text, style: leftTitle.style);
    final TextPainter leftTp = TextPainter(
      text: leftSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      textScaler: TextScaler.linear(1.1),
    )..layout();

    canvas.save();
    //canvas.translate(0, -leftTp.height / 2);
    canvas.drawArc(rect, startAngle, endAngle - openedAngle, false, arcPaint);
    //canvas.drawArc(rect, valueAngle, endAngle - valueAngle, false, arcBackgroundPaint);
    canvas.drawCircle(Offset(0 + size.width / 2 + dy, 0 + size.height / 2 + dx), lineWidth + 2, valueBackgroundPaint);
    canvas.drawCircle(Offset(0 + size.width / 2 + dy, 0 + size.height / 2 + dx), lineWidth - 2, valueForegroundPaint);
    canvas.restore();

    canvas.save();
    canvas.translate(size.width / 2, 0);
    canvas.rotate(-math.pi);
    canvas.translate(-leftTp.width / 2, -min / 2 - leftTp.height * 2 - lineWidth - size.width / 2);
    leftTp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  Color lerpGradient(List<Color> colors, List<double>? stops, double? t) {
    if (t == null) return Colors.grey;
    for (var s = 0; s < (stops?.length ?? 0) - 1; s++) {
      final leftStop = stops?[s], rightStop = stops?[s + 1];
      final leftColor = colors[s], rightColor = colors[s + 1];
      if (t <= leftStop!) {
        return leftColor;
      } else if (t < rightStop!) {
        final sectionT = (t - leftStop) / (rightStop - leftStop);
        return Color.lerp(leftColor, rightColor, sectionT)!;
      }
    }
    return colors.last;
  }
}
