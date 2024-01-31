import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:moekey/state/server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio.g.dart';

@Riverpod(keepAlive: true)
class Http extends _$Http {
  @override
  Future<Dio> build() async {
    var user = await ref.watch(currentLoginUserProvider.future);
    var host = user?.serverUrl;

    var dio = Dio(BaseOptions(
      baseUrl: host != null ? "$host/api" : "http://localhost",
    ));

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        return client;
      },
    );
    return dio;
  }
}

@Riverpod(keepAlive: true)
class SelectHttp extends _$SelectHttp {
  @override
  Dio build() {
    var host = ref.watch(selectServerHostProvider);
    var dio = Dio(BaseOptions(
      baseUrl: host != "" ? "$host/api" : "",
    ));

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        return client;
      },
    );
    return dio;
  }
}
