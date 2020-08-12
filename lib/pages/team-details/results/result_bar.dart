import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultBar extends StatelessWidget {
  final MinMax minMax;
  final int diffValue;
  final bool isHost;
  final double kHeight = 8;

  const ResultBar(
      {@required this.minMax, @required this.diffValue, @required this.isHost});

  @override
  Widget build(BuildContext context) {
    int max =
        (minMax.min.abs() > minMax.max.abs() ? minMax.min : minMax.max).abs();
    return Center(
      child: CustomPaint(
        painter: _BarPainter(
            color: Theme.of(context).textTheme.caption.color,
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
  final Color color;

  _BarPainter({
    @required this.color,
    @required this.widthOffset,
    @required this.height,
    @required this.isHost,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double offset = isHost ? widthOffset : -widthOffset;
    Paint roundedLinePaint = Paint()
      ..color = (offset > 0 ? Colors.green : Colors.red)
      ..strokeWidth = height
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    Paint verticalLine = Paint()
      ..color = color
      ..strokeWidth = height / 2
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;
    if (offset > 0) {
      canvas.drawLine(
          Offset(size.width / 2 + (height / 2), height / 4),
          Offset(size.width / 2 + ((size.width / 2) * offset), height / 4),
          roundedLinePaint);
    } else {
      canvas.drawLine(
          Offset(size.width / 2 + ((size.width / 2) * offset), height / 4),
          Offset((size.width) / 2 - (height / 2), height / 4),
          roundedLinePaint);
    }
    canvas.drawLine(
        Offset(size.width / 2, -5), Offset(size.width / 2, 10), verticalLine);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
