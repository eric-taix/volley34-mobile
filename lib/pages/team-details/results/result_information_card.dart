import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:v34/utils/extensions.dart';

class ResultInformationCard extends StatelessWidget {

  const ResultInformationCard({
    Key key,
    @required this.title,
    @required this.titleStyle,
    @required this.hostName,
    @required this.visitorName,
    @required this.hostPoints,
    @required this.visitorPoints,
    @required this.scoreColor,
    this.elevation,
    this.titleIcon
  }) : super(key: key);

  final String title;
  final TextStyle titleStyle;
  final Icon titleIcon;
  final String hostName;
  final String visitorName;
  final int hostPoints;
  final int visitorPoints;
  final Color scoreColor;
  final bool elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: (elevation != null && elevation) ? 8.0 : 0.0,
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.all(Radius.circular(18.0))),
        height: 130,
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardTheme.titleBackgroundColor(context), borderRadius: BorderRadius.vertical(top: Radius.circular(18.0))),
              child: Padding(
                padding: EdgeInsets.only(top: 7, bottom: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(title, style: titleStyle, textAlign: TextAlign.center,),
                    titleIcon ?? Container(),
                  ],
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Text(hostName, textAlign: TextAlign.center, style: TextStyle(fontSize: 15,
                          fontWeight: hostPoints >= visitorPoints ? FontWeight.bold : FontWeight.normal),),
                    ),
                  ),
                  Expanded(
                    child: Text(
                        "$hostPoints - $visitorPoints",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 35.0, fontWeight: FontWeight.bold, color: scoreColor)
                    ),
                  ),
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      child: Text(visitorName, textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, fontWeight: visitorPoints >= hostPoints ? FontWeight.bold : FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}