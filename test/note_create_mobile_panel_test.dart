import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/drive.dart';
import 'package:moekey/apis/models/emojis.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/widgets/driver/drive.dart';
import 'package:moekey/widgets/driver/driver_select_dialog/driver_select_dialog.dart';
import 'package:moekey/widgets/note_create_dialog/mobile_composer_bottom_area.dart';
import 'package:moekey/widgets/note_create_dialog/note_create_dialog.dart';

void main() {
  testWidgets('attachment panel replaces the mobile keyboard slot', (
    tester,
  ) async {
    final driveFile = DriveFileModel(
      'drive-file',
      'photo.png',
      '2026-01-01T00:00:00.000Z',
      null,
      'image/png',
      'https://example.com/photo.png',
      1024,
      false,
      null,
      null,
      null,
    );
    final longNameDriveFile = DriveFileModel(
      'long-name-drive-file',
      'Screenshot-2026-07-01-really-long-name.png',
      '2026-01-01T00:00:00.000Z',
      null,
      'image/png',
      'https://example.com/long-name-photo.png',
      1024,
      false,
      null,
      null,
      null,
    );
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          driveListProvider.overrideWithBuild(
            (ref, notifier) => [driveFile, longNameDriveFile],
          ),
          drivePathProvider.overrideWithBuild(
            (ref, notifier) => [
              {'name': 'Drive', 'id': null},
            ],
          ),
          apiEmojisByCategoryProvider.overrideWith(
            (ref) => {
              '用户': [
                EmojiSimple(
                  aliases: const [],
                  name: 'smile',
                  url: '😀',
                  code: true,
                ),
              ],
            },
          ),
        ],
        child: MaterialApp(
          locale: const Locale('zh', 'CN'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const NoteCreateDialog(),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('text')));
    tester.view.viewInsets = const FakeViewPadding(bottom: 220);
    await tester.pump();

    await tester.tap(find.byIcon(TablerIcons.photo_plus));
    await tester.pump();
    tester.view.viewInsets = FakeViewPadding.zero;
    await tester.pump();

    expect(find.byType(DriverSelectPanel), findsOneWidget);
    expect(tester.getSize(find.byType(MobileComposerBottomArea)).height, 220);
    expect(find.byType(MobileComposerDragHandle), findsOneWidget);
    await tester.drag(
      find.byType(MobileComposerDragHandle),
      const Offset(0, -220),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(
      tester.getSize(find.byType(MobileComposerBottomArea)).height,
      greaterThan(600),
    );
    final resizedPanelHeight = tester
        .getSize(find.byType(MobileComposerBottomArea))
        .height;
    await tester.tap(find.byIcon(TablerIcons.mood_happy));
    await tester.pump();
    expect(
      tester.getSize(find.byType(MobileComposerBottomArea)).height,
      resizedPanelHeight,
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('emoji-tab-divider'))).width,
      390,
    );
    final panelClip = tester.widget<ClipRect>(
      find.byKey(const ValueKey('mobile-composer-panel-clip')),
    );
    expect(panelClip.clipper!.getClip(const Size(374, 300)).width, 390);
    expect(
      tester
          .getSize(
            find.byKey(const ValueKey('mobile-composer-panel-background')),
          )
          .width,
      390,
    );
    await tester.tap(find.byIcon(TablerIcons.photo_plus));
    await tester.pump();
    expect(
      tester.getSize(find.byType(MobileComposerBottomArea)).height,
      resizedPanelHeight,
    );
    await tester.drag(
      find.byType(MobileComposerDragHandle),
      const Offset(0, 220),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(
      tester.getSize(find.byType(MobileComposerBottomArea)).height,
      closeTo(220, 0.1),
    );
    final toolbar = tester.widget<Container>(
      find.byKey(const ValueKey('mobile-composer-toolbar')),
    );
    final toolbarDecoration = toolbar.decoration as BoxDecoration;
    expect((toolbarDecoration.border! as Border).top.style, BorderStyle.solid);
    expect(toolbarDecoration.color, isNotNull);
    expect(
      tester
          .getSize(find.byKey(const ValueKey('mobile-composer-toolbar')))
          .width,
      390,
    );
    expect(find.byKey(const ValueKey('inline-drive-upload')), findsOneWidget);
    expect(find.text(S.current.fromCloud), findsNothing);
    expect(find.text('photo.png'), findsOneWidget);
    expect(
      find.text('Screenshot-2026-07-01-really-long-name.png'),
      findsOneWidget,
    );
    expect(
      tester
          .getTopLeft(find.byKey(const ValueKey('inline-drive-upload-label')))
          .dy,
      tester.getTopLeft(find.text('photo.png')).dy,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const ValueKey('inline-drive-confirm')),
          )
          .onPressed,
      isNull,
    );

    await tester.tap(find.byKey(const ValueKey('drive-file')));
    await tester.pump();
    expect(
      find.byKey(const ValueKey('inline-drive-selected-drive-file')),
      findsOneWidget,
    );
    expect(
      tester
          .widget<FilledButton>(
            find.byKey(const ValueKey('inline-drive-confirm')),
          )
          .onPressed,
      isNotNull,
    );

    await tester.tap(find.byKey(const ValueKey('inline-drive-cancel')));
    await tester.pump();
    expect(find.byType(DriverSelectPanel), findsNothing);

    await tester.tap(find.byIcon(TablerIcons.photo_plus));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(
      find.byKey(const ValueKey('inline-drive-selected-drive-file')),
      findsNothing,
    );

    await tester.tap(find.byKey(const ValueKey('drive-file')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('inline-drive-confirm')));
    await tester.pump();
    expect(find.byType(DriverSelectPanel), findsNothing);

    await tester.tap(find.byIcon(TablerIcons.photo_plus));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    expect(
      find.byKey(const ValueKey('inline-drive-selected-drive-file')),
      findsOneWidget,
    );
  });

  testWidgets('emoji panel handle expands the shared bottom slot', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          locale: const Locale('zh', 'CN'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const NoteCreateDialog(),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(TablerIcons.mood_happy));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));
    final initialHeight = tester
        .getSize(find.byType(MobileComposerBottomArea))
        .height;

    await tester.drag(
      find.byType(MobileComposerDragHandle),
      const Offset(0, -220),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));

    expect(
      tester.getSize(find.byType(MobileComposerBottomArea)).height,
      greaterThan(initialHeight),
    );
  });
}
