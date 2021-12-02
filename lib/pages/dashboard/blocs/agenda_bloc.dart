import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/event.dart';
import 'package:v34/repositories/repository.dart';

//--- States

@immutable
abstract class AgendaState extends Equatable {
  final List<Event> events;

  AgendaState(this.events);

  @override
  List<Object> get props => [events];
}

class AgendaUninitialized extends AgendaState {
  AgendaUninitialized() : super([]);
}

class AgendaLoading extends AgendaState {
  AgendaLoading(List<Event> events) : super(events);
}

class AgendaLoaded extends AgendaState {
  AgendaLoaded(List<Event> events) : super(events);
}

//--- Events

@immutable
abstract class AgendaEvent extends Equatable {}

class LoadWeekAgenda extends AgendaEvent {
  final int? week;

  LoadWeekAgenda({this.week});

  @override
  List<Object?> get props => [week];
}

class LoadTeamMonthAgenda extends AgendaEvent {
  final String? teamCode;
  final int days;

  LoadTeamMonthAgenda({required this.teamCode, this.days = 30});

  @override
  List<Object?> get props => [teamCode];
}

class LoadTeamsMonthAgenda extends AgendaEvent {
  final List<String?> teamCodes;
  final int days;

  LoadTeamsMonthAgenda({required this.teamCodes, this.days = 30});

  @override
  List<Object> get props => [teamCodes];
}

//--- Bloc

class AgendaBloc extends Bloc<AgendaEvent, AgendaState> {
  final Repository repository;

  AgendaBloc({required this.repository}) : super(AgendaUninitialized());

  @override
  Stream<AgendaState> mapEventToState(AgendaEvent event) async* {
    yield AgendaLoading(state.events);
    if (event is LoadTeamMonthAgenda) {
      var today = DateTime.now();
      List<Event> events = (await repository.loadTeamAgenda(event.teamCode, event.days))
          .where((calendarEvent) => calendarEvent.date!.compareTo(today) > 0)
          .toList();

      events.sort((event1, event2) => event1.date!.compareTo(event2.date!));
      yield AgendaLoaded(events);
    } else if (event is LoadTeamsMonthAgenda) {
      var today = DateTime.now();
      Set<Event> allEvents = Set();
      for (String? teamCode in event.teamCodes) {
        List<Event> events = (await repository.loadTeamAgenda(teamCode, event.days))
            .where((calendarEvent) => calendarEvent.date!.compareTo(today) > 0)
            .toList();
        allEvents.addAll(events);
      }
      List<Event> eventList = allEvents.toList();
      eventList.sort((event1, event2) => event1.date!.compareTo(event2.date!));
      yield AgendaLoaded(eventList);
    }
  }
}
