import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/blocs/preferences_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_agenda.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_club_teams.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_clubs.dart';
import 'package:v34/state_builder.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesBloc, PreferencesState>(
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
                      (_, __) => Loading(),
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
                  defaultBuilder: (_, state) => Container(height: 250, child: Text("Ooooops")),
                ),
                Paragraph(title: "Votre équipe"),
                StateConditionBuilder(
                  state: state,
                  conditionalBuilders: [
                    when(
                      stateIs<PreferencesLoadingState>(),
                      (_, __) => Loading(),
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
                  defaultBuilder: (_, state) => Container(height: 250, child: Text("Ooooops")),
                ),
                Paragraph(title: "Votre agenda"),
                StateConditionBuilder(
                  state: state,
                  conditionalBuilders: [
                    when<PreferencesUpdatedState>(stateIs<PreferencesLoadingState>(), (_, __) => Loading()),
                    when<PreferencesUpdatedState>(
                      stateIs<PreferencesUpdatedState>(),
                      (_, state) => state.favoriteTeam != null
                          ? DashboardAgenda(team: state.favoriteTeam!)
                          : _buildNoFavorite(context, "Sélectionnez votre équipe dans votre profil"),
                    ),
                  ],
                  defaultBuilder: (_, state) => Container(height: 250, child: Text("Ooooops")),
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
}
