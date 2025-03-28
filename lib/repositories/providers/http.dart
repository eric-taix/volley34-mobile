import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:v34/message_cubit.dart';

late final Dio dio;

final CacheStore _cacheStore = MemCacheStore(maxEntrySize: 1600000, maxSize: 14340032);

void initDio(MessageCubit messageCubit) {
  final defaultCacheOptions = CacheOptions(
    store: _cacheStore,
    policy: CachePolicy.forceCache,
    hitCacheOnErrorExcept: [401, 403],
    maxStale: const Duration(minutes: 30),
    priority: CachePriority.normal,
    cipher: null,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );

  var apiTest = false;
  dio = Dio(BaseOptions(
    baseUrl: !kDebugMode || !apiTest ? "http://api.volley34.fr/v1/" : "http://apitest.volley34.fr/v1/",
  ))
    ..interceptors.add(DioCacheInterceptor(
      options: defaultCacheOptions,
    ))
    ..interceptors.add(DebugCacheInterceptor())
    ..interceptors.add(ServerErrorInterceptor(messageCubit));
}

Map<String, List<Duration>> slowRequests = Map();

class DebugCacheInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    DateTime? start = response.requestOptions.extra["start"];
    Duration requestDuration = start != null ? DateTime.now().difference(start) : Duration();
    print(
        "${requestDuration.inMilliseconds > 1000 ? "SLOW [${requestDuration.inMilliseconds} ms]" : ""} Request: ${response.realUri}");
    if (requestDuration.inMilliseconds > 1000) {
      var durations = slowRequests.putIfAbsent(response.realUri.path, () => <Duration>[])..add(requestDuration);
      if (durations.length > 10) {
        durations.removeAt(0);
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra["start"] = DateTime.now();
    super.onRequest(options, handler);
  }
}

class ServerErrorInterceptor extends InterceptorsWrapper {
  final MessageCubit messageCubit;

  ServerErrorInterceptor(this.messageCubit);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout) {
      messageCubit.showMessage(
          message: "Impossible de contacter le serveur. Merci d'essayer à nouveau dans quelques minutes.");
    } else if (err.response != null) {
      if ((err.response!.statusCode ?? 0) >= 500) {
        print("Error for request ${err.response?.realUri ?? "-nop-"} [${err.error} - ${err.response?.data}]");
        messageCubit.showMessage(
            message: "Le serveur a rencontré un problème. Merci d'essayer à nouveau dans quelques minutes.");
      } else {
        messageCubit.showMessage(
            message: "Nous rencontrons un problème. Merci d'essayer à nouveau dans quelques minutes.");
      }
    } else {
      messageCubit.showMessage(
          message: "Nous rencontrons un problème. Merci d'essayer à nouveau dans quelques minutes.");
    }
    _cacheStore.clean();
    super.onError(err, handler);
  }
}
