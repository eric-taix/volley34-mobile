import 'package:dio/dio.dart';
import 'package:v34/models/gymnasium.dart';

import 'http.dart';

class GymnasiumProvider {
  Future<List<Gymnasium>> loadAllGymnasiums() async {
    Response response = await dio.get("/gymnases");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => Gymnasium.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les gymnases');
    }
  }

  Future<Gymnasium> loadGymnasium(String? gymnasiumCode) async {
    Response response = await dio.get("/gymnases/$gymnasiumCode");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return Gymnasium.fromJson(response.data);
    } else {
      throw Exception('Impossible de récupérer le gymnase');
    }
  }
}
