part of 'favorite_cubit.dart';

@immutable
abstract class FavoriteState {}

class FavoriteStateInitial extends FavoriteState {}

class FavoriteStateClubLoading extends FavoriteState {}

class FavoriteStateClubNotSet extends FavoriteState {}

class FavoriteStateTeamLoading extends FavoriteState {
  final Club club;

  FavoriteStateTeamLoading(this.club);
}

class FavoriteStateTeamNotSet extends FavoriteStateTeamLoading {
  FavoriteStateTeamNotSet(Club club) : super(club);
}

class FavoriteStateTeamLoaded extends FavoriteStateTeamLoading {
  final Team team;
  FavoriteStateTeamLoaded(Club club, this.team) : super(club);
}
