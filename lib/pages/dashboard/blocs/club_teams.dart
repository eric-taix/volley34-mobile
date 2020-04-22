

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/repository.dart';

//--- States

abstract class ClubTeamsState extends Equatable {

  final List<Team> teams;

  const ClubTeamsState(this.teams) : assert(teams != null);

  @override
  List<Object> get props => [teams];

  @override
  String toString() => "ClubTeams(teams: $teams)";
}

class ClubTeamsUninitializedState extends ClubTeamsState {
  const ClubTeamsUninitializedState(List<Team> teams) : super(teams);
}

class ClubTeamsLoadingState extends ClubTeamsState {
  const ClubTeamsLoadingState(List<Team> teams) : super(teams);
}

class ClubTeamsLoadedState extends ClubTeamsState {
  const ClubTeamsLoadedState(List<Team> teams) : super(teams);
}


//--- Events

abstract class ClubTeamsEvent extends Equatable {
  const ClubTeamsEvent();

  @override
  List<Object> get props => [];
}

class ClubTeamsLoadEvent extends ClubTeamsEvent {
  final String clubCode;
  ClubTeamsLoadEvent(this.clubCode);
}


//--- Bloc

class ClubTeamsBloc extends Bloc<ClubTeamsEvent, ClubTeamsState> {
  @override
  ClubTeamsState get initialState => ClubTeamsUninitializedState([]);

  final Repository repository;

  ClubTeamsBloc({@required this.repository});

  @override
  Stream<ClubTeamsState> mapEventToState(ClubTeamsEvent event) async* {
    if (event is ClubTeamsLoadEvent) {
      yield ClubTeamsLoadingState([]);
      var teams = await repository.loadClubTeams(event.clubCode);
      yield ClubTeamsLoadedState(teams);
    }
  }

}
