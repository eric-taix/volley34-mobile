import "dart:math";

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineGraph extends StatefulWidget {
  final List<double> results;
  final bool thumbnail;
  final bool showTitle;
  final DateTime? startDate;
  final DateTime? endDate;
  final String title;

  LineGraph(List<double> results,
      {this.thumbnail = false, this.showTitle = true, this.startDate, this.endDate, this.title = "Sets"})
      : this.results = results.toList()..insert(0, 0.0);

  @override
  State<LineGraph> createState() => _LineGraphState();
}

class _LineGraphState extends State<LineGraph> {
  late List<double> _results;
  late double _maxY;
  late double _minY;

  final List<Color> gradientColorsAboveCutOff = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  final List<Color> gradientColorsBelowCutOff = [
    Colors.redAccent,
    Colors.orangeAccent,
  ];

  @override
  void initState() {
    super.initState();
    _results = List.generate(widget.results.length > 1 ? widget.results.length : 2, (_) => 0.0);
    _maxY = widget.results.reduce(max);
    _minY = widget.results.reduce(min);

    if (widget.results.length > 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 400), () {
          if (mounted)
            setState(() {
              _results = widget.results;
            });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0, top: 8),
          child: LineChart(
            mainData(context, _results),
            duration: Duration(milliseconds: 600),
          ),
        ),
        if (widget.thumbnail)
          Positioned(
            bottom: 0,
            child: Transform.rotate(
              angle: -pi / 2,
              alignment: Alignment.bottomLeft,
              child: Text('Diff. Sets', style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
      ],
    );
  }

  LineChartData mainData(BuildContext context, List<double?> results) {
    DateFormat _dateFormat = DateFormat('dd MMM', "FR");
    return LineChartData(
      maxY: _maxY,
      minY: _minY,
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: widget.startDate != null && widget.endDate != null,
            reservedSize: 22, // Augmenté pour plus d'espace
            getTitlesWidget: (value, meta) {
              final style = TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color, fontSize: 10);
              if (value.toInt() == 0) {
                return Text(_dateFormat.format(widget.startDate!).toUpperCase(), style: style);
              }
              if (value.toInt() == results.length - 1) {
                return Text(_dateFormat.format(widget.endDate!).toUpperCase(), style: style);
              }
              if (value.toInt() == results.length ~/ 2) {
                return Text(
                    _dateFormat
                        .format(widget.startDate!
                            .add(Duration(seconds: widget.endDate!.difference(widget.startDate!).inSeconds ~/ 2)))
                        .toUpperCase(),
                    style: style);
              }
              return const SizedBox.shrink();
            },
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              // Afficher uniquement les valeurs entières, min, max et zéro
              if (value == _minY || value == _maxY || value == 0 || value.floor() == value) {
                return Text(
                  "${value.toInt()}",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: 10, fontWeight: FontWeight.bold),
                );
              }
              return const SizedBox.shrink();
            },
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 5,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() % 5 == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("${value.toInt()}",
                          style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    );
                  }
                  return const SizedBox.shrink();
                })),
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
          gradient: LinearGradient(
            colors: gradientColorsAboveCutOff,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColorsAboveCutOff.map((color) => color.withValues(alpha: 0.3)).toList(),
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            cutOffY: 0,
            applyCutOffY: true,
          ),
          aboveBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColorsBelowCutOff.map((color) => color.withValues(alpha: 0.3)).toList(),
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            cutOffY: 0,
            applyCutOffY: true,
          ),
        ),
      ],
    );
  }
}
