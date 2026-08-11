import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/notes/timeline_note_size_observer.dart';

void main() {
  testWidgets('reports outer size changes after the initial layout', (
    tester,
  ) async {
    final height = ValueNotifier<double>(80);
    addTearDown(height.dispose);
    final changes = <(Size, Size)>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topCenter,
            child: ValueListenableBuilder<double>(
              valueListenable: height,
              builder: (context, value, child) => TimelineNoteSizeObserver(
                noteId: 'note-0',
                onSizeChanged: (noteId, oldSize, newSize) {
                  changes.add((oldSize, newSize));
                },
                child: SizedBox(height: value),
              ),
            ),
          ),
        ),
      ),
    );
    expect(changes, isEmpty);

    height.value = 140;
    await tester.pump();

    expect(changes, hasLength(1));
    expect(changes.single.$1.height, 80);
    expect(changes.single.$2.height, 140);
  });

  testWidgets('layout-time correction keeps a visible anchor stationary', (
    tester,
  ) async {
    final key = GlobalKey<_CorrectingListState>();
    final scrollController = ScrollController();
    addTearDown(scrollController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 500,
          child: _CorrectingList(key: key, controller: scrollController),
        ),
      ),
    );
    await tester.pumpAndSettle();

    scrollController.jumpTo(1000);
    await tester.pump();
    key.currentState!.anchorIndex = 10;
    final anchor = find.byKey(const ValueKey('size-note-10'));
    final initialY = tester.getTopLeft(anchor).dy;

    // Use a cached child immediately above the viewport. Children farther
    // away are not laid out and therefore cannot change size yet.
    key.currentState!.resize(8, 180);
    await tester.pump();

    expect(scrollController.offset, 1080);
    expect(tester.getTopLeft(anchor).dy, closeTo(initialY, 0.01));
  });
}

class _CorrectingList extends StatefulWidget {
  const _CorrectingList({super.key, required this.controller});

  final ScrollController controller;

  @override
  State<_CorrectingList> createState() => _CorrectingListState();
}

class _CorrectingListState extends State<_CorrectingList> {
  final heights = List<double>.filled(30, 100);
  final correction = TimelineLayoutCorrection();
  int anchorIndex = 0;

  void resize(int index, double height) {
    setState(() => heights[index] = height);
  }

  void handleSizeChanged(String noteId, Size oldSize, Size newSize) {
    final index = int.parse(noteId.substring('note-'.length));
    if (index >= anchorIndex || widget.controller.offset <= 0) return;
    correction.add(newSize.height - oldSize.height);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.controller,
      physics: TimelineSizeMaintainingScrollPhysics(
        correction: correction,
        parent: const ClampingScrollPhysics(),
      ),
      itemCount: heights.length,
      itemBuilder: (context, index) => TimelineNoteSizeObserver(
        key: ValueKey('size-note-$index'),
        noteId: 'note-$index',
        onSizeChanged: handleSizeChanged,
        child: SizedBox(height: heights[index]),
      ),
    );
  }
}
