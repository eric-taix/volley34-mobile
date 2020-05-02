import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:v34/models/club.dart';

import 'http.dart';

class ClubProvider {

  ClubProvider();

  Future<List<Club>> getAllClubs<T>() async {
    Response response = await dio.get("/clubs", options: buildConfigurableCacheOptions());
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => Club.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les clubs');
    }
  }

}