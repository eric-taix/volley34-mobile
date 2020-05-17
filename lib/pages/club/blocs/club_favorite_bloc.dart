

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/repositories/providers/club_provider.dart';
import 'package:v34/repositories/repository.dart';

//---- STATE
@immutable
abstract class ClubFavoriteState {}

class ClubFavoriteUninitialized extends ClubFavoriteState {}

class ClubFavoriteUpdating extends ClubFavoriteState {
  ClubFavoriteUpdating();
}

class ClubFavoriteUpdated extends ClubFavoriteState {
  final bool favorite;
  ClubFavoriteUpdated(this.favorite);
}

class ClubFavoriteLoaded extends ClubFavoriteState {
  final bool favorite;
  ClubFavoriteLoaded(this.favorite);
}

//---- EVENT
@immutable
abstract class ClubFavoriteEvent {}

class ClubFavoriteUpdateEvent extends ClubFavoriteEvent {
  final bool favorite;
  ClubFavoriteUpdateEvent(this.favorite);
}

class ClubFavoriteLoadEvent extends ClubFavoriteEvent {
  ClubFavoriteLoadEvent();
}

//---- BLOC
class ClubFavoriteBloc extends Bloc<ClubFavoriteEvent, ClubFavoriteState> {

  final Repository repository;
  final String clubCode;

  ClubFavoriteBloc(this.repository, this.clubCode);

  @override
  ClubFavoriteState get initialState => ClubFavoriteUninitialized();

  @override
  Stream<ClubFavoriteState> mapEventToState(ClubFavoriteEvent event) async* {
    if (event is ClubFavoriteUpdateEvent) {
      yield ClubFavoriteUpdating();
      repository.updateFavorite(clubCode, FavoriteType.Club, event.favorite);
      yield ClubFavoriteUpdated(event.favorite);
    }
    if (event is ClubFavoriteLoadEvent) {
      yield ClubFavoriteUpdating();
      var favorite = await repository.isClubFavorite(clubCode);
      yield ClubFavoriteLoaded(favorite);
    }
  }

}