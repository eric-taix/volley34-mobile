import 'package:flutter/foundation.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/event.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/repositories/providers/agenda_provider.dart';
import 'package:v34/repositories/providers/club_provider.dart';
import 'package:v34/repositories/providers/favorite_provider.dart';
import 'package:v34/repositories/providers/team_provider.dart';

class Repository {
  final ClubProvider clubProvider;
  final TeamProvider teamProvider;
  final FavoriteProvider favoriteProvider;
  final AgendaProvider agendaProvider;

  Repository(
      {@required this.clubProvider,
      @required this.teamProvider,
      @required this.favoriteProvider,
      @required this.agendaProvider});

  Future<List<Club>> loadAllClubs() async {
    List<Club> clubs = await clubProvider.getAllClubs();
    var favoriteClubs = await favoriteProvider.loadFavoriteClubs();
    return clubs
        .map((club) => club..favorite = favoriteClubs.contains(club.code))
        .toList();
  }

  Future<List<Club>> loadFavoriteClubs() async {
    List<Club> clubs = await clubProvider.getAllClubs();
    var favoriteClubs = await favoriteProvider.loadFavoriteClubs();
    return favoriteClubs.expand((favoriteCode) {
      var favoriteClub = clubs.firstWhere((club) => club.code == favoriteCode, orElse: null);
      List<Club> c = favoriteClub != null ? [favoriteClub..favorite = true] : [];
      return c;
    }).toList();
  }

  Future<List<Team>> loadClubTeams(String clubCode) async {
    return teamProvider.loadClubTeams(clubCode);
  }

  Future<MatchResult> lastTeamMatchResult(
      String teamCode, int nbLastMatches) async {
    List<MatchResult> matches =
        await teamProvider.lastTeamMatchesResult(teamCode);
    return matches.last;
  }

  Future<List<Event>> loadAgendaWeek(int week) async {
    return agendaProvider.listEvents();
  }

  Future<List<Event>> loadFavoriteTeamsMatches() async {
    var results = await Future.wait([
      teamProvider.loadTeamMatches("VCVX1"),
      teamProvider.loadTeamMatches("VCVX2"),
      teamProvider.loadTeamMatches("VCVX3"),
    ]);
    return results.expand((i) => i).toList();
  }

  Future updateFavorite(
      String favoriteId, FavoriteType favoriteType, bool favorite) async {
    print("Update fav $favoriteId of $favoriteType to value $favorite");
    switch (favoriteType) {
      case FavoriteType.Team:
        List<String> favoriteTeams = await favoriteProvider.loadFavoriteTeams();
        var isCurrentlyFavorite = favoriteTeams.firstWhere((favId) => favId == favoriteId, orElse: () => null) ?? false;
        if (isCurrentlyFavorite != favorite) {
          favorite ? favoriteTeams.add(favoriteId) : favoriteTeams.remove(favoriteId);
        }
        await favoriteProvider.saveFavoriteTeams(favoriteTeams);
        break;
      case FavoriteType.Club:
        List<String> favoriteClubs = await favoriteProvider.loadFavoriteClubs();
        var isCurrentlyFavorite = favoriteClubs.firstWhere((favId) => favId == favoriteId, orElse: () => null) ?? false;
        if (isCurrentlyFavorite != favorite) {
          favorite ? favoriteClubs.add(favoriteId) : favoriteClubs.remove(favoriteId);
        }
        await favoriteProvider.saveFavoriteClubs(favoriteClubs);
    }
  }

  Future<bool> isClubFavorite(String code) async {
    return favoriteProvider.loadFavoriteClubs().then((clubs) => clubs.contains(code));
  }
}
