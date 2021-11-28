import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/graphs/arc.dart';
import 'package:v34/commons/stat_row.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/matches_played.dart';
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
              StatRow(
                title: "A domicile",
                child: _buildPieChart(
                    context, state is ClubStatsLoadedState, state is ClubStatsLoadedState ? state.homeMatches : null),
              ),
              StatRow(
                title: "A l'extérieur",
                child: _buildPieChart(context, state is ClubStatsLoadedState,
                    state is ClubStatsLoadedState ? state.outsideMatches : null),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPieChart(BuildContext context, bool loaded, MatchesPlayed? matchesPlayed) {
    const double POSITION_OFFSET = 3.2;
    return AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sectionsSpace: 8,
          centerSpaceRadius: 20,
          sections: [
            PieChartSectionData(
              radius: 15,
              value: loaded ? matchesPlayed!.won.toDouble() : 1,
              title: "${loaded ? matchesPlayed!.won : 0} Vict.",
              titlePositionPercentageOffset: POSITION_OFFSET - 0.8,
              titleStyle: Theme.of(context).textTheme.bodyText2,
              color: loaded
                  ? _getSectionColor(matchesPlayed!.won, matchesPlayed.total)
                  : Theme.of(context).colorScheme.primaryVariant,
            ),
            PieChartSectionData(
              radius: 8,
              value: loaded ? matchesPlayed!.lost.toDouble() : 1,
              title: "${loaded ? matchesPlayed!.lost : 0} Déf.",
              titleStyle: Theme.of(context).textTheme.bodyText2,
              titlePositionPercentageOffset: POSITION_OFFSET + 0.3,
              color: loaded
                  ? _getSectionColor(matchesPlayed!.lost, matchesPlayed.total, invert: true)
                  : Theme.of(context).colorScheme.primaryVariant,
            ),
          ],
          borderData: FlBorderData(show: false),
        ),
        swapAnimationDuration: Duration(milliseconds: 800),
      ),
    );
  }

  Color _getSectionColor(int nb, int total, {bool invert = false}) {
    const int NB_COLOR = 6;
    var colorGroup = (((nb * 100) / total) / (100 / NB_COLOR)).ceil();
    if (invert) {
      colorGroup = NB_COLOR - 1 - colorGroup;
    }
    switch (colorGroup) {
      case 0:
        return Colors.redAccent;
      case 1:
        return Colors.deepOrangeAccent;
      case 2:
        return Colors.orangeAccent;
      case 3:
        return Colors.yellowAccent;
      case 4:
        return Colors.greenAccent;
      case 5:
        return Colors.green;
    }
    return Colors.grey;
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
            colors: [Theme.of(context).appBarTheme.backgroundColor!],
          ),
        ),
      ],
    );
  }
}
