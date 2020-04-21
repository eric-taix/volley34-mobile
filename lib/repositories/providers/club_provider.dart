import 'package:dio/dio.dart';

import 'http.dart';

class ClubProvider {

  ClubProvider();

  Future<Response<T>>getAllClubs<T>() => dio.get("/clubs");

}