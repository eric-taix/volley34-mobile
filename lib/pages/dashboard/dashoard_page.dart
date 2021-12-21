import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/app_page.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_agenda.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_club_teams.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_clubs.dart';
import 'package:v34/pages/favorite/favorite_wizard.dart';
import 'package:v34/state_builder.dart';
import 'package:v34/utils/analytics.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with RouteAwareAnalytics {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<PreferencesBloc>(context).add(PreferencesLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreferencesBloc, PreferencesState>(
      listener: (_, state) {
        if (state is PreferencesUpdatedState && (state.favoriteClub == null || state.favoriteTeam == null)) {
          showGeneralDialog(
            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: Colors.black45,
            context: context,
            pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) =>
                SelectFavoriteTeam(
              canClose: false,
            ),
          );
        } else if (state is PreferencesUpdatedState) {
          Future.delayed(Duration(milliseconds: 1000)).then(
            (_) {
              SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                FeatureDiscovery.discoverFeatures(
                  context,
                  const <String>{
                    MAIN_DASHBOARD,
                    MAIN_COMPETITION,
                    MAIN_CLUBS,
                    MAIN_GYMNASIUMS,
                  },
                );
              });
            },
          );
        }
      },
      builder: (context, state) {
        return MainPage(
          title: "Volley34",
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Paragraph(title: "Votre club"),
                StateConditionBuilder(
                  state: state,
                  conditionalBuilders: [
                    when(
                      stateIs<PreferencesLoadingState>(),
                      (_, __) => SizedBox(height: DashboardClub.cardHeight, child: Loading()),
                    ),
                    when<PreferencesUpdatedState>(
                      stateIs<PreferencesUpdatedState>(),
                      (_, state) {
                        if (state.favoriteClub != null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: DashboardClub(key: ValueKey("dashboard-clubs"), club: state.favoriteClub!),
                          );
                        } else {
                          return _buildNoFavorite(context, "Sélectionnez votre club dans votre profil");
                        }
                      },
                    ),
                  ],
                  defaultBuilder: (_, state) => Container(height: 250),
                ),
                Paragraph(title: "Votre équipe"),
                StateConditionBuilder(
                  state: state,
                  conditionalBuilders: [
                    when(
                      stateIs<PreferencesLoadingState>(),
                      (_, __) => SizedBox(
                        height: DashboardClubTeam.cardHeight,
                        child: Loading(),
                      ),
                    ),
                    when<PreferencesUpdatedState>(
                      stateIs<PreferencesUpdatedState>(),
                      (_, state) {
                        if (state.favoriteTeam != null && state.favoriteClub != null) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: DashboardClubTeam(
                              club: state.favoriteClub!,
                              team: state.favoriteTeam!,
                            ),
                          );
                        } else {
                          return _buildNoFavorite(context, "Sélectionnez votre équipe dans votre profil");
                        }
                      },
                    ),
                  ],
                  defaultBuilder: (_, state) => Container(height: 250),
                ),
                Paragraph(title: "Votre agenda"),
                StateConditionBuilder(
                  state: state,
                  conditionalBuilders: [
                    when<PreferencesLoadingState>(
                        stateIs<PreferencesLoadingState>(),
                        (_, __) => SizedBox(
                              height: DashboardClub.cardHeight,
                              child: Loading(),
                            )),
                    when<PreferencesUpdatedState>(
                      stateIs<PreferencesUpdatedState>(),
                      (_, state) => state.favoriteTeam != null
                          ? DashboardAgenda(team: state.favoriteTeam!)
                          : _buildNoFavorite(context, "Sélectionnez votre équipe dans votre profil"),
                    ),
                  ],
                  defaultBuilder: (_, state) => Container(height: 250),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoFavorite(BuildContext context, String message) {
    return Center(
      child: Container(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 28, right: 28),
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  AnalyticsRoute get route => AnalyticsRoute.dashboard;
}
