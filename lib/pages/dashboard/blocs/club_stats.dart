import 'package:collection/collection.dart' show IterableExtension;
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/repository.dart';

//---- STATES
@immutable
abstract class ClubStatsState extends Equatable {
  final int wonMatches;
  final int totalMatches;

  const ClubStatsState({this.wonMatches = 0, this.totalMatches = 0}) : assert(wonMatches <= totalMatches);

  @override
  List<Object> get props => [wonMatches, totalMatches];
}

class ClubStatsUninitializedState extends ClubStatsState {}

class ClubStatsLoadingState extends ClubStatsState {}

class ClubStatsLoadedState extends ClubStatsState {
  const ClubStatsLoadedState(int wonMatches, int totalMatches)
      : super(wonMatches: wonMatches, totalMatches: totalMatches);
}

//---- EVENTS

@immutable
abstract class ClubStatsEvent extends Equatable {
  const ClubStatsEvent();

  @override
  List<Object> get props => [];
}

class ClubStatsLoadEvent extends ClubStatsEvent {
  final String? clubCode;

  const ClubStatsLoadEvent(this.clubCode);
}

//---- BLOC

class ClubStatsBloc extends Bloc<ClubStatsEvent, ClubStatsState> {
  final Repository _repository;

  ClubStatsBloc(this._repository) : super(ClubStatsUninitializedState());

  @override
  Stream<ClubStatsState> mapEventToState(ClubStatsEvent event) async* {
    if (event is ClubStatsLoadEvent) {
      yield ClubStatsLoadingState();
      List<Team> teams = await _repository.loadClubTeams(event.clubCode);
      List<MatchResult?> teamsResults = await Future.wait(teams.expand((team) {
        var lastMatch = _repository.loadTeamLastMatchResult(team.code);
        if (lastMatch != null)
          return [lastMatch];
        else
          return [];
      }));
      var stats = teamsResults.fold(Tuple2<int, int>(0, 0), (dynamic acc, matchResult) {
        acc = acc.withItem2(acc.item2 + 1);
        bool hostedByClubTeam = (teams.firstWhereOrNull((team) => team.code == matchResult?.hostTeamCode) != null);
        if (hostedByClubTeam) {
          acc = matchResult!.totalSetsHost! > matchResult.totalSetsVisitor! ? acc.withItem1(acc.item1 + 1) : acc;
        } else {
          acc = (matchResult?.totalSetsVisitor ?? 0) > (matchResult?.totalSetsHost ?? 0)
              ? acc.withItem1(acc.item1 + 1)
              : acc;
        }
        return acc;
      });
      yield ClubStatsLoadedState(stats.item1, stats.item2);
    }
  }
}
