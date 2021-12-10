import 'package:flutter/material.dart';

import 'commons/text_tab_bar.dart';

const double CARD_BORDER_RADIUS = 18.0;

const Color _mainColor = Color(0xFFC9334F);

class AppTheme {
  static ThemeData darkTheme() {
    return ThemeData(
      splashColor: _mainColor.withOpacity(0.2),
      canvasColor: Color(0xFF262C41),
      scaffoldBackgroundColor: Color(0xFF262C41),
      highlightColor: Colors.transparent,
      primarySwatch: MaterialColor(
        _mainColor.value,
        <int, Color>{
          50: Color(0xFFE3F2FD),
          100: Color(0xFFBBDEFB),
          200: Color(0xFF90CAF9),
          300: Color(0xFF64B5F6),
          400: Color(0xFF42A5F5),
          500: _mainColor,
          600: Color(0xFF1E88E5),
          700: Color(0xFF1976D2),
          800: Color(0xFF1565C0),
          900: Color(0xFF0D47A1),
        },
      ),
      colorScheme: ColorScheme(
        primary: Color(0xFF262C41),
        primaryVariant: Color(0xFF313852),
        secondary: _mainColor,
        secondaryVariant: _mainColor.withOpacity(0.7),
        surface: Color(0xFF262C41),
        background: Color(0xFF262C41),
        error: _mainColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
      primaryColor: Color(0xFF262C41),
      bottomAppBarColor: Color(0xFFF7FBFE),
      cardTheme: CardTheme(
        color: Color(0xFF313852),
        margin: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 0),
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(CARD_BORDER_RADIUS)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF373E5D),
        titleTextStyle: TextStyle(
          color: Color(0xFFF7FBFE),
          fontSize: 22.0,
          fontFamily: "Raleway",
          fontWeight: FontWeight.w600,
        ),
        toolbarTextStyle: TextStyle(
          color: Color(0xFF979DB2),
          fontSize: 12.0,
          fontFamily: "Raleway",
        ),
      ),
      textTheme: TextTheme(
        button:
            TextStyle(color: Color(0xFFF7FBFE), fontSize: 14.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
        headline1:
            TextStyle(color: Color(0xFFF7FBFE), fontSize: 16.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
        headline4:
            TextStyle(color: Color(0xFFF7FBFE), fontSize: 20.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
        headline5:
            TextStyle(color: Color(0xFF979DB2), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
        headline6:
            TextStyle(color: Color(0xFF979DB2), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
        subtitle1:
            TextStyle(color: Color(0xFFF7FBFE), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.bold),
        subtitle2:
            TextStyle(color: Color(0xFFF7FBFE), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.bold),
        bodyText2:
            TextStyle(color: Color(0xFFF7FBFE), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w400),
        bodyText1:
            TextStyle(color: Color(0xFF979DB2), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w400),
        caption: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Raleway", fontWeight: FontWeight.w400),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Color(0xFFF7FBFE),
        unselectedLabelColor: Color(0xFF7E88A2),
        labelPadding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 10.0),
        labelStyle: TextStyle(fontSize: 15.0, fontFamily: "Raleway"),
        unselectedLabelStyle: TextStyle(fontSize: 15.0, fontFamily: "Raleway"),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: DashedUnderlineIndicator(
          width: 30.0,
          dashSpace: 0,
          borderSide: BorderSide(width: 6.0, color: _mainColor),
          insets: EdgeInsets.only(
            left: 30.0,
            right: 30,
          ),
        ),
      ),
      buttonBarTheme: ButtonBarThemeData(
        buttonPadding: EdgeInsets.all(0.0),
      ),
      buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF373E5D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(
              color: Colors.transparent,
            ),
          ),
          textTheme: ButtonTextTheme.accent),
      dialogTheme: DialogTheme(
        backgroundColor: Color(0xFF262C41),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontFamily: "Raleway"),
        contentTextStyle:
            TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white70, fontFamily: "Raleway"),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          overlayColor: OverlayStateColor(Colors.white.withOpacity(0.2)),
          shape: ButtonStateProperty(color: Colors.transparent),
          foregroundColor: ButtonForegroundStateColor(),
          backgroundColor: ButtonBackgroundStateColor(color: _mainColor),
          padding: ButtonPaddingProperty(),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        splashColor: Colors.white.withOpacity(0.2),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          overlayColor: OverlayStateColor(_mainColor.withOpacity(0.2)),
          shape: ButtonStateProperty(color: Colors.transparent),
          foregroundColor: ButtonForegroundStateColor(color: _mainColor),
          padding: ButtonPaddingProperty(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          overlayColor: OverlayStateColor(_mainColor.withOpacity(0.2)),
          shape: ButtonStateProperty(),
          padding: ButtonPaddingProperty(),
        ),
      ),
      dividerTheme: DividerThemeData(thickness: 0.3),
      switchTheme: SwitchThemeData(
        trackColor: MultiStateColor(
          disabledColor: Colors.grey,
          selectedColor: Colors.white,
          defaultColor: Colors.white24,
        ),
        thumbColor: MultiStateColor(
          disabledColor: Colors.grey,
          selectedColor: _mainColor,
          defaultColor: Colors.white,
        ),
      ),
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
        canvasColor: Colors.white, //(0xfff3f5ff),
        scaffoldBackgroundColor: Color(0xfff3f5ff),
        highlightColor: Colors.transparent,
        primarySwatch: Colors.blue,
        primaryColor: Color(0xfff3f5ff),
        bottomAppBarColor: Color(0xff44485d),
        cardTheme: CardTheme(
          color: Color(0xffeceef8),
          margin: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 0),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xffa1a5bf),
          titleTextStyle: TextStyle(
            color: Color(0xff080401),
            fontSize: 22.0,
            fontFamily: "Raleway",
            fontWeight: FontWeight.w600,
          ),
          toolbarTextStyle: TextStyle(
            color: Color(0xff4c4f59),
            fontSize: 12.0,
            fontFamily: "Raleway",
          ),
        ),
        textTheme: TextTheme(
          button:
              TextStyle(color: Color(0xff020202), fontSize: 14.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
          headline1:
              TextStyle(color: Color(0xff020202), fontSize: 16.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
          headline4:
              TextStyle(color: Color(0xff020202), fontSize: 20.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
          headline5:
              TextStyle(color: Color(0xff8c8f99), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
          headline6:
              TextStyle(color: Color(0xff8c8f99), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
          subtitle1:
              TextStyle(color: Color(0xff020202), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.bold),
          subtitle2:
              TextStyle(color: Color(0xff020202), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.bold),
          bodyText2:
              TextStyle(color: Color(0xff020202), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w400),
          bodyText1:
              TextStyle(color: Color(0xff8c8f99), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w400),
          caption: TextStyle(color: Color(0xff8c8f99), fontSize: 16, fontFamily: "Raleway"),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Color(0xff080401),
          unselectedLabelColor: Color(0xffacb0c6),
          labelPadding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 10.0),
          labelStyle: TextStyle(fontSize: 15.0, fontFamily: "Raleway"),
          unselectedLabelStyle: TextStyle(fontSize: 15.0, fontFamily: "Raleway"),
          indicatorSize: TabBarIndicatorSize.label,
          indicator: DashedUnderlineIndicator(
            width: 30.0,
            dashSpace: 0,
            borderSide: BorderSide(width: 6.0, color: _mainColor),
            insets: EdgeInsets.only(
              left: 30.0,
              right: 30,
            ),
          ),
        ),
        buttonBarTheme: ButtonBarThemeData(
          buttonPadding: EdgeInsets.all(0.0),
        ),
        buttonTheme: ButtonThemeData(
            buttonColor: Color(0xffe2e5f3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(
                color: Colors.transparent,
              ),
            ),
            textTheme: ButtonTextTheme.accent));
  }

  static ThemeData getNormalThemeFromPreferences(bool isAutomatic, bool isDark) {
    if (isAutomatic)
      return lightTheme();
    else
      return isDark ? darkTheme() : lightTheme();
  }

  static ThemeData? getDarkThemeFromPreferences(bool isAutomatic) {
    return isAutomatic ? darkTheme() : null;
  }
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

class ButtonBackgroundStateColor extends MaterialStateColor {
  final Color? color;
  static const int _defaultColor = 0xFFC9334F;

  const ButtonBackgroundStateColor({this.color}) : super(_defaultColor);

  @override
  Color resolve(Set<MaterialState> states) =>
      states.contains(MaterialState.disabled) ? Color(0xff3c404d) : color ?? Color(_defaultColor);
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
