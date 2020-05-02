

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:v34/models/event.dart';
import 'package:v34/repositories/providers/http.dart';

class AgendaProvider {
  
  Future<List<Event>> listEvents() async {
    Response response = await dio.get("/calendars", options: buildConfigurableCacheOptions());
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les clubs');
    }
  }
}