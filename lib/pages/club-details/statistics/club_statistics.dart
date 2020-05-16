import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v34/commons/card/card.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/club-details/blocs/club_stats.bloc.dart';
import 'package:v34/pages/club-details/statistics/club_sets_repartition_chart.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/launch.dart';

class ClubStatistics extends StatefulWidget {
  final Club club;

  ClubStatistics(this.club);

  @override
  _ClubStatisticsState createState() => _ClubStatisticsState();
}

class _ClubStatisticsState extends State<ClubStatistics> {
  int _touchedIndex = -1;
  ClubStatsBloc _clubStatsBloc;

  @override
  void initState() {
    _clubStatsBloc = ClubStatsBloc(repository: RepositoryProvider.of<Repository>(context))
      ..add(ClubStatsLoadEvent(
        clubCode: widget.club.code,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BlocBuilder(
          bloc: _clubStatsBloc,
          builder: (context, state) {
            if (state is ClubStatsLoadedState || state is ClubStatsLoadingState) {
              return TitledCard(
                icon: FaIcon(FontAwesomeIcons.layerGroup, color: Theme
                    .of(context)
                    .textTheme
                    .headline6
                    .color),
                title: "Matchs",
                body: (state is ClubStatsLoadedState) ? SizedBox(
                  height: 120,
                  child: BarChart(
                    setsReparitionData(),
                    swapAnimationDuration: Duration(milliseconds: 2000),
                  )
                )  : null,
              );
            } else {
              return SizedBox();
            }
          }
        ),
        TitledCard(
          icon: FaIcon(FontAwesomeIcons.layerGroup, color: Theme.of(context).textTheme.headline6.color),
          title: "Matchs",
          body: SizedBox(
            height: 120,
            child: ClubSetsReparitionData(),
          ),
        ),
      ],
    );
  }

  BarChartData setsReparitionData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = '3-0';
                  break;
                case 1:
                  weekDay = '3-1';
                  break;
                case 2:
                  weekDay = '3-0';
                  break;
                case 3:
                  weekDay = '2-3';
                  break;
                case 4:
                  weekDay = '1-3';
                  break;
                case 5:
                  weekDay = '0-3';
                  break;
              }
              return BarTooltipItem(weekDay + '\n' + (rod.y - 1).toString(), TextStyle(color: Colors.yellow));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null && barTouchResponse.touchInput is! FlPanEnd && barTouchResponse.touchInput is! FlLongPressEnd) {
              _touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              _touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(color: Colors.white, fontSize: 14),
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
      barGroups: showingGroups(),
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(6, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 10, isTouched: i == _touchedIndex, barColor: Colors.green);
          case 1:
            return makeGroupData(1, 16, isTouched: i == _touchedIndex, barColor: Colors.greenAccent);
          case 2:
            return makeGroupData(2, 5, isTouched: i == _touchedIndex, barColor: Colors.yellowAccent);
          case 3:
            return makeGroupData(3, 7.5, isTouched: i == _touchedIndex, barColor: Colors.orangeAccent);
          case 4:
            return makeGroupData(4, 9, isTouched: i == _touchedIndex, barColor: Colors.deepOrangeAccent);
          case 5:
            return makeGroupData(5, 1, isTouched: i == _touchedIndex, barColor: Colors.redAccent);
          default:
            return null;
        }
      });

  BarChartGroupData makeGroupData(
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
          y: isTouched ? y + 1 : y,
          color: isTouched ? Colors.yellow : barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 30,
            color: Theme.of(context).primaryColor, //barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}

class Tile extends StatelessWidget {
  final Widget leadingIcon;
  final String title;
  final url;

  Tile({this.leadingIcon, this.title, this.url});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: url != null ? () => launchURL(url) : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: leadingIcon,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(title.trim(), overflow: TextOverflow.ellipsis, style: textTheme.bodyText2.copyWith()),
            ),
          ),
          if (url != null) FaIcon(FontAwesomeIcons.externalLinkAlt, size: 14, color: Theme.of(context).textTheme.bodyText2.color)
        ]),
      ),
    );
  }
}
