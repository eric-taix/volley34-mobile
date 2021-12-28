import 'package:dio/dio.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/event.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/ranking.dart';
import 'package:v34/models/team.dart';

import 'http.dart';

class TeamProvider {
  Future<Team?> loadTeam(String teamCode) async {
    Response response = await dio.get("/equipes/$teamCode").catchError((error) {
      print("Error while getting team $teamCode");
    });
    if (response.statusCode == 200 || response.statusCode == 304) {
      return Team.fromJson(response.data);
    } else {
      return null;
    }
  }

  Future<List<Team>> loadClubTeams(String? clubCode) async {
    Response response = await dio.get("/clubs/$clubCode/equipes").catchError((error) {
      print("Error while getting teams for club $clubCode");
    });
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => Team.fromJson(json)).toSet().toList()
        ..sort((t1, t2) => t1.code!.compareTo(t2.code!));
    } else {
      return [];
    }
  }

  Future<List<MatchResult>> lastTeamMatchesResult(String? teamCode) async {
    Response response = await dio.get("/equipes/$teamCode/resultats");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => MatchResult.fromJson(json)).toList();
    } else {
      throw Exception("Impossible to retrieve matches result for team $teamCode");
    }
  }

  Future<List<Event>> loadTeamMatches(String teamCode) async {
    Response response = await dio.get("/equipes/$teamCode/matchs");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception("Impossible to retrieve matches for team  $teamCode");
    }
  }

  Future<List<RankingSynthesis>> loadClassificationSynthesis(String? teamCode) async {
    Response response = await dio.get("/Classements/equipes/$teamCode");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => RankingSynthesis.fromJson(json)).toList();
    } else {
      throw Exception("Impossible to retrieve classification synthesis for team  $teamCode");
    }
  }

  Future<List<RankingSynthesis>> loadAllRankingSynthesis() async {
    Response response = await dio.get("/Classements");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => RankingSynthesis.fromJson(json)).toList();
    } else {
      throw Exception("Impossible to retrieve all rankings");
    }
  }

  Future<Club> loadTeamClub(String? teamCode) async {
    Response response = await dio.get("/equipes/$teamCode/club");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return Club.fromJson(response.data);
    } else {
      throw Exception("Impossible to retrieve club for team $teamCode");
    }
  }
}
