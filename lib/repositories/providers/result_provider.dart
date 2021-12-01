import 'package:dio/dio.dart';
import 'package:v34/models/match_result.dart';

import 'http.dart';

class ResultProvider {
  ResultProvider();

  Future<List<MatchResult>> loadResults(String competition, String? division, String? pool) async {
    assert(pool == null || division != null, "Can't request pool result without division");
    String url = "/resultats/$competition";
    if (division != null) url += "/$division";
    if (pool != null) url += "/$pool";
    Response response = await dio.get(url);
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => MatchResult.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les résultats');
    }
  }
}
