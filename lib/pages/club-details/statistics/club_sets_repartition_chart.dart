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
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (_, __) => TextStyle(color: Colors.white, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return '3-0';
              case 1:
                return '3-1';
              case 2:
                return '3-2';
              case 3:
                return '2-3';
              case 4:
                return '1-3';
              case 5:
                return '0-3';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(context) as List<BarChartGroupData>?,
    );
  }

  List<BarChartGroupData?> showingGroups(BuildContext context) => List.generate(6, (i) {
        switch (i) {
          case 0:
            return makeGroupData(context, 0, 10, barColor: Colors.green);
          case 1:
            return makeGroupData(context, 1, 16, barColor: Colors.greenAccent);
          case 2:
            return makeGroupData(context, 2, 5, barColor: Colors.yellowAccent);
          case 3:
            return makeGroupData(context, 3, 7.5, barColor: Colors.orangeAccent);
          case 4:
            return makeGroupData(context, 4, 9, barColor: Colors.deepOrangeAccent);
          case 5:
            return makeGroupData(context, 5, 1, barColor: Colors.redAccent);
          default:
            return null;
        }
      });

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
          y: y,
          colors: [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 30,
            colors: [Theme.of(context).primaryColor], //barBackgroundColor,
          ),
        ),
      ],
    );
  }
}
