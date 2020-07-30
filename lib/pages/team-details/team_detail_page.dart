import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/app_bar/app_bar_with_image.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/text_tab_bar.dart';
import 'package:v34/models/classication.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
import 'package:v34/pages/team-details/results/team_results.dart';
import 'package:v34/pages/team-details/ranking/team_ranking.dart';
import 'package:v34/repositories/repository.dart';

class TeamDetailPage extends StatefulWidget {
  final Team team;
  final List<ClassificationSynthesis> classifications;

  const TeamDetailPage(
      {Key key, @required this.team, @required this.classifications})
      : super(key: key);

  @override
  TeamDetailPageState createState() => TeamDetailPageState();
}

class TeamDetailPageState extends State<TeamDetailPage> {
  TeamBloc _teamBloc;

  @override
  void initState() {
    super.initState();
    _teamBloc = TeamBloc(repository: RepositoryProvider.of<Repository>(context));
    _teamBloc.add(TeamLoadResults(code: widget.team.code, last: 50));
  }

  List<TextTab> _getTabs() {
    List<TextTab> tabs = widget.classifications.map((classification) {
      return TextTab(classification.label, _buildTab(_buildTeamRanking, classification));
    }).toList();
    tabs.add(TextTab("Résultats", _buildTab(_buildTeamResults, null)));
    return tabs;
  }

  Widget _buildTab(Function element, ClassificationSynthesis classification) {
    return BlocBuilder<TeamBloc, TeamState>(
      bloc: _teamBloc,
      builder: (context, state) {
        if (state is TeamResultsLoaded) {
          return element(classification, state.results);
        } else return SliverList(delegate: SliverChildListDelegate([Loading()]));
      }
    );
  }

  Widget _buildTeamRanking(ClassificationSynthesis classification, List<MatchResult> results) {
    return TeamRanking(team: widget.team, classification: classification, results: results);
  }

  Widget _buildTeamResults(ClassificationSynthesis classification, List<MatchResult> results) {
    return TeamResults(team: widget.team, results: results);
  }

  @override
  Widget build(BuildContext context) {
    return AppBarWithImage(
      widget.team.code,
      "hero-logo-${widget.team.code}",
      subTitle: widget.team.name,
      logoUrl: widget.team.clubLogoUrl,
      tabs: _getTabs(),
      favorite: Favorite(
        widget.team.favorite,
        widget.team.code,
        FavoriteType.Team,
      ),
    );
  }
}
