import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/app_bar/app_bar_with_image.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/force.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
import 'package:v34/pages/competition/bloc/competition_cubit.dart';
import 'package:v34/pages/dashboard/blocs/team_classification_bloc.dart';
import 'package:v34/pages/team-details/agenda/team_agenda.dart';
import 'package:v34/pages/team-details/ranking/team_ranking.dart';
import 'package:v34/pages/team-details/results/team_results.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/competition_text.dart';

enum OpenedPage { COMPETITION, RESULTS, AGENDA }

class TeamDetailPage extends StatefulWidget {
  final Team team;
  final Club club;
  final OpenedPage? openedPage;
  final String? openedCompetitionCode;

  TeamDetailPage({required this.team, required this.club, this.openedPage, this.openedCompetitionCode});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  late final TeamRankingBloc _rankingBloc;
  late final TeamBloc _teamBloc;
  late final CompetitionCubit _competitionCubit;
  ValueNotifier<bool> _showAllTeams = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    Repository repository = RepositoryProvider.of<Repository>(context);
    _rankingBloc = TeamRankingBloc(repository: repository);
    _teamBloc = TeamBloc(repository: repository);
    _rankingBloc.add(LoadTeamRankingEvent(widget.team));
    _competitionCubit = CompetitionCubit(repository);
    _competitionCubit.loadTeamCompetitions(widget.team);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _competitionCubit,
      listener: (BuildContext context, state) {
        if (state is CompetitionTeamLoadedState) {
          _teamBloc.add(TeamLoadDivisionPoolResults(
            teamCode: widget.team.code!,
            competitionsFullPath: state.competitions
                .map((competition) => CompetitionFullPath(competition.code, competition.division, competition.pool))
                .toList(),
          ));
        }
      },
      child: BlocBuilder<TeamRankingBloc, TeamRankingState>(
        bloc: _rankingBloc,
        builder: (context, state) {
          int? initialPosition;
          if (state is TeamRankingLoadedState && widget.openedPage != null) {
            switch (widget.openedPage!) {
              case OpenedPage.COMPETITION:
                initialPosition = state.rankings
                    .asMap()
                    .entries
                    .firstWhereOrNull((ranking) => ranking.value.competitionCode == widget.openedCompetitionCode)
                    ?.key;
                break;
              case OpenedPage.RESULTS:
                initialPosition = state.rankings.length;
                break;
              case OpenedPage.AGENDA:
                initialPosition = state.rankings.length + 1;
                break;
            }
          }
          return AppBarWithImage(
            widget.team.name,
            "hero-logo-${widget.team.code}",
            key: ValueKey("teamDetailPage"),
            initPosition: initialPosition,
            subTitle: widget.club.name ?? "",
            logoUrl: widget.team.clubLogoUrl,
            favorite: Favorite(
              widget.team.code,
              FavoriteType.Team,
            ),
            itemCount: state is TeamRankingLoadedState ? state.rankings.length + 2 : 0,
            tabBuilder: (context, index) {
              if (state is TeamRankingLoadedState) {
                if (index < state.rankings.length) {
                  return Text(extractEnhanceDivisionLabel(state.rankings[index].fullLabel!));
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
                    if (teamState is TeamDivisionPoolResultsLoaded) {
                      if (index < state.rankings.length) {
                        String? competitionCode = state.rankings[index].competitionCode;
                        Forces forces = teamState.forceByCompetitionCode.putIfAbsent(competitionCode, () => Forces());
                        return _buildTeamRanking(state.rankings[index], teamState.teamResults, forces);
                      }
                      if (index == state.rankings.length)
                        return AnimatedBuilder(
                          animation: _showAllTeams,
                          builder: (BuildContext context, Widget? child) => TeamResults(
                            showOnlyTeam: _showAllTeams.value,
                            team: widget.team,
                            results: _showAllTeams.value ? teamState.allResults : teamState.teamResults,
                            onChanged: (onlyTeam) {
                              _showAllTeams.value = onlyTeam;
                            },
                          ),
                        );
                      if (index == state.rankings.length + 1)
                        return _buildTeamAgenda(state.rankings[0], teamState.teamResults);
                    }
                    return SliverFillRemaining(child: Center(child: Loading()));
                  },
                );
              }
              return SliverFillRemaining(child: Center(child: Loading()));
            },
          );
        },
      ),
    );
  }

  Widget _buildTeamAgenda(RankingSynthesis? ranking, List<MatchResult> results) {
    return TeamAgenda(team: widget.team);
  }

  Widget _buildTeamRanking(RankingSynthesis ranking, List<MatchResult> results, Forces forces) {
    return TeamRanking(
      team: widget.team,
      ranking: ranking,
      results: results.where((result) => result.competitionCode == ranking.competitionCode).toList(),
      forces: forces,
    );
  }
}
