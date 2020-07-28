import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:intl/intl.dart';
import 'package:v34/models/event.dart';
import 'package:v34/repositories/providers/http.dart';

class AgendaProvider {
  
  Future<List<Event>> listEvents() async {
    Response response = await dio.get("/calendars", options: buildConfigurableCacheOptions());
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les événements');
    }
  }

  Future<List<Event>> listTeamMonthMatches(String teamCode) async {
    Response response = await dio.get("/equipes/$teamCode/matchs", options: buildConfigurableCacheOptions());
    if (response.statusCode == 200) {
      List<Event> events = (response.data as List).map((json) => Event.fromJson(json)).toList();
      events.removeWhere((event) => event.date.compareTo(DateTime.now()) < 0 || event.date.compareTo(DateTime.now().add(Duration(days: 30))) > 0);
      return events;
    } else {
      throw Exception('Impossible de récupérer les événements');
    }
  }

  Future<List<Event>> listTeamMonthEvents(String teamCode) async {
    DateTime min = DateTime.now(), max = min.add(Duration(days: 30));
    DateFormat format = DateFormat("yyyy-MM-ddTHH:00:00");
    Response response = await dio.get("/calendars?equipe=$teamCode&min=${format.format(min)}&max=${format.format(max)}", options: buildConfigurableCacheOptions());
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les événements');
    }
  }

}