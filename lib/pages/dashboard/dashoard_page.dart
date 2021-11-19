import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club-details/blocs/club_teams.bloc.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_agenda.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_club_teams.dart';
import 'package:v34/pages/dashboard/widgets/dashboard_clubs.dart';
import 'package:v34/pages/favorite/blocs/favorite_cubit.dart';
import 'package:v34/pages/favorite/favorite_wizard.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/state_builder.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Club? _currentClub;
  late final ClubTeamsBloc _clubTeamsBloc;
  late final FavoriteCubit _favoriteCubit;

  @override
  void initState() {
    _clubTeamsBloc = ClubTeamsBloc(
      repository: RepositoryProvider.of<Repository>(context),
    );
    super.initState();
    _favoriteCubit = FavoriteCubit(RepositoryProvider.of<Repository>(context));
    _favoriteCubit.loadFavoriteClub();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoriteCubit, FavoriteState>(
      listener: (_, state) {
        if (state is FavoriteStateClubNotSet) {
          showDialog(context: context, builder: (_) => SelectFavoriteClub());
        }
      },
      bloc: _favoriteCubit,
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
                      stateIs<FavoriteStateClubLoading>(),
                      (_, __) => Loading(),
                    ),
                    when<FavoriteStateTeamLoading>(
                      or(
                        [stateIs<FavoriteStateTeamLoading>(), stateIs<FavoriteStateTeamNotSet>()],
                      ),
                      (_, state) => DashboardClub(key: ValueKey("dashboard-clubs"), club: state.club),
                    ),
                    when(stateIs<FavoriteStateClubNotSet>(),
                        (_, __) => _buildNoFavorite("Sélectionnez votre club dans votre profil")),
                  ],
                  defaultBuilder: (_, state) => Container(height: 250, child: Text("Ooooops")),
                ),
                Paragraph(title: "Votre équipe"),
                StateConditionBuilder(
                  state: state,
                  conditionalBuilders: [
                    when(
                        or(
                          [stateIs<FavoriteStateClubLoading>(), stateIs<FavoriteStateTeamLoading>()],
                        ),
                        (_, __) => Loading()),
                    when<FavoriteStateTeamLoaded>(
                      stateIs<FavoriteStateTeamLoaded>(),
                      (_, state) => DashboardClubTeam(club: state.club, team: state.team),
                    ),
                    when(
                        or(
                          [stateIs<FavoriteStateClubNotSet>(), stateIs<FavoriteStateTeamNotSet>()],
                        ),
                        (_, __) => _buildNoFavorite("Sélectionnez votre équipe dans votre profil")),
                  ],
                  defaultBuilder: (_, state) => Container(height: 250, child: Text("Ooooops")),
                ),
                Paragraph(title: "Votre agenda"),
                StateConditionBuilder(
                  state: state,
                  conditionalBuilders: [
                    when(
                        or(
                          [stateIs<FavoriteStateClubLoading>(), stateIs<FavoriteStateTeamLoading>()],
                        ),
                        (_, __) => Loading()),
                    when<FavoriteStateTeamLoaded>(
                      stateIs<FavoriteStateTeamLoaded>(),
                      (_, state) => DashboardAgenda(team: state.team),
                    ),
                    when(
                        or(
                          [stateIs<FavoriteStateClubNotSet>(), stateIs<FavoriteStateTeamNotSet>()],
                        ),
                        (_, __) => _buildNoFavorite("Sélectionnez votre équipe dans votre profil")),
                  ],
                  defaultBuilder: (_, state) => Container(height: 250, child: Text("Ooooops")),
                )
                //   DashboardAgenda(_agendaElement)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoFavorite(String message) {
    return Center(
      child: Container(
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            /*SvgPicture.asset(
              "assets/error.svg",
              width: 80,
            ),*/
            Icon(Icons.warning_rounded, color: Theme.of(context).textTheme.bodyText1!.color),
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

  Widget _buildLoadingOrEmpty(bool loading, Widget orElse) {
    return loading
        ? Container(
            height: 240,
            child: Center(
              child: Loading(),
            ),
          )
        : orElse;
  }
}
