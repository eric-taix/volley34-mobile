import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

var dio = Dio(BaseOptions(
  baseUrl: "http://api.volley34.fr/v1/",
))
  ..interceptors.add(DioCacheManager(
    CacheConfig(
      baseUrl: "http://api.volley34.fr",
      defaultMaxAge: Duration.zero,
      defaultMaxStale: Duration(days: 7),
    ),
  ).interceptor)
  ..interceptors.add(DebugCacheInterceptor());

class DebugCacheInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    List<String>? responseSource = response.headers["dio_cache_header_key_data_source"];
    print("Request: ${response.realUri} ${responseSource?[0] ?? "from_network"}");
    super.onResponse(response, handler);
  }
}
