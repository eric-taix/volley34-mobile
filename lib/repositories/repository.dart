import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:v34/commons/favorite/favorite.dart';
import 'package:v34/models/classication.dart';
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
import 'package:v34/repositories/providers/map_provider.dart';
import 'package:v34/repositories/providers/team_provider.dart';

class Repository {
  final ClubProvider _clubProvider;
  final TeamProvider _teamProvider;
  final FavoriteProvider _favoriteProvider;
  final AgendaProvider _agendaProvider;
  final GymnasiumProvider _gymnasiumProvider;
  final MapProvider _mapProvider;

  Repository(this._clubProvider, this._teamProvider, this._favoriteProvider,
      this._agendaProvider, this._gymnasiumProvider, this._mapProvider);

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
      var favoriteClub =
          clubs.firstWhere((club) => club.code == favoriteCode, orElse: null);
      List<Club> c =
          favoriteClub != null ? [favoriteClub..favorite = true] : [];
      return c;
    }).toList();
  }

  /// Load all favorite team codes
  Future<List<String>> loadFavoriteTeamCodes() async {
    return _favoriteProvider.loadFavoriteTeams();
  }

  /// Load all favorite club codes
  Future<List<String>> loadFavoriteClubCodes() async {
    return _favoriteProvider.loadFavoriteClubs();
  }

  Future<Club> loadClub(String clubCode) async {
    return _clubProvider.loadClub(clubCode);
  }

  //------ TEAM -------

  /// Load a club's teams
  Future<List<Team>> loadClubTeams(String clubCode) async {
    return _teamProvider.loadClubTeams(clubCode);
  }

  /// Load the last N matches result of a team
  Future<List<MatchResult>> loadTeamLastMatchesResult(
      String teamCode, int nbLastMatches) async {
    List<MatchResult> matches =
        await _teamProvider.lastTeamMatchesResult(teamCode);
    return matches
        .sublist(
            matches.length > nbLastMatches ? matches.length - nbLastMatches : 0)
        .toList();
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

  /// Load classification synthesis
  Future<List<ClassificationSynthesis>> loadTeamClassificationSynthesis(
      String teamCode) async {
    return await _teamProvider.loadClassificationSynthesis(teamCode);
  }

  //-------------------------------

  Future<MatchResult> loadTeamLastMatchResult(String teamCode) async {
    var matches = await loadTeamLastMatchesResult(teamCode, 1);
    return matches.isNotEmpty ? matches.last : null;
  }

  /// Load the general agenda for a week number
  Future<List<Event>> loadAgendaWeek(int week) async {
    return _agendaProvider.listEvents();
  }

  Future<List<Event>> loadTeamMonthAgenda(String teamCode) async {
    List<Event> matches = await _agendaProvider.listTeamMonthMatches(teamCode);
    List<Event> events = await _agendaProvider.listTeamMonthEvents(teamCode);
    events.addAll(matches);
    return events;
  }

  /// Update a favorite by providing the [FavoriteType], a generic favoriteId and the flag (favorite or not)
  Future updateFavorite(
      String favoriteId, FavoriteType favoriteType, bool favorite) async {
    switch (favoriteType) {
      case FavoriteType.Team:
        List<String> favoriteTeams =
            await _favoriteProvider.loadFavoriteTeams();
        var isCurrentlyFavorite = favoriteTeams.firstWhere(
                (favId) => favId == favoriteId,
                orElse: () => null) ??
            false;
        if (isCurrentlyFavorite != favorite) {
          favorite
              ? favoriteTeams.add(favoriteId)
              : favoriteTeams.remove(favoriteId);
        }
        _favoriteProvider.saveFavoriteTeams(favoriteTeams);
        break;
      case FavoriteType.Club:
        List<String> favoriteClubs =
            await _favoriteProvider.loadFavoriteClubs();
        var isCurrentlyFavorite = favoriteClubs.firstWhere(
                (favId) => favId == favoriteId,
                orElse: () => null) ??
            false;
        if (isCurrentlyFavorite != favorite) {
          favorite
              ? favoriteClubs.add(favoriteId)
              : favoriteClubs.remove(favoriteId);
        }
        _favoriteProvider.saveFavoriteClubs(favoriteClubs);
    }
  }

  /// Return if a club is in favorites
  Future<bool> isClubFavorite(String code) async {
    return _favoriteProvider
        .loadFavoriteClubs()
        .then((clubs) => clubs.contains(code));
  }

  /// Return if a team is in favorites
  Future<bool> isTeamFavorite(String code) async {
    return _favoriteProvider
        .loadFavoriteTeams()
        .then((teams) => teams.contains(code));
  }

  /// Load the club statistics by team
  Future<List<TeamStat>> loadClubStats(String clubCode) async {
    return _clubProvider.loadClubStats(clubCode);
  }

  /// Load all available slots for a club
  Future<List<Slot>> loadClubSlots(String clubCode) async {
    return _clubProvider.loadClubSlots(clubCode);
  }

  /// Load all gymnasiums
  Future<List<Gymnasium>> loadAllGymnasiums() async {
    return _gymnasiumProvider.loadAllGymnasiums();
  }

  /// Load a gymnasium
  Future<Gymnasium> loadGymnasium(String gymnasiumCode) async {
    return _gymnasiumProvider.loadGymnasium(gymnasiumCode);
  }

  /// Load gymnasium map camera
  Future<CameraPosition> loadCameraPosition(String mapName) {
    return _mapProvider.loadCameraPosition(mapName);
  }

  void saveCameraPosition(String mapName, CameraPosition cameraPosition) {
    return _mapProvider.saveCameraPosition(mapName, cameraPosition);
  }
}
