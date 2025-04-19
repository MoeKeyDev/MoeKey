import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/timeline.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';

class TimeLineListPage extends HookConsumerWidget {
  const TimeLineListPage({super.key, required this.api, this.controller});

  final ScrollController? controller;
  final String api;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dataProvider = timelineProvider(api: api);
    var data = ref.watch(dataProvider);
    return MkPaginationNoteList(
      onLoad: () => ref.read(dataProvider.notifier).load(),
      hasMore: data.valueOrNull?.hasMore,
      items: data.valueOrNull?.list,
      onRefresh: () async {
        await ref.read(dataProvider.notifier).cleanCache();
        return await ref.refresh(dataProvider.future);
      },
    );
  }
}
