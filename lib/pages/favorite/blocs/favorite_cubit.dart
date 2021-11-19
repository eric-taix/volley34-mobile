import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/repository.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final Repository repository;

  FavoriteCubit(this.repository) : super(FavoriteStateInitial());

  void loadFavoriteClub() async {
    emit(FavoriteStateClubLoading());
    Club? favoriteClub = await repository.loadFavoriteClub();
    if (favoriteClub != null && favoriteClub.code != null) {
      emit(FavoriteStateTeamLoading(favoriteClub));
      Team? mayBeFavoriteTeam = await repository.loadFavoriteTeam(favoriteClub.code!);
      if (mayBeFavoriteTeam != null) {
        emit(FavoriteStateTeamLoaded(favoriteClub, mayBeFavoriteTeam));
      } else {
        emit(FavoriteStateTeamNotSet(favoriteClub));
      }
    } else {
      emit(FavoriteStateClubNotSet());
    }
  }
}
