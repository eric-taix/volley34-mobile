import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/repository.dart';

// ----- STATES -----

abstract class ClubTeamsState {}

class ClubTeamsUninitialized extends ClubTeamsState {}

class ClubTeamsLoading extends ClubTeamsState {}

class ClubTeamsLoaded extends ClubTeamsState {
  final List<Team> teams;
  ClubTeamsLoaded({this.teams});
}


// ----- EVENTS -----

abstract class ClubTeamsEvent {
  final String clubCode;
  ClubTeamsEvent(this.clubCode);
}

class ClubTeamsLoadEvent extends ClubTeamsEvent {
  ClubTeamsLoadEvent(clubCode): super(clubCode);
}

class ClubFavoriteTeamsLoadEvent extends ClubTeamsEvent {
  ClubFavoriteTeamsLoadEvent(clubCode): super(clubCode);
}

// ----- BLOC -----

class ClubTeamsBloc extends Bloc<ClubTeamsEvent, ClubTeamsState> {

  final Repository repository;

  ClubTeamsBloc({@required this.repository});

  @override
  ClubTeamsState get initialState => ClubTeamsUninitialized();

  @override
  Stream<ClubTeamsState> mapEventToState(ClubTeamsEvent event) async* {
    if (event is ClubTeamsLoadEvent || event is ClubFavoriteTeamsLoadEvent) {
      yield ClubTeamsLoading();
      var teams  = await repository.loadClubTeams(event.clubCode);
      var favTeams = await repository.loadFavoriteTeamCodes();
      if (favTeams.isNotEmpty) {
        teams.forEach((team) {
          if (favTeams.contains(team.code)) team.favorite = true;
        });
      }
      if (event is ClubFavoriteTeamsLoadEvent) {
        teams = teams.where((team) => team.favorite).toList();
      }
      teams.sort((team1, team2) {
        if (team1.favorite && !team2.favorite) return -1;
        if (!team1.favorite && team2.favorite) return 1;
        else return team1.name.compareTo(team2.name);
      });
      yield ClubTeamsLoaded(teams: teams);
    }
  }

}