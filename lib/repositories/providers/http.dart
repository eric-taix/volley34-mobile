import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

var dio = Dio(BaseOptions(
  baseUrl: "http://api.volley34.fr/v1/",
))
  ..interceptors.add(DioCacheManager(
    CacheConfig(
      baseUrl: "http://api.volley34.fr",
      defaultMaxAge: Duration(hours: 6),
      defaultMaxStale: Duration(hours: 24),
    ),
  ).interceptor)
  ..interceptors.add(LogInterceptor(requestBody: false, requestHeader: false, responseBody: false, responseHeader: false));
