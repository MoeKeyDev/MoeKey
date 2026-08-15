import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'a short conversation remains scrollable above the current note',
    (tester) async {
      final currentNoteSliverKey = GlobalKey();
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            height: 500,
            child: CustomScrollView(
              controller: controller,
              center: currentNoteSliverKey,
              anchor: 0.2,
              slivers: [
                const SliverPadding(
                  padding: EdgeInsets.only(top: 100),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(key: ValueKey('parent-note'), height: 80),
                  ),
                ),
                SliverPadding(
                  key: currentNoteSliverKey,
                  padding: const EdgeInsets.only(top: 8),
                  sliver: const SliverToBoxAdapter(
                    child: SizedBox(key: ValueKey('current-note'), height: 120),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final currentNote = find.byKey(const ValueKey('current-note'));
      final anchorTop = controller.position.viewportDimension * 0.2;
      final initialCurrentTop = anchorTop + 8;
      expect(controller.position.minScrollExtent, lessThan(0));
      expect(
        tester.getTopLeft(currentNote).dy,
        closeTo(initialCurrentTop, 0.01),
      );
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('parent-note'))).dy,
        closeTo(anchorTop - 80, 0.01),
      );

      final minimumOffset = controller.position.minScrollExtent;
      controller.jumpTo(controller.position.minScrollExtent);
      await tester.pump();

      expect(find.byKey(const ValueKey('parent-note')), findsOneWidget);
      expect(
        tester.getTopLeft(currentNote).dy,
        closeTo(initialCurrentTop - minimumOffset, 0.01),
      );
    },
  );

  testWidgets('prepending ancestors does not move the visible current note', (
    tester,
  ) async {
    final conversationKey = GlobalKey<_GrowingConversationState>();
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: _GrowingConversation(
          key: conversationKey,
          controller: controller,
        ),
      ),
    );
    await tester.pumpAndSettle();

    controller.jumpTo(controller.position.minScrollExtent);
    await tester.pump();
    final currentNote = find.byKey(const ValueKey('growing-current-note'));
    final currentNoteTop = tester.getTopLeft(currentNote).dy;
    final oldOffset = controller.offset;

    conversationKey.currentState!.prependAncestor();
    await tester.pump();

    expect(controller.position.minScrollExtent, lessThan(oldOffset));
    expect(controller.offset, oldOffset);
    expect(tester.getTopLeft(currentNote).dy, closeTo(currentNoteTop, 0.01));

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 100));
    await tester.pumpAndSettle();
    final offsetAfterScrollingUp = controller.offset;
    expect(offsetAfterScrollingUp, lessThan(oldOffset));

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -100));
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(offsetAfterScrollingUp));
  });

  testWidgets('the note page can elastically drag beyond a short list edge', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: CustomScrollView(
          controller: controller,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: const [SliverToBoxAdapter(child: SizedBox(height: 100))],
        ),
      ),
    );

    final gesture = await tester.startGesture(const Offset(400, 300));
    await gesture.moveBy(const Offset(0, 120));
    await tester.pump();

    expect(controller.offset, lessThan(controller.position.minScrollExtent));

    await gesture.up();
    await tester.pumpAndSettle();
    expect(
      controller.offset,
      closeTo(controller.position.minScrollExtent, 0.01),
    );
  });
}

class _GrowingConversation extends StatefulWidget {
  const _GrowingConversation({super.key, required this.controller});

  final ScrollController controller;

  @override
  State<_GrowingConversation> createState() => _GrowingConversationState();
}

class _GrowingConversationState extends State<_GrowingConversation> {
  final currentNoteSliverKey = GlobalKey();
  double ancestorHeight = 0;

  void prependAncestor() {
    setState(() => ancestorHeight += 180);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.controller,
      center: currentNoteSliverKey,
      anchor: 0.2,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 120),
          sliver: SliverToBoxAdapter(child: SizedBox(height: ancestorHeight)),
        ),
        SliverPadding(
          key: currentNoteSliverKey,
          padding: const EdgeInsets.only(top: 8),
          sliver: const SliverToBoxAdapter(
            child: SizedBox(key: ValueKey('growing-current-note'), height: 120),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}
