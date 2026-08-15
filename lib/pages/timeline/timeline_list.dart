import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/timeline.dart';
import 'package:moekey/widgets/mk_refresh_load.dart';
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
    final isVisible = active;
    final isInitialActiveSession = useRef(isVisible);
    final hasBeenActive = useRef(isVisible);
    final syncOnNextActivation = useRef(false);
    if (isVisible && !hasBeenActive.value) {
      hasBeenActive.value = true;
      isInitialActiveSession.value = true;
    } else if (!isVisible && hasBeenActive.value) {
      isInitialActiveSession.value = false;
    }
    final refreshLoadController = DefaultMkRefreshLoadListController.of(
      context,
    );

    useEffect(() {
      final notifier = ref.read(dataProvider.notifier);
      return () {
        // This effect only cleans up the lifetime of this timeline page. Tab
        // activation changes are handled separately so an old cleanup cannot
        // overwrite the newly active tab's subscription.
        scheduleMicrotask(() {
          notifier.setBeforeStreamPrepend(null);
          notifier.setStreamActive(false);
        });
      };
    }, [dataProvider]);

    useEffect(() {
      final notifier = ref.read(dataProvider.notifier);
      var cancelled = false;

      void updateStreamSubscription() {
        if (cancelled) return;
        notifier.setBeforeStreamPrepend(
          isVisible ? listKey.currentState?.preservePrependedEntries : null,
        );
        notifier.setStreamActive(isVisible);
      }

      WidgetsBinding.instance.addPostFrameCallback(
        (_) => updateStreamSubscription(),
      );
      return () => cancelled = true;
    }, [dataProvider, isVisible]);

    useEffect(() {
      if (!isVisible) {
        if (hasBeenActive.value) syncOnNextActivation.value = true;
        return null;
      }
      if (!hasBeenActive.value) {
        hasBeenActive.value = true;
        return null;
      }
      if (!syncOnNextActivation.value) return null;
      syncOnNextActivation.value = false;

      var cancelled = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (cancelled || !context.mounted) return;
        try {
          await ref
              .read(dataProvider.notifier)
              .refreshLatest(
                force: true,
                beforePrepend: listKey.currentState?.preservePrependedEntries,
              );
        } catch (_) {
          // The next activation or a manual refresh retries reconciliation.
        }
      });
      return () => cancelled = true;
    }, [dataProvider, isVisible]);

    useEffect(
      () {
        if (!isVisible || data.value?.isLatestLoaded != false) return null;
        var cancelled = false;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (cancelled || !context.mounted) return;
          if (isInitialActiveSession.value && refreshLoadController != null) {
            refreshLoadController.refreshController.refresh();
            return;
          }
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
      },
      [
        dataProvider,
        isVisible,
        data.value?.isLatestLoaded,
        refreshLoadController,
      ],
    );

    Future<void> refreshAndShowLatest() async {
      if (data.isLoading && data.value == null) {
        try {
          final initialData = await ref.read(dataProvider.future);
          if (!initialData.isLatestLoaded) {
            await ref
                .read(dataProvider.notifier)
                .refreshLatest(
                  beforePrepend: listKey.currentState?.preservePrependedEntries,
                );
          }
        } catch (_) {
          // The list switches to its initial error state after the indicator
          // closes, where the user can retry normally.
        }
        return;
      }
      if (data.value?.isLatestLoaded == false) {
        await ref
            .read(dataProvider.notifier)
            .refreshLatest(
              beforePrepend: listKey.currentState?.preservePrependedEntries,
            );
        return;
      }
      await ref.read(dataProvider.notifier).replaceWithLatest();
    }

    Future<void> loadLatestAtTop() async {
      if (!isVisible || data.value?.isLatestLoaded != false) return;
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
      loading: data.isLoading,
      initialLoading: data.isLoading && data.value == null,
      showRefreshIndicatorOnInitialLoad: isInitialActiveSession.value,
      initialError: data.hasError && data.value == null ? data.error : null,
      onRetry: () => ref.invalidate(dataProvider),
      loadMoreError: data.value?.loadMoreError,
      onRetryLoadMore: () => ref.read(dataProvider.notifier).load(),
      onReachTop: loadLatestAtTop,
      onRefresh: refreshAndShowLatest,
    );
  }
}
