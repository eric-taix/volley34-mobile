import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/app_bar/app_bar_with_image.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/text_tab_bar.dart';
import 'package:v34/models/classication.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
import 'package:v34/pages/dashboard/blocs/team_classification_bloc.dart';
import 'package:v34/pages/team-details/agenda/team_agenda.dart';
import 'package:v34/pages/team-details/ranking/team_ranking.dart';
import 'package:v34/pages/team-details/results/team_results.dart';
import 'package:v34/repositories/repository.dart';

class TeamDetailPage extends StatefulWidget {
  final Team team;
  final List<ClassificationSynthesis> classifications;

  final Club club;

  const TeamDetailPage(
      {Key key,
      @required this.team,
      @required this.classifications,
      @required this.club})
      : super(key: key);

  @override
  TeamDetailPageState createState() => TeamDetailPageState();
}

class TeamDetailPageState extends State<TeamDetailPage> {
  TeamBloc _teamBloc;
  TeamClassificationBloc _classificationBloc;

  @override
  void initState() {
    super.initState();
    Repository repository = RepositoryProvider.of<Repository>(context);
    _teamBloc = TeamBloc(repository: repository);
    _teamBloc.add(TeamLoadResults(code: widget.team.code, last: 50));
    if (widget.classifications == null) {
      _classificationBloc = TeamClassificationBloc(repository: repository);
      _classificationBloc.add(LoadTeamClassificationEvent(widget.team));
    }
  }

  List<TextTab> _getTabs(List<ClassificationSynthesis> classifications) {
    List<TextTab> tabs = classifications.map((classification) {
      return TextTab(
          classification.label, _buildTab(_buildTeamRanking, classification));
    }).toList();
    tabs.add(TextTab("Résultats", _buildTab(_buildTeamResults, null)));
    tabs.add(TextTab("Agenda", _buildTab(_buildTeamAgenda, null)));
    return tabs;
  }

  Widget _buildTab(Function element, ClassificationSynthesis classification) {
    return BlocBuilder<TeamBloc, TeamState>(
        cubit: _teamBloc,
        builder: (context, state) {
          if (state is TeamResultsLoaded) {
            return element(classification, state.results);
          } else
            return SliverList(delegate: SliverChildListDelegate([Loading()]));
        });
  }

  Widget _buildTeamRanking(
      ClassificationSynthesis classification, List<MatchResult> results) {
    return TeamRanking(
        team: widget.team,
        classification: classification,
        results: results
            .where((result) =>
                result.competitionCode == classification.competitionCode)
            .toList());
  }

  Widget _buildTeamResults(
      ClassificationSynthesis classification, List<MatchResult> results) {
    return TeamResults(team: widget.team, results: results);
  }

  Widget _buildTeamAgenda(
      ClassificationSynthesis classification, List<MatchResult> results) {
    return TeamAgenda(team: widget.team);
  }

  Widget _buildTeamDetailPage(String key, List<TextTab> tabs) {
    return AppBarWithImage(
      widget.team.name,
      "hero-logo-${widget.team.code}",
      key: ValueKey(key),
      subTitle: widget.club.name,
      logoUrl: widget.team.clubLogoUrl,
      tabs: tabs,
      favorite: Favorite(
        widget.team.favorite,
        widget.team.code,
        FavoriteType.Team,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.classifications == null) {
      return BlocBuilder<TeamClassificationBloc, TeamClassificationState>(
          cubit: _classificationBloc,
          builder: (context, state) {
            if (state is TeamClassificationLoadedState) {
              return _buildTeamDetailPage(
                  "teamDetailPageLoaded", _getTabs(state.classifications));
            } else {
              return Center(
                child: Loading(),
              );
            }
          });
    } else {
      return _buildTeamDetailPage(
          "teamDetailPageLoaded", _getTabs(widget.classifications));
    }
  }
}
