import 'package:flutter/material.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/models/competition.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/team-details/results/result_card.dart';
import 'package:v34/utils/analytics.dart';

class TeamResults extends StatefulWidget {
  final Team team;
  final List<MatchResult> results;
  late final List<MatchResult> _sortedResults;
  final Function(bool)? onChanged;
  final bool showOnlyTeam;
  final List<Competition>? competitions;
  TeamResults(
      {Key? key,
      required this.team,
      required this.results,
      this.onChanged,
      this.showOnlyTeam = true,
      required this.competitions})
      : super(key: key) {
    _sortedResults = results.toList();
    _sortedResults.sort((result1, result2) => result1.matchDate!.compareTo(result2.matchDate!) * -1);
  }

  @override
  State<TeamResults> createState() => _TeamResultsState();
}

class _TeamResultsState extends State<TeamResults> with RouteAwareAnalytics {
  @override
  void didUpdateWidget(covariant TeamResults oldWidget) {
    if (oldWidget.showOnlyTeam != widget.showOnlyTeam) {
      pushAnalyticsScreen();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(widget.competitions != null
          ? [
              SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Voir tous les résultats", style: Theme.of(context).textTheme.bodyLarge),
                    SizedBox(width: 18),
                    SizedBox(
                      height: 36,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          value: widget.showOnlyTeam,
                          onChanged: (newValue) {
                            if (widget.onChanged != null) widget.onChanged!(newValue);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28),
              ...widget._sortedResults.map(
                (result) => ResultCard(
                  key: ValueKey("result-${result.hostTeamCode}-${result.visitorTeamCode}"),
                  team: widget.team,
                  result: result,
                  competitions: widget.competitions!,
                ),
              ),
            ]
          : [Center(child: Loading())]),
    );
  }

  @override
  AnalyticsRoute get route => AnalyticsRoute.team_results;

  @override
  String? get extraRoute => widget.showOnlyTeam ? "all" : null;
}
