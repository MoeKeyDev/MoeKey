import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';

import '../../status/user.dart';

class UserReactionsPage extends HookConsumerWidget {
  const UserReactionsPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dataProvider = userReactionsListProvider(userId: userId);
    var data = ref.watch(dataProvider);
    var items = data.value?.list ?? (List<NoteModel>.empty());
    return MkPaginationNoteList(
      onLoad: () => ref.read(dataProvider.notifier).load(),
      onRefresh: () => ref.refresh(dataProvider.future),
      hasMore: data.value?.hasMore ?? true,
      items: items,
      initialLoading: data.isLoading && data.value == null,
      initialError: data.hasError && data.value == null ? data.error : null,
      onRetry: () => ref.invalidate(dataProvider),
      loadMoreError: data.value?.loadMoreError,
      onRetryLoadMore: () => ref.read(dataProvider.notifier).load(),
    );
  }
}
