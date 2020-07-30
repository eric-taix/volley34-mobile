import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/podium_widget.dart';
import 'package:v34/models/classication.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
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
      _buildTitle(),
      _buildPodium(stats),
      InformationDivider(title: "Statistiques", size: 15),
      _buildStats(context, stats),
    ]));
  }

  Widget _buildTitle() {
    return InformationDivider(title: "Classement du ${classification.fullLabel}",);
  }

  Widget _buildPodium(ClassificationTeamSynthesis teamStats) {
    String title = teamStats.rank <= classification.promoted ? "Promue" : "Reléguée";
    return Container(
      height: 150,
      child: Row(
        children: <Widget>[
          Expanded(child: PodiumWidget(title: title, classification: classification, currentlyDisplayed: true, highlightedTeamCode: team.code)),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context, ClassificationTeamSynthesis teamStats) {
    return Column(
      children: <Widget>[
        StatisticsWidget(title: "Matchs gagnés", wonPoints: teamStats.wonMatches, lostPoints: teamStats.lostMatches),
        Divider(),
        SummaryWidget(title: "Scores", teamStats: teamStats),
        Divider(),
        StatisticsWidget(title: "Set pris", wonPoints: teamStats.wonSets, lostPoints: teamStats.lostSets),
        Divider(),
        EvolutionWidget(title: "Evolution de la différence de sets", team: team, results: results),
        Divider(),
        StatisticsWidget(title: "Points pris", wonPoints: teamStats.wonPoints, lostPoints: teamStats.lostPoints),
      ],
    );
  }

}