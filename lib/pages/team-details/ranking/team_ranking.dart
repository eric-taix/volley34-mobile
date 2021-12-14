import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class TeamRanking extends StatefulWidget {
  final Team team;
  final RankingSynthesis ranking;
  final List<MatchResult> results;

  const TeamRanking({Key? key, required this.team, required this.ranking, required this.results}) : super(key: key);

  @override
  _TeamRankingState createState() => _TeamRankingState();
}

class _TeamRankingState extends State<TeamRanking> {
  double _cupOpacity = 0;
  bool _openRankingTable = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _cupOpacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    int teamIndex = widget.ranking.ranks?.indexWhere((element) => element.teamCode == widget.team.code) ?? -1;
    RankingTeamSynthesis stats = widget.ranking.ranks?[teamIndex] ?? RankingTeamSynthesis.empty();
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
          Text(getClassificationCategory(widget.ranking.division), style: Theme.of(context).textTheme.headline4),
          CompetitionBadge(competitionCode: widget.ranking.competitionCode, deltaSize: 0.8),
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
          child: Stack(
            children: [
              Container(
                alignment: Alignment.bottomRight,
                height: 50,
                child: AnimatedOpacity(
                  opacity: _cupOpacity,
                  duration: Duration(milliseconds: 1800),
                  curve: Curves.easeInOut,
                  child: FaIcon(
                    FontAwesomeIcons.trophy,
                    size: 44,
                    color: _getRankColor(teamStats.rank),
                  ),
                ),
              ),
              Container(
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
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: TeamRankingTable(team: widget.team, ranking: widget.ranking),
        ),
      ],
    );
  }

  Color _getRankColor(int? rank) {
    switch (rank) {
      case 1:
        return Color(0xffFFD700);
      case 2:
        return Color(0xffC0C0C0);
      case 3:
        return Color(0xff796221);
      default:
        return Colors.transparent;
    }
  }

  Widget _buildStats(BuildContext context, RankingTeamSynthesis? teamStats) {
    List<double> setsDiffEvolution = TeamBloc.computePointsDiffs(widget.results, widget.team.code);
    DateTime? startDate = widget.results.first.matchDate;
    DateTime? endDate = widget.results.last.matchDate;
    List<double> cumulativeSetsDiffEvolution = TeamBloc.computeCumulativePointsDiffs(setsDiffEvolution);
    return Column(
      children: <Widget>[
        StatisticsWidget(
          title: "Matchs\ngagnés",
          points: teamStats?.wonMatches ?? 0,
          maxPoints: (teamStats?.wonMatches ?? 0) + (teamStats?.lostMatches ?? 0),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        SummaryWidget(title: "Scores", teamStats: teamStats ?? RankingTeamSynthesis.empty()),
        StatisticsWidget(
          title: "Sets pris",
          points: teamStats?.wonSets ?? 0,
          maxPoints: (teamStats?.wonSets ?? 0) + (teamStats?.lostSets ?? 0),
          backgroundColor: Theme.of(context).canvasColor,
        ),
        EvolutionWidget(title: "Diff.\nde sets", evolution: setsDiffEvolution, startDate: startDate, endDate: endDate),
        EvolutionWidget(
            title: "Cumul diff.\nde sets",
            evolution: cumulativeSetsDiffEvolution,
            startDate: startDate,
            endDate: endDate),
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
