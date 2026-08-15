import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/mk_overflow_show.dart';

void main() {
  Widget overflowShow({required double contentHeight}) {
    return MaterialApp(
      home: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 320,
          child: MkOverflowShow(
            limit: 1000,
            height: 400,
            action: (_, _) => const Text('view more'),
            content: SizedBox(height: contentHeight),
          ),
        ),
      ),
    );
  }

  testWidgets('measures long content independently of the viewport height', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(overflowShow(contentHeight: 1200));

    expect(tester.getSize(find.byType(MkOverflowShow)).height, 400);
  });

  testWidgets('rebuilding a long item produces the same collapsed height', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(overflowShow(contentHeight: 1200));
    expect(tester.getSize(find.byType(MkOverflowShow)).height, 400);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(overflowShow(contentHeight: 1200));

    expect(tester.getSize(find.byType(MkOverflowShow)).height, 400);
  });

  testWidgets('short content keeps its natural height', (tester) async {
    await tester.pumpWidget(overflowShow(contentHeight: 300));

    expect(tester.getSize(find.byType(MkOverflowShow)).height, 300);
  });

  testWidgets('overflow items survive a keyed prepend', (tester) async {
    final key = GlobalKey<_PrependingOverflowListState>();
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: _PrependingOverflowList(key: key, controller: controller),
      ),
    );
    await tester.pump();
    controller.jumpTo(1200);
    await tester.pump();

    key.currentState!.prepend();
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}

class _PrependingOverflowList extends StatefulWidget {
  const _PrependingOverflowList({super.key, required this.controller});

  final ScrollController controller;

  @override
  State<_PrependingOverflowList> createState() =>
      _PrependingOverflowListState();
}

class _PrependingOverflowListState extends State<_PrependingOverflowList> {
  final items = ['b', 'c', 'd', 'e', 'f', 'g'];

  void prepend() => setState(() => items.insert(0, 'a'));

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.controller,
      slivers: [
        SliverList.separated(
          itemCount: items.length,
          findItemIndexCallback: (key) {
            final index = items.indexOf((key as ValueKey<String>).value);
            return index < 0 ? null : index;
          },
          itemBuilder: (context, index) {
            final id = items[index];
            return RepaintBoundary(
              key: ValueKey(id),
              child: MkOverflowShow(
                limit: 1000,
                height: 400,
                action: (_, _) => const Text('view more'),
                content: const SizedBox(height: 1200),
              ),
            );
          },
          separatorBuilder: (_, _) => const SizedBox(height: 1),
        ),
      ],
    );
  }
}
