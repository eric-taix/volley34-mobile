import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v34/models/match_result.dart';

import 'information_divider.dart';

class ResultInformation extends StatelessWidget {
  final String teamCode;
  final MatchResult result;

  static final double bigScoreSize = 50.0;
  static final double scoreSize = 30.0;
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
    if (index == 0) return _buildMatchResult(context);
    else if (index == 1) return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InformationDivider(title: "Détails du match"),
    );
    else if (index % 2 == 0) {
      index = index ~/ 2;
      if (index <= nbSets) return _buildSetResult(context, index);
      else if (index == nbSets + 1) return _buildPointSummaryResult(context);
      else return null;
    } else {
      return Divider();
    }
  }

  Widget _buildScore(PointSituation pointSituation, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          pointSituation.hostPoints.toString(),
          style: TextStyle(color: pointSituation.hostColor, fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
        Text(
            " - ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize)
        ),
        Text(
          pointSituation.visitorPoints.toString(),
          style: TextStyle(color: pointSituation.visitorColor, fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
      ],
    );
  }

  Widget _buildMatchResult(BuildContext context) {
    PointSituation matchSituation = PointSituation(context, result.totalSetsHost, result.totalSetsVisitor);
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("${result.hostName} ${matchSituation.label}", style: Theme.of(context).textTheme.subtitle1,),
            )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
            child: _buildScore(matchSituation, bigScoreSize)
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text("contre ${result.visitorName}", style: Theme.of(context).textTheme.subtitle1,),
            )
          )
        ],
      ),
    );
  }

  Widget _buildSetResult(BuildContext context, int setIndex) {
    if (setIndex > 5) return null;
    if (result.sets[setIndex - 1].hostPoint == null) return null;
    PointSituation setSituation = PointSituation(context, result.sets[setIndex - 1].hostPoint, result.sets[setIndex - 1].visitorpoint);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Set n°" , style: Theme.of(context).textTheme.headline4,),
            _buildIndexIcon(context, setIndex)
          ],
        ),
        _buildScore(setSituation, scoreSize)
      ],
    );
  }

  Widget _buildPointSummaryResult(BuildContext context) {
    int hostPoints = result.totalPointsHost;
    int visitorPoints = result.totalPointsVisitor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text("Total des points", style: Theme.of(context).textTheme.headline4,),
        Row(
          children: <Widget>[
            Text(
              hostPoints.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: scoreSize),
            ),
            Text(
                " - ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: scoreSize)
            ),
            Text(
              visitorPoints.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: scoreSize),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIndexIcon(BuildContext context, int index) {
    Color color = Theme.of(context).accentColor;
    if (index <= 5) return Icon(icons[index - 1], color: color);
    else return null;
  }
}

class PointSituation {
  String label;
  int hostPoints, visitorPoints;
  Color hostColor, visitorColor;

  PointSituation(BuildContext context, this.hostPoints, this.visitorPoints) {
    int diff = hostPoints - visitorPoints;
    if (diff > 0){
      this.label = "gagne";
      this.hostColor = Colors.green;
      this.visitorColor = Colors.red;
    } else if (diff < 0){
      this.label = "perd";
      this.hostColor = Colors.red;
      this.visitorColor = Colors.green;
    } else {
      this.label = "fait une égalité";
      this.hostColor = Theme.of(context).textTheme.bodyText2.color;
      this.visitorColor = Theme.of(context).textTheme.bodyText2.color;
    }
  }
}