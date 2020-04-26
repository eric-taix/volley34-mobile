import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:v34/models/team.dart';

import 'http.dart';

class ClubProvider {

  ClubProvider();

  Future<Response<T>>getAllClubs<T>() => dio.get("/clubs", options: buildConfigurableCacheOptions());

}