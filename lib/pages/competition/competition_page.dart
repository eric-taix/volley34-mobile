import 'package:badges/badges.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:v34/commons/competition_badge.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _competitionCubit,
      child: BlocBuilder<RankingCubit, RankingState>(
        bloc: _rankingCubit,
        builder: (context, state) {
          return MainPage(
            title: "Compétitions",
            actions: [
              Badge(
                showBadge: _filter.count > 0,
                padding: EdgeInsets.all(5),
                animationDuration: Duration(milliseconds: 200),
                position: BadgePosition(top: 0, end: 0),
                badgeColor: Theme.of(context).colorScheme.secondary,
                animationType: BadgeAnimationType.scale,
                badgeContent: Text("${_filter.count}", style: Theme.of(context).textTheme.bodyText2),
                child: IconButton(
                  icon: Icon(Icons.filter_list),
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
                                return SizedBox(height: FluidNavBar.nominalHeight + 18);
                              }
                              RankingSynthesis ranking = state.rankings[index];
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 28.0),
                                    child: _buildTitle(ranking),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18.0, left: 18, right: 8),
                                    child: TeamRankingTable(ranking: ranking),
                                  ),
                                ],
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

  @override
  AnalyticsRoute get route => AnalyticsRoute.competitions;

  Widget _buildTitle(RankingSynthesis ranking) {
    String poolLabel = getClassificationPool(ranking.pool) != null ? "- ${getClassificationPool(ranking.pool)}" : "";
    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 8.0),
      child: Row(
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
    );
  }
}
