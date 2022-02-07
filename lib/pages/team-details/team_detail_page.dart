import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/app_bar/app_bar_with_image.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/competition.dart';
import 'package:v34/models/force.dart';
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
  final String teamCode;
  final String teamName;
  final Club? club;
  final OpenedPage? openedPage;
  final String? openedCompetitionCode;

  TeamDetailPage(
      {required this.teamCode, required this.teamName, this.openedPage, this.club, this.openedCompetitionCode});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  late final TeamRankingBloc _rankingBloc;
  late final TeamBloc _teamBloc;
  late final CompetitionCubit _competitionCubit;
  ValueNotifier<bool> _showAllTeams = ValueNotifier(false);
  List<Competition>? _competitions;

  Team? _team;
  Club? _club;

  @override
  void initState() {
    super.initState();
    Repository repository = RepositoryProvider.of<Repository>(context);
    _rankingBloc = TeamRankingBloc(repository: repository);
    _teamBloc = TeamBloc(repository: repository);
    _competitionCubit = CompetitionCubit(repository);

    _club = widget.club;
    Future.wait([repository.loadTeam(widget.teamCode), if (_club == null) repository.loadTeamClub(widget.teamCode)])
        .then((results) {
      _team = results[0] as Team;
      if (_club == null) _club = results[1] as Club;
      _rankingBloc.add(LoadTeamRankingEvent(_team!));
      _competitionCubit.loadTeamCompetitions(_team!);
    });

    repository.loadAllCompetitions().then((competitions) {
      setState(() {
        _competitions = competitions;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _competitionCubit,
      listener: (BuildContext context, state) {
        if (state is CompetitionTeamLoadedState) {
          _teamBloc.add(TeamLoadDivisionPoolResults(
            teamCode: widget.teamCode,
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
            widget.teamName,
            "hero-logo-${widget.teamCode}",
            key: ValueKey("teamDetailPage"),
            initPosition: initialPosition,
            subTitle: _club?.name ?? "",
            logoUrl: _club?.logoUrl ?? "",
            favorite: Favorite(
              widget.teamCode,
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
                      if (index < state.rankings.length && _team != null) {
                        String? competitionCode = state.rankings[index].competitionCode;
                        Forces forces = teamState.forceByCompetitionCode.putIfAbsent(competitionCode, () => Forces());
                        return TeamRanking(
                          team: _team!,
                          ranking: state.rankings[index],
                          results: teamState.teamResults
                              .where((result) => result.competitionCode == state.rankings[index].competitionCode)
                              .toList(),
                          forces: forces,
                        );
                      }
                      if (index == state.rankings.length && _team != null)
                        return AnimatedBuilder(
                          animation: _showAllTeams,
                          builder: (BuildContext context, Widget? child) => TeamResults(
                            competitions: _competitions,
                            showOnlyTeam: _showAllTeams.value,
                            team: _team!,
                            results: _showAllTeams.value ? teamState.allResults : teamState.teamResults,
                            onChanged: (onlyTeam) {
                              _showAllTeams.value = onlyTeam;
                            },
                          ),
                        );
                      if (index == state.rankings.length + 1 && _team != null)
                        return TeamAgenda(team: _team!, competitions: _competitions);
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
}
