import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:moekey/utils/open_misskey_link.dart';

void main() {
  group('resolveLocalMisskeyRoute', () {
    const instanceUrl = 'https://nya.one';

    test('maps local note links and ignores query and fragment', () {
      expect(
        resolveLocalMisskeyRoute(
          url: 'https://nya.one/notes/ap70fhbspf3p04ca?ref=timeline#reply',
          instanceUrl: instanceUrl,
        ),
        '/notes/ap70fhbspf3p04ca',
      );
    });

    test('maps local and federated account links', () {
      expect(
        resolveLocalMisskeyRoute(
          url: 'https://nya.one/@alice',
          instanceUrl: instanceUrl,
        ),
        '/user/null/alice',
      );
      expect(
        resolveLocalMisskeyRoute(
          url: 'https://nya.one/@alice@remote.example',
          instanceUrl: instanceUrl,
        ),
        '/user/remote.example/alice',
      );
    });

    test('maps other routes supported by MoeKey', () {
      expect(
        resolveLocalMisskeyRoute(
          url: 'https://nya.one/users/user-id',
          instanceUrl: instanceUrl,
        ),
        '/user/user-id',
      );
      expect(
        resolveLocalMisskeyRoute(
          url: 'https://nya.one/tags/flutter',
          instanceUrl: instanceUrl,
        ),
        '/tags/flutter',
      );
      expect(
        resolveLocalMisskeyRoute(
          url: 'https://nya.one/clips/clip-id',
          instanceUrl: instanceUrl,
        ),
        '/clips/clip-id',
      );
      expect(
        resolveLocalMisskeyRoute(
          url: 'https://nya.one/my/follow-requests',
          instanceUrl: instanceUrl,
        ),
        '/notifications?tab=sent-follow-requests',
      );
    });

    test('leaves remote, different-port, and unsupported links external', () {
      expect(
        resolveLocalMisskeyRoute(
          url: 'https://remote.example/notes/note-id',
          instanceUrl: instanceUrl,
        ),
        isNull,
      );
      expect(
        resolveLocalMisskeyRoute(
          url: 'https://nya.one:8443/notes/note-id',
          instanceUrl: instanceUrl,
        ),
        isNull,
      );
      expect(
        resolveLocalMisskeyRoute(
          url: 'https://nya.one/channels/channel-id',
          instanceUrl: instanceUrl,
        ),
        isNull,
      );
    });
  });

  testWidgets('opens a local note link with the native router', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => TextButton(
            onPressed: () => openMisskeyLink(
              context,
              url: 'https://nya.one/notes/local-note',
              instanceUrl: 'https://nya.one',
            ),
            child: const Text('open'),
          ),
        ),
        GoRoute(
          path: '/notes/:id',
          builder: (_, state) => Text('note:${state.pathParameters['id']}'),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('note:local-note'), findsOneWidget);
  });
}
