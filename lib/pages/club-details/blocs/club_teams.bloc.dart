

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/repository.dart';

//---- STATE
@immutable
abstract class ClubTeamsState {}

class ClubTeamsUninitialized extends ClubTeamsState {}

class ClubTeamsLoading extends ClubTeamsState {}

class ClubTeamsLoaded extends ClubTeamsState {
  final List<Team> teams;
  ClubTeamsLoaded({this.teams});
}


//---- EVENT
@immutable
abstract class ClubTeamsEvent {}

class ClubTeamsLoadEvent extends ClubTeamsEvent {
  final String clubCode;
  ClubTeamsLoadEvent({@required this.clubCode});
}

//---- BLOC
class ClubTeamsBloc extends Bloc<ClubTeamsEvent, ClubTeamsState> {

  final Repository repository;

  ClubTeamsBloc({@required this.repository});

  @override
  ClubTeamsState get initialState => ClubTeamsUninitialized();

  @override
  Stream<ClubTeamsState> mapEventToState(ClubTeamsEvent event) async* {
    if (event is ClubTeamsLoadEvent) {
      yield ClubTeamsLoading();
      var teams  = await repository.loadClubTeams(event.clubCode);
      final seen = Set<String>();
      teams.sort((team1, team2) => team1.name.compareTo(team2.name));
      var uniqueTeams = teams.where((team) => seen.add(team.name)).toList();
      yield ClubTeamsLoaded(teams: uniqueTeams);
    }
  }

}