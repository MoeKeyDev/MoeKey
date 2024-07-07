import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';

import '../../status/user.dart';

class UserReactionsPage extends HookConsumerWidget {
  const UserReactionsPage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dataProvider = userReactionsListProvider(
      userId: userId,
    );
    var data = ref.watch(dataProvider);
    var items = data.valueOrNull?.list ?? (List<NoteModel>.empty());
    return MkPaginationNoteList(
      onLoad: () => ref.read(dataProvider.notifier).load(),
      onRefresh: () => ref.refresh(dataProvider.future),
      hasMore: data.valueOrNull?.hasMore ?? true,
      items: items,
    );
  }
}
