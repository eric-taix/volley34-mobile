import 'package:localstorage/localstorage.dart';

class FavoriteProvider {
  static const FavoriteClubKey = "favorite_clubs";
  static const FavoriteTeamKey = "favorite_teams";

  final LocalStorage _localeStorage = localStorage;

  Future<List<String?>> loadFavoriteClubs() async {
    final clubs = _localeStorage.getItem(FavoriteClubKey)?.split(',') ?? [];
    return Future.value(clubs);
  }

  Future<List<String?>> loadFavoriteTeams() async {
    final teams = _localeStorage.getItem(FavoriteTeamKey)?.split(',') ?? [];
    return Future.value(teams);
  }

  Future<void> saveFavoriteClubs(List<String?> favoriteClubs) async {
    _localeStorage.setItem(FavoriteClubKey, favoriteClubs.whereType<String>().join(','));
  }

  Future<void> saveFavoriteTeams(List<String?> favoriteTeams) async {
    _localeStorage.setItem(FavoriteTeamKey, favoriteTeams.whereType<String?>().join(','));
  }
}
