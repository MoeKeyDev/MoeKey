import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/drive.dart';
import 'package:moekey/apis/models/login_user.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/pages/image_preview/image_preview.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/server.dart';

class _NoLoginUser extends CurrentLoginUser {
  @override
  LoginUser? build() => null;
}

void main() {
  testWidgets('zoomed image pans without paging and reset restores paging', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final files = List.generate(
      2,
      (i) => DriveFileModel(
        '$i',
        'image.png',
        '2026-01-01',
        null,
        'image/png',
        'https://example.com/$i.png',
        100,
        false,
        null,
        const Properties(width: 400, height: 800),
        null,
      ),
    );
    final note = NoteModel.fromJson({
      'id': 'note',
      'createdAt': '2026-01-01T00:00:00Z',
      'files': [],
      'localOnly': false,
      'reactionEmojis': <String, dynamic>{},
      'reactions': <String, dynamic>{},
      'userId': 'user',
      'visibility': 'public',
      'user': <String, dynamic>{
        'id': 'user',
        'username': 'user',
        'avatarDecorations': [],
        'emojis': <String, dynamic>{},
        'onlineStatus': 'unknown',
      },
    });
    var page = 0;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentLoginUserProvider.overrideWith(_NoLoginUser.new),
          apiEmojisListProvider.overrideWith((ref) async => []),
          instanceMetaProvider.overrideWith((ref) async => null),
        ],
        child: MaterialApp(
          home: ImagePreviewPage(
            initialIndex: 0,
            galleryItems: files,
            heroKeys: [],
            note: note,
            onPageChanged: (value) => page = value,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    const center = Offset(200, 350);
    Future<void> doubleTap() async {
      await tester.tapAt(center);
      await tester.pump(const Duration(milliseconds: 80));
      await tester.tapAt(center);
      await tester.pumpAndSettle();
    }

    await doubleTap();
    final controller = tester
        .widget<InteractiveViewer>(find.byType(InteractiveViewer).first)
        .transformationController!;
    expect(controller.value.getMaxScaleOnAxis(), closeTo(2, 0.01));
    final before = controller.value.clone();
    await tester.dragFrom(center, const Offset(-90, 0));
    await tester.pumpAndSettle();
    expect(controller.value.storage[12], lessThan(before.storage[12] - 20));
    final beforeVertical = controller.value.storage[13];
    await tester.dragFrom(center, const Offset(0, -90));
    await tester.pumpAndSettle();
    expect(controller.value.storage[13], lessThan(beforeVertical - 20));
    expect(page, 0);
    await doubleTap();
    expect(controller.value.getMaxScaleOnAxis(), closeTo(1, 0.01));
    await tester.dragFrom(center, const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(page, 1);
    final left = await tester.startGesture(const Offset(150, 350), pointer: 1);
    final right = await tester.startGesture(const Offset(250, 350), pointer: 2);
    await tester.pump();
    await left.moveTo(const Offset(90, 350));
    await right.moveTo(const Offset(310, 350));
    await tester.pump();
    await left.up();
    await right.up();
    await tester.pumpAndSettle();
    final pinched = tester
        .widget<InteractiveViewer>(find.byType(InteractiveViewer).first)
        .transformationController!;
    expect(pinched.value.getMaxScaleOnAxis(), greaterThan(1.1));
    final x = pinched.value.storage[12];
    await tester.dragFrom(center, const Offset(-60, 0));
    await tester.pumpAndSettle();
    expect(pinched.value.storage[12], lessThan(x));
    expect(page, 1);
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
