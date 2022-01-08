import 'dart:io';

import 'package:badges/badges.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/commons/router.dart';
import 'package:v34/commons/scrolling_fab.dart';
import 'package:v34/commons/search_page.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/pages/competition/bloc/competition_cubit.dart';
import 'package:v34/pages/competition/bloc/ranking_cubit.dart';
import 'package:v34/pages/competition/competition_filter.dart';
import 'package:v34/pages/competition/competition_landscape_page.dart';
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
  ValueNotifier<String?> _query = ValueNotifier(null);
  CompetitionFilter _filter = CompetitionFilter.all;
  List<RankingSynthesis> _filteredRankings = [];
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _competitionCubit = CompetitionCubit(RepositoryProvider.of<Repository>(context));
    _competitionCubit.loadCompetitions();
    _rankingCubit = RankingCubit(RepositoryProvider.of<Repository>(context));
    _loadRanking();
  }

  @override
  void dispose() {
    super.dispose();
    _competitionCubit.close();
    _scrollController.dispose();
  }

  void _loadRanking() {
    _rankingCubit.loadAllRankings(_filter);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _competitionCubit,
      child: BlocBuilder<RankingCubit, RankingState>(
        bloc: _rankingCubit,
        builder: (context, state) {
          return MainPage(
            title: "Compétitions",
            scrollController: _scrollController,
            actions: [
              if (state is RankingLoadedState)
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => showSearch(
                    context: context,
                    delegate: SearchPage<RankingSynthesis>(
                        items: state.rankings,
                        showItemsOnEmpty: true,
                        searchLabel: "Rechercher une équipe",
                        failure: Center(
                          child: Text("Aucune équipe trouvée", style: Theme.of(context).textTheme.bodyText1),
                        ),
                        filter: (ranking) => [
                              if (ranking.ranks != null) ...ranking.ranks!.map((rank) => rank.name).toList(),
                            ],
                        onQueryUpdate: (query, filteredItems) =>
                            SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                              _query.value = query;
                              setState(() {
                                _filteredRankings = filteredItems;
                              });
                            }),
                        builder: (ranking) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 0),
                            child: ValueListenableBuilder<String?>(
                                builder: (context, value, __) =>
                                    _buildCompetitionRankingTable(context, ranking, highlightTeamName: value),
                                valueListenable: _query),
                          );
                        },
                        bottomPadding: 88,
                        barTheme: Theme.of(context).copyWith(
                          textTheme: TextTheme(headline6: Theme.of(context).textTheme.headline4),
                          inputDecorationTheme: InputDecorationTheme(hintStyle: Theme.of(context).textTheme.headline5),
                        ),
                        stackedWidgets: [
                          Positioned(
                            bottom: 10,
                            right: -10,
                            child: ScrollingFabAnimated(
                              width: 170,
                              color: Theme.of(context).colorScheme.secondary,
                              icon: Icon(Icons.stay_primary_landscape_rounded),
                              text: Padding(
                                padding: const EdgeInsets.only(left: 0.0),
                                child: Text(
                                  "Afficher le détail",
                                  style: Theme.of(context).floatingActionButtonTheme.extendedTextStyle,
                                ),
                              ),
                              scrollController: _scrollController,
                              onPress: () {
                                RouterFacade.push(
                                  context: context,
                                  builder: (_) => CompetitionLandscapePage(rankings: _filteredRankings),
                                );
                              },
                            ),
                          ),
                        ]),
                  ),
                ),
              Badge(
                showBadge: _filter.count > 0,
                padding: EdgeInsets.all(5),
                animationDuration: Duration(milliseconds: 200),
                position: BadgePosition(top: 0, end: 0),
                badgeColor: Theme.of(context).colorScheme.secondary,
                animationType: BadgeAnimationType.scale,
                badgeContent: Text("${_filter.count}", style: Theme.of(context).textTheme.bodyText2),
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
              ),
            ],
            slivers: [
              state is RankingLoadedState
                  ? (state.rankings.length != 0
                      ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index == ((state is RankingLoadedState ? state.rankings.length : 0) + 1) - 1) {
                                return SizedBox(height: FluidNavBar.nominalHeight + 88);
                              }
                              RankingSynthesis ranking = state.rankings[index];
                              return SafeArea(
                                left: false,
                                top: false,
                                bottom: false,
                                right: Platform.isIOS && MediaQuery.of(context).orientation == Orientation.landscape,
                                child: _buildCompetitionRankingTable(context, ranking),
                              );
                            },
                            childCount: (state is RankingLoadedState ? state.rankings.length : 0) + 1,
                          ),
                        )
                      : SliverFillRemaining(child: Center(child: Text("Aucun résultat"))))
                  : SliverFillRemaining(
                      child: Center(child: state is RankingLoadingState ? Loading() : SizedBox()),
                    ),
            ],
          );
        },
      ),
    );
  }

  _buildCompetitionRankingTable(BuildContext context, RankingSynthesis ranking, {String? highlightTeamName}) {
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
            showDetailed: MediaQuery.of(context).orientation == Orientation.landscape,
          ),
        ),
      ],
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
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(ranking.label!, style: Theme.of(context).textTheme.bodyText2),
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
