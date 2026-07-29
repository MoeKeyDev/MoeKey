import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/emojis.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/widgets/emoji_list.dart';
import 'package:twemoji_v2/twemoji_v2.dart';

void main() {
  testWidgets('builds only the visible emoji rows', (tester) async {
    tester.view.physicalSize = const Size(360, 360);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final emojis = List.generate(
      300,
      (index) => EmojiSimple(
        aliases: const [],
        name: 'emoji$index',
        url: '😀',
        code: true,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiEmojisByCategoryProvider.overrideWith((ref) => {'test': emojis}),
        ],
        child: const MaterialApp(
          home: Scaffold(body: EmojiList(onInsert: _ignoreInsert)),
        ),
      ),
    );
    await tester.pump();

    // 300 source emoji would all be mounted with the old category-level
    // Column. The flattened ListView mounts only the viewport and cache rows.
    expect(find.byType(Twemoji).evaluate().length, lessThan(100));
  });

  testWidgets('coalesces rapid category taps without layout exceptions', (
    tester,
  ) async {
    final emojisByCategory = {
      for (var category = 0; category < 4; category++)
        'test$category': List.generate(
          80,
          (index) => EmojiSimple(
            aliases: const [],
            name: 'emoji$category-$index',
            url: '😀',
            code: true,
          ),
        ),
    };

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          apiEmojisByCategoryProvider.overrideWith((ref) => emojisByCategory),
        ],
        child: const MaterialApp(
          home: Scaffold(body: EmojiList(onInsert: _ignoreInsert)),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(Tab).at(1));
    await tester.pump(const Duration(milliseconds: 16));
    await tester.tap(find.byType(Tab).at(3));
    await tester.pump(const Duration(milliseconds: 16));
    await tester.tap(find.byType(Tab).at(2));
    await tester.pumpAndSettle();

    expect(find.text('test2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void _ignoreInsert(Map data) {}
