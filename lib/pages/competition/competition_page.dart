import 'package:badges/badges.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:v34/commons/page/main_page.dart';
import 'package:v34/pages/competition/bloc/competition_cubit.dart';
import 'package:v34/pages/competition/competition_filter.dart';
import 'package:v34/pages/competition/filter_options.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/analytics.dart';

class CompetitionPage extends StatefulWidget {
  @override
  State<CompetitionPage> createState() => _CompetitionPageState();
}

class _CompetitionPageState extends State<CompetitionPage> with SingleTickerProviderStateMixin, RouteAwareAnalytics {
  late final CompetitionCubit _competitionCubit;

  CompetitionFilter _filter = CompetitionFilter.all;

  @override
  void initState() {
    super.initState();
    _competitionCubit = CompetitionCubit(RepositoryProvider.of<Repository>(context));
    _competitionCubit.loadCompetitions();
  }

  @override
  void dispose() {
    super.dispose();
    _competitionCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _competitionCubit,
      child: MainPage(
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
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                ...List.generate(
                  30,
                  (index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("11-$index"),
                  ),
                ),
                SizedBox(height: FluidNavBar.nominalHeight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  AnalyticsRoute get route => AnalyticsRoute.competitions;
}
