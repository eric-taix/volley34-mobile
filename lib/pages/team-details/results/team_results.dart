import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/results/result_card.dart';

class TeamResults extends StatelessWidget {
  final Team team;
  final List<MatchResult> results;

  TeamResults({Key key, @required this.team, @required this.results}) : super(key: key) {
    results.sort((result1, result2) => result1.matchDate.compareTo(result2.matchDate) * -1);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(height: 28),
        ...results.map((result) => ResultCard(team: team, result: result)),
      ]),
    );
  }
}