import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:v34/models/force.dart';

class ForceWidget extends StatefulWidget {
  static const double centerWidth = 50;

  final String hostName;
  final String visitorName;
  final Force hostForce;
  final Force visitorForce;
  final Force globalForce;

  ForceWidget(
      {Key? key,
      required this.hostName,
      required this.visitorName,
      required this.hostForce,
      required this.visitorForce,
      required this.globalForce})
      : super(key: key) {
    print("$hostName Att: ${hostForce.homeAttack} / ${hostForce.countHome}");
    print("$visitorName Att: ${visitorForce.outsideAttack} / ${visitorForce.countOutside}");
    print("GLOBAL ${globalForce.homeAttack} pour ${globalForce.countHome}");
  }

  @override
  State<ForceWidget> createState() => _ForceWidgetState();
}

class _ForceWidgetState extends State<ForceWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
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
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 1,
                child: Text(widget.hostName, textAlign: TextAlign.end, style: Theme.of(context).textTheme.bodyText1)),
            Container(width: ForceWidget.centerWidth, child: Center(child: Text(""))),
            Expanded(
                flex: 1,
                child:
                    Text(widget.visitorName, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyText1)),
          ],
        ),
        _buildRow(
          CustomPaint(
            painter: ForceGraphPainter(
              value: _animation.value * (widget.hostForce.homeAttackPerSet / widget.globalForce.homeAttackPerSet),
              orientation: ForceOrientation.rightToLeft,
              backgroundColor: Theme.of(context).cardTheme.color!,
            ),
          ),
          SvgPicture.asset("assets/attack.svg", width: 24, color: Theme.of(context).textTheme.bodyText1!.color),
          CustomPaint(
            painter: ForceGraphPainter(
              value:
                  _animation.value * (widget.visitorForce.outsideAttackPerSet / widget.globalForce.outsideAttackPerSet),
              backgroundColor: Theme.of(context).cardTheme.color!,
            ),
          ),
        ),
        _buildRow(
          CustomPaint(
            painter: ForceGraphPainter(
              value: _animation.value *
                  ((25 - widget.hostForce.homeDefensePerSet) / (25 - widget.globalForce.homeDefensePerSet)),
              orientation: ForceOrientation.rightToLeft,
              backgroundColor: Theme.of(context).cardTheme.color!,
            ),
          ),
          SvgPicture.asset("assets/defense.svg", width: 20, color: Theme.of(context).textTheme.bodyText1!.color),
          CustomPaint(
            painter: ForceGraphPainter(
              value: _animation.value *
                  ((25 - widget.visitorForce.outsideAttackPerSet) / (25 - widget.globalForce.outsideAttackPerSet)),
              backgroundColor: Theme.of(context).cardTheme.color!,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(Widget leftCell, Widget middleCell, Widget rightCell) {
    const double forceMargin = 58;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: forceMargin),
          child: leftCell,
        )),
        Container(
            width: ForceWidget.centerWidth,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
              child: middleCell,
            ))),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(right: forceMargin),
          child: rightCell,
        )),
      ],
    );
  }
}

enum ForceOrientation { leftToRight, rightToLeft }

class ForceGraphPainter extends CustomPainter {
  final ForceOrientation orientation;
  final double min;
  final double max;
  late final double value;
  late final Color backgroundColor;

  ForceGraphPainter({
    this.orientation: ForceOrientation.leftToRight,
    this.min = 0.5,
    this.max = 1.5,
    required double value,
    required this.backgroundColor,
  }) {
    this.value = value;
    /* if (value < min) {
      this.value = min;
    } else if (value > max) {
      this.value = max;
    } else {
      this.value = value;
    }*/
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double barTranslationX = 8;

    final double strokeWidth = 10;
    final colors = [Colors.red, Colors.orange, Colors.green];
    final invertedColors = colors.reversed.toList();
    final stops = List.generate(colors.length, (index) => 1 / (2 * colors.length) + (index * 1 / (colors.length)));
    final gradient = LinearGradient(colors: colors, stops: stops);
    final invertedGradient = LinearGradient(colors: invertedColors, stops: stops);

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final invertedPaint = Paint()
      ..shader = invertedGradient.createShader(Rect.fromLTRB(0, 0, size.width, size.height))
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint paintStart = Paint()
      ..shader = gradient.createShader(Rect.fromLTRB(size.width / 2, 0, size.width, size.height))
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;
    Paint invertedPaintStart = Paint()
      ..shader = invertedGradient.createShader(Rect.fromLTRB(size.width / 2, 0, size.width, size.height))
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    Offset start = orientation == ForceOrientation.leftToRight ? Offset(0, 0) : Offset(size.width, 0);
    Offset end = orientation == ForceOrientation.leftToRight
        ? Offset(value * size.width / max, 0).translate(10, 0)
        : Offset(size.width, 0).translate(-(value * size.width / max), 0).translate(-10, 0);
    canvas.drawLine(
        start,
        end.translate(orientation == ForceOrientation.leftToRight ? barTranslationX : -barTranslationX, 0),
        orientation == ForceOrientation.leftToRight ? paint : invertedPaint);

    Offset startOffset = orientation == ForceOrientation.leftToRight ? Offset(0, 0) : Offset(size.width, 0);
    canvas.drawLine(
        startOffset, startOffset, orientation == ForceOrientation.leftToRight ? paintStart : invertedPaintStart);

    Paint circleForegroundPaint = Paint()
      ..color = _lerpGradient(colors, stops, value)
      ..style = PaintingStyle.fill;

    Paint circleBackgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(end, 10, circleBackgroundPaint);
    canvas.drawCircle(end, 8, circleForegroundPaint);

    TextSpan span = new TextSpan(text: "${((value / max) * 100).toInt()}%");
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(
        canvas,
        orientation == ForceOrientation.leftToRight
            ? end.translate(2 * barTranslationX + 5, -8)
            : end.translate(-tp.width - 2 * barTranslationX - 5, -8));
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
