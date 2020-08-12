import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/paragraph.dart';
import 'package:v34/commons/podium_widget.dart';
import 'package:v34/models/classication.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
import 'package:v34/pages/team-details/ranking/statistics_widget.dart';
import 'package:v34/pages/team-details/ranking/summary_widget.dart';

import 'evolution_widget.dart';

class TeamRanking extends StatefulWidget {
  final Team team;
  final ClassificationSynthesis classification;
  final List<MatchResult> results;

  const TeamRanking(
      {Key key,
      @required this.team,
      @required this.classification,
      @required this.results})
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
    int teamIndex = widget.classification.teamsClassifications
        .indexWhere((element) => element.teamCode == widget.team.code);
    ClassificationTeamSynthesis stats =
        widget.classification.teamsClassifications[teamIndex];
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
          Text(_getClassificationCategory(),
              style: Theme.of(context).textTheme.headline4),
          CompetitionBadge(
              competitionCode: widget.classification.competitionCode,
              deltaSize: 0.8),
        ],
      ),
    );
  }

  String _getClassificationCategory() {
    switch (widget.classification.division) {
      case "EX":
        return "Excellence";
      case "HO":
        return "Honneur";
      case "PR":
        return "Promotion";
      case "AC":
        return "Accession";
      case "L1":
        return "Loisirs 1";
      default:
        return _getPool();
    }
  }

  String _getPool() {
    if (widget.classification.pool == "0")
      return "";
    else
      return "Poule ${widget.classification.pool}";
  }

  Widget _buildPodium(
      BuildContext context, ClassificationTeamSynthesis teamStats) {
    String title = "";
    if (teamStats.rank <= widget.classification.promoted)
      title = "Promue";
    else if (widget.classification.teamsClassifications.length -
            teamStats.rank <
        widget.classification.relegated) title = "Reléguée";
    return Column(
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
          child: GestureDetector(
            onTap: () {
              setState(() {
                _openClassificationList = !_openClassificationList;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0, top: 12, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      _openClassificationList
                          ? "Cacher le détail"
                          : "Voir le détail",
                      style: Theme.of(context).textTheme.bodyText2),
                  Icon(
                    _openClassificationList
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: Theme.of(context).textTheme.bodyText2.color,
                  )
                ],
              ),
            ),
          ),
          alignment: Alignment.bottomRight,
        ),
        AnimatedOpacity(
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 800),
          opacity: _openClassificationList ? 1.0 : 0.0,
          child: _openClassificationList
              ? Column(
                  children: [
                    ...widget.classification.teamsClassifications.reversed
                        .map((classificationSynthesis) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 28.0, right: 28, top: 6, bottom: 6),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    classificationSynthesis.name,
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: classificationSynthesis.teamCode ==
                                            widget.team.code
                                        ? Theme.of(context).textTheme.bodyText2
                                        : Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${classificationSynthesis.wonSets} pts",
                                      style: classificationSynthesis.teamCode ==
                                              widget.team.code
                                          ? Theme.of(context)
                                              .textTheme
                                              .bodyText2
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                    ))
                              ],
                            )),
                      );
                    }).toList()
                  ],
                )
              : null,
        ),
      ],
    );
  }

  Color _getRankColor(int rank) {
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

  Widget _buildStats(
      BuildContext context, ClassificationTeamSynthesis teamStats) {
    List<double> setsDiffEvolution =
        TeamBloc.computePointsDiffs(widget.results, widget.team.code);
    List<double> cumulativeSetsDiffEvolution =
        TeamBloc.computeCumulativePointsDiffs(setsDiffEvolution);
    return Column(
      children: <Widget>[
        StatisticsWidget(
          title: "Matchs\ngagnés",
          wonPoints: teamStats.wonMatches,
          maxPoints: teamStats.wonMatches + teamStats.lostMatches,
        ),
        SummaryWidget(title: "Scores", teamStats: teamStats),
        StatisticsWidget(
          title: "Sets pris",
          wonPoints: teamStats.wonSets,
          maxPoints: teamStats.wonSets + teamStats.lostSets,
        ),
        EvolutionWidget(title: "Diff.\nde sets", evolution: setsDiffEvolution),
        EvolutionWidget(
            title: "Cumul diff.\nde sets",
            evolution: cumulativeSetsDiffEvolution),
        StatisticsWidget(
          title: "Points pris",
          wonPoints: teamStats.wonPoints,
          maxPoints: teamStats.wonPoints + teamStats.lostPoints,
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
