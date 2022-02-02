import 'dart:io';

import 'package:badges/badges.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/landscape_helper.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/pages/competition/bloc/competition_cubit.dart';
import 'package:v34/pages/competition/bloc/ranking_cubit.dart';
import 'package:v34/pages/competition/competition_filter.dart';
import 'package:v34/pages/competition/filter_options.dart';
import 'package:v34/pages/team-details/ranking/team_ranking_table.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/analytics.dart';
import 'package:v34/utils/competition_text.dart';

class CompetitionPage extends StatefulWidget {
  @override
  State<CompetitionPage> createState() => _CompetitionPageState();
}

class _CompetitionPageState extends State<CompetitionPage> with SingleTickerProviderStateMixin, RouteAwareAnalytics {
  late final CompetitionCubit _competitionCubit;
  late final RankingCubit _rankingCubit;
  CompetitionFilter _filter = CompetitionFilter.all;
  List<RankingSynthesis>? _rankings;
  String _query = "";
  List<RankingSynthesis>? _filteredRankings;

  @override
  void initState() {
    super.initState();
    _competitionCubit = CompetitionCubit(RepositoryProvider.of<Repository>(context));
    _competitionCubit.loadCompetitions();
    _rankingCubit = RankingCubit(RepositoryProvider.of<Repository>(context));
    _loadRanking();
  }

  @override
  void dispose() {
    super.dispose();
    _competitionCubit.close();
  }

  void _loadRanking() {
    _rankingCubit.loadAllRankings(_filter);
  }

  _filterRankings() {
    setState(() {
      if (_rankings != null) {
        var queryWords = _query.isNotEmpty ? _query.split(" ") : <String>[];
        _filteredRankings = _rankings!.where((ranking) => _teamNameFilter(ranking, queryWords)).toList();
      } else {
        _filteredRankings = null;
      }
    });
  }

  bool _teamNameFilter(RankingSynthesis ranking, List<String> queryWords) => ranking.ranks != null
      ? ranking.ranks!.firstWhereOrNull((rank) => queryWords.fold(
              true, (previousValue, word) => (rank.name ?? "").toLowerCase().contains(word) && previousValue)) !=
          null
      : false;

  @override
  Widget build(BuildContext context) {
    var filterButton = Badge(
      showBadge: _filter.count > 0,
      padding: EdgeInsets.all(5),
      animationDuration: Duration(milliseconds: 200),
      position: BadgePosition(top: 0, end: 0),
      badgeColor: Theme.of(context).colorScheme.secondary,
      animationType: BadgeAnimationType.scale,
      badgeContent:
          Text("${_filter.count}", style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white)),
      child: IconButton(
        icon: Icon(Icons.tune_rounded),
        onPressed: () => showMaterialModalBottomSheet(
          expand: false,
          enableDrag: true,
          bounce: true,
          shape: RoundedRectangleBorder(
            side: BorderSide.none,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
          ),
          elevation: 4,
          context: context,
          builder: (context) => Container(
            height: 2 * MediaQuery.of(context).size.height / 3,
            child: FilterOptions(
              filter: _filter,
              onFilterUpdated: (filter) => setState(
                () {
                  setState(() {
                    _filter = filter;
                    _loadRanking();
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
    bool portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    Map<String, List<RankingSynthesis>>? rankingsPerCompetition;
    if (_filteredRankings != null) {
      rankingsPerCompetition =
          groupBy<RankingSynthesis, String>(_filteredRankings!, (ranking) => ranking.fullLabel!).map(
        (key, value) => MapEntry(
          key,
          value
            ..sort(
              (r1, r2) {
                return getDivisionOrder(r1.division).compareTo(getDivisionOrder(r2.division));
              },
            ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => _competitionCubit,
      child: BlocListener<RankingCubit, RankingState>(
        listener: (context, state) {
          if (state is RankingLoadedState) {
            setState(() {
              _rankings = state.rankings;
              _filterRankings();
            });
          }
        },
        bloc: _rankingCubit,
        child: MainPage(
          title: "Compétitions",
          actions: [
            filterButton,
          ],
          onSearch: (query) {
            _query = query.toLowerCase();
            _filterRankings();
          },
          slivers: [
            if (rankingsPerCompetition != null) ...[
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Container(child: LandscapeHelper()),
              )),
              ...rankingsPerCompetition.entries
                  .map(
                    (entry) => SliverStickyHeader(
                      header: Container(
                        color: Theme.of(context).canvasColor,
                        child: Padding(
                          padding: EdgeInsets.only(top: portrait ? 38.0 : 4.0),
                          child: Container(
                            height: 60.0,
                            color: Theme.of(context).cardTheme.color,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            alignment: Alignment.centerLeft,
                            child: _buildCompetitionTitle(
                                entry.key, entry.value.length > 0 ? entry.value[0].competitionCode : null),
                          ),
                        ),
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            RankingSynthesis ranking = entry.value[index];
                            return _buildCompetitionRankingTable(context, ranking,
                                highlightTeamNames: _query.isNotEmpty ? _query.split(" ") : null);
                          },
                          childCount: entry.value.length,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],
            if (rankingsPerCompetition == null)
              SliverFillRemaining(
                child: Center(child: Loading()),
              ),
            SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompetitionTitle(String fullLabel, String? competitionCode) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(extractEnhanceDivisionLabel(fullLabel), style: Theme.of(context).textTheme.headline6),
        ),
        if (competitionCode != null)
          CompetitionBadge(
            competitionCode: competitionCode,
            deltaSize: 0.6,
            showSubTitle: false,
          )
      ],
    );
  }

  _buildCompetitionRankingTable(BuildContext context, RankingSynthesis ranking, {List<String>? highlightTeamNames}) {
    return SafeArea(
      left: false,
      top: false,
      bottom: false,
      right: Platform.isIOS && MediaQuery.of(context).orientation == Orientation.landscape,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: _buildTitle(ranking),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 18, right: 8),
            child: TeamRankingTable(
              ranking: ranking,
              highlightTeamNames: highlightTeamNames,
              showDetailed: MediaQuery.of(context).orientation == Orientation.landscape,
            ),
          ),
        ],
      ),
    );
  }

  @override
  AnalyticsRoute get route => AnalyticsRoute.competitions;

  Widget _buildTitle(RankingSynthesis ranking) {
    String poolLabel = getClassificationPool(ranking.pool) != null ? "- ${getClassificationPool(ranking.pool)}" : "";
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 8.0),
      child: Column(
        children: [
          Text("${getDivisionLabel(ranking.division)} $poolLabel",
              style: Theme.of(context).textTheme.headline5!.copyWith(fontSize: 15)),
        ],
      ),
    );
  }
}
