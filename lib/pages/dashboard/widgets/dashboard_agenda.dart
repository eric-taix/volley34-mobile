import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/loading.dart';
import 'package:v34/pages/dashboard/blocs/agenda_bloc.dart';
import 'package:v34/pages/dashboard/widgets/timeline/timeline.dart';
import 'package:v34/pages/dashboard/widgets/timeline/timeline_items.dart';
import 'package:v34/repositories/repository.dart';

class DashboardAgenda extends StatefulWidget {
  @override
  DashboardAgendaState createState() => DashboardAgendaState();
}

class DashboardAgendaState extends State<DashboardAgenda> {
  AgendaBloc _agendaBloc;

  @override
  void initState() {
    super.initState();
    _agendaBloc = AgendaBloc(repository: RepositoryProvider.of<Repository>(context));
    _agendaBloc.add(AgendaLoadWeek(week: 0));
  }

  Widget _buildTimeline(AgendaState state) {
    if (state is AgendaLoaded) {
      return Timeline([
        ...groupBy(state.events, (event) => DateTime(event.date.year, event.date.month, event.date.day)).entries.expand((entry) {
          return [
            TimelineItem(date: entry.key, events: [
              ...entry.value.map((e) {
                TimelineItemWidget timelineItemWidget = TimelineItemWidget.from(e);
                return TimelineEvent(
                  child: timelineItemWidget,
                  color: timelineItemWidget.color(),
                );
              })
            ])
          ];
        }),
      ]);
    } else {
      return Center(child: Loading());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgendaBloc, AgendaState>(
      bloc: _agendaBloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 28.0),
          child: _buildTimeline(state)
        );
      },
    );
  }

}