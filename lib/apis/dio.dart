import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';

class MisskeyApisHttpClient {
  MisskeyApisHttpClient({
    required this.host,
    required this.accessToken,
    required this.onUnauthorized,
  }) {
    client = Dio(BaseOptions(
      baseUrl: "$host/api",
    ));
    client.interceptors.add(
      RetryInterceptor(
        dio: client,
        logPrint: print,
      ),
    );
  }

  String host;
  String accessToken;
  Function? onUnauthorized;
  late Dio client;

  Future<T> post<T>(
    String path, {
    Map? data,
    auth = true,
    Options? options,
  }) async {
    try {
      return (await client.post(path,
              data: {
                if (auth) "i": accessToken,
                ...?data,
              },
              options: options))
          .data;
    } on DioException catch (e) {
      // 401
      if (e.response?.statusCode == 401) {
        onUnauthorized?.call();
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> get(
    String path, {
    Map? data,
    auth = true,
    Options? options,
  }) async {
    return (await client.get(path,
            queryParameters: {
              if (auth) "i": accessToken,
              ...?data,
            },
            options: options))
        .data;
  }
}
