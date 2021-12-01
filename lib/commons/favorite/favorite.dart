import 'package:equatable/equatable.dart';

enum FavoriteType { Team, Club }

class Favorite extends Equatable {
  final String? id;
  final FavoriteType type;

  Favorite(this.id, this.type);

  @override
  List<Object?> get props => [id, type];
}
