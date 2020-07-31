import 'package:flutter/material.dart';
import 'package:v34/commons/graphs/line_graph.dart';

class EvolutionWidget extends StatelessWidget {
  final String title;
  final List<double> evolution;

  static final double miniGraphHeight = 60;

  const EvolutionWidget({Key key, @required this.title, @required this.evolution}) : super(key: key);

  Widget _buildGraph(BuildContext context) {
    if (evolution.length > 1) {
      return FractionallySizedBox(
        widthFactor: 0.8,
        child: SizedBox(
          height: miniGraphHeight,
          child: LineGraph(
            evolution,
            showTitle: false,
          ),
        ),
      );
    } else if (evolution.length == 1) {
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
          Expanded(flex: 1, child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2)),
          Expanded(flex: 2, child: _buildGraph(context)),
        ],
      ),
    );
  }

}