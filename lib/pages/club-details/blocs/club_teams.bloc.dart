import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/team.dart';
import 'package:v34/pages/dashboard/blocs/favorite_bloc.dart';
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

abstract class ClubTeamsEvent {}

class ClubTeamsLoadEvent extends ClubTeamsEvent {
  final String clubCode;
  ClubTeamsLoadEvent({@required this.clubCode});
}

// ----- BLOC -----

class ClubTeamsBloc extends Bloc<ClubTeamsEvent, ClubTeamsState> {

  final Repository repository;
  final FavoriteBloc favoriteBloc;
  List<String> _favoriteTeams = [];

  ClubTeamsBloc({@required this.repository, this.favoriteBloc}) {
    if (favoriteBloc != null) {
      favoriteBloc.listen((state) {
        if (state is FavoriteLoadedState) {
          _favoriteTeams.addAll(state.teamCodes);
        }
      });
    }
  }

  @override
  ClubTeamsState get initialState => ClubTeamsUninitialized();

  @override
  Stream<ClubTeamsState> mapEventToState(ClubTeamsEvent event) async* {
    if (event is ClubTeamsLoadEvent) {
      yield ClubTeamsLoading();
      var teams  = await repository.loadClubTeams(event.clubCode);
      if (_favoriteTeams.isNotEmpty) {
        teams.forEach((team) {
          if (_favoriteTeams.contains(team.code)) team.favorite = true;
        });
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