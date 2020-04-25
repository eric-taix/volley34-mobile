import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/providers/club_provider.dart';
import 'package:v34/repositories/providers/favorite_provider.dart';
import 'package:v34/repositories/providers/team_provider.dart';

class Repository {
  final ClubProvider clubProvider;
  final TeamProvider teamProvider;
  final FavoriteProvider favoriteProvider;

  Repository({@required this.clubProvider, @required this.teamProvider, @required this.favoriteProvider});

  Future<List<Club>> loadClubs() async {
    Response res = await clubProvider.getAllClubs();
    if (res.statusCode == 200) {
      var clubs = (res.data as List).map((json) => Club.fromJson(json)).toList();
      var favorites = await favoriteProvider.loadFavoriteClubs();
      return clubs.map((club) => club..favorite = favorites.contains(club.code)).toList();
    } else {
      throw Exception('Impossible de récupérer les clubs');
    }
  }

  Future<List<Club>> loadFavoriteClubCodes() async {
    var clubs = await loadClubs();
    return clubs.where((club) => club.favorite).toList();
  }

  Future<void> saveFavoriteClubs(List<Club> favoriteClubs) async {
    return favoriteProvider.saveFavoriteClubs(favoriteClubs.map((club) => club.code).toList());
  }

  Future<List<Team>> loadClubTeams(String clubCode) async {
    return teamProvider.loadClubTeams(clubCode);
  }

  Future<MatchResult>lastTeamMatchResult(String teamCode, int nbLastMatches) async {
    List<MatchResult> matches = await teamProvider.lastTeamMatchResult(teamCode);
    return matches.last;
  }
}
