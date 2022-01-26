import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/commons/timeline/timeline.dart';
import 'package:v34/commons/timeline/timeline_items.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/dashboard/blocs/agenda_bloc.dart';
import 'package:v34/repositories/repository.dart';

class DashboardAgenda extends StatefulWidget {
  final Team team;
  final Club club;
  const DashboardAgenda({Key? key, required this.team, required this.club}) : super(key: key);

  @override
  DashboardAgendaState createState() => DashboardAgendaState();
}

class DashboardAgendaState extends State<DashboardAgenda> with AutomaticKeepAliveClientMixin {
  // AutomaticKeepAliveClientMixin permits to preserve this state when scrolling on the dashboard

  late final AgendaBloc _agendaBloc;

  @override
  void initState() {
    super.initState();
    _agendaBloc = AgendaBloc(repository: RepositoryProvider.of<Repository>(context));
    _loadTeamsMonthAgenda();
  }

  void _loadTeamsMonthAgenda() {
    _agendaBloc.add(LoadTeamMonthAgenda(teamCode: widget.team.code, days: 30));
  }

  @override
  void didUpdateWidget(DashboardAgenda oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.team.code != oldWidget.team.code) {
      _loadTeamsMonthAgenda();
    }
  }

  Widget _buildTimeline(AgendaState state) {
    if (state is AgendaLoaded) {
      return Padding(
        padding: EdgeInsets.only(right: 18, left: 18),
        child: Column(
          children: [
            Timeline(
              [
                ...groupBy(state.events, (dynamic event) => DateTime(event.date.year, event.date.month, event.date.day))
                    .entries
                    .expand(
                  (entry) {
                    return [
                      TimelineItem(
                        date: entry.key,
                        events: [
                          ...entry.value.map(
                            (e) {
                              TimelineItemWidget timelineItemWidget = TimelineItemWidget.from(e, widget.team, false);
                              return TimelineEvent(
                                child: timelineItemWidget,
                                color: timelineItemWidget.color(),
                              );
                            },
                          )
                        ],
                      )
                    ];
                  },
                ),
              ],
            ),
          ],
        ),
      );
    } else if (state is AgendaLoading) {
      return Container(height: 150, child: Center(child: Loading()));
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AgendaBloc, AgendaState>(
      bloc: _agendaBloc,
      builder: (context, state) {
        return Padding(padding: const EdgeInsets.only(top: 18), child: _buildTimeline(state));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
