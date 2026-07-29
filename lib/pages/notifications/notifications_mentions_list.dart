import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/notifications.dart';
import '../../widgets/notes/note_pagination_list.dart';

class MentionsList extends HookConsumerWidget {
  const MentionsList({
    super.key,
    this.specified = false,
    this.padding = EdgeInsets.zero,
  });

  final bool specified;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dataProvider = mentionsNotificationsProvider(specified: specified);
    var data = ref.watch(dataProvider);
    return MkPaginationNoteList(
      padding: padding,
      onLoad: () => ref.read(dataProvider.notifier).loadMore(),
      onRefresh: () => ref.refresh(dataProvider.future),
      items: data.value?.list,
      hasMore: data.value?.hasMore,
      initialLoading: data.isLoading && data.value == null,
      initialError: data.hasError && data.value == null ? data.error : null,
      onRetry: () => ref.invalidate(dataProvider),
      loadMoreError: data.value?.loadMoreError,
      onRetryLoadMore: () => ref.read(dataProvider.notifier).loadMore(),
    );
  }
}
