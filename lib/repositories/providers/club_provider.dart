import 'package:dio/dio.dart';
import 'package:v34/models/club.dart';
import 'package:v34/models/slot.dart';
import 'package:v34/models/team_stats.dart';

import 'http.dart';

class ClubProvider {
  ClubProvider();

  Future<List<Club>> loadAllClubs<T>() async {
    Response response = await dio.get("/clubs");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => Club.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les clubs');
    }
  }

  Future<Club> loadClub(String? clubCode) async {
    Response response = await dio.get("/clubs/$clubCode");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return Club.fromJson(response.data);
    } else {
      throw Exception('Impossible de récupérer le club');
    }
  }

  Future<List<TeamStat>> loadClubStats(String? clubCode) async {
    Response response = await dio.get("/clubs/$clubCode/stats");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List<dynamic>).map((teamStatJson) => TeamStat.fromJson(teamStatJson)).toList();
    } else {
      throw Exception('Impossible de récupérer les stats du club $clubCode');
    }
  }

  Future<List<Slot>> loadClubSlots(String? clubCode) async {
    Response response = await dio.get("/clubs/$clubCode/creneaux");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => Slot.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les créneaux du club $clubCode');
    }
  }
}
