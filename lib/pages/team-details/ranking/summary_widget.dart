import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/pages/team-details/ranking/team_ranking.dart';

class SummaryWidget extends StatelessWidget {
  final String title;
  final RankingTeamSynthesis teamStats;

  const SummaryWidget({Key? key, required this.title, required this.teamStats}) : super(key: key);

  List<BarChartGroupData>? showingGroups(BuildContext context, RankingTeamSynthesis teamStats) {
    return List.generate(7, (i) {
      switch (i) {
        case 0:
          return makeGroupData(
              context, 0, ((teamStats.nbSets30 ?? 0) + (teamStats.nbSetsF30 ?? 0)).toDouble(), Colors.green, teamStats);
        case 1:
          return makeGroupData(context, 1, teamStats.nbSets31?.toDouble() ?? 0, Colors.greenAccent, teamStats);
        case 2:
          return makeGroupData(context, 2, teamStats.nbSets32?.toDouble() ?? 0, Colors.yellowAccent, teamStats);
        case 3:
          return makeGroupData(context, 3, teamStats.nbSets23?.toDouble() ?? 0, Colors.orangeAccent, teamStats);
        case 4:
          return makeGroupData(context, 4, teamStats.nbSets13?.toDouble() ?? 0, Colors.deepOrangeAccent, teamStats);
        case 5:
          return makeGroupData(context, 5, ((teamStats.nbSets03 ?? 0) + (teamStats.nbSetsF03 ?? 0)).toDouble(),
              Colors.redAccent, teamStats);
        default:
          return makeGroupData(
              context, 6, teamStats.nbSetsMI?.toDouble() ?? 0, Theme.of(context).colorScheme.secondary, teamStats);
      }
    });
  }

  Widget _buildGraph(BuildContext context) {
    final maxValue = [
      teamStats.nbSets30,
      teamStats.nbSets31,
      teamStats.nbSets32,
      teamStats.nbSets23,
      teamStats.nbSets13,
      teamStats.nbSets03,
      teamStats.nbSetsMI
    ].whereType<int>().reduce(max);
    return SizedBox(
      height: 80,
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: BarChart(
          BarChartData(
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => Colors.transparent,
                tooltipPadding: const EdgeInsets.only(bottom: 2),
                tooltipMargin: 0,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return rod.toY.toInt() == 0
                      ? null
                      : BarTooltipItem(
                          "${rod.toY.toInt()}",
                          TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium!.color,
                              fontSize: 10,
                              fontFamily: "Raleway",
                              fontWeight: FontWeight.bold),
                        );
                },
              ),
            ),
            maxY: maxValue.toDouble(),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta meta) {
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
                        text = 'NT';
                        break;
                    }
                    return Text(
                      text,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 12),
                    );
                  },
                  reservedSize: 18,
                ),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            barGroups: showingGroups(context, teamStats),
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
      BuildContext context, int x, double y, Color barColor, RankingTeamSynthesis teamStats) {
    int countMatches = ((teamStats.wonMatches ?? 0) + (teamStats.lostMatches ?? 0));
    if (countMatches == 0) {
      countMatches = 1;
    }
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: const [0],
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: 12,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: countMatches.toDouble(),
            color: Theme.of(context).cardTheme.color!.withOpacity(0.1),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: TEAM_RANKING_LEFT_PADDING),
                child: Text(title, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyLarge),
              )),
          Expanded(flex: 2, child: _buildGraph(context)),
        ],
      ),
    );
  }
}
