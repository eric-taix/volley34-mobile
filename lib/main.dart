import 'package:bloc/bloc.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/blocs/logging_bloc.dart';
import 'package:v34/commons/env.dart';
import 'package:v34/commons/tab_bar.dart';
import 'package:v34/pages/competition/competition_page.dart';
import 'package:v34/pages/dashboard/dashoard_page.dart';
import 'package:v34/pages/find/find_page.dart';
import 'package:v34/repositories/providers/club_provider.dart';
import 'package:v34/repositories/providers/favorite_provider.dart';
import 'package:v34/repositories/providers/team_provider.dart';
import 'package:v34/repositories/repository.dart';

void main() {
  BlocSupervisor.delegate = LoggingBlocDelegate();
  runApp(V34());
}

class V34 extends StatefulWidget {
  @override
  _V34State createState() => _V34State();

  static String _pkg = "mobile";

  static String get pkg => Env.getPackage(_pkg);
}

class _V34State extends State<V34> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Volley34',
      theme: ThemeData(
        highlightColor: Colors.transparent,
        primarySwatch: Colors.blue,
        accentColor: Color(0xFF979DB2),
        primaryColor: Color(0xFF262C41),
        bottomAppBarColor: Color(0xFFF7FBFE),
        cardTheme: CardTheme(
          color: Color(0xFF313852),
          margin: EdgeInsets.all(8.0),
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
        ),
        textTheme: TextTheme(
          title: TextStyle(color: Color(0xFF979DB2), fontSize: 20, fontFamily: "Raleway", fontWeight: FontWeight.w300),
          body1: TextStyle(color: Color(0xFFF7FBFE), fontSize: 14, fontFamily: "Raleway", fontWeight: FontWeight.w400),
          body2: TextStyle(color: Color(0xFF979DB2), fontSize: 12, fontFamily: "Raleway", fontWeight: FontWeight.w400),
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
      home: RepositoryProvider(
        create: (context) => Repository(
          clubProvider: ClubProvider(),
          favoriteProvider: FavoriteProvider(),
          teamProvider: TeamProvider(),
        ),
        child: _MainPage(),
      ),
    );
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
          iconSelectedForegroundColor: Color(0xFF313852),
          iconUnselectedForegroundColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
        ),
        onChange: _handleNavigationChange,
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = DashboardPage();
          break;
        case 1:
          _child = CompetitionPage();
          break;
        case 2:
          _child = FindPage();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,
      );
    });
  }
}
