import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarker {
  final Color borderColor;
  final double borderWidth;
  final Color backgroundColor;
  final double size;
  final double pinLength;
  final String? imageAsset;

  late Point center;
  late int shadowPadding;
  late double elevation = 4;
  late double borderRadius;
  late double backgroundRadius;

  MapMarker(
      {this.imageAsset,
      required this.size,
      this.borderWidth = 10,
      this.borderColor = material.Colors.white,
      this.backgroundColor = material.Colors.white,
      this.pinLength = 20}) {
    shadowPadding = 30;
    center = Point((size / 2) + shadowPadding, (size / 2) + shadowPadding);
    borderRadius = size / 2;
    backgroundRadius = borderRadius - borderWidth * 2;
  }

  Future<BitmapDescriptor> get bitmapDescriptor async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    _paintElevation(canvas);
    _paintBorder(canvas);
    _paintBackground(canvas);
    await _paintImage(canvas);

    final recordedImage = await pictureRecorder.endRecording().toImage(
          size.toInt() + shadowPadding * 2,
          size.toInt() + pinLength.toInt() + shadowPadding * 2,
        );
    final data = await recordedImage.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  _paintElevation(Canvas canvas) {
    Path shadowPath = Path()
      ..fillType = PathFillType.nonZero
      ..addArc(
        Rect.fromCenter(
          center: Offset(center.x + elevation * 2, center.y + elevation * 2),
          width: size,
          height: size,
        ),
        pi / 2 + pi / 10,
        pi * 2 - 2 * pi / 10,
      )
      ..lineTo(center.x + elevation * 2, center.y + (size / 2) + pinLength + elevation * 2)
      ..close();

    canvas.drawPath(
      shadowPath,
      Paint()
        ..shader = material.LinearGradient(
          begin: material.Alignment.topLeft,
          end: material.Alignment.bottomRight,
          colors: [
            material.Colors.black26,
            material.Colors.transparent,
          ],
          stops: [0.7, 1.0],
        ).createShader(Rect.fromCircle(
          center: Offset(center.x + elevation, center.y + elevation),
          radius: borderRadius,
        )),
    );
    //..color = material.Colors.black
    //..strokeWidth = 1
    //..style = PaintingStyle.fill
  }

  _paintBorder(Canvas canvas) {
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = 1
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..fillType = PathFillType.nonZero
      ..addArc(
        Rect.fromCenter(
          center: Offset(center.x.toDouble(), center.y.toDouble()),
          width: size,
          height: size,
        ),
        pi / 2 + pi / 10,
        pi * 2 - 2 * pi / 10,
      )
      ..lineTo(center.x.toDouble(), center.y + (size / 2) + pinLength)
      ..close();

    canvas.drawPath(path, borderPaint);
  }

  _paintBackground(Canvas canvas) {
    final Paint backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawCircle(
      Offset(center.x.toDouble(), center.y.toDouble()),
      backgroundRadius,
      backgroundPaint,
    );
  }

  _paintImage(Canvas canvas) async {
    if (imageAsset != null) {
      ByteData byteData = await rootBundle.load(imageAsset!);
      DrawableRoot drawableRoot = await svg.fromSvgBytes(byteData.buffer.asUint8List(), "");
      double imageSize = ((backgroundRadius * 2) / sqrt(2)) - 4;
      Image image = await drawableRoot
          .toPicture(
            size: Size(imageSize, imageSize),
            colorFilter: ColorFilter.mode(borderColor, BlendMode.srcATop),
          )
          .toImage(size.toInt(), size.toInt());
      canvas.drawImage(
        image,
        Offset(center.x - imageSize / 2, center.y - imageSize / 2),
        Paint()..color = borderColor,
      );
    }
  }
}

class ImageMarkerProxy extends material.StatelessWidget {
  @override
  material.Widget build(material.BuildContext context) {
    throw UnimplementedError();
  }
}
