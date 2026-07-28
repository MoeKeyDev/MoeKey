import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/widgets/mk_user_avatar.dart';

Widget _avatarApp(OnlineStatus? onlineStatus) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(
        body: Center(child: MkUserAvatar(size: 48, onlineStatus: onlineStatus)),
      ),
    ),
  );
}

Color _indicatorColor(WidgetTester tester) {
  final indicator = tester.widget<DecoratedBox>(
    find.byKey(const ValueKey('mk-user-avatar-online-indicator-fill')),
  );
  return (indicator.decoration as BoxDecoration).color!;
}

void main() {
  testWidgets('only active and online avatars show an online indicator', (
    tester,
  ) async {
    await tester.pumpWidget(_avatarApp(OnlineStatus.online));
    expect(
      find.byKey(const ValueKey('mk-user-avatar-online-indicator')),
      findsOneWidget,
    );
    expect(_indicatorColor(tester), const Color(0xFF98C934));

    await tester.pumpWidget(_avatarApp(OnlineStatus.active));
    expect(
      find.byKey(const ValueKey('mk-user-avatar-online-indicator')),
      findsOneWidget,
    );
    expect(_indicatorColor(tester), const Color(0xFFE4BC48));

    await tester.pumpWidget(_avatarApp(OnlineStatus.offline));
    expect(
      find.byKey(const ValueKey('mk-user-avatar-online-indicator')),
      findsNothing,
    );

    await tester.pumpWidget(_avatarApp(null));
    expect(
      find.byKey(const ValueKey('mk-user-avatar-online-indicator')),
      findsNothing,
    );
  });
}
