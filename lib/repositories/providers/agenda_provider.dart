import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:v34/models/event.dart';
import 'package:v34/repositories/providers/http.dart';

class AgendaProvider {
  Future<List<Event>> listEvents() async {
    Response response = await dio.get("/calendars");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les événements');
    }
  }

  Future<List<Event>> listTeamMatches(String? teamCode, int days) async {
    Response response = await dio.get("/equipes/$teamCode/matchs?filter=weeks&value=${(days / 7).ceil()}");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les événements');
    }
  }

  Future<List<Event>> listTeamEvents(String? teamCode, int days) async {
    DateTime min = DateTime.now().subtract(Duration(days: 1)), max = min.add(Duration(days: days));
    DateFormat format = DateFormat("yyyy-MM-ddTHH:00:00");
    Response response =
        await dio.get("/calendars?equipe=$teamCode&min=${format.format(min)}&max=${format.format(max)}");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les événements');
    }
  }
}
