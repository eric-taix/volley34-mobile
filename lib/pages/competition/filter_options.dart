import 'package:badges/badges.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:v34/commons/competition_badge.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/models/competition.dart';
import 'package:v34/models/division.dart';
import 'package:v34/pages/competition/bloc/competition_cubit.dart';
import 'package:v34/pages/competition/bloc/division_cubit.dart';
import 'package:v34/pages/competition/competition_filter.dart';
import 'package:v34/repositories/repository.dart';
import 'package:v34/utils/extensions.dart';

class FilterOptions extends StatefulWidget {
  final void Function(CompetitionFilter) onFilterUpdated;
  final CompetitionFilter filter;
  const FilterOptions({Key? key, required this.onFilterUpdated, required this.filter}) : super(key: key);

  @override
  _FilterOptionsState createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  static const double LEFT_PADDING = 18;

  final DateFormat _fullDateFormat = DateFormat("dd\/MM\/yyyy", "FR");

  late final CompetitionCubit _competitionCubit;
  late final DivisionCubit _divisionCubit;

  Map<String, List<Competition>>? _competitionsByGroup;

  late CompetitionFilter _filter;

  @override
  void initState() {
    super.initState();
    _competitionCubit = CompetitionCubit(RepositoryProvider.of<Repository>(context));
    _competitionCubit.loadCompetitions();
    _divisionCubit = DivisionCubit(RepositoryProvider.of<Repository>(context));
    _divisionCubit.loadDivisions();
    _filter = widget.filter;
  }

  _reinitFilters() {
    _updateFilter(
        CompetitionFilter(competitionGroup: CompetitionFilter.ALL_COMPETITION, competitionDivision: Division.all));
  }

  @override
  void didUpdateWidget(covariant FilterOptions oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _competitionCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CompetitionCubit, CompetitionState>(
      bloc: _competitionCubit,
      listener: (context, state) {
        if (state is CompetitionLoadedState) {
          setState(() {
            _competitionsByGroup = _groupByKey<String>(state.competitions, (competition) => competition.code);
          });
        }
      },
      builder: (context, state) {
        if (state is CompetitionLoadedState) {
          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                child: Container(
                  color: Theme.of(context).cardTheme.titleBackgroundColor(context),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.tune_rounded),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Badge(
                                showBadge: _filter.count > 0,
                                padding: EdgeInsets.all(5),
                                animationDuration: Duration(milliseconds: 200),
                                position: BadgePosition(top: -15, end: -20),
                                badgeColor: Theme.of(context).colorScheme.secondary,
                                animationType: BadgeAnimationType.scale,
                                badgeContent: Text("${_filter.count}", style: Theme.of(context).textTheme.bodyText2),
                                child: Text("Filtres", style: Theme.of(context).appBarTheme.titleTextStyle),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextButton(
                                onPressed: _filter.count > 0 ? () => _reinitFilters() : null,
                                child: Text("Réinitialiser"),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ..._buildCompetitionFilter(context),
                    ..._buildLevelFilter(context),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        } else if (state is CompetitionLoadingState) {
          return Center(child: Loading());
        } else {
          return SizedBox();
        }
      },
    );
  }

  Map<S, List<Competition>> _groupByKey<S>(List<Competition> competitions, S Function(Competition) key) {
    return groupBy<Competition, S>(competitions, key)..removeWhere((key, value) => value.isEmpty);
  }

  _buildLevelFilter(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 28.0, left: LEFT_PADDING, bottom: 18),
        child: Text("Niveaux de jeu", style: Theme.of(context).textTheme.headline6),
      ),
      RadioListTile<Division>(
        contentPadding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
        controlAffinity: ListTileControlAffinity.leading,
        title: Text("Tous les niveaux de jeu", style: Theme.of(context).textTheme.bodyText2),
        value: Division.all,
        onChanged: (_) => _updateFilter(_filter.copyWith(competitionDivision: Division.all)),
        groupValue: _filter.competitionDivision,
      ),
      BlocBuilder(
        bloc: _divisionCubit,
        builder: (BuildContext context, state) {
          return state is DivisionLoadedState
              ? Column(
                  children: [
                    ...state.divisions.map(
                      (division) => RadioListTile<Division>(
                        contentPadding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
                        title: Text(division.label, style: Theme.of(context).textTheme.bodyText2),
                        groupValue: _filter.competitionDivision,
                        value: division,
                        onChanged: (_) => _updateFilter(_filter.copyWith(competitionDivision: division)),
                      ),
                    )
                  ],
                )
              : SizedBox();
        },
      )
    ];
  }

  _buildCompetitionFilter(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 8.0, left: LEFT_PADDING, bottom: 18),
        child: Text("Compétitions", style: Theme.of(context).textTheme.headline6),
      ),
      RadioListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
        title: Text(
          "Toutes les compétitions",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        value: CompetitionFilter.ALL_COMPETITION,
        groupValue: _filter.competitionGroup,
        onChanged: (value) => _updateFilter(_filter.copyWith(competitionGroup: CompetitionFilter.ALL_COMPETITION)),
      ),
      if (_competitionsByGroup != null)
        ..._competitionsByGroup!.entries.map(
          (competitions) => RadioListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: LEFT_PADDING),
            title: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 22,
                  child: CompetitionBadge(
                    deltaSize: 2,
                    competitionCode: competitions.value[0].code,
                    showSubTitle: false,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          competitions.value[0].competitionLabel,
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "Du ${_fullDateFormat.format(competitions.value[0].start)} au ${_fullDateFormat.format(competitions.value[0].end)}",
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            value: competitions.key,
            onChanged: (value) => setState(
              () {
                if (value != null && value != CompetitionFilter.ALL_COMPETITION)
                  _updateFilter(_filter.copyWith(competitionGroup: competitions.key));
                else
                  _updateFilter(_filter.copyWith(competitionGroup: CompetitionFilter.ALL_COMPETITION));
              },
            ),
            groupValue: _filter.competitionGroup,
          ),
        ),
    ];
  }

  _updateFilter(CompetitionFilter filter) {
    setState(() {
      _filter = filter;
      widget.onFilterUpdated(_filter);
    });
  }
}
