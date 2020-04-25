

import 'package:localstorage/localstorage.dart';

class FavoriteProvider {
  static const FavoriteClubKey = "favorite_clubs";

  final LocalStorage _localeStorage = LocalStorage("v34");

  Future<List<dynamic>> loadFavoriteClubs() async {
    await _localeStorage.ready;
    return (_localeStorage.getItem(FavoriteClubKey) as List) ?? List();
  }

  Future<List<dynamic>> loadFavoriteTeams() async {
    await _localeStorage.ready;
    return (_localeStorage.getItem("favorite_teams") as List) ?? List();
  }

  Future<void> saveFavoriteClubs(List<String> favoriteClubs) async {
    await _localeStorage.ready;
    _localeStorage.setItem(FavoriteClubKey, favoriteClubs);
  }

}