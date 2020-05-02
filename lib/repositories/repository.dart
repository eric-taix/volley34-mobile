import 'package:flutter/foundation.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/event.dart';
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

  Future<List<Club>> loadClubs() async {
    List<Club> clubs = await clubProvider.getAllClubs();
    var favoriteClubs = await favoriteProvider.loadFavoriteClubs();
    return clubs
        .map((club) => club..favorite = favoriteClubs.contains(club.code))
        .toList();
  }

  Future<List<Club>> loadFavoriteClubCodes() async {
    var clubs = await loadClubs();
    return clubs.where((club) => club.favorite).toList();
  }

  Future<void> saveFavoriteClubs(List<Club> favoriteClubs) async {
    return favoriteProvider
        .saveFavoriteClubs(favoriteClubs.map((club) => club.code).toList());
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
}
