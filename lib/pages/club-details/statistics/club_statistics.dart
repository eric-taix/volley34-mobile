import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/graphs/arc.dart';
import 'package:v34/commons/stat_row.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team_stats.dart';
import 'package:v34/pages/club-details/blocs/club_stats.bloc.dart';
import 'package:v34/repositories/repository.dart';

class ClubStatistics extends StatefulWidget {
  final Club? club;

  ClubStatistics(this.club);

  @override
  _ClubStatisticsState createState() => _ClubStatisticsState();
}

class _ClubStatisticsState extends State<ClubStatistics> {
  ClubStatsBloc? _clubStatsBloc;

  @override
  void initState() {
    super.initState();
    _clubStatsBloc = ClubStatsBloc(repository: RepositoryProvider.of<Repository>(context))
      ..add(ClubStatsLoadEvent(
        clubCode: widget.club!.code,
      ));
  }

  @override
  void dispose() {
    super.dispose();
    _clubStatsBloc!.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _clubStatsBloc,
      builder: (context, state) {
        return SliverList(
          delegate: SliverChildListDelegate(
            [
              SizedBox(height: 40),
              StatRow(
                title: "Matchs gagnés",
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 100, maxHeight: 80),
                  child: ArcGraph(
                    lineWidth: 8,
                    minValue: 0,
                    maxValue: 1,
                    animationDuration: Duration(milliseconds: 1200),
                    value: state is ClubStatsLoadedState && state.matchesPlayed.total != 0
                        ? state.matchesPlayed.won.toDouble() / state.matchesPlayed.total
                        : 0.0,
                    valueBuilder: (value, _, max) => RichText(
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        text: state is ClubStatsLoadedState ? "${(value * state.matchesPlayed.total).toInt()}" : "0",
                        style: new TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyText2!.color,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                              text: " / ${state is ClubStatsLoadedState ? state.matchesPlayed.total : "0"}",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              StatRow(
                title: "Scores",
                child: BarChart(
                  computeSetsRepartitionChartData(
                      context, (state is ClubStatsLoadedState) ? state.setsDistribution : SetsDistribution()),
                  swapAnimationDuration: Duration(milliseconds: 600),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  BarChartData computeSetsRepartitionChartData(BuildContext context, SetsDistribution setsDistribution) {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
            fitInsideVertically: false,
            tooltipMargin: 0,
            tooltipBgColor: Colors.transparent,
            getTooltipItem: (barChartGroupData, index, barChartRodData, rodIndex) {
              return BarTooltipItem("${barChartRodData.y.toInt()}", Theme.of(context).textTheme.bodyText2!);
            }),
      ),
      alignment: BarChartAlignment.center,
      gridData: FlGridData(show: false),
      axisTitleData: FlAxisTitleData(show: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (_, __) => Theme.of(context).textTheme.bodyText1,
          margin: 12,
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
        rightTitles: SideTitles(
          showTitles: false,
        ),
        topTitles: SideTitles(
          margin: 2,
          reservedSize: 0,
          showTitles: false,
          getTitles: (value) => "${value.toInt()}",
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(setsDistribution),
    );
  }

  List<BarChartGroupData> showingGroups(SetsDistribution setsDistribution) => [
        makeGroupData(0, setsDistribution.s30!.toDouble(), setsDistribution.maxValue.toDouble(),
            barColor: Colors.green),
        makeGroupData(1, setsDistribution.s31!.toDouble(), setsDistribution.maxValue.toDouble(),
            barColor: Colors.greenAccent),
        makeGroupData(2, setsDistribution.s32!.toDouble(), setsDistribution.maxValue.toDouble(),
            barColor: Colors.yellowAccent),
        makeGroupData(3, setsDistribution.s23!.toDouble(), setsDistribution.maxValue.toDouble(),
            barColor: Colors.orangeAccent),
        makeGroupData(4, setsDistribution.s13!.toDouble(), setsDistribution.maxValue.toDouble(),
            barColor: Colors.deepOrangeAccent),
        makeGroupData(5, setsDistribution.s03!.toDouble(), setsDistribution.maxValue.toDouble(),
            barColor: Colors.redAccent),
      ];

  BarChartGroupData makeGroupData(
    int x,
    double y,
    double maxRodY, {
    Color barColor = Colors.white,
    double width = 15,
  }) {
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: y != 0 ? [0] : null,
      barRods: [
        BarChartRodData(
          y: y,
          colors: [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: maxRodY == 0 ? 10 : maxRodY,
            colors: [Theme.of(context).appBarTheme.color!],
          ),
        ),
      ],
    );
  }
}
