import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../generated/l10n.dart';
import '../../status/misskey_api.dart';
import '../../status/note_deletion_registry.dart';
import '../../status/note_posted.dart';
import '../../status/themes.dart';
import '../mk_card.dart';
import '../mk_skeleton_block.dart';
import 'note_card.dart';
import 'reply_thread_controller.dart';
import 'timeline_insert_transition.dart';

export 'reply_thread_controller.dart' show mergeReplyNotes;

class NoteChildren extends HookConsumerWidget {
  const NoteChildren({
    super.key,
    required this.noteId,
    required this.repliesCount,
    required this.onContentVisibilityChanged,
  });

  final String noteId;
  final int repliesCount;
  final ValueChanged<bool> onContentVisibilityChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apis = ref.read(misskeyApisProvider);
    final themes = ref.watch(themeColorsProvider);
    final deletedNoteIds = ref.watch(deletedNoteIdsProvider);
    final controller = useMemoized(
      () => ReplyThreadController(
        rootNoteId: noteId,
        postedNotes: notePostedStream,
        loadChildren: (parentId, limit, untilId) => apis.notes.children(
          noteId: parentId,
          limit: limit,
          untilId: untilId,
        ),
      ),
      [noteId, apis],
    );
    useListenable(controller);
    final knownReplyIds = useMemoized(() => <String>{}, [controller]);
    useEffect(() {
      scheduleMicrotask(controller.loadInitial);
      return controller.dispose;
    }, [controller]);

    final entries = controller.entriesExcluding(deletedNoteIds);
    final initialPlaceholderCount = replyPlaceholderCount(repliesCount);
    final loadedRootReplies = entries.where((entry) => entry.depth == 0).length;
    final remainingRootReplies = repliesCount - loadedRootReplies;
    final showPagination =
        controller.isInitialLoaded &&
        (controller.hasMoreRootReplies ||
            controller.isLoadingMoreRoot ||
            controller.rootPaginationError != null);
    final isInitialPending =
        !controller.isInitialLoaded && controller.initialLoadError == null;
    final hasVisibleContent = replyThreadHasVisibleContent(
      isInitialPending: isInitialPending,
      entryCount: entries.length,
      initialPlaceholderCount: initialPlaceholderCount,
      hasInitialError: controller.initialLoadError != null,
      showPagination: showPagination,
    );
    final latestContentVisibility = useRef(hasVisibleContent);
    latestContentVisibility.value = hasVisibleContent;
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          onContentVisibilityChanged(latestContentVisibility.value);
        }
      });
      return null;
    }, [hasVisibleContent]);

    if (isInitialPending && entries.isEmpty) {
      return _ReplyPlaceholderList(
        count: initialPlaceholderCount,
        color: themes.fgColor.withValues(alpha: 0.1),
        dividerColor: themes.dividerColor,
      );
    }

    if (controller.initialLoadError != null && entries.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: TextButton(
            onPressed: controller.retryInitial,
            child: Text(S.current.refresh),
          ),
        ),
      );
    }

    final newlyAppearedReplyIds = entries
        .map((entry) => entry.note.id)
        .where(knownReplyIds.add)
        .toSet();
    final entryIndexes = {
      for (var index = 0; index < entries.length; index++)
        entries[index].note.id: index,
    };
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == entries.length) {
            return _RootRepliesPagination(
              isLoading: controller.isLoadingMoreRoot,
              hasError: controller.rootPaginationError != null,
              placeholderCount: replyPlaceholderCount(
                remainingRootReplies,
                minimum: 1,
              ),
              placeholderColor: themes.fgColor.withValues(alpha: 0.1),
              dividerColor: themes.dividerColor,
              onPressed: controller.loadMoreRoot,
            );
          }
          final entry = entries[index];
          final previousEntry = index > 0 ? entries[index - 1] : null;
          return TimelineInsertTransition(
            key: ValueKey<String>(entry.note.id),
            animate: newlyAppearedReplyIds.contains(entry.note.id),
            child: _ReplyThreadRow(
              entry: entry,
              dividerColor: themes.dividerColor,
              placeholderColor: themes.fgColor.withValues(alpha: 0.1),
              connectFromPrevious:
                  previousEntry != null &&
                  entry.depth == previousEntry.depth + 1,
              connectToNext:
                  entry.hasVisibleChildren || entry.isLoadingChildren,
              showSiblingDivider: !entry.isFirstSibling,
              roundBottom:
                  index == entries.length - 1 && !controller.isLoadingMoreRoot,
              onRetryChildren: () => controller.retryChildren(entry),
            ),
          );
        },
        childCount: entries.length + (showPagination ? 1 : 0),
        findChildIndexCallback: (key) {
          return key is ValueKey<String> ? entryIndexes[key.value] : null;
        },
      ),
    );
  }
}

class _RootRepliesPagination extends StatelessWidget {
  const _RootRepliesPagination({
    required this.isLoading,
    required this.hasError,
    required this.placeholderCount,
    required this.placeholderColor,
    required this.dividerColor,
    required this.onPressed,
  });

  final bool isLoading;
  final bool hasError;
  final int placeholderCount;
  final Color placeholderColor;
  final Color dividerColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        children: [
          for (var index = 0; index < placeholderCount; index++)
            _ReplyPlaceholder(
              color: placeholderColor,
              dividerColor: dividerColor,
              showDivider: true,
              roundBottom: index == placeholderCount - 1,
            ),
        ],
      );
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: TextButton(
          onPressed: onPressed,
          child: Text(hasError ? S.current.refresh : S.current.viewMore),
        ),
      ),
    );
  }
}

class _ReplyThreadRow extends StatelessWidget {
  const _ReplyThreadRow({
    required this.entry,
    required this.dividerColor,
    required this.placeholderColor,
    required this.connectFromPrevious,
    required this.connectToNext,
    required this.showSiblingDivider,
    required this.roundBottom,
    required this.onRetryChildren,
  });

  final ReplyThreadEntry entry;
  final Color dividerColor;
  final Color placeholderColor;
  final bool connectFromPrevious;
  final bool connectToNext;
  final bool showSiblingDivider;
  final bool roundBottom;
  final VoidCallback onRetryChildren;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showSiblingDivider)
          SizedBox(
            height: 1,
            width: double.infinity,
            child: ColoredBox(color: dividerColor),
          ),
        MkCard(
          shadow: false,
          borderRadius: roundBottom && !entry.isLoadingChildren
              ? _bottomCardRadius
              : BorderRadius.zero,
          padding: EdgeInsets.fromLTRB(
            16,
            connectFromPrevious ? 0 : 10,
            16,
            connectToNext ? 0 : 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimeLineNoteCardComponent(data: entry.note, reply: connectToNext),
              if (entry.childLoadError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: TextButton(
                    onPressed: onRetryChildren,
                    child: Text(S.current.refresh),
                  ),
                ),
              if (entry.hasHiddenChildren)
                TextButton.icon(
                  onPressed: () => context.push(
                    '/notes/${entry.note.id}',
                    extra: entry.note.copyWith(),
                  ),
                  icon: const Icon(Icons.keyboard_double_arrow_right, size: 16),
                  label: Text(S.current.view),
                ),
            ],
          ),
        ),
        if (entry.isLoadingChildren)
          for (
            var index = 0;
            index < replyPlaceholderCount(entry.note.repliesCount);
            index++
          )
            _ReplyPlaceholder(
              color: placeholderColor,
              dividerColor: dividerColor,
              showDivider: index > 0,
              roundBottom:
                  roundBottom &&
                  index == replyPlaceholderCount(entry.note.repliesCount) - 1,
            ),
      ],
    );
  }
}

class _ReplyPlaceholderList extends StatelessWidget {
  const _ReplyPlaceholderList({
    required this.count,
    required this.color,
    required this.dividerColor,
  });

  final int count;
  final Color color;
  final Color dividerColor;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: count,
      itemBuilder: (context, index) => _ReplyPlaceholder(
        color: color,
        dividerColor: dividerColor,
        showDivider: index > 0,
        roundBottom: index == count - 1,
      ),
    );
  }
}

class _ReplyPlaceholder extends StatelessWidget {
  const _ReplyPlaceholder({
    required this.color,
    required this.dividerColor,
    required this.showDivider,
    required this.roundBottom,
  });

  final Color color;
  final Color dividerColor;
  final bool showDivider;
  final bool roundBottom;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Column(
        children: [
          if (showDivider)
            SizedBox(
              height: 1,
              width: double.infinity,
              child: ColoredBox(color: dividerColor),
            ),
          MkCard(
            shadow: false,
            borderRadius: roundBottom ? _bottomCardRadius : BorderRadius.zero,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MkSkeletonBlock(
                  width: 40,
                  height: 40,
                  color: color,
                  shape: BoxShape.circle,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PlaceholderBar(color: color, widthFactor: 0.4),
                      const SizedBox(height: 12),
                      _PlaceholderBar(color: color, widthFactor: 0.75),
                      const SizedBox(height: 16),
                      _PlaceholderBar(color: color, widthFactor: 0.5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _bottomCardRadius = BorderRadius.only(
  bottomLeft: Radius.circular(12),
  bottomRight: Radius.circular(12),
);

class _PlaceholderBar extends StatelessWidget {
  const _PlaceholderBar({required this.color, required this.widthFactor});

  final Color color;
  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return MkSkeletonBlock(color: color, height: 10, widthFactor: widthFactor);
  }
}

int replyPlaceholderCount(int repliesCount, {int minimum = 0}) {
  if (repliesCount <= minimum) return minimum;
  return repliesCount > 3 ? 3 : repliesCount;
}

bool replyThreadHasVisibleContent({
  required bool isInitialPending,
  required int entryCount,
  required int initialPlaceholderCount,
  required bool hasInitialError,
  required bool showPagination,
}) {
  return entryCount > 0 ||
      showPagination ||
      hasInitialError ||
      (isInitialPending && initialPlaceholderCount > 0);
}
