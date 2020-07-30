import 'package:flutter/material.dart';
import 'package:v34/commons/graphs/line_graph.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';

class EvolutionWidget extends StatelessWidget {
  final String title;
  final Team team;
  final List<MatchResult> results;

  static final double miniGraphHeight = 60;

  const EvolutionWidget({Key key, @required this.title, @required this.results, @required this.team}) : super(key: key);

  Widget _buildGraph(BuildContext context) {
    results.sort((result1, result2) => result1.matchDate.compareTo(result2.matchDate));
    if (results.length > 1) {
      return FractionallySizedBox(
        widthFactor: 0.8,
        child: SizedBox(
          height: miniGraphHeight,
          child: LineGraph(
            TeamBloc.computePointsDiffs(results, team.code),
            showTitle: false,
          ),
        ),
      );
    } else if (results.length == 1) {
      return Text("Un seul match joué.", textAlign: TextAlign.center);
    } else {
      return Text("Aucun match joué.", textAlign: TextAlign.center);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(flex: 1, child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.subtitle2)),
          Expanded(flex: 2, child: _buildGraph(context)),
        ],
      ),
    );
  }

}