import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/force_widget.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/commons/podium_widget.dart';
import 'package:v34/models/force.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
import 'package:v34/pages/team-details/ranking/labeled_stat.dart';
import 'package:v34/pages/team-details/ranking/statistics_widget.dart';
import 'package:v34/pages/team-details/ranking/summary_widget.dart';
import 'package:v34/pages/team-details/ranking/team_ranking_table.dart';
import 'package:v34/utils/analytics.dart';
import 'package:v34/utils/competition_text.dart';

import 'evolution_widget.dart';

class TeamRanking extends StatefulWidget {
  final Team team;
  final RankingSynthesis ranking;
  final List<MatchResult> results;
  final Force teamForce;
  final Force globalForce;

  const TeamRanking(
      {Key? key,
      required this.team,
      required this.ranking,
      required this.results,
      required this.teamForce,
      required this.globalForce})
      : super(key: key);

  @override
  State<TeamRanking> createState() => _TeamRankingState();
}

class _TeamRankingState extends State<TeamRanking> with RouteAwareAnalytics {
  @override
  Widget build(BuildContext context) {
    int teamIndex = widget.ranking.ranks?.indexWhere((element) => element.teamCode == widget.team.code) ?? -1;
    RankingTeamSynthesis stats = widget.ranking.ranks?[teamIndex] ?? RankingTeamSynthesis.empty();
    return SliverList(
        delegate: SliverChildListDelegate([
      Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Text(
          widget.ranking.fullLabel ?? "",
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: TextAlign.center,
        ),
      ),
      _buildCompetitionDescription(context),
      Paragraph(title: "Classement"),
      _buildPodium(context, stats),
      Paragraph(title: "Statistiques"),
      _buildStats(context, stats, widget.teamForce, widget.globalForce),
    ]));
  }

  Widget _buildCompetitionDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("${getClassificationCategory(widget.ranking.division)} - ${getClassificationPool(widget.ranking.pool)}",
              style: Theme.of(context).textTheme.headline4),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: CompetitionBadge(
              competitionCode: widget.ranking.competitionCode,
              deltaSize: 0.8,
              showSubTitle: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodium(BuildContext context, RankingTeamSynthesis teamStats) {
    String title = "";
    if (teamStats.rank! <= widget.ranking.promoted!) {
      title = "Promue";
    } else if (widget.ranking.ranks != null &&
        widget.ranking.ranks!.length - teamStats.rank! < widget.ranking.relegated!) {
      title = "Reléguée";
    } else {
      title = "";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 28),
        FractionallySizedBox(
          widthFactor: 0.8,
          child: Container(
            alignment: Alignment.bottomLeft,
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    child: PodiumWidget(
                  title: title,
                  classification: widget.ranking,
                  currentlyDisplayed: true,
                  highlightedTeamCode: widget.team.code,
                  showTrailing: false,
                )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: TeamRankingTable(team: widget.team, ranking: widget.ranking),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context, RankingTeamSynthesis? teamStats, Force force, Force globalForce) {
    List<double> setsDiffEvolution = TeamBloc.computePointsDiffs(widget.results, widget.team.code);
    DateTime? startDate = widget.results.first.matchDate;
    DateTime? endDate = widget.results.last.matchDate;
    List<double> cumulativeSetsDiffEvolution = TeamBloc.computeCumulativePointsDiffs(setsDiffEvolution);
    return Column(
      children: <Widget>[
        StatisticsWidget(
          title: "Victoires",
          points: teamStats?.wonMatches ?? 0,
          maxPoints: (teamStats?.wonMatches ?? 0) + (teamStats?.lostMatches ?? 0),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        EvolutionWidget(
          title: "Total pts.",
          evolution: cumulativeSetsDiffEvolution,
          startDate: startDate,
          endDate: endDate,
          topPadding: 0,
        ),
        SummaryWidget(title: "Scores", teamStats: teamStats ?? RankingTeamSynthesis.empty()),
        StatisticsWidget(
          title: "Sets pris",
          points: teamStats?.wonSets ?? 0,
          maxPoints: (teamStats?.wonSets ?? 0) + (teamStats?.lostSets ?? 0),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        LabeledStat(
            title: "Forces",
            child: ForceWidget(
              force: force,
              globalForce: globalForce,
            )),
        StatisticsWidget(
          title: "Points pris",
          points: teamStats?.wonPoints ?? 0,
          maxPoints: (teamStats?.wonPoints ?? 0) + (teamStats?.lostPoints ?? 0),
          backgroundColor: Theme.of(context).canvasColor,
        ),
      ],
    );
  }

  @override
  AnalyticsRoute get route => AnalyticsRoute.team_competitions;

  @override
  String? get extraRoute => widget.ranking.fullLabel;
}

class ClassificationClip extends CustomClipper<Rect> {
  final double height;

  ClassificationClip(this.height);

  @override
  Rect getClip(Size size) {
    return Offset.zero & Size(size.width, height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
