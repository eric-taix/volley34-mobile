import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v34/models/match_result.dart';

class ResultCard extends StatelessWidget {
  final String teamCode;
  final MatchResult result;

  const ResultCard({Key key, @required this.teamCode, @required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int diffSets = result.totalSetsHost - result.totalSetsVisitor;
    if (teamCode == result.visitorTeamCode) diffSets = -diffSets;
    Color scoreColor;
    if (diffSets == 0) scoreColor = Colors.orange;
    else if (diffSets > 0) scoreColor = Colors.green;
    else scoreColor = Colors.red;
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.all(Radius.circular(5.0))),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Theme.of(context).textTheme.bodyText2.color)
              )
            ),
            child: Text(
              "${result.totalSetsHost} - ${result.totalSetsVisitor}",
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: scoreColor)
            ),
          ),
          title: Text(
            "${result.hostName} vs. ${result.visitorName}",
            style: TextStyle(fontSize: 15.0, color: Theme.of(context).textTheme.bodyText2.color, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Icon(Icons.linear_scale, color: Theme.of(context).accentColor),
              ),
              Text("Saisi le ${dateFormat.format(result.inputDate)}", style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color))
            ],
          ),
          trailing:
          Icon(Icons.keyboard_arrow_right, color: Theme.of(context).textTheme.bodyText2.color, size: 30.0)
        )
      )
    );
  }
}