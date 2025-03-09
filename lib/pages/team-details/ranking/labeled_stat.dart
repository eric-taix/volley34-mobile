import 'package:flutter/material.dart';
import 'package:v34/pages/team-details/ranking/team_ranking.dart';

class LabeledStat extends StatelessWidget {
  final String title;
  final Widget child;

  const LabeledStat({Key? key, required this.title, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: TEAM_RANKING_LEFT_PADDING),
                child: Text(title, textAlign: TextAlign.start, style: Theme.of(context).textTheme.bodyLarge),
              )),
          Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 28.0, left: 18),
                child: child,
              )),
        ],
      ),
    );
  }
}
