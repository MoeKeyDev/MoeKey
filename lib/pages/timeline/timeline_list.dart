import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/timeline.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';

class TimeLineListPage extends HookConsumerWidget {
  const TimeLineListPage({
    super.key,
    required this.api,
    required this.active,
    this.controller,
  });

  final ScrollController? controller;
  final String api;
  final bool active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataProvider = timelineProvider(api: api);
    final listKey = useMemoized(() => GlobalKey<MkPaginationNoteListState>(), [
      api,
    ]);
    final data = ref.watch(dataProvider);

    useEffect(() {
      final notifier = ref.read(dataProvider.notifier);
      var disposed = false;

      void attachStream() {
        if (disposed) return;
        notifier.setBeforeStreamPrepend(
          active ? listKey.currentState?.preservePrependedEntries : null,
        );
        notifier.setStreamActive(active);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) => attachStream());
      return () {
        disposed = true;
        notifier.setBeforeStreamPrepend(null);
        if (active) notifier.setStreamActive(false);
      };
    }, [dataProvider, active]);

    useEffect(() {
      if (!active || data.value?.isLatestLoaded != false) return null;
      var cancelled = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (cancelled || !context.mounted) return;
        if (listKey.currentState?.isAtTop != true) return;
        try {
          await ref
              .read(dataProvider.notifier)
              .refreshLatest(
                beforePrepend: listKey.currentState?.preservePrependedEntries,
              );
        } catch (_) {
          // Reaching the top again or pulling to refresh retries the request.
        }
      });
      return () => cancelled = true;
    }, [dataProvider, active, data.value?.isLatestLoaded]);

    Future<void> refreshAndShowLatest() async {
      await ref.read(dataProvider.notifier).replaceWithLatest();
    }

    Future<void> loadLatestAtTop() async {
      if (!active || data.value?.isLatestLoaded != false) return;
      try {
        await ref
            .read(dataProvider.notifier)
            .refreshLatest(
              beforePrepend: listKey.currentState?.preservePrependedEntries,
            );
      } catch (_) {
        // Keep the cache visible. Leaving and reaching the top again retries.
      }
    }

    return MkPaginationNoteList(
      key: listKey,
      onLoad: () => ref.read(dataProvider.notifier).load(),
      hasMore: data.value?.hasMore,
      items: data.value?.list,
      initialLoading: data.isLoading && data.value == null,
      initialError: data.hasError && data.value == null ? data.error : null,
      onRetry: () => ref.invalidate(dataProvider),
      loadMoreError: data.value?.loadMoreError,
      onRetryLoadMore: () => ref.read(dataProvider.notifier).load(),
      onReachTop: loadLatestAtTop,
      onRefresh: refreshAndShowLatest,
    );
  }
}
