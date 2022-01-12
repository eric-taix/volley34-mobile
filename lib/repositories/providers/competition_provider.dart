import 'package:dio/dio.dart';
import 'package:v34/models/competition.dart';
import 'package:v34/repositories/providers/http.dart';

class CompetitionProvider {
  CompetitionProvider();

  Future<List<Competition>> loadAllCompetitions<T>() async {
    Response response = await dio.get("/competitions");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => Competition.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les competitions');
    }
  }

  Future<List<TeamCompetition>> loadTeamCompetitions(String teamCode) async {
    Response response = await dio.get("/equipes/$teamCode/competitions");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => TeamCompetition.fromJson(json)).toList();
    } else {
      throw Exception("Impossible de récupérer les competitions de l'équipe $teamCode");
    }
  }
}
