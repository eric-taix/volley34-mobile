

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/repositories/repository.dart';


class ClubStats extends Equatable {

  final List<int> setsDistribution;

  ClubStats({this.setsDistribution});

  @override
  List<Object> get props => [setsDistribution];
}


//----- STATE
abstract class ClubStatsState extends Equatable {

  final ClubStats stats;

  ClubStatsState({this.stats});

  @override
  List<Object> get props => [stats];

}

class ClubStatsUninitializedState extends ClubStatsState {}

class ClubStatsLoadingState extends ClubStatsState {}

class ClubStatsLoadedState extends ClubStatsState {}

//----- EVENT
abstract class ClubStatsEvent extends Equatable {}

class ClubStatsLoadEvent extends ClubStatsEvent {

  final String clubCode;

  ClubStatsLoadEvent({this.clubCode});

  @override
  List<Object> get props => [clubCode];
}

//------ BLOC

class ClubStatsBloc extends Bloc<ClubStatsEvent, ClubStatsState> {

  final Repository repository;

  ClubStatsBloc({this.repository});

  @override
  ClubStatsState get initialState => ClubStatsUninitializedState();

  @override
  Stream<ClubStatsState> mapEventToState(ClubStatsEvent event) async* {

    if (event is ClubStatsLoadEvent) {
      yield ClubStatsLoadingState();
      var stats = await repository.loadClubStats(event.clubCode);
      yield ClubStatsLoadedState();
    }
  }

}