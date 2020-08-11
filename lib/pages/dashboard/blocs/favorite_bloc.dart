import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/club.dart';
import 'package:v34/repositories/repository.dart';

//--- States
@immutable
abstract class FavoriteState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoriteUninitializedState extends FavoriteState {}

class FavoriteLoadingState extends FavoriteState {}

class FavoriteLoadedState extends FavoriteState {
  final List<String> teamCodes;
  final List<Club> clubs;

  FavoriteLoadedState(this.teamCodes, this.clubs)
      : assert(teamCodes != null),
        assert(clubs != null);

  @override
  List<Object> get props => [teamCodes, clubs];

  @override
  String toString() => "FavoriteState(teams: $teamCodes, clubs: $clubs)";
}

//--- Events
@immutable
abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class FavoriteLoadEvent extends FavoriteEvent {}

//--- Bloc

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final Repository repository;

  FavoriteBloc({@required this.repository})
      : super(FavoriteUninitializedState());

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FavoriteLoadEvent) {
      yield FavoriteLoadingState();
      var favClubs = await repository.loadFavoriteClubs();
      var favTeamsCodes = await repository.loadFavoriteTeamCodes();
      yield FavoriteLoadedState(favTeamsCodes, favClubs);
    }
  }
}
