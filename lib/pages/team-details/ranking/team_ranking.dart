import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:v34/commons/podium_widget.dart';
import 'package:v34/models/classication.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/information_divider.dart';
import 'package:v34/pages/team-details/ranking/statistics_widget.dart';

class TeamRanking extends StatelessWidget {
  final Team team;
  final ClassificationSynthesis classification;

  const TeamRanking({Key key, @required this.team, @required this.classification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int teamIndex = classification.teamsClassifications.indexWhere((element) => element.teamCode == team.code);
    ClassificationTeamSynthesis stats = classification.teamsClassifications[teamIndex];
    return SliverList(delegate: SliverChildListDelegate([
      _buildTitle(),
      _buildPodium(),
      InformationDivider(title: "Statistiques", size: 15),
      _buildStats(context, stats),
      InformationDivider(title: "Résultat de vos matchs", size: 15),
      _buildResultsSummary(context, stats)
    ]));
  }

  Widget _buildTitle() {
    return InformationDivider(title: "Classement du ${classification.fullLabel}",);
  }

  Widget _buildPodium() {
    return Container(
      height: 150,
      child: Row(
        children: <Widget>[
          Expanded(child: PodiumWidget(classification: classification, currentlyDisplayed: true, highlightedTeamCode: team.code)),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context, ClassificationTeamSynthesis teamStats) {
    return Wrap(
      alignment: WrapAlignment.center,
      runSpacing: 20,
      spacing: 20,
      children: <Widget>[
        StatisticsWidget(title: "Matchs gagnés", wonPoints: teamStats.wonMatches, lostPoints: teamStats.lostMatches),
        StatisticsWidget(title: "Set pris", wonPoints: teamStats.wonSets, lostPoints: teamStats.lostSets),
        StatisticsWidget(title: "Points pris", wonPoints: teamStats.wonPoints, lostPoints: teamStats.lostPoints, width: 180),
      ],
    );
  }

  Widget _buildResultsSummary(BuildContext context, ClassificationTeamSynthesis teamStats) {
    TextStyle style = TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15);
    return PieChart(PieChartData(
      borderData: FlBorderData(border: Border.all(width: 0.0)),
      centerSpaceRadius: 80,
      sections: [
        if (teamStats.nbSets30 > 0) PieChartSectionData(
          color: Colors.greenAccent,
          title: "3-0",
          value: teamStats.nbSets30.toDouble(),
          titleStyle: style
        ),
        if (teamStats.nbSets31 > 0) PieChartSectionData(
          color: Colors.cyanAccent,
          title: "3-1",
          value: teamStats.nbSets31.toDouble(),
          titleStyle: style
        ),
        if (teamStats.nbSets32 > 0) PieChartSectionData(
          color: Colors.blueAccent,
          title: "3-2",
          value: teamStats.nbSets32.toDouble(),
          titleStyle: style
        ),
        if (teamStats.nbSets22 > 0) PieChartSectionData(
          color: Colors.black38,
          title: "2-2",
          value: teamStats.nbSets22.toDouble(),
          titleStyle: style
        ),
        if (teamStats.nbSets03 > 0) PieChartSectionData(
          color: Colors.redAccent,
          title: "0-3",
          value: teamStats.nbSets03.toDouble(),
          titleStyle: style
        ),
        if (teamStats.nbSets13 > 0) PieChartSectionData(
          color: Colors.orangeAccent,
          title: "1-3",
          value: teamStats.nbSets13.toDouble(),
          titleStyle: style
        ),
        if (teamStats.nbSets23 > 0) PieChartSectionData(
          color: Colors.yellowAccent,
          title: "2-3",
          value: teamStats.nbSets23.toDouble(),
          titleStyle: style
        ),
      ]
    ));
  }

}