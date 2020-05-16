import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/slot.dart';
import 'package:v34/models/team_stats.dart';

import 'http.dart';

class ClubProvider {

  ClubProvider();

  Future<List<Club>> loadAllClubs<T>() async {
    Response response = await dio.get("/clubs", options: buildConfigurableCacheOptions());
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => Club.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les clubs');
    }
  }

  Future<List<TeamStat>> loadClubStats(String clubCode, List<String> teamsCode) async {
    Response response = await dio.get("/clubs/$clubCode/stats", options: buildConfigurableCacheOptions());
    if (response.statusCode == 200) {
      return teamsCode.map((teamCode) {
        return TeamStat.fromJson(teamCode, (response.data as Map)["Statistiques"][teamCode]);
      }).toList();
    } else {
      throw Exception('Impossible de récupérer les stats du club $clubCode');
    }
  }

  Future<List<Slot>> loadClubSlots(String clubCode) async {
    Response response = await dio.get("/clubs/$clubCode/creneaux", options: buildConfigurableCacheOptions());
    if (response.statusCode == 200) {
        return (response.data as List).map((json) => Slot.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les créneaux du club $clubCode');
    }
  }

}