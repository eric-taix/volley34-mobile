import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/podium_widget.dart';
import 'package:v34/models/classication.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
import 'package:v34/pages/team-details/information_divider.dart';
import 'package:v34/pages/team-details/ranking/statistics_widget.dart';
import 'package:v34/pages/team-details/ranking/summary_widget.dart';

import 'evolution_widget.dart';

class TeamRanking extends StatelessWidget {
  final Team team;
  final ClassificationSynthesis classification;
  final List<MatchResult> results;

  const TeamRanking({Key key, @required this.team, @required this.classification, @required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int teamIndex = classification.teamsClassifications.indexWhere((element) => element.teamCode == team.code);
    ClassificationTeamSynthesis stats = classification.teamsClassifications[teamIndex];
    return SliverList(delegate: SliverChildListDelegate([
      _buildTitle(context),
      _buildPodium(stats),
      InformationDivider(title: "Statistiques", size: 15),
      _buildStats(context, stats),
    ]));
  }

  String _getClassificationCategory() {
    switch (classification.division) {
      case "EX": return "- Excellence";
      case "HO": return "- Honneur";
      case "PR": return "- Promotion";
      case "AC": return "- Accession";
      case "L1": return "- Loisirs 1";
      default: return _getPool();
    }
  }

  String _getPool() {
    if (classification.pool == "0") return "";
    else return "- Poule ${classification.pool}";
  }

  Widget _buildTitle(BuildContext context) {
    return Stack(
      children: <Widget>[
        InformationDivider(title: "Classement ${_getClassificationCategory()}", size: 15),
        Positioned(
          top: 12,
          right: 12,
          child: CompetitionBadge(competitionCode: classification.competitionCode, deltaSize: 0.8)
        )
      ],
    );
  }

  Widget _buildPodium(ClassificationTeamSynthesis teamStats) {
    String title = "";
    if (teamStats.rank <= classification.promoted) title = "Promue";
    else if (classification.teamsClassifications.length - teamStats.rank < classification.relegated) title = "Reléguée";
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: Container(
        height: 150,
        child: Row(
          children: <Widget>[
            Expanded(child: PodiumWidget(title: title, classification: classification, currentlyDisplayed: true, highlightedTeamCode: team.code)),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context, ClassificationTeamSynthesis teamStats) {
    List<double> setsDiffEvolution = TeamBloc.computePointsDiffs(results, team.code);
    List<double> cumulativeSetsDiffEvolution = TeamBloc.computeCumulativePointsDiffs(setsDiffEvolution);
    return Column(
      children: <Widget>[
        StatisticsWidget(title: "Matchs gagnés", wonPoints: teamStats.wonMatches, lostPoints: teamStats.lostMatches),
        SummaryWidget(title: "Scores", teamStats: teamStats),
        StatisticsWidget(title: "Set pris", wonPoints: teamStats.wonSets, lostPoints: teamStats.lostSets),
        EvolutionWidget(title: "Ev. de la différence de sets", evolution: setsDiffEvolution),
        EvolutionWidget(title: "Ev. de la différence de sets cumulée", evolution: cumulativeSetsDiffEvolution),
        StatisticsWidget(title: "Points pris", wonPoints: teamStats.wonPoints, lostPoints: teamStats.lostPoints),
      ],
    );
  }

}