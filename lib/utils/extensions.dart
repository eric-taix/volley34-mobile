

import 'dart:ui';

import 'package:tinycolor/tinycolor.dart';

extension Extension on String {
  bool isNullOrEmpty() => this == null || this.trim() == '';

  bool isNotNullAndNotEmpty() => this != null && this.trim() != '';
}

extension TinyColorExtension on Color {

  Color tiny(int amount) {
    return TinyColor(this).isDark()
        ? TinyColor(this).lighten(amount).color
        : TinyColor(this).darken(amount).color;
  }

  Color smallTiny() => this.tiny(3);
}