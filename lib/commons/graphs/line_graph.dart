import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineGraph extends StatelessWidget {
  final List<Color> gradientColorsAboveCutOff = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];
  final List<Color> gradientColorsBelowCutOff = [
    Colors.redAccent,
    Colors.orangeAccent,
  ];

  final List<double?> results;
  final bool thumbnail;
  final bool showTitle;
  final DateTime? startDate;
  final DateTime? endDate;

  LineGraph(List<double?> results, {this.thumbnail = false, this.showTitle = true, this.startDate, this.endDate})
      : this.results = results.toList()..insert(0, 0.0);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      mainData(context, results),
    );
  }

  LineChartData mainData(BuildContext context, List<double?> results) {
    DateFormat _dateFormat = DateFormat('dd MMM', "FR");
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
      ),
      axisTitleData: FlAxisTitleData(
        leftTitle: AxisTitle(
          showTitle: showTitle,
          titleText: 'Sets',
          margin: 20,
          textStyle: Theme.of(context).textTheme.bodyText1,
          reservedSize: 0,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: startDate != null && endDate != null,
          reservedSize: 0,
          getTextStyles: (_, __) => TextStyle(color: Theme.of(context).textTheme.bodyText1!.color, fontSize: 10),
          getTitles: (value) {
            if (value.toInt() == 0) return _dateFormat.format(startDate!).toUpperCase();
            if (value.toInt() == results.length - 1) return _dateFormat.format(endDate!).toUpperCase();
            if (value.toInt() == results.length / 2)
              return _dateFormat
                  .format(startDate!.add(Duration(seconds: endDate!.difference(startDate!).inSeconds ~/ 2)))
                  .toUpperCase();
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: !thumbnail,
          getTextStyles: (_, __) =>
              TextStyle(color: Theme.of(context).textTheme.bodyText2!.color, fontSize: 10, fontWeight: FontWeight.bold),
          getTitles: (value) {
            if (value.floor().toDouble() == value)
              return "${value.toInt()}";
            else
              return "";
          },
          checkToShowTitle:
              (double minValue, double maxValue, SideTitles sideTitles, double appliedInterval, double value) {
            return (value == minValue || value == maxValue || value == 0);
          },
          reservedSize: 10,
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
              return FlSpot(entry.key.toDouble(), entry.value!.toDouble());
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
