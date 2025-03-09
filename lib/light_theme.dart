import 'package:flutter/material.dart';
import 'package:v34/commons/text_tab_bar.dart';
import 'package:v34/theme.dart';

ThemeData buildLightTheme(Color mainColor) {
  return ThemeData(
    brightness: Brightness.light,
    splashColor: mainColor.withOpacity(0.2),
    primaryColor: Color(0xfff6f6f6),
    canvasColor: Color(0xfff6f6f6),
    scaffoldBackgroundColor: Color(0xfff6f6f6),
    highlightColor: Colors.transparent,
    primarySwatch: Colors.blue,
    colorScheme: ColorScheme(
      primary: Color(0xFF262C41),
      primaryContainer: Color(0xFF313852),
      secondary: mainColor,
      secondaryContainer: Colors.white,
      surface: Color(0xFF262C41),
      error: mainColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
    ),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 22.0,
        fontFamily: "Raleway",
        fontWeight: FontWeight.w600,
      ),
      toolbarTextStyle: TextStyle(
        color: Colors.white70,
        fontSize: 12.0,
        fontFamily: "Raleway",
      ),
    ),
    switchTheme: SwitchThemeData(
      trackColor: MultiStateColor(
        disabledColor: Colors.grey,
        selectedColor: Colors.grey,
        defaultColor: Colors.grey, //white,
      ),
      thumbColor: MultiStateColor(
        disabledColor: Colors.grey,
        selectedColor: mainColor,
        defaultColor: Colors.white,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MultiStateColor(defaultColor: Colors.black45, selectedColor: mainColor, disabledColor: Colors.white30),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xfff6f6f6),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: MultiStateColor(defaultColor: Colors.white, selectedColor: Colors.white, disabledColor: Colors.grey),
      fillColor: MultiStateColor(defaultColor: Colors.white, selectedColor: mainColor, disabledColor: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    textTheme: TextTheme(
      labelLarge:
          TextStyle(color: Color(0xff020202), fontSize: 14.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
      displayLarge:
          TextStyle(color: Color(0xff020202), fontSize: 16.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
      headlineMedium:
          TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
      headlineSmall:
          TextStyle(color: Color(0xff8c8f99), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
      titleLarge: TextStyle(color: Color(0xff5c5e65), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
      titleMedium: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.bold),
      titleSmall: TextStyle(color: Color(0xff020202), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: Color(0xff5e5e5e), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w400),
      bodySmall: TextStyle(color: Colors.black, fontSize: 16, fontFamily: "Raleway", fontWeight: FontWeight.bold),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: Colors.black,
      unselectedLabelColor: Color(0xff868686), //
      labelPadding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 10.0),
      labelStyle: TextStyle(fontSize: 15.0, fontFamily: "Raleway"),
      unselectedLabelStyle: TextStyle(fontSize: 15.0, fontFamily: "Raleway"),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: DashedUnderlineIndicator(
        width: 30.0,
        dashSpace: 0,
        borderSide: BorderSide(width: 6.0, color: mainColor),
        insets: EdgeInsets.only(
          left: 30.0,
          right: 30,
        ),
      ),
    ),
    buttonTheme: ButtonThemeData(
        buttonColor: Color(0xffe2e5f3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Colors.transparent,
          ),
        ),
        textTheme: ButtonTextTheme.accent),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        overlayColor: OverlayStateColor(Colors.white.withOpacity(0.2)),
        shape: ButtonStateProperty(color: Colors.transparent, disableColor: Colors.transparent),
        foregroundColor: ButtonForegroundStateColor(),
        backgroundColor: ButtonBackgroundStateColor(color: mainColor),
        padding: ButtonPaddingProperty(),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      splashColor: Colors.white.withOpacity(0.2),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: ButtonTextStyleState(
          enabledStyle: TextStyle(fontSize: 16),
          disabledStyle: TextStyle(fontSize: 16),
        ),
        overlayColor: OverlayStateColor(mainColor.withOpacity(0.2)),
        shape: ButtonStateProperty(color: Colors.transparent, disableColor: Colors.transparent),
        foregroundColor: ButtonForegroundStateColor(color: mainColor),
        padding: ButtonPaddingProperty(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        overlayColor: OverlayStateColor(mainColor.withOpacity(0.2)),
        shape: ButtonStateProperty(),
        padding: ButtonPaddingProperty(),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      suffixStyle: TextStyle(color: Colors.black54),
      labelStyle: TextStyle(color: Colors.black45, fontSize: 18, fontFamily: "Raleway", fontWeight: FontWeight.normal),
      errorStyle: TextStyle(color: Color(0xFFC73551), fontSize: 11, height: 0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        borderSide: BorderSide(style: BorderStyle.solid, color: Colors.white10, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        borderSide: BorderSide(style: BorderStyle.solid, color: Color(0xFFC73551), width: 3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        borderSide: BorderSide(style: BorderStyle.solid, color: Color(0xFFC73551), width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        borderSide: BorderSide(style: BorderStyle.solid, color: Colors.black12, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        borderSide: BorderSide(style: BorderStyle.solid, color: Colors.white24, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        borderSide: BorderSide(style: BorderStyle.solid, color: Colors.grey, width: 1),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: mainColor,
      selectionColor: mainColor,
      selectionHandleColor: mainColor,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.white,
      contentTextStyle: TextStyle(color: Colors.black, fontSize: 14),
      actionTextColor: mainColor,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFF313852)),
  );
}
