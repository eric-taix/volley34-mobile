import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
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
      children: <Widget>[
        StatisticsWidget(title: "Matchs gagnés", wonPoints: teamStats.wonMatches, lostPoints: teamStats.lostMatches),
        StatisticsWidget(title: "Set pris", wonPoints: teamStats.wonSets, lostPoints: teamStats.lostSets),
        StatisticsWidget(title: "Points pris", wonPoints: teamStats.wonPoints, lostPoints: teamStats.lostPoints, width: 200),
      ],
    );
  }

  Widget _buildResultsSummary(BuildContext context, ClassificationTeamSynthesis teamStats) {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      runSpacing: 20,
      children: <Widget>[
        _buildMiniResult(context, "3 - 0", teamStats.nbSets30),
        _buildMiniResult(context, "3 - 1", teamStats.nbSets31),
        _buildMiniResult(context, "3 - 2", teamStats.nbSets32),
        _buildMiniResult(context, "0 - 3", teamStats.nbSets03),
        _buildMiniResult(context, "1 - 3", teamStats.nbSets13),
        _buildMiniResult(context, "2 - 3", teamStats.nbSets23),
        _buildMiniResult(context, "2 - 2", teamStats.nbSets22),
      ],
    );
  }
  
  Widget _buildMiniResult(BuildContext context, String title, int points) {
    Color color = Theme.of(context).cardTheme.color;
    Color darkenedColor = TinyColor(color).darken(5).color;
    return Container(
      height: 50,
      width: 100,
      decoration: BoxDecoration(color: darkenedColor, borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2.apply(fontWeightDelta: 2, fontSizeFactor: 1.3))
            ),
          ),
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 50,
              child: Container(
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), bottomRight: Radius.circular(20.0))),
                child: Center(child: Text(points.toString(), textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2.apply(fontWeightDelta: 2, fontSizeFactor: 1.7)))
              )
            ),
          )
        ],
      ),
    );
  }

}