import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/pages/team-details/results/result_information_card.dart';

import 'information_divider.dart';

class ResultInformation extends StatelessWidget {
  final String teamCode;
  final MatchResult result;

  static final List<IconData> icons = [Icons.looks_one, Icons.looks_two, Icons.looks_3, Icons.looks_4, Icons.looks_5];

  const ResultInformation({Key key, @required this.teamCode, @required this.result}) : super(key: key);

  Widget build(BuildContext context) {
    int nbSets = result.totalSetsHost + result.totalSetsVisitor;
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Match du ${dateFormat.format(result.matchDate)}"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => _buildListItem(context, index, nbSets)
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index, int nbSets) {
    if (index == 0) return _buildMatchResultInformationCard(context);
    else if (index == 1) return InformationDivider(title: "Détails du match");
    else if (index <= nbSets + 1) return _buildSetResultInformationCard(context, index - 1);
    else if (index == nbSets + 2) return _buildPointSummaryInformationCard(context);
    else if (index == nbSets + 3) return Container(height: 30,);
    else return null;
  }

  Widget _buildMatchResultInformationCard(BuildContext context) {
    String title = "Résultat du match";
    int hostPoints = result.totalSetsHost;
    int visitorPoints = result.totalSetsVisitor;
    return _buildInformationCard(context, title, FontWeight.bold, hostPoints, visitorPoints, true);
  }

  Widget _buildSetResultInformationCard(BuildContext context, int setIndex) {
    if (setIndex > 5) return null;
    if (result.sets[setIndex - 1].hostPoint == null) return null;
    String title = "Set n°";
    int hostPoints = result.sets[setIndex - 1].hostPoint;
    int visitorPoints = result.sets[setIndex - 1].visitorpoint;
    Icon icon = _buildIndexIcon(context, setIndex);
    return _buildInformationCard(context, title, FontWeight.normal, hostPoints, visitorPoints, false, icon: icon);
  }

  Widget _buildPointSummaryInformationCard(BuildContext context) {
    String title = "Total des points";
    int hostPoints = result.totalPointsHost;
    int visitorPoints = result.totalPointsVisitor;
    return _buildInformationCard(context, title, FontWeight.normal, hostPoints, visitorPoints, false, neutral: true);
  }

  Widget _buildInformationCard(BuildContext context, String title, FontWeight fontWeight, int hostPoints, int visitorPoints, bool elevation, {Icon icon, bool neutral}) {
    TextStyle titleStyle = TextStyle(
        fontSize: 20,
        fontWeight: fontWeight,
        color: Theme.of(context).textTheme.bodyText2.color
    );
    int diff = hostPoints - visitorPoints;
    if (teamCode == result.visitorTeamCode) diff = -diff;
    Color scoreColor;
    if (neutral != null && neutral) scoreColor = Theme.of(context).textTheme.bodyText2.color;
    else if (diff == 0) scoreColor = Colors.orange;
    else if (diff > 0) scoreColor = Colors.green;
    else scoreColor = Colors.red;
    return ResultInformationCard(
      title: title, titleStyle: titleStyle, elevation: elevation,
      hostName: result.hostName, visitorName: result.visitorName, titleIcon: icon,
      hostPoints: hostPoints, visitorPoints: visitorPoints, scoreColor: scoreColor
    );
  }

  Widget _buildIndexIcon(BuildContext context, int index) {
    Color color = Theme.of(context).accentColor;
    if (index <= 5) return Icon(icons[index - 1], color: color);
    else return null;
  }
}