

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/club.dart';
import 'package:v34/repositories/repository.dart';

//--- States
@immutable
abstract class FavoriteState extends Equatable {

  final List<String> teamCodes;
  final List<Club> clubs;

  const FavoriteState(this.teamCodes, this.clubs) : assert(teamCodes != null), assert(clubs != null);

  @override
  List<Object> get props => [teamCodes, clubs];

  @override
  String toString() => "FavoriteState(teams: $teamCodes, clubs: $clubs)";
}

class FavoriteUninitializedState extends FavoriteState {
  const FavoriteUninitializedState(List<String> teamCodes, List<Club> clubs) : super(teamCodes, clubs);
}

class FavoriteLoadingState extends FavoriteState {
  const FavoriteLoadingState(List<String> teamCodes, List<Club> clubs) : super(teamCodes, clubs);
}

class FavoriteLoadedState extends FavoriteState {
  const FavoriteLoadedState(List<String> teamCodes, List<Club> clubs) : super(teamCodes, clubs);
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
  @override
  FavoriteState get initialState => FavoriteUninitializedState([], []);

  final Repository repository;

  FavoriteBloc({@required this.repository});

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FavoriteLoadEvent) {
      yield FavoriteLoadingState([], []);
      var favClubs = await repository.loadFavoriteClubs();
      yield FavoriteLoadedState([], favClubs);
    }
  }

}
