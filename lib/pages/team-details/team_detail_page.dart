import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/app_bar/app_bar_with_image.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
import 'package:v34/pages/dashboard/blocs/team_classification_bloc.dart';
import 'package:v34/pages/team-details/agenda/team_agenda.dart';
import 'package:v34/pages/team-details/ranking/team_ranking.dart';
import 'package:v34/pages/team-details/results/team_results.dart';
import 'package:v34/repositories/repository.dart';

class TeamDetailPage extends StatefulWidget {
  final Team team;
  final Club club;

  TeamDetailPage({required this.team, required this.club});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  late final TeamRankingBloc _rankingBloc;
  late final TeamBloc _teamBloc;

  @override
  void initState() {
    super.initState();
    Repository repository = RepositoryProvider.of<Repository>(context);
    _rankingBloc = TeamRankingBloc(repository: repository);
    _teamBloc = TeamBloc(repository: repository);

    _rankingBloc.add(LoadTeamRankingEvent(widget.team));
    _teamBloc.add(TeamLoadResults(code: widget.team.code, last: 8));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamRankingBloc, TeamRankingState>(
      bloc: _rankingBloc,
      builder: (context, state) {
        return AppBarWithImage(
          widget.team.name,
          "hero-logo-${widget.team.code}",
          key: ValueKey("teamDetailPage"),
          subTitle: widget.club.name ?? "",
          logoUrl: widget.team.clubLogoUrl,
          favorite: Favorite(
            widget.team.code,
            FavoriteType.Team,
          ),
          itemCount: state is TeamRankingLoadedState ? state.rankings.length + 2 : 1,
          tabBuilder: (context, index) {
            if (state is TeamRankingLoadedState) {
              if (index < state.rankings.length) {
                return Text(state.rankings[index].label ?? "?");
              }
              if (index == state.rankings.length) return Text("Résultats");
              if (index == state.rankings.length + 1) return Text("Agenda");
            }
            return SizedBox();
          },
          pageBuilder: (BuildContext context, int index) {
            if (state is TeamRankingLoadedState) {
              return BlocBuilder<TeamBloc, TeamState>(
                bloc: _teamBloc,
                builder: (context, teamState) {
                  if (teamState is TeamResultsLoaded) {
                    if (index < state.rankings.length)
                      return _buildTeamRanking(state.rankings[index], teamState.results);
                    if (index == state.rankings.length) return _buildTeamResults(state.rankings[0], teamState.results);
                    if (index == state.rankings.length + 1)
                      return _buildTeamAgenda(state.rankings[0], teamState.results);
                  }
                  return SliverFillRemaining(child: Center(child: Loading()));
                },
              );
            }
            return SliverFillRemaining(child: Center(child: Loading()));
          },
        );
      },
    );
  }

  Widget _buildTeamResults(RankingSynthesis? ranking, List<MatchResult> results) {
    return TeamResults(team: widget.team, results: results);
  }

  Widget _buildTeamAgenda(RankingSynthesis? ranking, List<MatchResult> results) {
    return TeamAgenda(team: widget.team);
  }

  Widget _buildTeamRanking(RankingSynthesis? ranking, List<MatchResult> results) {
    return TeamRanking(
        team: widget.team,
        ranking: ranking ?? RankingSynthesis(),
        results: results.where((result) => result.competitionCode == ranking?.competitionCode).toList());
  }
}
