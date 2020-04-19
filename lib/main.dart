import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v34/commons/tab_bar.dart';
import 'package:v34/pages/competition/competition_page.dart';
import 'package:v34/pages/dashboard/dashoard_page.dart';
import 'package:v34/pages/find/find_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(V34());
}

class V34 extends StatefulWidget {
  @override
  _V34State createState() => _V34State();
}

class _V34State extends State<V34> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Volley34',
        theme: ThemeData(
          highlightColor: Colors.transparent,
          primarySwatch: Colors.blue,
          primaryColor: Color(0xFF262C41),
          bottomAppBarColor: Color(0xFF313852),
          textTheme: TextTheme(
            body1: TextStyle(color: Color(0xFFF7FBFE), fontFamily: "Raleway"),
            body2: TextStyle(color: Color(0xFF979DB2), fontSize: 12),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Color(0xFFF7FBFE),
            unselectedLabelColor: Color(0xFF7E88A2),
            labelPadding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 10.0),
            labelStyle: TextStyle(fontSize: 20.0, fontFamily: "Raleway"),
            unselectedLabelStyle: TextStyle(fontSize: 20.0, fontFamily: "Raleway"),
            indicatorSize: TabBarIndicatorSize.label,
            indicator: DashedUnderlineIndicator(
              width: 30.0,
              dashSpace: 0,
              borderSide: BorderSide(width: 6.0, color: Color(0xFFF7FBFE)),
              insets: EdgeInsets.symmetric(horizontal: 30.0),
            ),
          ),
        ),
        home: _MainPage());
  }
}

class _MainPage extends StatefulWidget {
  @override
  __MainPageState createState() => __MainPageState();
}

class __MainPageState extends State<_MainPage> {
  Widget _child;

  @override
  void initState() {
    super.initState();
    _child = DashboardPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      extendBody: true,
      body: _child,
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(iconPath: "assets/dashboard.svg"),
          FluidNavBarIcon(iconPath: "assets/competition-filled.svg"),
          FluidNavBarIcon(iconPath: "assets/map-filled.svg"),
        ],
        style: FluidNavBarStyle(
            barBackgroundColor: Theme.of(context).bottomAppBarColor,
            iconSelectedForegroundColor: Theme.of(context).tabBarTheme.labelColor,
            iconUnselectedForegroundColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
        ),
        onChange: _handleNavigationChange,
      ),
    );
  }

  void _handleNavigationChange(int index) {
    Widget widget;
    switch (index) {
      case 0:
        widget = DashboardPage();
        break;
      case 1:
        widget = CompetitionPage();
        break;
      case 2:
        widget = FindPage();
        break;
    }
    _child = AnimatedSwitcher(
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      duration: Duration(milliseconds: 500),
      child: widget,
    );
    setState(() {});
  }
}
