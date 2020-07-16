import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    this.icon
  }) : super(key: key);

  final String title;
  final TextStyle titleStyle;
  final Icon icon;
  final String hostName;
  final String visitorName;
  final int hostPoints;
  final int visitorPoints;
  final Color scoreColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      child: Container(
        decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.all(Radius.circular(5.0))),
        height: 130,
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Row(
                  children: <Widget>[
                    (icon != null) ? Padding(child: icon, padding: EdgeInsets.only(left: 10)): Container(),
                    Expanded(child: Text(title, style: titleStyle, textAlign: TextAlign.center,)),
                  ],
                )
            ),
            Row(
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
            )
          ],
        ),
      ),
    );
  }
}