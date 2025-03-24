import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/graphs/arc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/stat_row.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/matches_played.dart';
import 'package:v34/models/team_stats.dart';
import 'package:v34/pages/club-details/blocs/club_stats.bloc.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/analytics.dart';

class ClubStatistics extends StatefulWidget {
  final Club? club;

  ClubStatistics(this.club);

  @override
  _ClubStatisticsState createState() => _ClubStatisticsState();
}

class _ClubStatisticsState extends State<ClubStatistics> with RouteAwareAnalytics {
  ClubStatsBloc? _clubStatsBloc;
  ClubStatsState _appliedState = ClubStatsUninitializedState();

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
    _clubStatsBloc?.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClubStatsBloc, ClubStatsState>(
      bloc: _clubStatsBloc,
      listener: (context, state) {
        if (state is ClubStatsLoadedState) {
          setState(() {
            _appliedState = ClubStatsLoadedState(
                setsDistribution: SetsDistribution(),
                matchesPlayed: MatchesPlayed.empty(),
                homeMatches: MatchesPlayed.empty(),
                outsideMatches: MatchesPlayed.empty());
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                _appliedState = state;
              });
            });
          });
        }
      },
      builder: (context, state) {
        ClubStatsState clubState = _appliedState;
        return clubState is ClubStatsLoadedState
            ? SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SizedBox(height: 40),
                    StatRow(
                      title: "Victoires",
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 140, maxHeight: 100),
                        child: ArcGraph(
                          minValue: 0,
                          maxValue: 1,
                          animationDuration: Duration(milliseconds: 1200),
                          backgroundColor: Theme.of(context).canvasColor,
                          value: clubState.matchesPlayed.total != 0
                              ? clubState.matchesPlayed.won.toDouble() / clubState.matchesPlayed.total
                              : 0.0,
                          valueBuilder: (value, _, max) => RichText(
                            textAlign: TextAlign.center,
                            text: new TextSpan(
                              text: "${(value * clubState.matchesPlayed.total).toInt()}",
                              style: new TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                    text: " / ${clubState.matchesPlayed.total}",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                              ],
                            ),
                            textScaler: TextScaler.linear(1.0),
                          ),
                        ),
                      ),
                    ),
                    StatRow(
                      title: "Scores",
                      child: BarChart(
                        computeSetsRepartitionChartData(context, clubState.setsDistribution),
                        duration: Duration(milliseconds: 600),
                      ),
                    ),
                    StatRow(
                      title: "Domicile",
                      child: _buildPieChart(context, true, clubState.homeMatches),
                    ),
                    StatRow(
                      title: "Extérieur",
                      child: _buildPieChart(context, true, clubState.outsideMatches),
                    ),
                  ],
                ),
              )
            : SliverFillRemaining(child: Center(child: Loading()));
      },
    );
  }

  Widget _buildPieChart(BuildContext context, bool loaded, MatchesPlayed? matchesPlayed) {
    const double POSITION_OFFSET = 3.6;
    return PieChart(
      PieChartData(
        sectionsSpace: 8,
        centerSpaceRadius: 20,
        sections: [
          PieChartSectionData(
            radius: loaded && matchesPlayed != null ? (matchesPlayed.won > matchesPlayed.lost ? 15 : 8) : 8,
            value: loaded && matchesPlayed != null
                ? (matchesPlayed.won != 0 ? matchesPlayed.won.toDouble() : 0.000001)
                : 1,
            title: "${loaded && matchesPlayed != null ? "${matchesPlayed.won} Vict." : 0}",
            titlePositionPercentageOffset: loaded && matchesPlayed != null
                ? (matchesPlayed.won > matchesPlayed.lost ? POSITION_OFFSET - 1.3 : POSITION_OFFSET - 0.5)
                : POSITION_OFFSET - 0.5,
            titleStyle: Theme.of(context).textTheme.bodyLarge,
            color: loaded && matchesPlayed != null
                ? _getSectionColor(matchesPlayed.won, matchesPlayed.total)
                : Theme.of(context).colorScheme.primaryContainer,
          ),
          PieChartSectionData(
            radius: loaded && matchesPlayed != null ? (matchesPlayed.lost > matchesPlayed.won ? 15 : 8) : 8,
            value: loaded && matchesPlayed != null
                ? (matchesPlayed.lost != 0 ? matchesPlayed.lost.toDouble() : 0.000001)
                : 1,
            title: "${loaded && matchesPlayed != null ? "${matchesPlayed.lost} Déf." : 0}",
            titleStyle: Theme.of(context).textTheme.bodyLarge,
            titlePositionPercentageOffset: loaded && matchesPlayed != null
                ? (matchesPlayed.lost > matchesPlayed.won ? POSITION_OFFSET - 1.3 : POSITION_OFFSET - 0.5)
                : POSITION_OFFSET - 0.5,
            color: loaded && matchesPlayed != null
                ? _getSectionColor(matchesPlayed.lost, matchesPlayed.total, invert: true)
                : Theme.of(context).colorScheme.primaryContainer,
          ),
        ],
        borderData: FlBorderData(show: false),
      ),
      duration: Duration(milliseconds: 800),
    );
  }

  Color _getSectionColor(int nb, int total, {bool invert = false}) {
    const int NB_COLOR = 7;
    var colorGroup = total != 0 ? (((nb * 100) / total) / (100 / NB_COLOR)).ceil() : 4;
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
        return Colors.blueAccent;
      case 5:
        return Colors.greenAccent;
      case 6:
        return Colors.green;
    }
    if (colorGroup < 0) return Colors.redAccent;
    if (colorGroup >= NB_COLOR) return Colors.green;
    return Colors.grey;
  }

  BarChartData computeSetsRepartitionChartData(BuildContext context, SetsDistribution setsDistribution) {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          fitInsideVertically: false,
          tooltipMargin: 0,
          getTooltipColor: (_) => Colors.transparent,
          getTooltipItem: (barChartGroupData, index, barChartRodData, rodIndex) {
            return BarTooltipItem("${barChartRodData.toY.toInt()}", Theme.of(context).textTheme.bodyMedium!);
          },
        ),
      ),
      alignment: BarChartAlignment.center,
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          axisNameWidget: null,
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTitlesWidget: (double value, TitleMeta meta) {
              final TextStyle style = Theme.of(context).textTheme.bodyLarge!;
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
                case 6:
                  text = 'NT';
                  break;
                default:
                  text = '';
                  break;
              }
              return Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(text, style: style),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: null, // Pas de titre pour l'axe Y
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: AxisTitles(
          axisNameWidget: null,
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: AxisTitles(
          axisNameWidget: null,
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
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
        makeGroupData(6, setsDistribution.nt!.toDouble(), setsDistribution.maxValue.toDouble(), barColor: Colors.pink),
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
      showingTooltipIndicators: y != 0 ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: width,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxRodY == 0 ? 10 : maxRodY,
            color: Colors.black12,
          ),
        ),
      ],
    );
  }

  @override
  AnalyticsRoute get route => AnalyticsRoute.club_statistics;
}
