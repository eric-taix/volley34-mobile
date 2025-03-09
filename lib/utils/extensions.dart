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
    return TinyColor.fromColor(this).isDark()
        ? TinyColor.fromColor(this).lighten(amount).color
        : TinyColor.fromColor(this).darken(amount).color;
  }

  Color smallTiny() => this.tiny(3);
}

extension CustomCardTheme on CardThemeData {
  Color titleBackgroundColor(BuildContext context) {
    return TinyColor.fromColor(Theme.of(context).cardTheme.color!).isDark()
        ? TinyColor.fromColor(Theme.of(context).cardTheme.color!).lighten(3).color
        : Theme.of(context).cardTheme.color!;
  }
}

extension HexColor on Color {
  String toHexWithoutAlpha({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${r.toInt().toRadixString(16).padLeft(2, '0')}'
      '${g.toInt().toRadixString(16).padLeft(2, '0')}'
      '${b.toInt().toRadixString(16).padLeft(2, '0')}';
}
