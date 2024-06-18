import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';

import '../../apis/models/note.dart';
import '../../utils/get_padding_note.dart';
import '../loading_weight.dart';
import 'note_card.dart';

class NoteListModel {
  List<NoteModel> list = [];
  bool hasMore = true;
}

class SliverPaginationNoteList extends HookConsumerWidget {
  const SliverPaginationNoteList(
      {super.key, required this.watch, required this.loadMore, this.padding});

  final AsyncValue<NoteListModel> Function(WidgetRef ref) watch;

  final Future Function(WidgetRef ref) loadMore;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var data = watch(ref);
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: padding ?? EdgeInsets.zero,
          sliver: SliverMainAxisGroup(
            slivers: [
              SliverList.separated(
                itemBuilder: (BuildContext context, int index) {
                  BorderRadius borderRadius;
                  if (index == 0) {
                    borderRadius = const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12));
                  } else {
                    borderRadius = const BorderRadius.all(Radius.zero);
                  }
                  return NoteCard(
                      key: ValueKey(data.valueOrNull!.list[index].id),
                      borderRadius: borderRadius,
                      data: data.valueOrNull!.list[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: double.infinity,
                    height: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: themes.dividerColor,
                      ),
                    ),
                  );
                },
                itemCount: (data.valueOrNull?.list.length ?? 0),
              ),
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.remainingPaintExtent > 0 &&
                      (data.valueOrNull?.hasMore ?? false)) {
                    loadMore(ref);
                  }
                  if (!(data.valueOrNull?.hasMore ?? true)) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text("暂无更多"),
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: LoadingCircularProgress(),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
