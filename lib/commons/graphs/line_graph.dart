import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineGraph extends StatelessWidget {
  List<Color> gradientColorsAboveCutOff = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  List<Color> gradientColorsBelowCutOff = [
    Colors.redAccent,
    Colors.orangeAccent,
  ];

  final List<double> results;
  final bool thumbnail;

  LineGraph(this.results, {this.thumbnail = false});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      mainData(context, results),
    );
  }

  LineChartData mainData(BuildContext context, List<double> results) {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
      ),
      axisTitleData: FlAxisTitleData(
        leftTitle: AxisTitle(
          showTitle: true,
          titleText: 'Sets',
          margin: 20,
          textStyle: Theme.of(context).textTheme.bodyText1,
          reservedSize: 0,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: false,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontSize: 12,
          ),
          getTitles: (value) {
            if ((!thumbnail && value.toInt() % (thumbnail ? 10 : 5) == 0) || (value.toInt() == 0))
              return "${value.toInt()}";
            else
              return "";
          },
          reservedSize: 0,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(show: false, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: (results.length - 1).toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: [
            ...results.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value.toDouble());
            })
          ],
          isCurved: true,
          colors: gradientColorsAboveCutOff,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: gradientColorsAboveCutOff.map((color) => color.withOpacity(0.3)).toList(),
            cutOffY: 0,
            applyCutOffY: true,
          ),
          aboveBarData: BarAreaData(
            show: true,
            colors: gradientColorsBelowCutOff.map((color) => color.withOpacity(0.3)).toList(),
            cutOffY: 0,
            applyCutOffY: true,
          ),
        ),
      ],
    );
  }
}
