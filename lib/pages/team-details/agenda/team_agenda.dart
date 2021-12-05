import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/timeline/timeline.dart';
import 'package:v34/commons/timeline/timeline_items.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/dashboard/blocs/agenda_bloc.dart';
import 'package:v34/repositories/repository.dart';

class TeamAgenda extends StatefulWidget {
  final Team team;

  TeamAgenda({required this.team});

  @override
  _TeamAgendaState createState() => _TeamAgendaState();
}

class _TeamAgendaState extends State<TeamAgenda> {
  AgendaBloc? _agendaBloc;

  @override
  void initState() {
    super.initState();
    _agendaBloc = AgendaBloc(repository: RepositoryProvider.of<Repository>(context));
    _agendaBloc!.add(LoadTeamMonthAgenda(teamCode: widget.team.code, days: 120));
  }

  @override
  void dispose() {
    _agendaBloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _agendaBloc,
        builder: (context, dynamic state) {
          if (state is AgendaLoaded) {
            return SliverToBoxAdapter(
              child: Timeline(
                [
                  ...groupBy(
                          state.events, (dynamic event) => DateTime(event.date.year, event.date.month, event.date.day))
                      .entries
                      .expand((entry) {
                    return [
                      TimelineItem(date: entry.key, events: [
                        ...entry.value.map((e) {
                          TimelineItemWidget timelineItemWidget = TimelineItemWidget.from(e, widget.team);
                          return TimelineEvent(
                            child: timelineItemWidget,
                            color: timelineItemWidget.color(),
                          );
                        })
                      ])
                    ];
                  }),
                ],
              ),
            );
          } else {
            return SliverFillRemaining(child: Center(child: Loading()));
          }
        });
  }
}
