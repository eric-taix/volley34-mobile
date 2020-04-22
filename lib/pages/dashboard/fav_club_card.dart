import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:v34/commons/rounded_network_image.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/dashboard/blocs/club_stats.dart';
import 'package:v34/repositories/repository.dart';

class FavoriteClubCard extends StatefulWidget {
  final Club club;

  FavoriteClubCard(this.club);

  @override
  _FavoriteClubCardState createState() => _FavoriteClubCardState();
}

class _FavoriteClubCardState extends State<FavoriteClubCard> {
  ClubStatsBloc _clubStatsBloc;
  List<CircularStackEntry> _data;

  final GlobalKey<AnimatedCircularChartState> _chartKey = new GlobalKey<AnimatedCircularChartState>();

  void _updateState(int wonMatches, int totalMatches) {
    setState(() {
      _chartKey.currentState.updateData([
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(0.0, Theme.of(context).accentColor, rankKey: "none"),
            new CircularSegmentEntry(wonMatches.toDouble(), Colors.green, rankKey: "win"),
            new CircularSegmentEntry(totalMatches - wonMatches.toDouble(), Colors.red, rankKey: "lost"),
          ],
        ),
      ]);
    });
  }

  @override
  void initState() {
    super.initState();
    _clubStatsBloc = ClubStatsBloc(RepositoryProvider.of<Repository>(context))..add(ClubStatsLoadEvent(widget.club.code));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _data = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(10, Theme.of(context).accentColor, rankKey: "none"),
          new CircularSegmentEntry(0.toDouble(), Colors.green, rankKey: "win"),
          new CircularSegmentEntry(0.toDouble(), Colors.red, rankKey: "lost"),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
        height: 300,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Card(
            child: InkWell(
              onTap: () => print("Tapped"),
              child: BlocListener(
                  listener: (context, state) {
                    if (state is ClubStatsLoadedState) {
                      _updateState(state.wonMatches, state.totalMatches);
                    }
                  },
                  bloc: _clubStatsBloc,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0, right: 8.0, bottom: 10.0, left: 48.0),
                          child: Text(
                            widget.club.shortName,
                            style: Theme.of(context).textTheme.body1.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder(
                            bloc: _clubStatsBloc,
                            builder: (context, state) {
                              return _buildCardContent(context, state);
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
      Padding(padding: const EdgeInsets.only(left: 8.0, bottom: 140), child: RoundedNetworkImage(40, widget.club.logoUrl)),
    ]);
  }

  Widget _buildCardContent(BuildContext context, ClubStatsState state) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Derniers matchs", style: Theme.of(context).textTheme.body2),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text("Matchs gagnés", style: Theme.of(context).textTheme.body1,),
                ),
                Stack(alignment: Alignment.center, children: [
                  AnimatedCircularChart(
                    key: _chartKey,
                    duration: Duration(milliseconds: 1000),
                    edgeStyle: SegmentEdgeStyle.round,
                    size: const Size(60.0, 60.0),
                    initialChartData: _data,
                    chartType: CircularChartType.Radial,
                  ),
                  (state is ClubStatsLoadedState)
                      ? RichText(
                    textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          text: new TextSpan(
                            text: "${state.wonMatches}",
                            style: new TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).textTheme.body1.color,
                            ),
                            children: <TextSpan>[
                              new TextSpan(text: ' / ${state.totalMatches}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                            ],
                          ),
                        )
                      : Text("?", style: TextStyle(fontSize: 12))
                ]),
              ],
            ),
          ),
          Text("Cette semaine", style: Theme.of(context).textTheme.body2),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: RichText(
                    maxLines: 2,
                    textAlign: TextAlign.right,
                    textScaleFactor: 1.1,
                    text: TextSpan(
                      text: "X",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold
                      ),
                      children: [
                        new TextSpan(text: " / y matchs à domicile", style: Theme.of(context).textTheme.body1)
                      ]
                    )
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
