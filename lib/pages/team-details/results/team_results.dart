import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/results/result_card.dart';

class TeamResults extends StatelessWidget {
  final Team team;
  final List<MatchResult> results;

  const TeamResults({Key key, @required this.team, @required this.results}) : super(key: key);

  Widget _buildChampionshipResults() {
    List<Widget> items = [];
    for (MatchResult result in results) {
      Widget element = ResultCard(team: team, result: result);
      items.add(element);
    }
    return Column(children: items);
  }

  Widget _buildChallengeResults() {
    return Container();
  }

  Widget _buildSpringCupResults() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _buildChampionshipResults(),
        _buildChallengeResults(),
        _buildSpringCupResults()
      ]),
    );
  }
}