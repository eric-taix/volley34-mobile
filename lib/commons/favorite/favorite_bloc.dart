

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
      repository.updateFavorite(favoriteId, favoriteType, event.favorite);
      yield FavoriteUpdated(event.favorite);
    }
    if (event is FavoriteLoadEvent) {
      yield FavoriteUpdating();
      var favorite = await repository.isClubFavorite(favoriteId);
      yield FavoriteLoaded(favorite);
    }
  }

}