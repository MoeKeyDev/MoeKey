import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/login_user.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/mk_skeleton_block.dart';

class _NoLoginUser extends CurrentLoginUser {
  @override
  LoginUser? build() => null;
}

void main() {
  testWidgets('MFM custom emoji uses a square skeleton while loading', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentLoginUserProvider.overrideWith(_NoLoginUser.new),
          instanceMetaProvider.overrideWith((ref) async => null),
          apiEmojisProvider.overrideWith((ref) async => {}),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: MFMText(
              text: ':test:',
              emojis: {'test': 'https://example.invalid/test.png'},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final image = tester.widget<MkImage>(find.byType(MkImage));
    final placeholder = image.placeholder! as MkSkeletonBlock;
    expect(placeholder.borderRadius, BorderRadius.zero);
    expect(placeholder.width, placeholder.height);
    expect(find.byType(MkSkeletonBlock), findsOneWidget);
  });
}
