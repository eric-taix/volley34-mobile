import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/commons/podium_widget.dart';
import 'package:v34/commons/rounded_outlined_button.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
import 'package:v34/pages/team-details/ranking/statistics_widget.dart';
import 'package:v34/pages/team-details/ranking/summary_widget.dart';
import 'package:v34/utils/competition_text.dart';

import 'evolution_widget.dart';

class TeamRanking extends StatefulWidget {
  final Team team;
  final RankingSynthesis classification;
  final List<MatchResult> results;

  const TeamRanking({Key? key, required this.team, required this.classification, required this.results})
      : super(key: key);

  @override
  _TeamRankingState createState() => _TeamRankingState();
}

class _TeamRankingState extends State<TeamRanking> {
  double _cupOpacity = 0;
  bool _openClassificationList = false;

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
    int teamIndex =
        widget.classification.teamsRankings?.indexWhere((element) => element.teamCode == widget.team.code) ?? -1;
    RankingTeamSynthesis stats = widget.classification.teamsRankings?[teamIndex] ?? RankingTeamSynthesis.empty();
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
          Text(getClassificationCategory(widget.classification.division), style: Theme.of(context).textTheme.headline4),
          CompetitionBadge(competitionCode: widget.classification.competitionCode, deltaSize: 0.8),
        ],
      ),
    );
  }

  Widget _buildPodium(BuildContext context, RankingTeamSynthesis teamStats) {
    String title = "";
    if (teamStats.rank! <= widget.classification.promoted!) {
      title = "Promue";
    } else if (widget.classification.teamsRankings != null &&
        widget.classification.teamsRankings!.length - teamStats.rank! < widget.classification.relegated!) {
      title = "Reléguée";
    } else {
      title = "";
    }

    RankingTeamSynthesis currentTeamClassification = widget.classification.teamsRankings
            ?.firstWhere((teamClassification) => teamClassification.teamCode == widget.team.code) ??
        RankingTeamSynthesis.empty();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
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
                            classification: widget.classification,
                            currentlyDisplayed: true,
                            highlightedTeamCode: widget.team.code)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 18.0, top: 12, bottom: 8),
            child: SizedBox(
              width: 180,
              child: RoundedOutlinedButton(
                onPressed: () => setState(() {
                  _openClassificationList = !_openClassificationList;
                }),
                child: AnimatedCrossFade(
                  duration: Duration(milliseconds: 500),
                  crossFadeState: _openClassificationList ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  firstChild: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text("Cacher le détail", style: Theme.of(context).textTheme.bodyText2),
                      ),
                      Icon(
                        Icons.arrow_drop_up,
                        color: Theme.of(context).textTheme.bodyText2!.color,
                      )
                    ],
                  ),
                  secondChild: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text("Voir le détail", style: Theme.of(context).textTheme.bodyText2),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).textTheme.bodyText2!.color,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          crossFadeState: _openClassificationList ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: Duration(milliseconds: 800),
          firstChild: SizedBox(
            width: double.infinity,
          ),
          secondChild: Column(
            children: [
              if (widget.classification.teamsRankings != null)
                ...widget.classification.teamsRankings!.reversed
                    .toList()
                    .asMap()
                    .map(
                      (index, classificationSynthesis) {
                        return MapEntry(
                          index,
                          Padding(
                            padding: const EdgeInsets.only(left: 28.0, right: 28, top: 6, bottom: 6),
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(4)),
                                              color: classificationSynthesis.teamCode == widget.team.code
                                                  ? Theme.of(context).textTheme.bodyText2!.color
                                                  : Theme.of(context).textTheme.bodyText1!.color),
                                          child: Center(
                                            child: Text(
                                              "${index + 1}",
                                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                                  color: Theme.of(context).canvasColor, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 100,
                                      child: Text(
                                        classificationSynthesis.name!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: classificationSynthesis.teamCode == widget.team.code
                                            ? Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(fontWeight: FontWeight.bold)
                                            : Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 52,
                                      child: Row(
                                        children: [
                                          Text(
                                            "${classificationSynthesis.wonSets} pts",
                                            style: classificationSynthesis.teamCode == widget.team.code
                                                ? Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(fontWeight: FontWeight.bold)
                                                : Theme.of(context).textTheme.bodyText1,
                                          ),
                                          classificationSynthesis.teamCode != widget.team.code
                                              ? Text(
                                                  " (${classificationSynthesis.totalPoints! - currentTeamClassification.totalPoints! > 0 ? "+" : ""}${classificationSynthesis.totalPoints! - currentTeamClassification.totalPoints!})",
                                                  style: classificationSynthesis.teamCode == widget.team.code
                                                      ? Theme.of(context)
                                                          .textTheme
                                                          .bodyText2!
                                                          .copyWith(fontWeight: FontWeight.bold)
                                                      : Theme.of(context).textTheme.bodyText1,
                                                )
                                              : SizedBox()
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      },
                    )
                    .values
                    .toList()
            ],
          ),
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

  Widget _buildStats(BuildContext context, RankingTeamSynthesis teamStats) {
    List<double> setsDiffEvolution = TeamBloc.computePointsDiffs(widget.results, widget.team.code);
    DateTime? startDate = widget.results.first.matchDate;
    DateTime? endDate = widget.results.last.matchDate;
    List<double> cumulativeSetsDiffEvolution = TeamBloc.computeCumulativePointsDiffs(setsDiffEvolution);
    return Column(
      children: <Widget>[
        StatisticsWidget(
          title: "Matchs\ngagnés",
          wonPoints: teamStats.wonMatches,
          maxPoints: teamStats.wonMatches! + teamStats.lostMatches!,
        ),
        SummaryWidget(title: "Scores", teamStats: teamStats),
        StatisticsWidget(
          title: "Sets pris",
          wonPoints: teamStats.wonSets,
          maxPoints: teamStats.wonSets! + teamStats.lostSets!,
        ),
        EvolutionWidget(title: "Diff.\nde sets", evolution: setsDiffEvolution, startDate: startDate, endDate: endDate),
        EvolutionWidget(
            title: "Cumul diff.\nde sets",
            evolution: cumulativeSetsDiffEvolution,
            startDate: startDate,
            endDate: endDate),
        StatisticsWidget(
          title: "Points pris",
          wonPoints: teamStats.wonPoints,
          maxPoints: teamStats.wonPoints! + teamStats.lostPoints!,
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
