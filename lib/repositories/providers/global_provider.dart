import 'package:dio/dio.dart';
import 'package:v34/models/division.dart';

import 'http.dart';

class GlobalProvider {
  GlobalProvider();

  Future<List<Division>> loadDivisions() async {
    Response response = await dio.get("/divisions");
    if (response.statusCode == 200 || response.statusCode == 304) {
      return (response.data as List).map((json) => Division.fromJson(json)).toList();
    } else {
      throw Exception('Impossible de récupérer les divisions');
    }
  }
}
