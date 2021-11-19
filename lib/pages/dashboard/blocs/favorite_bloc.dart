import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/models/club.dart';
import 'package:v34/repositories/repository.dart';

//--- States
@immutable
abstract class FavoriteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteUninitializedState extends FavoriteState {}

class FavoriteLoadingState extends FavoriteState {}

class FavoriteLoadedState extends FavoriteState {
  final String? teamCode;
  final Club? club;

  FavoriteLoadedState(this.teamCode, this.club);

  @override
  List<Object?> get props => [teamCode, club];

  @override
  String toString() => "FavoriteState(teams: $teamCode, clubs: $club)";
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

  FavoriteBloc({required this.repository}) : super(FavoriteUninitializedState());

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FavoriteLoadEvent) {
      yield FavoriteLoadingState();
      var favClub = await repository.loadFavoriteClub();
      var favTeamsCode = await repository.loadFavoriteTeamCode();
      yield FavoriteLoadedState(favTeamsCode, favClub);
    }
  }
}
