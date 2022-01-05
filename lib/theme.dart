import 'package:flutter/material.dart';
import 'package:v34/dark_theme.dart';
import 'package:v34/light_theme.dart';

const double CARD_BORDER_RADIUS = 18.0;
const Color test = Color(0xfff5f5f6);
const Color mainColor = Color(0xFFC9334F);

class AppTheme {
  static ThemeData darkTheme() => buildDarkTheme(mainColor);
  static ThemeData lightTheme() => buildLightTheme(mainColor);
}

class OverlayStateColor extends MaterialStateColor {
  static const int _defaultColor = 0x50FFFFFF;

  final Color? color;

  OverlayStateColor(this.color) : super(_defaultColor);

  @override
  Color resolve(Set<MaterialState> states) =>
      states.contains(MaterialState.disabled) ? Colors.transparent : color ?? Color(_defaultColor);
}

class ButtonForegroundStateColor extends MaterialStateColor {
  static const int _defaultColor = 0xFFFFFFFF;

  final Color? color;

  const ButtonForegroundStateColor({this.color}) : super(_defaultColor);

  @override
  Color resolve(Set<MaterialState> states) =>
      states.contains(MaterialState.disabled) ? Colors.white30 : color ?? Color(_defaultColor);
}

class MultiStateColor extends MaterialStateColor {
  static const int _defaultColor = 0xFFFFFFFF;

  final Color disabledColor;
  final Color selectedColor;
  final Color defaultColor;

  const MultiStateColor({
    required this.disabledColor,
    required this.selectedColor,
    required this.defaultColor,
  }) : super(_defaultColor);

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) {
      return disabledColor;
    }
    if (states.contains(MaterialState.selected)) {
      return selectedColor;
    }
    return defaultColor;
  }
}

class ButtonTextStyleState extends MaterialStateProperty<TextStyle> {
  final TextStyle disabledStyle;
  final TextStyle enabledStyle;
  ButtonTextStyleState({required this.enabledStyle, required this.disabledStyle});

  @override
  TextStyle resolve(Set<MaterialState> states) =>
      states.contains(MaterialState.disabled) ? disabledStyle : enabledStyle;
}

class ButtonBackgroundStateColor extends MaterialStateColor {
  final Color? color;
  static const int _defaultColor = 0xFFC9334F;

  const ButtonBackgroundStateColor({this.color}) : super(_defaultColor);

  @override
  Color resolve(Set<MaterialState> states) =>
      states.contains(MaterialState.disabled) ? Colors.grey : color ?? Color(_defaultColor);
}

class ButtonStateProperty extends MaterialStateProperty<OutlinedBorder> {
  final Color? color;
  final Color? disableColor;

  ButtonStateProperty({this.color, this.disableColor});

  @override
  OutlinedBorder resolve(Set<MaterialState> states) => states.contains(MaterialState.disabled)
      ? RoundedRectangleBorder(
          side: BorderSide(color: disableColor ?? Color(0xff3c404d), width: 2),
          borderRadius: BorderRadius.circular(80.0),
        )
      : RoundedRectangleBorder(
          side: BorderSide(color: color ?? Color(0xff3c404d), width: 2),
          borderRadius: BorderRadius.circular(80.0),
        );
}

class ButtonPaddingProperty extends MaterialStateProperty<EdgeInsetsGeometry> {
  @override
  EdgeInsetsGeometry resolve(Set<MaterialState> states) {
    return EdgeInsets.symmetric(horizontal: 18);
  }
}
