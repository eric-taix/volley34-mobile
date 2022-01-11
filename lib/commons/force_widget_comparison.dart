import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v34/models/force.dart';

class ForceComparison extends StatefulWidget {
  static const double iconWidth = 25;

  final String? hostName;
  final String? visitorName;
  final Force hostForce;
  final Force visitorForce;
  final Force globalForce;
  final ForceDirection direction;

  ForceComparison({
    Key? key,
    this.hostName,
    this.visitorName,
    required this.hostForce,
    required this.visitorForce,
    required this.globalForce,
    required this.direction,
  }) : super(key: key);

  @override
  State<ForceComparison> createState() => _ForceComparisonState();
}

class _ForceComparisonState extends State<ForceComparison> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.hostName != null || widget.visitorName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(widget.hostName ?? "",
                        textAlign: TextAlign.end, style: Theme.of(context).textTheme.bodyText1)),
                Container(width: 50, child: Center(child: Text(""))),
                Expanded(
                    flex: 1,
                    child: Text(widget.visitorName ?? "",
                        textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText1)),
              ],
            ),
          ),
        _buildRow(
          SvgPicture.asset("assets/attack.svg", width: 20, color: Theme.of(context).textTheme.bodyText1!.color),
          CustomPaint(
            painter: ForceGraphPainter(
              value: _animation.value *
                  (((widget.hostForce.totalAttackPerSet / widget.globalForce.totalAttackPerSet)) -
                      ((widget.visitorForce.totalAttackPerSet / widget.globalForce.totalAttackPerSet))),
              direction: widget.direction,
              backgroundColor: Theme.of(context).cardTheme.color!,
              textDisplay: TextDisplay.displayAbove,
            ),
          ),
        ),
        _buildRow(
          SvgPicture.asset("assets/defense.svg", width: 14, color: Theme.of(context).textTheme.bodyText1!.color),
          CustomPaint(
            painter: ForceGraphPainter(
              value: _animation.value *
                  (((25 - widget.hostForce.totalDefensePerSet) / (25 - widget.globalForce.totalDefensePerSet)) -
                      ((25 - widget.visitorForce.totalDefensePerSet) / (25 - widget.globalForce.totalDefensePerSet))),
              direction: widget.direction,
              backgroundColor: Theme.of(context).cardTheme.color!,
              textDisplay: TextDisplay.displayBellow,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(Widget leftCell, Widget middleCell) {
    const double forceMargin = 38;
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              width: ForceComparison.iconWidth,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: leftCell,
              ))),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: forceMargin, right: forceMargin),
            child: middleCell,
          )),
        ],
      ),
    );
  }
}

enum ForceDirection { leftToRight, rightToLeft }

enum TextDisplay { displayAbove, displayBellow }

class ForceGraphPainter extends CustomPainter {
  final ForceDirection direction;
  final double min;
  final double max;
  final double ref;
  late final double value;
  late final Color backgroundColor;
  final TextDisplay textDisplay;

  ForceGraphPainter({
    this.direction: ForceDirection.leftToRight,
    this.min = -1,
    this.max = 1,
    this.ref = 1,
    required double value,
    required this.backgroundColor,
    required this.textDisplay,
  }) {
    value = value * (direction == ForceDirection.leftToRight ? -1 : 1);
    if (value > max)
      this.value = max;
    else if (value < min)
      this.value = min;
    else
      this.value = value;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 8;
    final colors = [Colors.green, Colors.orange, Colors.red, Colors.orange, Colors.green];
    final invertedColors = colors.reversed.toList();
    final stops = List.generate(colors.length, (index) => 1 / (colors.length * 2) + (index * (1 / colors.length)));
    final gradient = LinearGradient(colors: colors, stops: stops);
    final invertedGradient = LinearGradient(colors: invertedColors, stops: stops);

    double gradientSize = size.width;
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTRB(0, 0, gradientSize, size.height))
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final invertedPaint = Paint()
      ..shader = invertedGradient.createShader(Rect.fromLTRB(0, 0, gradientSize, size.height))
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Offset start = direction == ForceDirection.leftToRight ? Offset(0, 0) : Offset(size.width, 0);
    Offset end = direction == ForceDirection.leftToRight ? Offset(size.width, 0) : Offset(0, 0);
    Offset point =
        Offset((size.width / 2) + (size.width * (value * (direction == ForceDirection.leftToRight ? 1 : -1)) / 2), 0);

    double axisWidth = 2;
    double axisHeight = 14;
    final axisPaint = Paint()
      ..color = Colors.white30
      ..style = PaintingStyle.stroke
      ..strokeWidth = axisWidth
      ..strokeCap = StrokeCap.square;

    Paint circleBackgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    Paint circleForegroundPaint = Paint()
      ..color = _lerpGradient(colors, stops, value + 0.5)
      ..style = PaintingStyle.fill;

    const double circleRadius = 7;

    canvas.drawLine(Offset((size.width / 2) - (axisWidth / 2), 0 - axisHeight),
        Offset((size.width / 2) - (axisWidth / 2), size.height + axisHeight), axisPaint);
    canvas.drawLine(start, end, direction == ForceDirection.leftToRight ? paint : invertedPaint);
    canvas.drawCircle(point, circleRadius + 4, circleBackgroundPaint);

    canvas.drawCircle(point, circleRadius, circleForegroundPaint);

    /*  TextSpan span = new TextSpan(
        text: "${value > 0 ? "+" : ""}${((value / ref) * 100).toInt()}%", style: TextStyle(color: Colors.grey));
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(
        canvas,
        point.translate(
            -tp.width / 2, textDisplay == TextDisplay.displayAbove ? -circleRadius - tp.height - 10 : tp.height + 2));

   */
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Color _lerpGradient(List<Color> colors, List<double>? stops, double? t) {
    if (t == null) return Colors.grey;
    for (var s = 0; s < (stops?.length ?? 0) - 1; s++) {
      final leftStop = stops?[s], rightStop = stops?[s + 1];
      final leftColor = colors[s], rightColor = colors[s + 1];
      if (t <= leftStop!) {
        return leftColor;
      } else if (t < rightStop!) {
        final sectionT = (t - leftStop) / (rightStop - leftStop);
        return HSVColor.lerp(HSVColor.fromColor(leftColor), HSVColor.fromColor(rightColor), sectionT)!.toColor();
      }
    }
    return colors.last;
  }
}
