import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/apis/dio.dart';

class _StatusAdapter implements HttpClientAdapter {
  _StatusAdapter(this.statusCode);

  final int statusCode;
  int requestCount = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount++;
    return ResponseBody.fromString('{"error":"server error"}', statusCode);
  }
}

void main() {
  test('a 500 response is surfaced immediately without retries', () async {
    final api = MisskeyApisHttpClient(
      host: 'https://example.com',
      accessToken: '',
      onUnauthorized: null,
    );
    final adapter = _StatusAdapter(500);
    api.client.httpClientAdapter = adapter;

    await expectLater(
      api.post('/notes/timeline'),
      throwsA(isA<DioException>()),
    );

    expect(adapter.requestCount, 1);
  });
}
