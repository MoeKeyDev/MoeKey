import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

void main() {
  runApp(const MaterialApp(home: ScrollviewObserverTimelinePocPage()));
}

/// An isolated, single-list proof of concept for preserving the visible note
/// while items are prepended or an item above the viewport changes height.
///
/// This page is intentionally not registered in the application router. It is
/// kept separate from the production timeline so the scrolling behavior can be
/// evaluated before any timeline state is changed.
class ScrollviewObserverTimelinePocPage extends StatefulWidget {
  const ScrollviewObserverTimelinePocPage({super.key});

  @override
  State<ScrollviewObserverTimelinePocPage> createState() =>
      _ScrollviewObserverTimelinePocPageState();
}

class _ScrollviewObserverTimelinePocPageState
    extends State<ScrollviewObserverTimelinePocPage> {
  final timelineKey = GlobalKey<ScrollviewObserverTimelinePocState>();
  var nextNewerId = -1;

  List<ScrollObserverPocItem> get initialItems => List.generate(
    40,
    (index) => ScrollObserverPocItem(
      id: 'note-$index',
      height: 72.0 + (index % 4) * 28.0,
    ),
  );

  Future<void> prependItems() async {
    final items = List.generate(3, (index) {
      final id = nextNewerId--;
      return ScrollObserverPocItem(id: 'note-$id', height: 88.0 + index * 44.0);
    });
    await timelineKey.currentState?.prepend(items);
  }

  Future<void> resizeFirstItem(double delta) async {
    await timelineKey.currentState?.resizeFirstItem(delta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('scrollview_observer timeline PoC')),
      body: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              FilledButton(
                onPressed: prependItems,
                child: const Text('顶部插入 3 条'),
              ),
              OutlinedButton(
                onPressed: () => resizeFirstItem(120),
                child: const Text('首条高度 +120'),
              ),
              OutlinedButton(
                onPressed: () => resizeFirstItem(-120),
                child: const Text('首条高度 -120'),
              ),
            ],
          ),
          Expanded(
            child: ScrollviewObserverTimelinePoc(
              key: timelineKey,
              initialItems: initialItems,
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class ScrollObserverPocItem {
  const ScrollObserverPocItem({required this.id, required this.height});

  final String id;
  final double height;

  ScrollObserverPocItem copyWith({double? height}) {
    return ScrollObserverPocItem(id: id, height: height ?? this.height);
  }
}

class ScrollviewObserverTimelinePoc extends StatefulWidget {
  const ScrollviewObserverTimelinePoc({
    super.key,
    required this.initialItems,
    this.controller,
  });

  final List<ScrollObserverPocItem> initialItems;
  final ScrollController? controller;

  @override
  State<ScrollviewObserverTimelinePoc> createState() =>
      ScrollviewObserverTimelinePocState();
}

class ScrollviewObserverTimelinePocState
    extends State<ScrollviewObserverTimelinePoc> {
  late final ScrollController scrollController;
  late final ListObserverController observerController;
  late final ChatScrollObserver chatObserver;
  late final List<ScrollObserverPocItem> items;
  late final bool ownsScrollController;

  String? firstVisibleItemId;

  @override
  void initState() {
    super.initState();
    ownsScrollController = widget.controller == null;
    scrollController = widget.controller ?? ScrollController();
    observerController = ListObserverController(controller: scrollController);
    chatObserver = ChatScrollObserver(observerController)
      // The PoC should preserve position at every non-zero offset.
      ..fixedPositionOffset = -double.maxFinite
      ..toRebuildScrollViewCallback = () {
        if (mounted) setState(() {});
      };
    items = [...widget.initialItems];
  }

  Future<void> prepend(List<ScrollObserverPocItem> newItems) async {
    if (newItems.isEmpty) return;

    // Record a laid-out reference item before changing the child indices.
    await chatObserver.standby(changeCount: newItems.length);
    observerController.clearScrollIndexCache();
    if (!mounted) return;
    setState(() => items.insertAll(0, newItems));
  }

  Future<void> resizeItem(String id, double newHeight) async {
    final index = items.indexWhere((item) => item.id == id);
    if (index < 0) return;

    // Generative mode keeps the same reference index before and after layout.
    // This covers media/preview content above the viewport changing height.
    await chatObserver.standby(mode: ChatScrollObserverHandleMode.generative);
    if (!mounted) return;
    setState(() {
      items[index] = items[index].copyWith(height: newHeight.clamp(48, 360));
    });
  }

  Future<void> resizeFirstItem(double delta) async {
    if (items.isEmpty) return;
    await resizeItem(items.first.id, items.first.height + delta);
  }

  @override
  void dispose() {
    if (ownsScrollController) scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListViewObserver(
      controller: observerController,
      triggerOnObserveType: ObserverTriggerOnObserveType.directly,
      onObserve: (result) {
        final index = result.firstChild?.index;
        if (index != null && index >= 0 && index < items.length) {
          firstVisibleItemId = items[index].id;
        }
      },
      child: ListView.builder(
        controller: scrollController,
        physics: ChatObserverClampingScrollPhysics(observer: chatObserver),
        itemCount: items.length,
        findChildIndexCallback: (key) {
          if (key case ValueKey<String>(value: final value)) {
            final id = value.replaceFirst('poc-note-', '');
            final index = items.indexWhere((item) => item.id == id);
            return index < 0 ? null : index;
          }
          return null;
        },
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            key: ValueKey('poc-note-${item.id}'),
            height: item.height,
            child: Card(
              margin: const EdgeInsets.fromLTRB(12, 4, 12, 4),
              child: Center(
                child: Text('${item.id} · ${item.height.toInt()} px'),
              ),
            ),
          );
        },
      ),
    );
  }
}
