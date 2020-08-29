
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:v34/models/gymnasium.dart';

import 'http.dart';

class GymnasiumProvider {

  Future<List<Gymnasium>> loadAllGymnasiums() async {
    Response response = await dio.get("/gymnases", options: buildConfigurableCacheOptions());
    if (response.statusCode == 200) {
      return (response.data as List).map((json) => Gymnasium.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les gymnases');
    }
  }

  Future<Gymnasium> loadGymnasium(String gymnasiumCode) async {
    Response response = await dio.get("/gymnases/$gymnasiumCode", options: buildConfigurableCacheOptions());
    if (response.statusCode == 200) {
      return Gymnasium.fromJson(response.data);
    } else {
      throw Exception('Impossible de récupérer le gymnase');
    }
  }
}