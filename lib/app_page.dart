import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:upgrader/upgrader.dart';
import 'package:v34/commons/feature_tour.dart';
import 'package:v34/commons/show_dialog.dart';
import 'package:v34/menu.dart';
import 'package:v34/message_cubit.dart';
import 'package:v34/pages/club/club_page.dart';
import 'package:v34/pages/competition/competition_page.dart';
import 'package:v34/pages/dashboard/dashoard_page.dart';
import 'package:v34/pages/gymnasium/gymnasium_page.dart';

const String MAIN_DASHBOARD = "main_dashboard";
const String MAIN_COMPETITION = "main_competition";
const String MAIN_CLUBS = "main_clubs";
const String MAIN_GYMNASIUMS = "main_gymnasiums";

class AppPage extends StatefulWidget {
  @override
  _AppPageState createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  Widget? _child;

  @override
  void initState() {
    _child = DashboardPage();
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppMenu(),
      backgroundColor: Theme.of(context).canvasColor,
      extendBody: true,
      body: UpgradeAlert(
        debugLogging: true,
        showIgnore: false,
        child: BlocListener<MessageCubit, MessageState>(
          listener: (BuildContext context, state) {
            if (state is NewMessage) {
              showAlertDialog(
                context,
                state.title,
                state.message,
                onPressed: (context) {
                  BlocProvider.of<MessageCubit>(context).clearMessage();
                },
              );
            }
            if (state is NewHelp) {
              showHelpDialog(
                context,
                state.title,
                state.paragraphs,
                onPressed: () {
                  BlocProvider.of<MessageCubit>(context).clearMessage();
                },
              );
            }
            if (state is SnackMessage) {
              print("XXXXXXXXXXXXXXXXXXXXXXXXXX");
              final snackBar = SnackBar(
                content: Text(state.text),
                duration: state.duration ?? Duration(milliseconds: 4000),
                action: state.canClose
                    ? SnackBarAction(
                        label: "Fermer",
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      )
                    : null,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: _child,
        ),
      ),
      bottomNavigationBar: FluidNavBar(
        icons: [
          FluidNavBarIcon(svgPath: "assets/dashboard.svg", extras: {
            "featureId": "dashboard_feature_id",
            "title": "Tableau de bord",
            "paragraphs": [
              "Votre club et votre équipe favorite toujours à portée.",
              "Retrouvez votre agenda, des statistiques et l'ensemble des informations utiles au jour le jour."
            ],
          }),
          FluidNavBarIcon(svgPath: "assets/competition-filled.svg", extras: {
            "featureId": "competition_feature_id",
            "title": "Compétitions",
            "paragraphs": [
              "Championnats, Challenges et Coupe de printemps.",
              "L'ensemble des résultats, classements par catégorie, poule et type de compétition."
            ],
          }),
          FluidNavBarIcon(svgPath: "assets/shield.svg", extras: {
            "featureId": "clubs_feature_id",
            "title": "Liste des clubs",
            "paragraphs": [
              "Accédez à l'ensemble des clubs inscrits aux compétitions.",
            ],
          }),
          FluidNavBarIcon(svgPath: "assets/gymnasium.svg", extras: {
            "featureId": "gymnasiums_feature_id",
            "title": "Liste des gymnases",
            "paragraphs": [
              "Trouvez les Horaires, téléphone ou itinéraire pour aller à un gymnase ou celui le plus près de chez vous."
            ],
          }),
        ],
        style: FluidNavBarStyle(
          barBackgroundColor: Theme.of(context).bottomAppBarColor,
          iconSelectedForegroundColor: Theme.of(context).canvasColor,
          iconUnselectedForegroundColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
        ),
        scaleFactor: 1.4,
        onChange: _handleNavigationChange,
        itemBuilder: (icon, item) {
          return FeatureTour(
            child: item,
            featureId: icon.extras!["featureId"],
            title: icon.extras!["title"],
            paragraphs: icon.extras!["paragraphs"] ?? [],
            target: SvgPicture.asset(
              icon.svgPath!,
              height: 30,
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
          );
        },
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
          _child = ClubPage();
          break;
        case 3:
          _child = GymnasiumPage();
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
