import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';

import 'information_divider.dart';

class ResultInformation extends StatelessWidget {
  final Team team;
  final MatchResult result;

  static final double bigScoreSize = 50.0;
  static final double scoreSize = 30.0;
  static final List<IconData> icons = [Icons.looks_one, Icons.looks_two, Icons.looks_3, Icons.looks_4, Icons.looks_5];

  static final String tempPlaceholder = "https://lunawood.com/wp-content/uploads/2018/02/placeholder-image.png";

  const ResultInformation({Key key, @required this.team, @required this.result}) : super(key: key);

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

  Widget _buildMatchResult(BuildContext context) {
    int hostPoints = result.totalSetsHost;
    int visitorPoints = result.totalSetsVisitor;
    String situation = _getSituation(hostPoints, visitorPoints);
    bool isHost = team.code == result.hostTeamCode;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTeamIcon(context, true, isHost),
              Expanded(
                flex: 8,
                child: Column(
                  children: <Widget>[
                    Text(result.hostName, textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1),
                    Text("$situation contre", textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).textTheme.subtitle1.color, fontSize: 15.0)),
                    Text(result.visitorName, textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle1)
                  ],
                ),
              ),
              _buildTeamIcon(context, false, isHost),
            ],
          ),
          Flex(direction: Axis.horizontal, children: <Widget>[_buildScore(context, hostPoints, visitorPoints, true, false, bigScoreSize)]),
        ],
      ),
    );
  }

  Widget _buildSetResult(BuildContext context, int setIndex) {
    if (setIndex > 5) return null;
    if (result.sets[setIndex - 1].hostPoint == null) return null;
    int hostPoints = result.sets[setIndex - 1].hostPoint;
    int visitorPoints = result.sets[setIndex - 1].visitorpoint;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Set n°" , style: Theme.of(context).textTheme.headline4,),
              _buildIndexIcon(context, setIndex)
            ],
          ),
        ),
        _buildScore(context, hostPoints, visitorPoints, false, false, scoreSize)
      ],
    );
  }

  Widget _buildPointSummaryResult(BuildContext context) {
    int hostPoints = result.totalPointsHost;
    int visitorPoints = result.totalPointsVisitor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: Text("Total des points", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline4,)
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                hostPoints.toString(),
                textAlign: TextAlign.right,
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
        ),
      ],
    );
  }

  Widget _buildIndexIcon(BuildContext context, int index) {
    Color color = Theme.of(context).accentColor;
    if (index <= 5) return Icon(icons[index - 1], color: color);
    else return null;
  }

  String _getSituation(int hostPoints, int visitorPoints) {
    int diff = hostPoints - visitorPoints;
    if (diff > 0) return "gagne";
    else if (diff < 0) return "perd";
    else return "fait une égalité";
  }

  Widget _buildScore(BuildContext context, int hostPoints, int visitorPoints, bool noColor, bool colorAll, double fontSize) {
    int diff = hostPoints - visitorPoints;
    bool isHost = team.code == result.hostTeamCode;
    Color hostColor, visitorColor;
    if (noColor) {
      hostColor = isHost ? hostColor : Theme.of(context).textTheme.bodyText2.color;
      visitorColor = isHost ? Theme.of(context).textTheme.bodyText2.color : visitorColor;
    } else if (diff > 0) {
      hostColor = isHost ? Colors.green : Colors.red;
      visitorColor = isHost ? Colors.green : Colors.red;
    } else if (diff < 0) {
      hostColor = isHost ? Colors.red : Colors.green;
      visitorColor = isHost ? Colors.red : Colors.green;
    } else {
      hostColor = Theme.of(context).textTheme.bodyText2.color;
      visitorColor = Theme.of(context).textTheme.bodyText2.color;
    }
    if (!colorAll) {
      hostColor = isHost ? hostColor : Theme.of(context).textTheme.bodyText2.color;
      visitorColor = isHost ? Theme.of(context).textTheme.bodyText2.color : visitorColor;
    }
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(hostPoints.toString(), textAlign: TextAlign.right, style: TextStyle(color: hostColor, fontSize: fontSize, fontWeight: FontWeight.w500)),
          Text(" - ", style: TextStyle(color: Theme.of(context).textTheme.bodyText2.color, fontSize: fontSize, fontWeight: FontWeight.w500)),
          Text(visitorPoints.toString(), style: TextStyle(color: visitorColor, fontSize: fontSize, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  Widget _buildTeamIcon(BuildContext context, bool left, bool isHost) {
    String imageUrl;
    if (left) imageUrl = isHost ? team.clubLogoUrl : tempPlaceholder;
    else imageUrl = isHost ? tempPlaceholder : team.clubLogoUrl;
    return Container(
      margin: left ? EdgeInsets.only(left: 16.0) : EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.color,
        borderRadius: BorderRadius.all(Radius.circular(30.0))
      ),
      width: 50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CachedNetworkImage(fit: BoxFit.fill, imageUrl: imageUrl),
      )
    );
  }
}