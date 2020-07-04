import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:bloc/bloc.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:v34/commons/blocs/logging_bloc.dart';
import 'package:v34/commons/env.dart';
import 'package:v34/commons/feature_tour.dart';
import 'package:v34/pages/club/club_page.dart';
import 'package:v34/pages/competition/competition_page.dart';
import 'package:v34/pages/dashboard/dashoard_page.dart';
import 'package:v34/repositories/providers/agenda_provider.dart';
import 'package:v34/repositories/providers/club_provider.dart';
import 'package:v34/repositories/providers/favorite_provider.dart';
import 'package:v34/repositories/providers/gymnasium_provider.dart';
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
    return RepositoryProvider(
      create: (context) => Repository(
        ClubProvider(),
        TeamProvider(),
        FavoriteProvider(),
        AgendaProvider(),
        GymnasiumProvider(),
      ),
      child: FeatureDiscovery(
        child: ThemeProvider(
          initTheme: AppTheme.lightTheme(),
          child: Builder(builder: (context) {
            return MaterialApp(
              title: 'Volley34',
              theme: ThemeProvider.of(context),
              home: _MainPage(),
            );
          }),
        ),
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
  Repository _repository;

  @override
  void initState() {
    super.initState();
    _child = DashboardPage();
    initializeDateFormatting();
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      _repository = RepositoryProvider.of<Repository>(context);
      _repository.loadFavoriteClubs().then((clubs) {
        if (clubs.isEmpty) {
          Future.delayed(Duration(seconds: 1)).then((_) {
            FeatureDiscovery.discoverFeatures(
              context,
              const <String>{"dashboard_feature_id", "competition_feature_id", "clubs_feature_id"},
            );
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          extendBody: true,
          body: _child,
          bottomNavigationBar: FluidNavBar(
            icons: [
              FluidNavBarIcon(iconPath: "assets/dashboard.svg", extras: {
                "featureId": "dashboard_feature_id",
                "title": "Tableau de bord",
                "paragraphs": [
                  "L'ensemble de vos clubs et équipes favorites toujours à portée.",
                  "Retrouvez votre agenda, des statistiques et l'ensemble des informations utiles au jour le jour."
                ],
              }),
              FluidNavBarIcon(iconPath: "assets/competition-filled.svg", extras: {
                "featureId": "competition_feature_id",
                "title": "Compétitions",
                "paragraphs": [
                  "Championnats, Challenges et Coupe de printemps.",
                  "L'ensemble des résultats, classements par catégorie, poule et type de compétition."
                ],
              }),
              FluidNavBarIcon(iconPath: "assets/shield.svg", extras: {
                "featureId": "clubs_feature_id",
                "title": "Liste des clubs",
                "paragraphs": [
                  "Accédez à l'ensemble des clubs inscrits aux compétitions.",
                  "Sélectionnez un ou plusieurs favoris, ainsi accédez rapidement depuis le tableau de bord à des informations importantes sur vos favoris."
                ],
              }),
            ],
            style: FluidNavBarStyle(
              barBackgroundColor: Theme.of(context).bottomAppBarColor,
              iconSelectedForegroundColor: Color(0xFF313852),
              iconUnselectedForegroundColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
            ),
            scaleFactor: 1.4,
            onChange: _handleNavigationChange,
            itemBuilder: (icon, item) {
              return FeatureTour(
                child: item,
                featureId: icon.extras["featureId"],
                title: icon.extras["title"],
                paragraphs: icon.extras["paragraphs"] ?? [],
                target: SvgPicture.asset(
                  icon.iconPath,
                  height: 30,
                  color: Theme.of(context).tabBarTheme.unselectedLabelColor,
                ),
              );
            },
          ),
        );
      })
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
          _child = ClubPage();
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
