import 'package:flutter/material.dart';
import 'package:v34/commons/text_tab_bar.dart';
import 'package:v34/theme.dart';

ThemeData buildDarkTheme(Color mainColor) {
  return ThemeData(
    brightness: Brightness.dark,
    splashColor: mainColor.withValues(alpha: 0.2),
    primaryColor: Color(0xFF262C41),
    canvasColor: Color(0xFF262C41),
    scaffoldBackgroundColor: Color(0xFF262C41),
    highlightColor: Colors.transparent,
    primarySwatch: MaterialColor(
      mainColor.r.toInt()* 256 * 256 + mainColor.g.toInt() * 256 + mainColor.b.toInt(),
      <int, Color>{
        50: Color(0xFFE3F2FD),
        100: Color(0xFFBBDEFB),
        200: Color(0xFF90CAF9),
        300: Color(0xFF64B5F6),
        400: Color(0xFF42A5F5),
        500: mainColor,
        600: Color(0xFF1E88E5),
        700: Color(0xFF1976D2),
        800: Color(0xFF1565C0),
        900: Color(0xFF0D47A1),
      },
    ),
    colorScheme: ColorScheme(
      primary: Color(0xFF262C41),
      primaryContainer: Color(0xFF313852),
      secondary: mainColor,
      secondaryContainer: mainColor.withValues(alpha: 0.7),
      surface: Color(0xFF262C41),
      error: mainColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
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
    drawerTheme: DrawerThemeData(
      elevation: 0.0,
      backgroundColor: Color(0xFF262C41),
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: MultiStateColor(defaultColor: Colors.white, selectedColor: Colors.white, disabledColor: Colors.grey),
      fillColor: MultiStateColor(defaultColor: Colors.white, selectedColor: mainColor, disabledColor: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    textTheme: TextTheme(
      labelLarge:
          TextStyle(color: Color(0xFFF7FBFE), fontSize: 14.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
      displayLarge:
          TextStyle(color: Color(0xFFF7FBFE), fontSize: 16.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
      headlineMedium:
          TextStyle(color: Color(0xFFF7FBFE), fontSize: 20.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
      headlineSmall:
          TextStyle(color: Color(0xFF979DB2), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
      titleLarge: TextStyle(color: Color(0xFF979DB2), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
      titleMedium:
          TextStyle(color: Color(0xFFF7FBFE), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.bold),
      titleSmall: TextStyle(color: Color(0xFFF7FBFE), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(color: Color(0xFFF7FBFE), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(color: Color(0xFF979DB2), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w400),
      bodySmall: TextStyle(color: Colors.white, fontSize: 18, fontFamily: "Raleway", fontWeight: FontWeight.w500),
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
        borderSide: BorderSide(width: 6.0, color: mainColor),
        insets: EdgeInsets.only(
          left: 30.0,
          right: 30,
        ),
      ),
    ),
    buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFF373E5D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
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
        overlayColor: OverlayStateColor(Colors.white.withValues(alpha: 0.2)),
        shape: ButtonStateProperty(color: Colors.transparent),
        foregroundColor: ButtonForegroundStateColor(),
        backgroundColor: ButtonBackgroundStateColor(color: mainColor),
        padding: ButtonPaddingProperty(),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      splashColor: Colors.white.withValues(alpha: 0.2),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: ButtonTextStyleState(
          enabledStyle: TextStyle(fontSize: 16),
          disabledStyle: TextStyle(fontSize: 16),
        ),
        overlayColor: OverlayStateColor(mainColor.withValues(alpha: 0.2)),
        shape: ButtonStateProperty(color: Colors.transparent, disableColor: Colors.transparent),
        foregroundColor: ButtonForegroundStateColor(color: mainColor),
        padding: ButtonPaddingProperty(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        overlayColor: OverlayStateColor(mainColor.withValues(alpha: 0.2)),
        shape: ButtonStateProperty(),
        padding: ButtonPaddingProperty(),
      ),
    ),
    dividerTheme: DividerThemeData(thickness: 0.3, color: Color(0xFF979DB2)),
    switchTheme: SwitchThemeData(
      trackColor: MultiStateColor(
        disabledColor: Colors.grey,
        selectedColor: Colors.white,
        defaultColor: Colors.white24,
      ),
      thumbColor: MultiStateColor(
        disabledColor: Colors.grey,
        selectedColor: mainColor,
        defaultColor: Colors.white,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: MultiStateColor(defaultColor: Colors.white70, selectedColor: mainColor, disabledColor: Colors.white30),
    ),
    inputDecorationTheme: InputDecorationTheme(
      suffixStyle: TextStyle(color: Colors.black54),
      labelStyle: TextStyle(color: Colors.white70, fontSize: 18, fontFamily: "Raleway", fontWeight: FontWeight.normal),
      errorStyle: TextStyle(color: mainColor, fontSize: 14, height: 0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        borderSide: BorderSide(style: BorderStyle.solid, color: Colors.white54, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        borderSide: BorderSide(style: BorderStyle.solid, color: mainColor, width: 3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        borderSide: BorderSide(style: BorderStyle.solid, color: mainColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        borderSide: BorderSide(style: BorderStyle.solid, color: Colors.white10, width: 1),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        borderSide: BorderSide(style: BorderStyle.solid, color: Colors.white24, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(CARD_BORDER_RADIUS),
        borderSide: BorderSide(style: BorderStyle.solid, color: Colors.white, width: 1),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: mainColor,
      selectionColor: mainColor,
      selectionHandleColor: mainColor,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Color(0xFF373E5D),
      contentTextStyle: TextStyle(color: Color(0xFFF7FBFE), fontSize: 14),
      actionTextColor: mainColor,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
      ),
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFFF7FBFE)),
  );
}
