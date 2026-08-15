import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../../apis/models/note.dart';
import '../../status/note_deletion_registry.dart';
import '../mk_refresh_load.dart';
import 'note_card.dart';
import 'timeline_insert_transition.dart';
import 'timeline_note_size_observer.dart';

class MkPaginationNoteList extends ConsumerStatefulWidget {
  const MkPaginationNoteList({
    super.key,
    required this.onLoad,
    required this.onRefresh,
    this.slivers,
    this.padding = EdgeInsets.zero,
    required this.hasMore,
    this.items,
    this.controller,
    this.loading = false,
    this.initialLoading = false,
    this.initialError,
    this.onRetry,
    this.loadMoreError,
    this.onRetryLoadMore,
    this.onReachTop,
    this.showRefreshIndicatorOnInitialLoad = false,
  });

  final Future Function() onLoad;
  final Future Function() onRefresh;
  final EdgeInsetsGeometry padding;
  final List<Widget>? slivers;
  final bool? hasMore;

  final List<NoteModel>? items;
  final MkRefreshLoadListController? controller;
  final bool loading;
  final bool initialLoading;
  final Object? initialError;
  final VoidCallback? onRetry;
  final Object? loadMoreError;
  final VoidCallback? onRetryLoadMore;
  final Future<void> Function()? onReachTop;
  final bool showRefreshIndicatorOnInitialLoad;

  @override
  ConsumerState<MkPaginationNoteList> createState() =>
      MkPaginationNoteListState();
}

class MkPaginationNoteListState extends ConsumerState<MkPaginationNoteList> {
  late final ListObserverController observerController;
  late final ChatScrollObserver chatObserver;
  BuildContext? noteSliverContext;
  bool wasAtTop = false;
  Set<String> animatedInsertNoteIds = const {};
  String? firstVisibleNoteId;
  final layoutCorrection = TimelineLayoutCorrection();

  @override
  void initState() {
    super.initState();
    observerController = ListObserverController();
    chatObserver = ChatScrollObserver(observerController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final inheritedController = DefaultMkRefreshLoadListController.of(
      context,
    )?.scrollController;
    final scrollController =
        widget.controller?.scrollController ?? inheritedController;
    if (observerController.controller != scrollController) {
      observerController.controller = scrollController;
      observerController.reattach();
    }
  }

  @override
  void didUpdateWidget(MkPaginationNoteList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final previous = oldWidget.items;
    final current = widget.items;
    final prependedIds = isAtTop
        ? _prependedIds(previous, current)
        : const <String>{};
    if (prependedIds.isNotEmpty) {
      animatedInsertNoteIds = prependedIds;
      final capturedIds = animatedInsertNoteIds;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (identical(animatedInsertNoteIds, capturedIds)) {
          animatedInsertNoteIds = const {};
        }
      });
    } else {
      animatedInsertNoteIds = const {};
    }
  }

  Set<String> _prependedIds(
    List<NoteModel>? previous,
    List<NoteModel>? current,
  ) {
    if (previous == null ||
        current == null ||
        current.length <= previous.length) {
      return const {};
    }
    final prependCount = current.length - previous.length;
    for (var index = 0; index < previous.length; index++) {
      if (previous[index].id != current[index + prependCount].id) {
        return const {};
      }
    }
    return {
      for (var index = 0; index < prependCount; index++) current[index].id,
    };
  }

  Future<void> preservePrependedEntries(int changeCount) async {
    final sliverContext = noteSliverContext;
    if (!mounted || sliverContext == null || changeCount <= 0 || isAtTop) {
      return;
    }
    await chatObserver.standby(
      sliverContext: sliverContext,
      changeCount: changeCount,
    );
    observerController.clearScrollIndexCache();
  }

  bool get isAtTop {
    final controller = observerController.controller;
    if (controller == null || !controller.hasClients) return false;
    final position = controller.position;
    return position.pixels <= position.minScrollExtent + 0.5;
  }

  void _handleNoteSizeChanged(String noteId, Size oldSize, Size newSize) {
    final controller = observerController.controller;
    final items = widget.items;
    final anchorId = firstVisibleNoteId;
    if (controller == null ||
        !controller.hasClients ||
        controller.position.isScrollingNotifier.value ||
        items == null ||
        anchorId == null ||
        isAtTop) {
      return;
    }

    final changedIndex = items.indexWhere((note) => note.id == noteId);
    final anchorIndex = items.indexWhere((note) => note.id == anchorId);
    if (changedIndex < 0 || anchorIndex < 0 || changedIndex >= anchorIndex) {
      return;
    }

    final delta = newSize.height - oldSize.height;
    if (delta.abs() < precisionErrorTolerance) return;

    layoutCorrection.add(delta);
    observerController.clearScrollIndexCache();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    final metrics = notification.metrics;
    final isAtTop = metrics.pixels <= metrics.minScrollExtent + 0.5;
    if (isAtTop && !wasAtTop) {
      wasAtTop = true;
      scheduleMicrotask(() => widget.onReachTop?.call());
    } else if (!isAtTop) {
      wasAtTop = false;
    }
    return false;
  }

  ScrollPhysics get scrollPhysics {
    const alwaysScrollable = AlwaysScrollableScrollPhysics();
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return TimelineSizeMaintainingScrollPhysics(
          correction: layoutCorrection,
          parent: ChatObserverBouncingScrollPhysics(
            observer: chatObserver,
            parent: alwaysScrollable,
          ),
        );
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return TimelineSizeMaintainingScrollPhysics(
          correction: layoutCorrection,
          parent: ChatObserverClampingScrollPhysics(
            observer: chatObserver,
            parent: alwaysScrollable,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    var themes = ref.watch(themeColorsProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        var padding = EdgeInsets.symmetric(
          horizontal: getPaddingForNote(constraints),
        ).add(widget.padding);
        final deletedNoteIds = ref.watch(deletedNoteIdsProvider);
        final items = excludeDeletedNotes(
          widget.items ?? const <NoteModel>[],
          deletedNoteIds,
        );

        return NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: MkRefreshLoadList<NoteModel>(
            onLoad: widget.onLoad,
            onRefresh: widget.onRefresh,
            padding: padding,
            controller: widget.controller,
            loading: widget.loading,
            initialLoading: widget.initialLoading,
            showRefreshIndicatorOnInitialLoad:
                widget.showRefreshIndicatorOnInitialLoad,
            initialError: widget.initialError,
            onRetry: widget.onRetry,
            loadMoreError: widget.loadMoreError,
            onRetryLoadMore: widget.onRetryLoadMore,
            scrollPhysics: scrollPhysics,
            scrollViewWrapper: (scrollView) => ListViewObserver(
              controller: observerController,
              sliverListContexts: () => [?noteSliverContext],
              triggerOnObserveType: ObserverTriggerOnObserveType.directly,
              onObserve: (result) {
                final index = result.firstChild?.index;
                if (index != null && index >= 0 && index < items.length) {
                  firstVisibleNoteId = items[index].id;
                }
              },
              child: scrollView,
            ),
            slivers: [
              ...?widget.slivers,
              SliverList.separated(
                findItemIndexCallback: (key) {
                  if (key case _TimelineNoteKey(:final noteId)) {
                    final noteIndex = items.indexWhere(
                      (note) => note.id == noteId,
                    );
                    return noteIndex < 0 ? null : noteIndex;
                  }
                  return null;
                },
                itemBuilder: (BuildContext context, int index) {
                  noteSliverContext = context;
                  final noteIndex = index;
                  BorderRadius borderRadius = const BorderRadius.all(
                    Radius.zero,
                  );
                  if (noteIndex == 0) {
                    borderRadius = borderRadius.copyWith(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    );
                  }
                  if (noteIndex + 1 == items.length) {
                    borderRadius = borderRadius.copyWith(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    );
                  }
                  return RepaintBoundary(
                    key: _TimelineNoteKey(items[noteIndex].id),
                    child: TimelineNoteSizeObserver(
                      noteId: items[noteIndex].id,
                      onSizeChanged: _handleNoteSizeChanged,
                      child: TimelineInsertTransition(
                        animate: animatedInsertNoteIds.contains(
                          items[noteIndex].id,
                        ),
                        child: NoteCard(
                          borderRadius: borderRadius,
                          data: items[noteIndex],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: double.infinity,
                    height: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: themes.dividerColor),
                    ),
                  );
                },
                itemCount: items.length,
              ),
            ],
            hasMore: widget.hasMore,
            empty: items.isEmpty,
          ),
        );
      },
    );
  }
}

class _TimelineNoteKey extends ValueKey<String> {
  const _TimelineNoteKey(this.noteId) : super(noteId);

  final String noteId;
}
