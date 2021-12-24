import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/event.dart';
import 'package:v34/models/force.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/pages/club-details/blocs/club_team.bloc.dart';
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

class LoadTeamFullAgenda extends AgendaEvent {
  final String teamCode;
  LoadTeamFullAgenda({required this.teamCode});

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
      var now = DateTime.now();
      var today = DateTime(now.year, now.month, now.day);

      List<Event> events =
          (await repository.loadTeamAgenda(event.teamCode, event.days)).where(_matchIsAfter(today)).toList();
      List<RankingSynthesis> rankings = await repository.loadTeamRankingSynthesis(event.teamCode);
      List<CompetitionFullPath> competitionsFullPath = rankings
          .map((ranking) => CompetitionFullPath(ranking.competitionCode!, ranking.division!, ranking.pool!))
          .toList();

      var allResults = (await Future.wait(competitionsFullPath.map((competitionFullPath) => repository.loadResults(
              competitionFullPath.competitionCode, competitionFullPath.division, competitionFullPath.pool))))
          .expand((e) => e);

      Force globalForce = Force();
      Map<String, ForceBuilder> forceByTeam = {};
      allResults.forEach((matchResult) {
        var hostForceBuilder = forceByTeam.putIfAbsent(
            matchResult.hostTeamCode!,
            () => ForceBuilder(
                  teamCode: matchResult.hostTeamCode,
                  othersForce: globalForce,
                ));
        var visitorForceBuilder = forceByTeam.putIfAbsent(
            matchResult.visitorTeamCode!, () => ForceBuilder(teamCode: matchResult.visitorTeamCode));
        hostForceBuilder.add(matchResult);
        visitorForceBuilder.add(matchResult);
      });

      List<Event> eventsWithForce = events.map((event) {
        if (event.type == EventType.Match) {
          return event.withForce(
              forceByTeam[event.hostCode]!.teamForce, forceByTeam[event.visitorCode]!.teamForce, globalForce);
        } else {
          return event;
        }
      }).toList();

      eventsWithForce.sort((event1, event2) => event1.date!.compareTo(event2.date!));
      yield AgendaLoaded(eventsWithForce);
    } else if (event is LoadTeamFullAgenda) {
      List<Event> events = await repository.loadTeamFullAgenda(event.teamCode);
      List<RankingSynthesis> rankings = await repository.loadTeamRankingSynthesis(event.teamCode);
      List<CompetitionFullPath> competitionsFullPath = rankings
          .map((ranking) => CompetitionFullPath(ranking.competitionCode!, ranking.division!, ranking.pool!))
          .toList();

      Iterable<MatchResult> allResults = (await Future.wait(competitionsFullPath.map((competitionFullPath) =>
              repository.loadResults(
                  competitionFullPath.competitionCode, competitionFullPath.division, competitionFullPath.pool))))
          .expand((e) => e);

      Force globalForce = Force();
      Map<String, ForceBuilder> forceByTeam = {};
      allResults.forEach((matchResult) {
        var hostForceBuilder = forceByTeam.putIfAbsent(
            matchResult.hostTeamCode!,
            () => ForceBuilder(
                  teamCode: matchResult.hostTeamCode,
                  othersForce: globalForce,
                ));
        var visitorForceBuilder = forceByTeam.putIfAbsent(
            matchResult.visitorTeamCode!, () => ForceBuilder(teamCode: matchResult.visitorTeamCode));
        hostForceBuilder.add(matchResult);
        visitorForceBuilder.add(matchResult);
      });

      List<Event> eventsWithForce = events.map((event) {
        if (event.type == EventType.Match) {
          return event.withForce(
              forceByTeam[event.hostCode]!.teamForce, forceByTeam[event.visitorCode]!.teamForce, globalForce);
        } else {
          return event;
        }
      }).toList();

      var resultByMatchCode =
          Map.fromIterable(allResults, key: (result) => (result as MatchResult).matchCode, value: (result) => result);
      var allEvents = eventsWithForce
          .map((event) => resultByMatchCode[event.matchCode] != null ? event.withResult() : event)
          .toList();

      allEvents.sort((event1, event2) => event1.date!.compareTo(event2.date!));

      yield AgendaLoaded(allEvents);
    }
  }

  bool Function(Event) _matchIsAfter(DateTime reference) {
    return (event) => event.date!.compareTo(reference) > 0;
  }
}
