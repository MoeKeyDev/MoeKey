import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_scaffold.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test.g.dart';

@riverpod
class Test extends _$Test {
  @override
  FutureOr<String> build() async {
    return " ";
  }

  test() {}
}

class TestWidget extends HookConsumerWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var t = ref.watch(testProvider);
    return MkScaffold(
      body: FlutterLogo(),
      header: MkAppbar(
        content: Text("content"),
        trailing: Text("trailing"),
        leading: Text("leading"),
        isSmallLeadingCenter: true,
      ),
    );
  }
}
