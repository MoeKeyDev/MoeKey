import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/login_user.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/widgets/mk_skeleton_block.dart';
import 'package:moekey/widgets/notes/note_card.dart';

class _NoLoginUser extends CurrentLoginUser {
  @override
  LoginUser? build() => null;
}

void main() {
  testWidgets('link preview keeps the same height when loading completes', (
    tester,
  ) async {
    final preview = Completer<LinkPreview?>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentLoginUserProvider.overrideWith(_NoLoginUser.new),
          getUriInfoProvider.overrideWith((ref, url) => preview.future),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 360,
                child: NoteLinkPreview(
                  link: 'https://example.com/article',
                  fontsize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final loadingHeight = tester.getSize(find.byType(NoteLinkPreview)).height;
    expect(find.byType(MkSkeletonBlock), findsWidgets);

    preview.complete(
      const LinkPreview(
        title: 'Example article',
        description: 'Preview description',
        sitename: 'example.com',
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(tester.getSize(find.byType(NoteLinkPreview)).height, loadingHeight);
    expect(find.text('Example article'), findsOneWidget);
  });
}
