import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultBar extends StatelessWidget {
  final MinMax minMax;
  final int diffValue;
  final bool isHost;
  final double kHeight = 8;

  const ResultBar({required this.minMax, required this.diffValue, required this.isHost});

  @override
  Widget build(BuildContext context) {
    int max = (minMax.min.abs() > minMax.max.abs() ? minMax.min : minMax.max).abs();
    return Center(
      child: CustomPaint(
        painter: _BarPainter(
            color: Theme.of(context).textTheme.bodyText1!.color,
            widthOffset: diffValue / max,
            height: kHeight,
            isHost: isHost),
        child: Container(),
      ),
    );
  }
}

class MinMax {
  final int min;
  final int max;

  MinMax(this.min, this.max);
}

class _BarPainter extends CustomPainter {
  final double widthOffset;
  final double height;
  final bool isHost;
  final Color? color;

  _BarPainter({
    required this.color,
    required this.widthOffset,
    required this.height,
    required this.isHost,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double offset = isHost ? widthOffset : -widthOffset;
    Paint verticalLine = Paint()
      ..color = color!
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;
    if (offset > 0) {
      final linePath = Path()
        ..moveTo(size.width / 2 + (height / 2), height / 4)
        ..lineTo(size.width / 2 + ((size.width / 2) * offset), height / 4);

      final colors = [Colors.lightBlueAccent, Colors.blue, Colors.green];
      final stops = [0.0, 0.4, 0.8];
      final gradient = LinearGradient(colors: colors, stops: stops);
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromLTRB(size.width / 2, 0, size.width, size.height))
        ..strokeWidth = height
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(linePath, paint);
    } else {
      final linePath = Path()
        ..moveTo(size.width / 2 + ((size.width / 2) * offset), height / 4)
        ..lineTo((size.width) / 2 - (height / 2), height / 4);

      final colors = [
        Colors.red,
        Colors.orange,
        Colors.yellow,
      ];

      final stops = [0.2, 0.6, 1.0];
      final gradient = LinearGradient(colors: colors, stops: stops);
      final paint = Paint()
        ..shader = gradient.createShader(Rect.fromLTRB(0, 0, size.width / 2, size.height))
        ..strokeWidth = height
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawPath(linePath, paint);
    }
    canvas.drawLine(Offset(size.width / 2, -5), Offset(size.width / 2, 10), verticalLine);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
