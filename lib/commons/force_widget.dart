import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v34/models/force.dart';

class ForceWidget extends StatefulWidget {
  static const double centerWidth = 50;

  final Force force;
  final Force globalForce;

  ForceWidget({Key? key, required this.force, required this.globalForce}) : super(key: key);

  @override
  State<ForceWidget> createState() => _ForceWidgetState();
}

class _ForceWidgetState extends State<ForceWidget> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildRow(
          SvgPicture.asset("assets/attack.svg", width: 24, color: Theme.of(context).textTheme.bodyText1!.color),
          ForceGraph(
            value: (widget.force.totalAttackPerSet / widget.globalForce.totalAttackPerSet),
            forceOrientation: ForceOrientation.leftToRight,
            textPosition: ForceTextPosition.above,
          ),
        ),
        _buildRow(
          SvgPicture.asset("assets/defense.svg", width: 20, color: Theme.of(context).textTheme.bodyText1!.color),
          ForceGraph(
            value: (25 - widget.force.totalDefensePerSet) / (25 - widget.globalForce.totalDefensePerSet),
            forceOrientation: ForceOrientation.leftToRight,
            textPosition: ForceTextPosition.above,
          ),
        ),
      ],
    );
  }

  Widget _buildRow(Widget leftCell, Widget rightCell) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: ForceWidget.centerWidth,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: leftCell,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: rightCell,
            ),
          ),
        ],
      ),
    );
  }
}

class ForceGraph extends StatefulWidget {
  final double value;
  final bool showValue;
  final ForceOrientation forceOrientation;
  final ForceTextPosition textPosition;
  const ForceGraph({
    Key? key,
    required this.value,
    this.showValue = false,
    required this.forceOrientation,
    required this.textPosition,
  }) : super(key: key);

  @override
  State<ForceGraph> createState() => _ForceGraphState();
}

class _ForceGraphState extends State<ForceGraph> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant ForceGraph oldWidget) {
    _controller.forward();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ForceGraphPainter(
        value: _animation.value * widget.value,
        backgroundColor: Theme.of(context).cardTheme.color!,
        showValue: widget.showValue,
        orientation: widget.forceOrientation,
        textPosition: widget.textPosition,
        textStyle: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}

enum ForceOrientation { leftToRight, rightToLeft }
enum ForceTextPosition { above, below }

class ForceGraphPainter extends CustomPainter {
  final double min;
  final double max;
  final double ref;
  late final double value;
  late final Color backgroundColor;
  final bool showValue;
  final ForceOrientation orientation;
  final ForceTextPosition textPosition;
  final TextStyle? textStyle;

  ForceGraphPainter({
    this.min = 0.75,
    this.max = 1.25,
    this.ref = 1,
    required double value,
    required this.backgroundColor,
    required this.showValue,
    required this.orientation,
    required this.textPosition,
    this.textStyle,
  }) {
    this.value = value;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double barTranslationX = 8;

    final double strokeWidth = 8;
    final colors = [Colors.red, Colors.orange, Colors.yellow, Colors.green];
    final stops = List.generate(colors.length, (index) => (index * max / (colors.length)));
    final invertedStops = stops.reversed.toList();
    final inversedColors = colors.reversed.toList();

    final gradient = LinearGradient(colors: colors, stops: stops);
    final invertedGradient = LinearGradient(colors: inversedColors, stops: stops);

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

    var val = value;
    if (val < min) val = min;
    if (val > max) val = max;
    //val = (max - min) / 2;
    //val = 1.104;
    double axisX = (val - min) / (max - min);

    // Offset start = Offset(0, size.height / 2);
    // Offset end = Offset(size.width, size.height / 2);

    Offset start =
        orientation == ForceOrientation.leftToRight ? Offset(0, size.height / 2) : Offset(size.width, size.height / 2);
    Offset end =
        orientation == ForceOrientation.leftToRight ? Offset(size.width, size.height / 2) : Offset(0, size.height / 2);
    Offset point = Offset(
        orientation == ForceOrientation.leftToRight ? axisX * size.width : (1 - axisX) * size.width, size.height / 2);

    double translation = orientation == ForceOrientation.leftToRight ? barTranslationX : -barTranslationX;
    canvas.drawLine(start.translate(-translation, 0), end.translate(translation, 0),
        orientation == ForceOrientation.leftToRight ? paint : invertedPaint);

    //  Offset point = Offset(
    //     orientation == ForceOrientation.leftToRight ? axisX * size.width : (1 - axisX) * size.width, size.height / 2);

    Paint circleForegroundPaint = Paint()
      ..color = _lerpGradient(orientation == ForceOrientation.leftToRight ? colors : colors,
          orientation == ForceOrientation.leftToRight ? stops : stops, axisX)
      ..style = PaintingStyle.fill;

    Paint circleBackgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    const double circleRadius = 8;
    canvas.drawCircle(point, 10, circleBackgroundPaint);
    canvas.drawCircle(point, circleRadius, circleForegroundPaint);

    if (showValue) {
      TextSpan span = new TextSpan(text: "${((value / ref) * 100).toInt()}%", style: textStyle);
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(
        canvas,
        end.translate(-tp.width / 2,
            textPosition == ForceTextPosition.above ? -tp.height - circleRadius - 3 : tp.height - circleRadius + 3),
      );
    }
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
        return Color.lerp(leftColor, rightColor, sectionT)!;
      }
    }
    return colors.last;
  }
}
