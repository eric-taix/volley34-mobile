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
  final String? favoriteId;
  final FavoriteType favoriteType;

  FavoriteBloc(this.repository, this.favoriteId, this.favoriteType) : super(FavoriteUninitialized()) {
    on<FavoriteUpdateEvent>((event, emit) async {
      emit(FavoriteUpdating());
      await repository.updateFavorite(favoriteId, favoriteType, event.favorite);
      emit(FavoriteUpdated(event.favorite));
    });
    on<FavoriteLoadEvent>((event, emit) async {
      emit(FavoriteUpdating());
      var favorite;
      if (favoriteType == FavoriteType.Club)
        favorite = await repository.isClubFavorite(favoriteId);
      else
        favorite = await repository.isTeamFavorite(favoriteId);
      emit(FavoriteLoaded(favorite));
    });
  }
}
