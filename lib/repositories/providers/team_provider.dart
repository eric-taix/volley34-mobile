
import 'package:dio/dio.dart';
import 'package:v34/models/match_result.dart';
import 'package:v34/models/team.dart';

import 'http.dart';

class TeamProvider {

  Future<List<Team>>loadClubTeams(String clubCode) async {
    Response response = await dio.get("/clubs/$clubCode/equipes").catchError((error) {
      print("Error while getting teams for club $clubCode");
    });
    if (response?.statusCode == 200) {
      return (response.data as List).map((json) => Team.fromJson(json)).toList();
    } else {
      return List();
    }
  }

  Future<List<MatchResult>> lastTeamMatchResult(String teamCode) async {
    Response response = await dio.get("/equipes/$teamCode/resultats");
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => MatchResult.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les clubs');
    }
  }

}