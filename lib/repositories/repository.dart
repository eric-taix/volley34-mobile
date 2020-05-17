import 'package:flutter/foundation.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/slot.dart';
import 'package:v34/models/event.dart';
import 'package:v34/models/gymnasium.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';
import 'package:v34/models/team_stats.dart';
import 'package:v34/repositories/providers/agenda_provider.dart';
import 'package:v34/repositories/providers/club_provider.dart';
import 'package:v34/repositories/providers/favorite_provider.dart';
import 'package:v34/repositories/providers/gymnasium_provider.dart';
import 'package:v34/repositories/providers/team_provider.dart';

class Repository {
  final ClubProvider _clubProvider;
  final TeamProvider _teamProvider;
  final FavoriteProvider _favoriteProvider;
  final AgendaProvider _agendaProvider;
  final GymnasiumProvider _gymnasiumProvider;

  Repository(this._clubProvider,
      this._teamProvider,
      this._favoriteProvider,
      this._agendaProvider,
      this._gymnasiumProvider);

  /// Load all clubs
  Future<List<Club>> loadAllClubs() async {
    List<Club> clubs = await _clubProvider.loadAllClubs();
    var favoriteClubs = await _favoriteProvider.loadFavoriteClubs();
    return clubs
        .map((club) => club..favorite = favoriteClubs.contains(club.code))
        .toList();
  }

  /// Load all favorite clubs
  Future<List<Club>> loadFavoriteClubs() async {
    List<Club> clubs = await _clubProvider.loadAllClubs();
    var favoriteClubs = await _favoriteProvider.loadFavoriteClubs();
    return favoriteClubs.expand((favoriteCode) {
      var favoriteClub = clubs.firstWhere((club) => club.code == favoriteCode, orElse: null);
      List<Club> c = favoriteClub != null ? [favoriteClub..favorite = true] : [];
      return c;
    }).toList();
  }

  /// Load a club's teams
  Future<List<Team>> loadClubTeams(String clubCode) async {
    return _teamProvider.loadClubTeams(clubCode);
  }

  /// Load the last match result of a team
  Future<MatchResult> lastTeamMatchResult(
      String teamCode, int nbLastMatches) async {
    List<MatchResult> matches =
        await _teamProvider.lastTeamMatchesResult(teamCode);
    return matches.last;
  }

  /// Load the general agenda for a week number
  Future<List<Event>> loadAgendaWeek(int week) async {
    return _agendaProvider.listEvents();
  }

  /// Load all favorite teams matches
  Future<List<Event>> loadFavoriteTeamsMatches() async {
    var results = await Future.wait([
      _teamProvider.loadTeamMatches("VCVX1"),
      _teamProvider.loadTeamMatches("VCVX2"),
      _teamProvider.loadTeamMatches("VCVX3"),
    ]);
    return results.expand((i) => i).toList();
  }

  /// Update a favorite by providing the [FavoriteType], a generic favoriteId and the flag (favorite or not)
  Future updateFavorite(String favoriteId, FavoriteType favoriteType, bool favorite) async {
    switch (favoriteType) {
      case FavoriteType.Team:
        List<String> favoriteTeams = await _favoriteProvider.loadFavoriteTeams();
        var isCurrentlyFavorite = favoriteTeams.firstWhere((favId) => favId == favoriteId, orElse: () => null) ?? false;
        if (isCurrentlyFavorite != favorite) {
          favorite ? favoriteTeams.add(favoriteId) : favoriteTeams.remove(favoriteId);
        }
        await _favoriteProvider.saveFavoriteTeams(favoriteTeams);
        break;
      case FavoriteType.Club:
        List<String> favoriteClubs = await _favoriteProvider.loadFavoriteClubs();
        var isCurrentlyFavorite = favoriteClubs.firstWhere((favId) => favId == favoriteId, orElse: () => null) ?? false;
        if (isCurrentlyFavorite != favorite) {
          favorite ? favoriteClubs.add(favoriteId) : favoriteClubs.remove(favoriteId);
        }
        await _favoriteProvider.saveFavoriteClubs(favoriteClubs);
    }
  }

  /// Return if a club is in favorites
  Future<bool> isClubFavorite(String code) async {
    return _favoriteProvider.loadFavoriteClubs().then((clubs) => clubs.contains(code));
  }

  /// Load the club statistics by team
  Future<List<TeamStat>> loadClubStats(String clubCode) async {
    var teams = await loadClubTeams(clubCode);
    return await _clubProvider.loadClubStats(clubCode, teams.map((team) => team.code).toList());
  }

  /// Load all available slots for a club
 Future<List<Slot>> loadClubSlots(String clubCode) async {
    return _clubProvider.loadClubSlots(clubCode);
 }
 
 Future<List<Gymnasium>> loadAllGymnasiums() async {
    return _gymnasiumProvider.loadAllGymnasiums();
 }
}
