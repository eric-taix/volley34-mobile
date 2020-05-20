

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/repositories/repository.dart';

//---- STATE
@immutable
abstract class FavoriteState {}

class FavoriteUninitialized extends FavoriteState {}

class FavoriteUpdating extends FavoriteState {
  FavoriteUpdating();
}

class FavoriteUpdated extends FavoriteState {
  final bool favorite;
  FavoriteUpdated(this.favorite);
}

class FavoriteLoaded extends FavoriteState {
  final bool favorite;
  FavoriteLoaded(this.favorite);
}

//---- EVENT
@immutable
abstract class FavoriteEvent {}

class FavoriteUpdateEvent extends FavoriteEvent {
  final bool favorite;
  FavoriteUpdateEvent(this.favorite);
}

class FavoriteLoadEvent extends FavoriteEvent {
  FavoriteLoadEvent();
}

//---- BLOC
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {

  final Repository repository;
  final String favoriteId;
  final FavoriteType favoriteType;

  FavoriteBloc(this.repository, this.favoriteId, this.favoriteType);

  @override
  FavoriteState get initialState => FavoriteUninitialized();

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FavoriteUpdateEvent) {
      yield FavoriteUpdating();
      var firstClubFavorite = await _isFirstClubFavorite(event);
      repository.updateFavorite(favoriteId, favoriteType, event.favorite);
      if (firstClubFavorite) {
        _updateAllTeamAsFavorite(true);
      } else if (!event.favorite) {
        _updateAllTeamAsFavorite(false);
      }
      yield FavoriteUpdated(event.favorite);
    }
    if (event is FavoriteLoadEvent) {
      yield FavoriteUpdating();
      var favorite = await repository.isClubFavorite(favoriteId);
      yield FavoriteLoaded(favorite);
    }
  }
  
  Future<bool> _isFirstClubFavorite(FavoriteUpdateEvent event) async {
    if (favoriteType == FavoriteType.Club && event.favorite) {
      var currentFavoriteClubs = await repository.loadFavoriteClubs();
      return currentFavoriteClubs.isEmpty;
    }
    return false;
  }
  
  Future<void> _updateAllTeamAsFavorite(bool fav) async {
    var teams = await repository.loadClubTeams(favoriteId);
    teams.forEach((team) => repository.updateFavorite(team.code, FavoriteType.Team, fav));
  }
  
}