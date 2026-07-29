import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:twemoji_v2/twemoji_v2.dart';

import '../apis/models/emojis.dart';
import 'mk_image.dart';

class EmojiList extends HookConsumerWidget {
  const EmojiList({super.key, this.scrollController, required this.onInsert});

  final ScrollController? scrollController;
  final void Function(Map data) onInsert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(apiEmojisByCategoryProvider);
    final categories = data.value?.keys.toList(growable: false) ?? const [];
    final ScrollController scrollController1 =
        scrollController ?? useScrollController();
    final observerController = useMemoized<ListObserverController>(
      () => ListObserverController(controller: scrollController1),
    );
    final isCategoryScrollInProgress = useRef(false);
    final requestedCategoryIndex = useRef<int?>(null);
    final categoryStartIndexes = useRef<List<int>>(const []);
    final tabSyncScheduled = useRef(false);
    final visibleCategoryIndex = useRef<int?>(null);
    if (data.isLoading) {
      return const LoadingWidget();
    }
    if (categories.isEmpty) {
      return const EmptyWidget();
    }
    final tabController = useTabController(initialLength: categories.length);

    void scheduleTabSync(int categoryIndex) {
      if (isCategoryScrollInProgress.value) return;
      visibleCategoryIndex.value = categoryIndex;
      if (tabSyncScheduled.value) return;

      tabSyncScheduled.value = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        tabSyncScheduled.value = false;
        final targetCategoryIndex = visibleCategoryIndex.value;
        if (!context.mounted ||
            targetCategoryIndex == null ||
            isCategoryScrollInProgress.value ||
            tabController.indexIsChanging ||
            tabController.index == targetCategoryIndex) {
          return;
        }
        tabController.animateTo(targetCategoryIndex);
      });
    }

    Future<void> scrollToRequestedCategory() async {
      if (isCategoryScrollInProgress.value) return;
      isCategoryScrollInProgress.value = true;

      // ListObserverController performs a multi-step lookup for an item that
      // is outside the viewport. Running those lookups concurrently can leave
      // its cached RenderObject references inactive. Coalesce fast taps and
      // always navigate to the newest requested category after the current
      // lookup finishes.
      while (context.mounted && requestedCategoryIndex.value != null) {
        final categoryIndex = requestedCategoryIndex.value!;
        requestedCategoryIndex.value = null;
        await observerController.animateTo(
          index: categoryStartIndexes.value[categoryIndex],
          duration: const Duration(milliseconds: 300),
          curve: Easing.emphasizedDecelerate,
        );
      }

      isCategoryScrollInProgress.value = false;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 48,
          child: TabBar(
            tabs: [
              for (final category in categories)
                Tab(
                  // Tooltip uses an OverlayPortal. When the picker opens under
                  // a stationary pointer, Flutter can activate that portal
                  // during the bottom sheet's layout pass. Keep the category
                  // name available to assistive technologies without putting
                  // an overlay inside the scrollable TabBar.
                  child: Semantics(
                    label: category,
                    child: [
                      if (data.value![category]![0].code == false)
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: MkImage(
                            data.value![category]![0].url,
                            cacheWidth: _cacheSize(context, 30),
                            cacheHeight: _cacheSize(context, 30),
                            proxy: const MkImageProxyOptions(
                              type: MkImageProxyType.emoji,
                            ),
                          ),
                        )
                      else
                        Twemoji(
                          emoji: data.value![category]![0].url,
                          width: 30,
                          height: 30,
                        ),
                    ][0],
                  ),
                ),
            ],
            controller: tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
            onTap: (value) {
              requestedCategoryIndex.value = value;
              unawaited(scrollToRequestedCategory());
            },
          ),
        ),
        Positioned(
          top: 48,
          left: 0,
          right: 0,
          bottom: 0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final colCount = ((constraints.maxWidth - 16) / 52)
                  .truncate()
                  .clamp(1, 99);
              final listData = _EmojiListData.build(
                categories: categories,
                emojisByCategory: data.value!,
                columnCount: colCount,
              );
              categoryStartIndexes.value = listData.categoryStartIndex;
              return ListViewObserver(
                onObserve: (p0) {
                  if (p0.displayingChildIndexList.isEmpty) return;
                  final entryIndex = p0.displayingChildIndexList.first;
                  if (entryIndex >= listData.entries.length) return;

                  final categoryIndex =
                      listData.entries[entryIndex].categoryIndex;
                  // The observer fires for every visible row. Updating the tab only
                  // after a category boundary avoids starting an animation for every
                  // scroll frame.
                  scheduleTabSync(categoryIndex);
                },
                controller: observerController,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: listData.entries.length,
                  controller: scrollController1,
                  itemBuilder: (context, index) {
                    final entry = listData.entries[index];
                    if (entry.isHeader) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(categories[entry.categoryIndex]),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (
                            var emojiIndex = entry.start;
                            emojiIndex < entry.end;
                            emojiIndex++
                          )
                            RepaintBoundary(
                              child: _EmojiTile(
                                item: entry.emojis[emojiIndex],
                                onInsert: onInsert,
                              ),
                            ),
                          for (
                            var emojiIndex = entry.end;
                            emojiIndex < entry.start + colCount;
                            emojiIndex++
                          )
                            const SizedBox(width: 44, height: 44),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static void showBottomSheet(
    BuildContext context, {
    required void Function(Map data, BuildContext context) onInsert,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        return HookConsumer(
          builder: (context, ref, child) {
            var themes = ref.watch(themeColorsProvider);
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.opaque,
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                //set this as you want
                maxChildSize: 0.8,
                //set this as you want
                minChildSize: 0.4,
                //set this as you want
                expand: true,
                builder: (context, scrollController) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    decoration: BoxDecoration(
                      color: themes.panelColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    height: 1000,
                    child: GestureDetector(
                      onTap: () {},
                      child: EmojiList(
                        scrollController: scrollController,
                        onInsert: (data) {
                          onInsert(data, context);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

int _cacheSize(BuildContext context, double logicalSize) =>
    (logicalSize * MediaQuery.devicePixelRatioOf(context)).round();

class _EmojiListData {
  const _EmojiListData({
    required this.entries,
    required this.categoryStartIndex,
  });

  final List<_EmojiListEntry> entries;
  final List<int> categoryStartIndex;

  factory _EmojiListData.build({
    required List<String> categories,
    required Map<String, List<EmojiSimple>> emojisByCategory,
    required int columnCount,
  }) {
    final entries = <_EmojiListEntry>[];
    final categoryStartIndex = <int>[];

    for (
      var categoryIndex = 0;
      categoryIndex < categories.length;
      categoryIndex++
    ) {
      final emojis = emojisByCategory[categories[categoryIndex]]!;
      categoryStartIndex.add(entries.length);
      entries.add(_EmojiListEntry.header(categoryIndex));
      for (var start = 0; start < emojis.length; start += columnCount) {
        entries.add(
          _EmojiListEntry.row(
            categoryIndex: categoryIndex,
            emojis: emojis,
            start: start,
            end: (start + columnCount).clamp(0, emojis.length),
          ),
        );
      }
    }

    return _EmojiListData(
      entries: entries,
      categoryStartIndex: categoryStartIndex,
    );
  }
}

class _EmojiListEntry {
  const _EmojiListEntry.header(this.categoryIndex)
    : emojis = const [],
      start = 0,
      end = 0;

  const _EmojiListEntry.row({
    required this.categoryIndex,
    required this.emojis,
    required this.start,
    required this.end,
  });

  final int categoryIndex;
  final List<EmojiSimple> emojis;
  final int start;
  final int end;

  bool get isHeader => emojis.isEmpty;
}

class _EmojiTile extends StatelessWidget {
  const _EmojiTile({required this.item, required this.onInsert});

  final EmojiSimple item;
  final void Function(Map data) onInsert;

  @override
  Widget build(BuildContext context) {
    if (item.code == false) {
      return Semantics(
        label: item.name,
        button: true,
        child: GestureDetector(
          onTap: () {
            var item1 = Map.from(item.toJson());
            item1["name"] = ":${item1["name"]}:";
            onInsert(item1);
          },
          child: MkImage(
            item.url,
            fit: BoxFit.contain,
            width: 44,
            height: 44,
            cacheWidth: _cacheSize(context, 44),
            cacheHeight: _cacheSize(context, 44),
            proxy: const MkImageProxyOptions(type: MkImageProxyType.emoji),
          ),
        ),
      );
    } else {
      return Semantics(
        label: item.name,
        button: true,
        child: GestureDetector(
          onTap: () {
            var item1 = Map.from(item.toJson());
            item1["name"] = item1["url"];
            onInsert(item1);
          },
          child: Twemoji(width: 44, height: 44, emoji: item.url),
        ),
      );
    }
  }
}
