import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/pages/team-details/results/result_information_card.dart';

class ResultInformation extends StatelessWidget {
  final String teamCode;
  final MatchResult result;

  static final List<String> setNames = [null, "Premier", "Deuxième", "Troisième", "Quatrième", "Cinquième"];

  const ResultInformation({Key key, @required this.teamCode, @required this.result}) : super(key: key);

  Widget build(BuildContext context) {
    String opponent;
    if (teamCode == result.visitorTeamCode) opponent = result.hostName;
    else opponent = result.visitorName;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Match contre $opponent"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => _buildInformationCard(context, index)
      ),
    );
  }

  Widget _buildInformationCard(BuildContext context, int setIndex) {
    if (setIndex > 5) return null;
    if (setIndex > 0 && result.sets[setIndex - 1].hostPoint == null) return null;
    TextStyle titleStyle = TextStyle(
        fontSize: 20,
        fontWeight: (setIndex == 0) ? FontWeight.bold: FontWeight.normal,
        color: Theme.of(context).textTheme.bodyText2.color
    );
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    String title = (setIndex == 0) ? "Résultat du match du ${dateFormat.format(result.inputDate)}" : (setNames[setIndex] + " set");
    int hostPoints = (setIndex == 0) ? result.totalSetsHost : result.sets[setIndex - 1].hostPoint;
    int visitorPoints = (setIndex == 0) ? result.totalSetsVisitor : result.sets[setIndex - 1].visitorpoint;
    int diff = hostPoints - visitorPoints;
    if (teamCode == result.visitorTeamCode) diff = -diff;
    Color scoreColor;
    if (diff == 0) scoreColor = Colors.orange;
    else if (diff > 0) scoreColor = Colors.green;
    else scoreColor = Colors.red;
    return ResultInformationCard(
      title: title, titleStyle: titleStyle,
      hostName: result.hostName, visitorName: result.visitorName, icon: _buildIndexIcon(context, setIndex),
      hostPoints: hostPoints, visitorPoints: visitorPoints, scoreColor: scoreColor);
  }

  Widget _buildIndexIcon(BuildContext context, int index) {
    Color color = Theme.of(context).accentColor;
    switch (index) {
      case 1:
        return Icon(Icons.looks_one, color: color,);
      case 2:
        return Icon(Icons.looks_two, color: color,);
      case 3:
        return Icon(Icons.looks_3, color: color,);
      case 4:
        return Icon(Icons.looks_4, color: color,);
      case 5:
        return Icon(Icons.looks_5, color: color,);
      default:
        return null;
    }
  }
}