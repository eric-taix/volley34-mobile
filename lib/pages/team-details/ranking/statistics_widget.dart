import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:tinycolor/tinycolor.dart';

class StatisticsWidget extends StatelessWidget {
  final String title;
  final double width;
  final int wonPoints;
  final int lostPoints;

  const StatisticsWidget({Key key, @required this.wonPoints, @required this.lostPoints, @required this.title, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = this.width ?? 140;
    double radius = width / 5;
    return Container(
      height: width + 30,
      width: width,
      decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.all(Radius.circular(9.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: TinyColor(Theme.of(context).textTheme.bodyText1.color).darken(10).color,
                    fontSize: 18,
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.w300
                )
              )
            )
          ),
          Expanded(
            flex: 2,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                RichText(
                  textScaleFactor: 1.0,
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
                ),
                AnimatedCircularChart(
                  duration: Duration(milliseconds: 1000),
                  edgeStyle: SegmentEdgeStyle.round,
                  size: Size(50.0 + radius*2, 50.0 + radius*2),
                  initialChartData: [
                    CircularStackEntry([
                      CircularSegmentEntry(lostPoints.toDouble(), Colors.redAccent, rankKey: "lost"),
                      CircularSegmentEntry(wonPoints.toDouble(), Colors.greenAccent, rankKey: "win"),
                    ])
                  ],
                  chartType: CircularChartType.Radial,
                  holeRadius: radius,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}