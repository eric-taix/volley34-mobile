import 'package:flutter/material.dart';
import 'package:v34/commons/graphs/arc.dart';

class StatisticsWidget extends StatelessWidget {
  final String title;
  final int wonPoints;
  final int lostPoints;

  static final double miniGraphSize = 60;

  const StatisticsWidget({Key key, @required this.wonPoints, @required this.lostPoints, @required this.title}) : super(key: key);

  Widget _buildRatio(BuildContext context) {
    return RichText(
      textScaleFactor: 1.2,
      textAlign: TextAlign.center,
      text: new TextSpan(
        text: wonPoints.toString(),
        style: new TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyText2.color,
        ),
        children: <TextSpan>[
          new TextSpan(text: ' / ${wonPoints + lostPoints}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildGraph(BuildContext context) {
    return SizedBox(
      height: miniGraphSize,
      width: miniGraphSize,
      child: ArcGraph(
        minValue: 0,
        maxValue: (wonPoints + lostPoints).toDouble(),
        value: wonPoints.toDouble(),
        lineWidth: 6,
        leftTitle: LeftTitle(
          show: true,
          text: "",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        valueBuilder: (value, minValue, maxValue) {
          var percentage = maxValue != 0 ? "${(((value - minValue) / maxValue) * 100).toStringAsFixed(1)}%" : "- -";
          return Text(percentage);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2)),
          Expanded(child: _buildRatio(context)),
          Expanded(child: _buildGraph(context)),
        ],
      ),
    );
  }
}