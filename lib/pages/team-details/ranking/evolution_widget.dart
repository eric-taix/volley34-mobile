import 'package:flutter/material.dart';
import 'package:v34/commons/graphs/line_graph.dart';

class EvolutionWidget extends StatelessWidget {
  final String title;
  final List<double> evolution;

  /// If startDate and endDate are provided then the widget display some dates
  final DateTime? startDate;
  final DateTime? endDate;

  final double miniGraphHeight;

  const EvolutionWidget({Key? key, required this.title, required this.evolution, this.startDate, this.endDate})
      : this.miniGraphHeight = (startDate != null && endDate != null) ? 80 : 60,
        super(key: key);

  Widget _buildGraph(BuildContext context) {
    if (evolution.length > 1) {
      return SizedBox(
        height: miniGraphHeight,
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: SizedBox(
            child: LineGraph(
              evolution,
              showTitle: false,
              startDate: startDate,
              endDate: endDate,
              thumbnail: true,
            ),
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
          Expanded(
              flex: 1, child: Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1)),
          Expanded(flex: 2, child: _buildGraph(context)),
        ],
      ),
    );
  }
}
