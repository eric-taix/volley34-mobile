import 'dart:math';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
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

// Dans votre classe MapMarker, remplacez l'ancienne méthode utilisant DrawableRoot par:
  Future<BitmapDescriptor> get bitmapDescriptor async {
    // Créer un PictureRecorder pour dessiner dans un canvas
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Dimensions du canvas
    final double width = size;
    final double height = size + pinLength;

    // Dessiner le cercle de fond
    final Paint backgroundPaint = Paint()..color = backgroundColor;
    final Paint borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final double circleRadius = size / 2 - borderWidth / 2;
    final Offset center = Offset(width / 2, size / 2);

    // Dessiner le cercle
    canvas.drawCircle(center, circleRadius, backgroundPaint);
    canvas.drawCircle(center, circleRadius, borderPaint);

    // Dessiner la pointe du marqueur
    final Path pinPath = Path()
      ..moveTo(width / 2 - pinLength / 2, size - borderWidth / 2)
      ..lineTo(width / 2, height - borderWidth / 2)
      ..lineTo(width / 2 + pinLength / 2, size - borderWidth / 2)
      ..close();

    canvas.drawPath(pinPath, backgroundPaint);
    canvas.drawPath(
      pinPath,
      borderPaint..style = PaintingStyle.stroke,
    );

    // Si vous avez une icône SVG à l'intérieur
    /*if (iconPath != null) {
    final ByteData data = await rootBundle.load(iconPath!);
    final PictureInfo pictureInfo = await vg.loadPicture(
      SvgBytesLoader(data.buffer.asUint8List()),
      null
    );

    // Calculer les dimensions de l'icône
    final double iconSize = size * 0.5;
    final Rect iconRect = Rect.fromCenter(
      center: center,
      width: iconSize,
      height: iconSize,
    );

    // Dessiner l'icône
    canvas.save();
    canvas.clipRect(iconRect);
    canvas.translate(
      iconRect.left + iconRect.width / 2 - pictureInfo.size.width / 2,
      iconRect.top + iconRect.height / 2 - pictureInfo.size.height / 2,
    );
    canvas.scale(
      iconRect.width / pictureInfo.size.width,
      iconRect.height / pictureInfo.size.height,
    );

    pictureInfo.picture.toImage(
      pictureInfo.size.width.toInt(),
      pictureInfo.size.height.toInt(),
    ).then((ui.Image image) {
      canvas.drawImage(image, Offset.zero, Paint());
    });

    canvas.restore();
  }*/

    // Convertir en image
    final ui.Image image = await pictureRecorder.endRecording().toImage(
          width.toInt(),
          height.toInt(),
        );

    // Convertir l'image en bytes
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }
  /*_paintImage(Canvas canvas) async {
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
  }*/
}

class ImageMarkerProxy extends material.StatelessWidget {
  @override
  material.Widget build(material.BuildContext context) {
    throw UnimplementedError();
  }
}
