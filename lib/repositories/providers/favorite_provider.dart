

import 'package:localstorage/localstorage.dart';

class FavoriteProvider {
  static const FavoriteClubKey = "favorite_clubs";
  static const FavoriteTeamKey = "favorite_teams";

  final LocalStorage _localeStorage = LocalStorage("v34");

  Future<List<String>> loadFavoriteClubs() async {
    await _localeStorage.ready;
    var clubs = (_localeStorage.getItem(FavoriteClubKey) as List)?.cast<String>() ?? List();
    print("Load favorite clubs $clubs");
    return clubs;
  }

  Future<List<String>> loadFavoriteTeams() async {
    await _localeStorage.ready;
    return (_localeStorage.getItem(FavoriteTeamKey) as List)?.cast<String>() ?? List();
  }

  Future<void> saveFavoriteClubs(List<String> favoriteClubs) async {
    await _localeStorage.ready;
    print("Saved favorite clubs: $favoriteClubs");
    await _localeStorage.setItem(FavoriteClubKey, favoriteClubs);
  }

  Future<void> saveFavoriteTeams(List<String> favoriteTeams) async {
    await _localeStorage.ready;
    print("Saved favorite teams: $favoriteTeams");
    await _localeStorage.setItem(FavoriteTeamKey, favoriteTeams);
  }

}