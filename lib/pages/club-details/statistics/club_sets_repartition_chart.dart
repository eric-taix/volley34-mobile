import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ClubSetsReparitionData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BarChart(
      buildData(context),
      swapAnimationDuration: Duration(milliseconds: 2000),
    );
  }

  BarChartData buildData(BuildContext context) {
    return BarChartData(
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              TextStyle style = TextStyle(color: Colors.white, fontSize: 14);
              String text;
              switch (value.toInt()) {
                case 0:
                  text = '3-0';
                  break;
                case 1:
                  text = '3-1';
                  break;
                case 2:
                  text = '3-2';
                  break;
                case 3:
                  text = '2-3';
                  break;
                case 4:
                  text = '1-3';
                  break;
                case 5:
                  text = '0-3';
                  break;
                default:
                  text = '';
                  break;
              }
              return Text(text, style: style);
            },
            reservedSize: 16,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(context),
      gridData: FlGridData(show: false),
    );
  }

  List<BarChartGroupData>? showingGroups(BuildContext context) => [
        makeGroupData(context, 0, 10, barColor: Colors.green),
        makeGroupData(context, 1, 16, barColor: Colors.greenAccent),
        makeGroupData(context, 2, 5, barColor: Colors.yellowAccent),
        makeGroupData(context, 3, 7.5, barColor: Colors.orangeAccent),
        makeGroupData(context, 4, 9, barColor: Colors.deepOrangeAccent),
        makeGroupData(context, 5, 1, barColor: Colors.redAccent)
      ];

  BarChartGroupData makeGroupData(
    BuildContext context,
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 15,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 30,
            color: Theme.of(context).primaryColor, //barBackgroundColor,
          ),
        ),
      ],
    );
  }
}
