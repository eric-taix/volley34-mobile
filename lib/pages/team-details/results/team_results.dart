import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/results/result_card.dart';

class TeamResults extends StatelessWidget {
  final Team team;
  final List<MatchResult> results;
  late final List<MatchResult> _sortedResults;
  final Function(bool)? onChanged;
  final bool showOnlyTeam;

  TeamResults({Key? key, required this.team, required this.results, this.onChanged, this.showOnlyTeam = true})
      : super(key: key) {
    _sortedResults = results.toList();
    _sortedResults.sort((result1, result2) => result1.matchDate!.compareTo(result2.matchDate!) * -1);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Voir tous les résultats", style: Theme.of(context).textTheme.bodyText1),
            Switch(
              value: showOnlyTeam,
              onChanged: (newValue) {
                if (onChanged != null) onChanged!(newValue);
              },
            ),
          ],
        ),
        SizedBox(height: 28),
        ..._sortedResults.map((result) => ResultCard(
            key: ValueKey("result-${result.hostTeamCode}-${result.visitorTeamCode}"), team: team, result: result)),
      ]),
    );
  }
}
