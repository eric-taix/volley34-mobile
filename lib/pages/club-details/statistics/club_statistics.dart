import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v34/commons/cards/titled_card.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team_stats.dart';
import 'package:v34/pages/club-details/blocs/club_stats.bloc.dart';
import 'package:v34/repositories/repository.dart';

class ClubStatistics extends StatefulWidget {
  final Club club;

  ClubStatistics(this.club);

  @override
  _ClubStatisticsState createState() => _ClubStatisticsState();
}

class _ClubStatisticsState extends State<ClubStatistics> {
  ClubStatsBloc _clubStatsBloc;

  @override
  void initState() {
    super.initState();
    _clubStatsBloc =
        ClubStatsBloc(repository: RepositoryProvider.of<Repository>(context))
          ..add(ClubStatsLoadEvent(
            clubCode: widget.club.code,
          ));
  }

  @override
  void dispose() {
    super.dispose();
    _clubStatsBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        BlocBuilder(
            cubit: _clubStatsBloc,
            builder: (context, state) {
              return TitledCard(
                  icon: FaIcon(FontAwesomeIcons.layerGroup,
                      color: Theme.of(context).textTheme.headline6.color),
                  title: "Résultats",
                  body: SizedBox(
                      height: 120,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: BarChart(
                                computeSetsRepartitionChartData(
                                    context,
                                    (state is ClubStatsLoadedState)
                                        ? state.setsDistribution
                                        : SetsDistribution()),
                                swapAnimationDuration:
                                    Duration(milliseconds: 2000),
                              ),
                            ),
                            if (state is ClubStatsLoadingState) Loading(),
                          ],
                        ),
                      )));
            })
      ]),
    );
  }

  BarChartData computeSetsRepartitionChartData(
      BuildContext context, SetsDistribution setsDistribution) {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: Theme.of(context).textTheme.bodyText1,
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
      barGroups: showingGroups(setsDistribution),
    );
  }

  List<BarChartGroupData> showingGroups(SetsDistribution setsDistribution) => [
        makeGroupData(0, setsDistribution.s30.toDouble(),
            setsDistribution.maxValue.toDouble(),
            barColor: Colors.green),
        makeGroupData(1, setsDistribution.s31.toDouble(),
            setsDistribution.maxValue.toDouble(),
            barColor: Colors.greenAccent),
        makeGroupData(2, setsDistribution.s32.toDouble(),
            setsDistribution.maxValue.toDouble(),
            barColor: Colors.yellowAccent),
        makeGroupData(3, setsDistribution.s23.toDouble(),
            setsDistribution.maxValue.toDouble(),
            barColor: Colors.orangeAccent),
        makeGroupData(4, setsDistribution.s13.toDouble(),
            setsDistribution.maxValue.toDouble(),
            barColor: Colors.deepOrangeAccent),
        makeGroupData(5, setsDistribution.s03.toDouble(),
            setsDistribution.maxValue.toDouble(),
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
      barRods: [
        BarChartRodData(
          y: y,
          color: barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: maxRodY,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}
