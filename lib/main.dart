import 'package:bloc/bloc.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:v34/commons/blocs/logging_bloc.dart';
import 'package:v34/commons/env.dart';
import 'package:v34/pages/competition/competition_page.dart';
import 'package:v34/pages/dashboard/dashoard_page.dart';
import 'package:v34/pages/find/find_page.dart';
import 'package:v34/repositories/providers/agenda_provider.dart';
import 'package:v34/repositories/providers/club_provider.dart';
import 'package:v34/repositories/providers/favorite_provider.dart';
import 'package:v34/repositories/providers/team_provider.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/theme.dart';

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
      theme: AppTheme.theme(),
      home: RepositoryProvider(
        create: (context) => Repository(
          clubProvider: ClubProvider(),
          favoriteProvider: FavoriteProvider(),
          teamProvider: TeamProvider(),
          agendaProvider: AgendaProvider(),
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
    initializeDateFormatting();
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
          iconUnselectedForegroundColor:
              Theme.of(context).tabBarTheme.unselectedLabelColor,
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
