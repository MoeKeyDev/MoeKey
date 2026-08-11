import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../generated/l10n.dart';
import '../../status/misskey_api.dart';
import '../../status/note_posted.dart';
import '../../status/themes.dart';
import '../loading_weight.dart';
import '../mk_card.dart';
import 'note_card.dart';
import 'reply_thread_controller.dart';

export 'reply_thread_controller.dart' show mergeReplyNotes;

class NoteChildren extends HookConsumerWidget {
  const NoteChildren({super.key, required this.noteId});

  final String noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apis = ref.read(misskeyApisProvider);
    final themes = ref.watch(themeColorsProvider);
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
    useEffect(() {
      scheduleMicrotask(controller.loadInitial);
      return controller.dispose;
    }, [controller]);

    if (controller.isInitialLoading && controller.entries.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: LoadingCircularProgress(size: 24, strokeWidth: 4),
          ),
        ),
      );
    }

    if (controller.initialLoadError != null && controller.entries.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: TextButton(
            onPressed: controller.retryInitial,
            child: Text(S.current.refresh),
          ),
        ),
      );
    }

    final entries = controller.entries;
    final showPagination =
        controller.isInitialLoaded &&
        (controller.hasMoreRootReplies ||
            controller.isLoadingMoreRoot ||
            controller.rootPaginationError != null);
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index == entries.length) {
          return _RootRepliesPagination(
            isLoading: controller.isLoadingMoreRoot,
            hasError: controller.rootPaginationError != null,
            onPressed: controller.loadMoreRoot,
          );
        }
        final entry = entries[index];
        final previousEntry = index > 0 ? entries[index - 1] : null;
        return _ReplyThreadRow(
          key: ValueKey(entry.note.id),
          entry: entry,
          dividerColor: themes.dividerColor,
          connectFromPrevious:
              previousEntry != null && entry.depth == previousEntry.depth + 1,
          connectToNext: entry.hasVisibleChildren || entry.isLoadingChildren,
          showSiblingDivider: !entry.isFirstSibling,
          onRetryChildren: () => controller.retryChildren(entry),
        );
      }, childCount: entries.length + (showPagination ? 1 : 0)),
    );
  }
}

class _RootRepliesPagination extends StatelessWidget {
  const _RootRepliesPagination({
    required this.isLoading,
    required this.hasError,
    required this.onPressed,
  });

  final bool isLoading;
  final bool hasError;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: isLoading
            ? const LoadingCircularProgress(size: 20, strokeWidth: 3)
            : TextButton(
                onPressed: onPressed,
                child: Text(hasError ? S.current.refresh : S.current.viewMore),
              ),
      ),
    );
  }
}

class _ReplyThreadRow extends StatelessWidget {
  const _ReplyThreadRow({
    super.key,
    required this.entry,
    required this.dividerColor,
    required this.connectFromPrevious,
    required this.connectToNext,
    required this.showSiblingDivider,
    required this.onRetryChildren,
  });

  final ReplyThreadEntry entry;
  final Color dividerColor;
  final bool connectFromPrevious;
  final bool connectToNext;
  final bool showSiblingDivider;
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
          borderRadius: BorderRadius.zero,
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
              if (entry.isLoadingChildren)
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 16),
                  child: LoadingCircularProgress(size: 16, strokeWidth: 3),
                ),
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
      ],
    );
  }
}
