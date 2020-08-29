import 'dart:ui';

import 'package:flutter/material.dart';
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

extension CustomCardTheme on CardTheme {
  Color titleBackgroundColor(BuildContext context) {
    return TinyColor(Theme.of(context).cardTheme.color).isDark()
        ? TinyColor(Theme.of(context).cardTheme.color).lighten(3).color
        :	TinyColor(Theme.of(context).cardTheme.color).darken(3).color;
  }
}

extension HexColor on Color {
  String toHexWithoutAlpha({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}