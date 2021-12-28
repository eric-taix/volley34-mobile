import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/pages/team-details/ranking/team_ranking_table.dart';
import 'package:v34/utils/analytics.dart';
import 'package:v34/utils/competition_text.dart';

class CompetitionLandscapePage extends StatefulWidget {
  final List<RankingSynthesis> rankings;

  CompetitionLandscapePage({required this.rankings});

  @override
  State<CompetitionLandscapePage> createState() => _CompetitionLandscapePageState();
}

class _CompetitionLandscapePageState extends State<CompetitionLandscapePage>
    with SingleTickerProviderStateMixin, RouteAwareAnalytics {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          MainPage(
            title: "Compétitions",
            scrollController: _scrollController,
            slivers: [
              (widget.rankings.length != 0
                  ? SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == widget.rankings.length) {
                            return SizedBox(height: 38);
                          }
                          return _buildCompetitionRankingTable(widget.rankings[index]);
                        },
                        childCount: widget.rankings.length + 1,
                      ),
                    )
                  : SliverFillRemaining(child: Center(child: Text("Aucun résultat"))))
            ],
          ),
        ],
      ),
    );
  }

  _buildCompetitionRankingTable(RankingSynthesis ranking, {String? highlightTeamName}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: _buildTitle(ranking),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 18, right: 8),
          child: TeamRankingTable(
            ranking: ranking,
            highlightTeamName: highlightTeamName,
            showDetailed: true,
          ),
        ),
      ],
    );
  }

  @override
  AnalyticsRoute get route => AnalyticsRoute.competitions_details;

  Widget _buildTitle(RankingSynthesis ranking) {
    String poolLabel = getClassificationPool(ranking.pool) != null ? "- ${getClassificationPool(ranking.pool)}" : "";
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(ranking.label!),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: SizedBox(
                  width: 60,
                  height: 25,
                  child: CompetitionBadge(
                    competitionCode: ranking.competitionCode,
                    deltaSize: 0.8,
                    showSubTitle: false,
                  ),
                ),
              ),
              Text("${getClassificationCategory(ranking.division)} $poolLabel",
                  style: Theme.of(context).textTheme.headline5),
            ],
          ),
        ],
      ),
    );
  }
}
