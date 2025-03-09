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

class OverlayStateColor extends WidgetStateColor {
  static const int _defaultColor = 0x50FFFFFF;

  final Color? color;

  OverlayStateColor(this.color) : super(_defaultColor);

  @override
  Color resolve(Set<WidgetState> states) =>
      states.contains(WidgetState.disabled) ? Colors.transparent : color ?? Color(_defaultColor);
}

class ButtonForegroundStateColor extends WidgetStateColor {
  static const int _defaultColor = 0xFFFFFFFF;

  final Color? color;

  const ButtonForegroundStateColor({this.color}) : super(_defaultColor);

  @override
  Color resolve(Set<WidgetState> states) =>
      states.contains(WidgetState.disabled) ? Colors.white30 : color ?? Color(_defaultColor);
}

class MultiStateColor extends WidgetStateColor {
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
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return disabledColor;
    }
    if (states.contains(WidgetState.selected)) {
      return selectedColor;
    }
    return defaultColor;
  }
}

class ButtonTextStyleState extends WidgetStateProperty<TextStyle> {
  final TextStyle disabledStyle;
  final TextStyle enabledStyle;
  ButtonTextStyleState({required this.enabledStyle, required this.disabledStyle});

  @override
  TextStyle resolve(Set<WidgetState> states) =>
      states.contains(WidgetState.disabled) ? disabledStyle : enabledStyle;
}

class ButtonBackgroundStateColor extends WidgetStateColor {
  final Color? color;
  static const int _defaultColor = 0xFFC9334F;

  const ButtonBackgroundStateColor({this.color}) : super(_defaultColor);

  @override
  Color resolve(Set<WidgetState> states) =>
      states.contains(WidgetState.disabled) ? Colors.grey : color ?? Color(_defaultColor);
}

class ButtonStateProperty extends WidgetStateProperty<OutlinedBorder> {
  final Color? color;
  final Color? disableColor;

  ButtonStateProperty({this.color, this.disableColor});

  @override
  OutlinedBorder resolve(Set<WidgetState> states) => states.contains(WidgetState.disabled)
      ? RoundedRectangleBorder(
          side: BorderSide(color: disableColor ?? Color(0xff3c404d), width: 2),
          borderRadius: BorderRadius.circular(80.0),
        )
      : RoundedRectangleBorder(
          side: BorderSide(color: color ?? Color(0xff3c404d), width: 2),
          borderRadius: BorderRadius.circular(80.0),
        );
}

class ButtonPaddingProperty extends WidgetStateProperty<EdgeInsetsGeometry> {
  @override
  EdgeInsetsGeometry resolve(Set<WidgetState> states) {
    return EdgeInsets.symmetric(horizontal: 18);
  }
}
