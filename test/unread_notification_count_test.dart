import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/unread_notification_count.dart';
import 'package:moekey/status/websocket.dart';
import 'package:moekey/widgets/notification_badge_icon.dart';

void main() {
  test('unread count follows main channel events', () async {
    final initialCount = Completer<int>();
    final container = ProviderContainer(
      overrides: [
        initialUnreadNotificationCountProvider.overrideWith(
          (ref) => initialCount.future,
        ),
      ],
    );
    final subscription = container.listen(
      unreadNotificationCountProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(() {
      subscription.close();
      container.dispose();
    });

    await container.pump();
    moekeyStreamMainChannelController.add({
      'type': 'unreadNotification',
      'body': <String, dynamic>{},
    });
    await container.pump();

    initialCount.complete(4);
    expect(await container.read(unreadNotificationCountProvider.future), 5);

    moekeyStreamMainChannelController.add({
      'type': 'unreadNotification',
      'body': <String, dynamic>{},
    });
    await container.pump();
    expect(container.read(unreadNotificationCountProvider).value, 6);

    moekeyStreamMainChannelController.add({
      'type': 'readAllNotifications',
      'body': null,
    });
    await container.pump();
    expect(container.read(unreadNotificationCountProvider).value, 0);
  });

  testWidgets('badge displays the initial count', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          initialUnreadNotificationCountProvider.overrideWith((ref) async => 8),
        ],
        child: const MaterialApp(
          home: Scaffold(body: Center(child: NotificationBadgeIcon())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('notification-unread-badge')),
      findsOneWidget,
    );
    expect(find.text('8'), findsOneWidget);
    expect(tester.widget<Icon>(find.byIcon(TablerIcons.bell)).size, 24);
  });

  testWidgets('standalone indicator displays count without a bell', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          initialUnreadNotificationCountProvider.overrideWith((ref) async => 3),
        ],
        child: const MaterialApp(
          home: Scaffold(body: Center(child: NotificationCountIndicator())),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('3'), findsOneWidget);
    expect(find.byIcon(TablerIcons.bell), findsNothing);
  });

  test('badge count is capped at 99+', () {
    expect(formatUnreadNotificationCount(99), '99');
    expect(formatUnreadNotificationCount(100), '99+');
  });
}
