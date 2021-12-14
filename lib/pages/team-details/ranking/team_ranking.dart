import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/commons/podium_widget.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
import 'package:v34/pages/team-details/ranking/statistics_widget.dart';
import 'package:v34/pages/team-details/ranking/summary_widget.dart';
import 'package:v34/pages/team-details/ranking/team_ranking_table.dart';
import 'package:v34/utils/competition_text.dart';

import 'evolution_widget.dart';

class TeamRanking extends StatelessWidget {
  final Team team;
  final RankingSynthesis ranking;
  final List<MatchResult> results;

  const TeamRanking({Key? key, required this.team, required this.ranking, required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int teamIndex = ranking.ranks?.indexWhere((element) => element.teamCode == team.code) ?? -1;
    RankingTeamSynthesis stats = ranking.ranks?[teamIndex] ?? RankingTeamSynthesis.empty();
    return SliverList(
        delegate: SliverChildListDelegate([
      _buildCompetitionDescription(context),
      Paragraph(title: "Classement"),
      _buildPodium(context, stats),
      Paragraph(title: "Statistiques"),
      _buildStats(context, stats),
    ]));
  }

  Widget _buildCompetitionDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(getClassificationCategory(ranking.division), style: Theme.of(context).textTheme.headline4),
          CompetitionBadge(competitionCode: ranking.competitionCode, deltaSize: 0.8),
        ],
      ),
    );
  }

  Widget _buildPodium(BuildContext context, RankingTeamSynthesis teamStats) {
    String title = "";
    if (teamStats.rank! <= ranking.promoted!) {
      title = "Promue";
    } else if (ranking.ranks != null && ranking.ranks!.length - teamStats.rank! < ranking.relegated!) {
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
                  classification: ranking,
                  currentlyDisplayed: true,
                  highlightedTeamCode: team.code,
                  showTrailing: false,
                )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: TeamRankingTable(team: team, ranking: ranking),
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context, RankingTeamSynthesis? teamStats) {
    List<double> setsDiffEvolution = TeamBloc.computePointsDiffs(results, team.code);
    DateTime? startDate = results.first.matchDate;
    DateTime? endDate = results.last.matchDate;
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
        StatisticsWidget(
          title: "Points pris",
          points: teamStats?.wonPoints ?? 0,
          maxPoints: (teamStats?.wonPoints ?? 0) + (teamStats?.lostPoints ?? 0),
          backgroundColor: Theme.of(context).canvasColor,
        ),
      ],
    );
  }
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
