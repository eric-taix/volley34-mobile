import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/matches_played.dart';
import 'package:v34/models/team_stats.dart';
import 'package:v34/repositories/repository.dart';

class ClubStats extends Equatable {
  final List<int>? setsDistribution;

  ClubStats({this.setsDistribution});

  @override
  List<Object?> get props => [setsDistribution];
}

//----- STATE
abstract class ClubStatsState extends Equatable {
  final ClubStats? stats;

  ClubStatsState({this.stats});

  @override
  List<Object?> get props => [stats];
}

class ClubStatsUninitializedState extends ClubStatsState {}

class ClubStatsLoadingState extends ClubStatsState {}

class ClubStatsLoadedState extends ClubStatsState {
  final SetsDistribution setsDistribution;
  final MatchesPlayed matchesPlayed;

  ClubStatsLoadedState({required this.setsDistribution, required this.matchesPlayed});
}

//----- EVENT
abstract class ClubStatsEvent extends Equatable {}

class ClubStatsLoadEvent extends ClubStatsEvent {
  final String? clubCode;

  ClubStatsLoadEvent({this.clubCode});

  @override
  List<Object?> get props => [clubCode];
}

//------ BLOC

class ClubStatsBloc extends Bloc<ClubStatsEvent, ClubStatsState> {
  final int index_30 = 0;
  final int index_31 = 1;
  final int index_32 = 2;
  final int index_23 = 3;
  final int index_13 = 4;
  final int index_03 = 5;

  final Repository? repository;

  ClubStatsBloc({this.repository}) : super(ClubStatsUninitializedState());

  @override
  Stream<ClubStatsState> mapEventToState(ClubStatsEvent event) async* {
    if (event is ClubStatsLoadEvent) {
      yield ClubStatsLoadingState();
      var stats = await repository!.loadClubStats(event.clubCode);
      var setsDistribution = stats.fold<SetsDistribution>(SetsDistribution(), (acc, stat) {
        return acc + (stat.setsDistribution ?? SetsDistribution());
      });
      var matchesPlayed = stats.fold<MatchesPlayed>(MatchesPlayed.empty(), (acc, stat) {
        return acc + MatchesPlayed(won: stat.victories ?? 0, total: stat.matchsPlayed ?? 0);
      });
      yield ClubStatsLoadedState(setsDistribution: setsDistribution, matchesPlayed: matchesPlayed);
    }
  }
}
