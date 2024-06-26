import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/timeline.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:moekey/widgets/mk_refresh_indicator.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';

import '../../widgets/loading_weight.dart';

class TimeLineListPage extends HookConsumerWidget {
  const TimeLineListPage(
      {super.key, required this.api, this.controller, this.refreshKey});

  final ScrollController? controller;
  final GlobalKey<RefreshIndicatorState>? refreshKey;
  final String api;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dataProvider = timelineProvider(api: api);
    var data = ref.watch(dataProvider);
    var mediaPadding = MediaQuery.paddingOf(context);
    return LayoutBuilder(builder: (context, constraints) {
      var padding = getPaddingForNote(constraints);
      return MkRefreshIndicator(
        refreshKey: refreshKey,
        child: LoadingAndEmpty(
          loading: data.isLoading,
          empty: data.valueOrNull?.list.isEmpty ?? true,
          refresh: () async {
            await ref.read(dataProvider.notifier).cleanCache();
            return await ref.refresh(dataProvider.future);
          },
          child: HookConsumer(
            builder: (context, ref, child) {
              return CustomScrollView(
                controller: controller,
                cacheExtent:
                    (Platform.isAndroid || Platform.isIOS) ? 1000 : 4000,
                // controller: scrollController,
                slivers: [
                  SliverPaginationNoteList(
                    padding: mediaPadding
                        .add(EdgeInsets.symmetric(horizontal: padding)),
                    watch: (ref) => ref.watch(dataProvider),
                    loadMore: (ref) => ref.read(dataProvider.notifier).load(),
                  )
                ],
              );
            },
          ),
        ),
        onRefresh: () async {
          await ref.read(dataProvider.notifier).cleanCache();
          return await ref.refresh(dataProvider.future);
        },
      );
    });
  }
}
