import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/podium_widget.dart';
import 'package:v34/models/classication.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/information_divider.dart';
import 'package:v34/pages/team-details/ranking/statistics_widget.dart';
import 'package:v34/utils/extensions.dart';

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
      InformationDivider(title: "Résultat de vos matchs", size: 15),
      _buildResultsSummary(context, stats)
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
        StatisticsWidget(title: "Set pris", wonPoints: teamStats.wonSets, lostPoints: teamStats.lostSets),
        StatisticsWidget(title: "Points pris", wonPoints: teamStats.wonPoints, lostPoints: teamStats.lostPoints),

      ],
    );
  }

  Widget _buildResultsSummary(BuildContext context, ClassificationTeamSynthesis teamStats) {
    return SizedBox(
      height: 150,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        child: BarChart(BarChartData(
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              textStyle: Theme.of(context).textTheme.bodyText2.apply(fontWeightDelta: 2),
              margin: 16,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0: return '3-0\n${teamStats.nbSets30 > 0 ? teamStats.nbSets30.toString() : "-"}';
                  case 1: return '3-1\n${teamStats.nbSets31 > 0 ? teamStats.nbSets31.toString() : "-"}';
                  case 2: return '3-2\n${teamStats.nbSets32 > 0 ? teamStats.nbSets32.toString() : "-"}';
                  case 3: return '2-3\n${teamStats.nbSets23 > 0 ? teamStats.nbSets23.toString() : "-"}';
                  case 4: return '1-3\n${teamStats.nbSets13 > 0 ? teamStats.nbSets13.toString() : "-"}';
                  case 5: return '0-3\n${teamStats.nbSets03 > 0 ? teamStats.nbSets03.toString() : "-"}';
                  case 6: return 'NT\n${teamStats.nbSetsMI > 0 ? teamStats.nbSetsMI.toString() : "-"}';
                  default: return '';
                }
              },
            ),
            leftTitles: SideTitles(showTitles: false),
          ),
          barGroups: showingGroups(context, teamStats),
        )),
      ),
    );
  }

  List<BarChartGroupData> showingGroups(BuildContext context, ClassificationTeamSynthesis teamStats) {
    return List.generate(7, (i) {
     switch (i) {
       case 0:
         return makeGroupData(context, 0, teamStats.nbSets30.toDouble(), Colors.green, teamStats);
       case 1:
         return makeGroupData(context, 1, teamStats.nbSets31.toDouble(), Colors.greenAccent, teamStats);
       case 2:
         return makeGroupData(context, 2, teamStats.nbSets32.toDouble(), Colors.yellowAccent, teamStats);
       case 3:
         return makeGroupData(context, 3, teamStats.nbSets23.toDouble(), Colors.orangeAccent, teamStats);
       case 4:
         return makeGroupData(context, 4, teamStats.nbSets13.toDouble(), Colors.deepOrangeAccent, teamStats);
       case 5:
         return makeGroupData(context, 5, teamStats.nbSets03.toDouble(), Colors.redAccent, teamStats);
       case 6:
         return makeGroupData(context, 6, teamStats.nbSetsMI.toDouble(), Theme.of(context).accentColor, teamStats);
       default:
         return null;
     }
    });
  }

  BarChartGroupData makeGroupData(BuildContext context, int x, double y, Color barColor, ClassificationTeamSynthesis teamStats) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(y: y, color: barColor, width: 14,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: (teamStats.wonMatches + teamStats.lostMatches).toDouble(),
            color: Theme.of(context).cardTheme.color.tiny(10), //barBackgroundColor,
          ),
        ),
      ],
    );
  }

}