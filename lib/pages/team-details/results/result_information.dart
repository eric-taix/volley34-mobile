import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/pages/team-details/results/result_information_card.dart';

class ResultInformation extends StatelessWidget {
  final String teamCode;
  final MatchResult result;

  const ResultInformation({Key key, @required this.teamCode, @required this.result}) : super(key: key);

  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Match du ${dateFormat.format(result.matchDate)}"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => _buildListItem(context, index)
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        return _buildInformationCard(context, index);
      case 1:
        return Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Divider(),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text("Détails du match", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline6,),
                ),
              ),
              Expanded(
                flex: 7,
                child: Divider(),
              )
            ],
          ),
        );
      default:
        return _buildInformationCard(context, index - 1);
    }
  }

  Widget _buildInformationCard(BuildContext context, int setIndex) {
    if (setIndex > 5) return null;
    if (setIndex > 0 && result.sets[setIndex - 1].hostPoint == null) return null;
    TextStyle titleStyle = TextStyle(
        fontSize: 20,
        fontWeight: (setIndex == 0) ? FontWeight.bold: FontWeight.normal,
        color: Theme.of(context).textTheme.bodyText2.color
    );
    String title = (setIndex == 0) ? "Résultat du match" : "Set n°";
    int hostPoints = (setIndex == 0) ? result.totalSetsHost : result.sets[setIndex - 1].hostPoint;
    int visitorPoints = (setIndex == 0) ? result.totalSetsVisitor : result.sets[setIndex - 1].visitorpoint;
    int diff = hostPoints - visitorPoints;
    if (teamCode == result.visitorTeamCode) diff = -diff;
    Color scoreColor;
    if (diff == 0) scoreColor = Colors.orange;
    else if (diff > 0) scoreColor = Colors.green;
    else scoreColor = Colors.red;
    return ResultInformationCard(
      title: title, titleStyle: titleStyle, elevation: setIndex == 0,
      hostName: result.hostName, visitorName: result.visitorName, titleIcon: _buildIndexIcon(context, setIndex),
      hostPoints: hostPoints, visitorPoints: visitorPoints, scoreColor: scoreColor
    );
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