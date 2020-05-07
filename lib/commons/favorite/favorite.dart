

import 'package:equatable/equatable.dart';

enum FavoriteType {
  Team, Club
}

class Favorite extends Equatable {
  final bool value;
  final String id;
  final FavoriteType type;

  Favorite(this.value, this.id, this.type);

  @override
  List<Object> get props => [id, value, type];
}