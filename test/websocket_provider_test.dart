import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/notes_listener.dart';
import 'package:moekey/status/websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  test('refreshing the socket does not invalidate during provider disposal',
      () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final sockets = <WebSocket>[];
    final serverSubscription =
        server.transform(WebSocketTransformer()).listen(sockets.add);

    final container = ProviderContainer(
      overrides: [
        moekeyWebSocketProvider.overrideWithBuild((ref, _) async {
          final channel = WebSocketChannel.connect(
            Uri.parse('ws://${server.address.host}:${server.port}'),
          );
          ref.onDispose(channel.sink.close);
          await channel.ready;
          return channel;
        }),
      ],
    );
    final listener = container.listen(
      moekeyGlobalEventProvider,
      (_, _) {},
      fireImmediately: true,
    );

    addTearDown(() async {
      listener.close();
      container.dispose();
      await serverSubscription.cancel();
      await server.close(force: true);
    });

    await container.read(moekeyGlobalEventProvider.future);
    await _waitUntil(() => sockets.isNotEmpty);

    container.invalidate(moekeyWebSocketProvider);

    await _waitUntil(() => sockets.length >= 2);
    expect(sockets, hasLength(greaterThanOrEqualTo(2)));
  });

  test('disposing a note listener unsubscribes outside provider disposal',
      () async {
    final container = ProviderContainer(
      overrides: [
        moekeyWebSocketProvider.overrideWithBuild((_, _) => null),
      ],
    );
    final listener = container.listen(
      noteIdListenerProvider('note-id'),
      (_, _) {},
      fireImmediately: true,
    );

    await container.pump();
    listener.close();
    await container.pump();
    await Future<void>.delayed(Duration.zero);
    await container.pump();

    container.dispose();
  });
}

Future<void> _waitUntil(bool Function() condition) async {
  final timeout = DateTime.now().add(const Duration(seconds: 3));
  while (!condition()) {
    if (DateTime.now().isAfter(timeout)) {
      fail('Timed out waiting for the WebSocket provider.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}
