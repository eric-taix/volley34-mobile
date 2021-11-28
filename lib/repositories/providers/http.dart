import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

final defaultCacheOptions = CacheOptions(
  store: MemCacheStore(),
  policy: CachePolicy.forceCache,
  hitCacheOnErrorExcept: [401, 403],
  maxStale: const Duration(minutes: 30),
  priority: CachePriority.normal,
  cipher: null,
  keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  allowPostMethod: false,
);

var dio = Dio(BaseOptions(
  baseUrl: "http://api.volley34.fr/v1/",
))
  ..interceptors.add(DioCacheInterceptor(
    options: defaultCacheOptions,
  ))
  ..interceptors.add(DebugCacheInterceptor());

class DebugCacheInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("Request: ${response.realUri}");
    super.onResponse(response, handler);
  }
}
