import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

extension Extension on String? {
  bool isNullOrEmpty() => this == null || this!.trim() == '';

  bool isNotNullAndNotEmpty() => this != null && this!.trim() != '';

  String? capitalize() {
    if (this != null) {
      return "${this![0].toUpperCase()}${this!.substring(1)}";
    } else {
      return null;
    }
  }

  String? snakeCase() {
    return this?.toLowerCase().replaceAll(" ", "_").replaceAll("-", "");
  }
}

extension TinyColorExtension on Color {
  Color tiny(int amount) {
    return TinyColor(this).isDark() ? TinyColor(this).lighten(amount).color : TinyColor(this).darken(amount).color;
  }

  Color smallTiny() => this.tiny(3);
}

extension CustomCardTheme on CardTheme {
  Color titleBackgroundColor(BuildContext context) {
    return TinyColor(Theme.of(context).cardTheme.color!).isDark()
        ? TinyColor(Theme.of(context).cardTheme.color!).lighten(3).color
        : Theme.of(context).cardTheme.color!;
  }
}

extension HexColor on Color {
  String toHexWithoutAlpha({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
