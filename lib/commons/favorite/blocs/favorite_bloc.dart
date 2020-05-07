


import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:v34/commons/favorite/favorite.dart';

@immutable
abstract class FavoriteState extends Equatable {}

class FavoriteUninitialized extends FavoriteState {
  @override
  List<Object> get props => [];
}

class FavoriteUpdated extends FavoriteState {
  final Favorite favorite;

  FavoriteUpdated(this.favorite);

  @override
  List<Object> get props => [favorite];
}

@immutable
abstract class FavoriteEvent extends Equatable {
}

class UpdateFavorite extends FavoriteEvent {

  final Favorite favorite;

  UpdateFavorite(this.favorite);

  @override
  List<Object> get props => [favorite];
}


