import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/feature_help.dart';
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
  static const TEAM_PODIUM_FEATURE = "team-podium";
  static const TEAM_RANKING_FEATURE = "team-ranking";
  static const TEAM_DIFF_SET_FEATURE = "team-diff-set";
  static const TEAM_VICTORY_FEATURE = "team-victory";
  static const TEAM_SCORES_FEATURE = "team-scores";
  static const TEAM_SETS_FEATURE = "team-sets";
  static const TEAM_FORCES_FEATURE = "team-forces";
  static const TEAM_POINTS_FEATURE = "team-points";

  final GlobalKey _teamRankingKey = GlobalKey();

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
        Container(
          alignment: Alignment.bottomLeft,
          height: 150,
          child: FeatureHelp(
            featureId: TEAM_PODIUM_FEATURE,
            title: "Classement",
            paragraphs: [
              "Votre position actuelle dans le classement et le nombre de points relatifs des adversaires directs de l'équipe."
            ],
            child: PodiumWidget(
              title: title,
              classification: widget.ranking,
              currentlyDisplayed: true,
              highlightedTeamCode: widget.team.code,
              showTrailing: false,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: FeatureHelp(
            featureId: TEAM_RANKING_FEATURE,
            title: "Détail du classement",
            paragraphs: ["Le classement en détail, vos points ainsi que la différence de matchs joués."],
            child: TeamRankingTable(key: _teamRankingKey, team: widget.team, ranking: widget.ranking),
          ),
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
        FeatureHelp(
          featureId: TEAM_VICTORY_FEATURE,
          title: "Nombre de victoires",
          paragraphs: [
            "Nombre de victoires par rapport au nombre total de matchs joués.",
          ],
          child: StatisticsWidget(
            title: "Victoires",
            points: teamStats?.wonMatches ?? 0,
            maxPoints: (teamStats?.wonMatches ?? 0) + (teamStats?.lostMatches ?? 0),
            backgroundColor: Theme.of(context).canvasColor,
          ),
        ),
        FeatureHelp(
          featureId: TEAM_DIFF_SET_FEATURE,
          title: "Différence de sets",
          paragraphs: [
            "Affiche la différence de sets cumulée, au cours des matchs."
                " Permet de détecter une baisse ou une hausse de résultats sur le long terme.",
          ],
          child: EvolutionWidget(
            title: "Diff. de sets",
            evolution: cumulativeSetsDiffEvolution,
            startDate: startDate,
            endDate: endDate,
          ),
        ),
        FeatureHelp(
          featureId: TEAM_SCORES_FEATURE,
          title: "Scores",
          paragraphs: [
            "Distribution du nombre de matchs par résultat final. La dernière colonne \"NT\" regroupe tous les matchs non terminés."
          ],
          child: SummaryWidget(title: "Scores", teamStats: teamStats ?? RankingTeamSynthesis.empty()),
        ),
        FeatureHelp(
          featureId: TEAM_SETS_FEATURE,
          title: "Sets pris",
          paragraphs: [
            "Affiche le nombre de sets gagnés par rapport au nombre de sets total. "
                "Une valeur de 100% signifie que tous les matchs ont été gagnés 3-0"
          ],
          child: StatisticsWidget(
            title: "Sets pris",
            points: teamStats?.wonSets ?? 0,
            maxPoints: (teamStats?.wonSets ?? 0) + (teamStats?.lostSets ?? 0),
            backgroundColor: Theme.of(context).canvasColor,
          ),
        ),
        FeatureHelp(
          featureId: TEAM_FORCES_FEATURE,
          title: "Forces",
          paragraphs: [
            "Force d'attaque : nombre moyen de points marqués par set, comparé à la moyenne des équipes de la poule. Une valeur > 100% signifie que l'équipe a une meilleure attaque que la moyenne des équipes.",
            "",
            "Potentiel de défense : nombre moyen de points concédés par set, comparé à la moyenne des équipes de la poule. Une valeur > 100% signifie que l'équipe a une meilleure défense que la moyenne des équipes.",
          ],
          child: LabeledStat(
              title: "Forces",
              child: ForceWidget(
                force: force,
                globalForce: globalForce,
              )),
        ),
        FeatureHelp(
          featureId: TEAM_POINTS_FEATURE,
          title: "Points pris",
          paragraphs: [
            "Affiche le nombre de points gagnés par rapport au nombre de points total. "
                "Une valeur de 100% signifie que tous les sets ont été gagnés 25-0"
          ],
          child: StatisticsWidget(
            title: "Points pris",
            points: teamStats?.wonPoints ?? 0,
            maxPoints: (teamStats?.wonPoints ?? 0) + (teamStats?.lostPoints ?? 0),
            backgroundColor: Theme.of(context).canvasColor,
          ),
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
