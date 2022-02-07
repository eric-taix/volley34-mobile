import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/cards/rounded_title_card.dart';
import 'package:v34/commons/graphs/arc.dart';
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
  static const int STAT_DAYS = 14;

  ClubStatsBloc? _clubStatsBloc;
  @override
  void initState() {
    super.initState();
    _clubStatsBloc = ClubStatsBloc(RepositoryProvider.of<Repository>(context))
      ..add(ClubStatsLoadEvent(widget.club.code, days: STAT_DAYS));
  }

  @override
  void dispose() {
    _clubStatsBloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedTitledCard(
      title: widget.club.shortName,
      heroTag: "hero-logo-${widget.club.code}",
      logoUrl: widget.club.logoUrl,
      onTap: widget.onTap,
      body: BlocBuilder(
        bloc: _clubStatsBloc,
        builder: (context, dynamic state) => _buildCardContent(context, state),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, ClubStatsState state) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Victoires", style: Theme.of(context).textTheme.bodyText1),
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      "Les $STAT_DAYS derniers jours",
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 100, maxHeight: 210),
                  child: ArcGraph(
                    minValue: 0,
                    maxValue: 1,
                    animationDuration: Duration(milliseconds: 1200),
                    value: state is ClubStatsLoadedState && state.totalMatches != 0
                        ? state.wonMatches.toDouble() / state.totalMatches
                        : 0.0,
                    valueBuilder: (value, _, max) => state is ClubStatsLoadedState
                        ? RichText(
                            textScaleFactor: 1.0,
                            textAlign: TextAlign.center,
                            text: new TextSpan(
                              text: "${(value * state.totalMatches).toInt()}",
                              style: new TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyText2!.color,
                              ),
                              children: <TextSpan>[
                                new TextSpan(
                                    text: ' / ${state.totalMatches}',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
                              ],
                            ),
                          )
                        : Loading.small(),
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
