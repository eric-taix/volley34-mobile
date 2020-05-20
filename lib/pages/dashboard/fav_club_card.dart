import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:v34/commons/cards/rounded_title_card.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/models/club.dart';
import 'package:v34/pages/dashboard/blocs/club_stats.dart';
import 'package:v34/repositories/repository.dart';

class FavoriteClubCard extends StatefulWidget {
  final Club club;
  final GestureTapCallback onTap;

  FavoriteClubCard(this.club, this.onTap);

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
  void dispose() {
    _clubStatsBloc.close();
    super.dispose();
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
    return RoundedTitledCard(
      title: widget.club.shortName,
      heroTag: "hero-logo-${widget.club.code}",
      logoUrl: widget.club.logoUrl,
      onTap: widget.onTap,
      body: BlocListener(
          listener: (context, state) {
            if (state is ClubStatsLoadedState) {
              _updateState(state.wonMatches, state.totalMatches);
            }
          },
          bloc: _clubStatsBloc,
          child: BlocBuilder(
            bloc: _clubStatsBloc,
            builder: (context, state) {
              return _buildCardContent(context, state);
            },
          ),
      ),
    );
    /*Stack(
      children: <Widget>[
        TitledCard(
          icon: SizedBox(width: 10),
          title:
          onTap: widget.onTap,
          body: BlocListener(
            listener: (context, state) {
              if (state is ClubStatsLoadedState) {
                _updateState(state.wonMatches, state.totalMatches);
              }
            },
            bloc: _clubStatsBloc,
            child: BlocBuilder(
              bloc: _clubStatsBloc,
              builder: (context, state) {
                return _buildCardContent(context, state);
              },
            ),
          ),
        ),
        Positioned(
          top: 17,
          child: Hero(
            tag: "hero-logo-${widget.club.code}",
            child: RoundedNetworkImage(
              40,
              widget.club.logoUrl,
              circleColor: TinyColor(Theme.of(context).cardTheme.color).isDark()
                  ? TinyColor(Theme.of(context).cardTheme.color).lighten().color
                  : TinyColor(Theme.of(context).cardTheme.color).darken().color,
            ),
          ),
        )
      ],
    );*/
  }

  Widget _buildCardContent(BuildContext context, ClubStatsState state) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("La semaine dernière", style: Theme.of(context).textTheme.bodyText1),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "Matchs gagnés",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Stack(alignment: Alignment.center, children: [
                  AnimatedCircularChart(
                    key: _chartKey,
                    duration: Duration(milliseconds: 1000),
                    edgeStyle: SegmentEdgeStyle.round,
                    size: const Size(80.0, 80.0),
                    initialChartData: _data,
                    chartType: CircularChartType.Radial,
                    holeRadius: 26,
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
                              color: Theme.of(context).textTheme.bodyText2.color,
                            ),
                            children: <TextSpan>[
                              new TextSpan(text: ' / ${state.totalMatches}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                            ],
                          ),
                        )
                      : Loading.small()
                ]),
              ],
            ),
          ),
          Text("Cette semaine", style: Theme.of(context).textTheme.bodyText1),
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
                          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                          children: [new TextSpan(text: " / y matchs à domicile", style: Theme.of(context).textTheme.bodyText2)])),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
