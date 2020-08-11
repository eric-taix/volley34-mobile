import 'package:flutter/material.dart';

import 'commons/text_tab_bar.dart';

class AppTheme {
  static ThemeData darkTheme() {
    return ThemeData(
      highlightColor: Colors.transparent,
      primarySwatch: Colors.blue,
      accentColor: Color(0xFF979DB2),
      primaryColor: Color(0xFF262C41),
      bottomAppBarColor: Color(0xFFF7FBFE),
      buttonColor: Color(0xFF373E5D),
      cardTheme: CardTheme(
        color: Color(0xFF313852),
        margin: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 0),
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
      appBarTheme: AppBarTheme(
        color: Color(0xFF373E5D),
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Color(0xFFF7FBFE),
            fontSize: 22.0,
            fontFamily: "Raleway",
            fontWeight: FontWeight.w600,
          ),
          subtitle2: TextStyle(
            color: Color(0xFF979DB2),
            fontSize: 12.0,
            fontFamily: "Raleway",
          ),
          button: TextStyle(
            color: Color(0xFFF7FBFE),
            fontSize: 17.0,
            fontFamily: "Raleway",
          ),
        ),
      ),
      textTheme: TextTheme(
        button: TextStyle(color: Color(0xFFF7FBFE), fontSize: 14.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
        headline4: TextStyle(color: Color(0xFFF7FBFE), fontSize: 20.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
        headline5: TextStyle(color: Color(0xFF979DB2), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
        headline6: TextStyle(color: Color(0xFF979DB2), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
        subtitle1: TextStyle(color: Color(0xFFF7FBFE), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.bold),
        subtitle2: TextStyle(color: Color(0xFFF7FBFE), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.bold),
        bodyText2: TextStyle(color: Color(0xFFF7FBFE), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w400),
        bodyText1: TextStyle(color: Color(0xFF979DB2), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w400),
        caption: TextStyle(color: Color(0xFF979DB2), fontSize: 16, fontFamily: "Raleway"),
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
          borderSide: BorderSide(width: 6.0, color: Color(0xFF7E88A2)),
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
    );
  }

  static ThemeData lightTheme() {
    return ThemeData(
        highlightColor: Colors.transparent,
        primarySwatch: Colors.blue,
        accentColor: Color(0xff4c4f59),
        primaryColor: Color(0xfff3f5ff),
        bottomAppBarColor: Color(0xffe2e5f3),
        cardTheme: CardTheme(
          color: Color(0xffeceef8),
          margin: EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 0),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xffe2e5f3),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Color(0xff080401),
              fontSize: 22.0,
              fontFamily: "Raleway",
              fontWeight: FontWeight.w600,
            ),
            subtitle2: TextStyle(
              color: Color(0xff4c4f59),
              fontSize: 12.0,
              fontFamily: "Raleway",
            ),
            button: TextStyle(
              color: Color(0xff080401),
              fontSize: 17.0,
              fontFamily: "Raleway",
            ),
          ),
        ),
        textTheme: TextTheme(
          button: TextStyle(color: Color(0xff020202), fontSize: 14.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
          headline4: TextStyle(color: Color(0xff020202), fontSize: 20.0, fontFamily: "Raleway", fontWeight: FontWeight.normal),
          headline5: TextStyle(color: Color(0xff8c8f99), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
          headline6: TextStyle(color: Color(0xff8c8f99), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
          subtitle1: TextStyle(color: Color(0xff020202), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.bold),
          subtitle2: TextStyle(color: Color(0xff020202), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.bold),
          bodyText2: TextStyle(color: Color(0xff020202), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w400),
          bodyText1: TextStyle(color: Color(0xff8c8f99), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w400),
          caption: TextStyle(color: Color(0xff8c8f99), fontSize: 16, fontFamily: "Raleway"),
        ),
        tabBarTheme: TabBarTheme(
          labelColor: Color(0xff080401),
          unselectedLabelColor: Color(0xff4c4f59),
          labelPadding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 10.0),
          labelStyle: TextStyle(fontSize: 15.0, fontFamily: "Raleway"),
          unselectedLabelStyle: TextStyle(fontSize: 15.0, fontFamily: "Raleway"),
          indicatorSize: TabBarIndicatorSize.label,
          indicator: DashedUnderlineIndicator(
            width: 30.0,
            dashSpace: 0,
            borderSide: BorderSide(width: 6.0, color: Color(0xff3c404d)),
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
            textTheme: ButtonTextTheme.accent
        )
    );
  }

  static ThemeData getNormalThemeFromPreferences(bool isAutomatic, bool isDark) {
    if (isAutomatic) return lightTheme();
    else return isDark ? darkTheme() : lightTheme();
  }

  static ThemeData getDarkThemeFromPreferences(bool isAutomatic) {
    return isAutomatic ? darkTheme() : null;
  }

}
