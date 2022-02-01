import 'package:flutter/material.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/scorer/score.model.dart';
import 'package:v34/pages/scorer/scorer_actions.widget.dart';
import 'package:v34/pages/scorer/scorer_header.widget.dart';
import 'package:v34/utils/analytics.dart';

class Scorer extends StatefulWidget {
  final Team team1;
  final Team team2;

  const Scorer({Key? key, required this.team1, required this.team2}) : super(key: key);

  @override
  _ScorerState createState() => _ScorerState();
}

class _ScorerState extends State<Scorer> with RouteAwareAnalytics {
  final Score _score = Score();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => null,
        ),
        title: ScorerHeader(team1: widget.team1, team2: widget.team2, score: _score),
      ),
      body: Container(
          color: Theme.of(context).canvasColor,
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: ScorerActions(score: _score),
            ),
          )),
    );
  }

  @override
  AnalyticsRoute get route => AnalyticsRoute.scorer;
}
