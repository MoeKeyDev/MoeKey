import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/utils/get_padding_note.dart';

import '../../apis/models/note.dart';
import '../mk_refresh_load.dart';
import 'note_card.dart';

class MkPaginationNoteList extends HookConsumerWidget {
  const MkPaginationNoteList({
    super.key,
    required this.onLoad,
    required this.onRefresh,
    this.slivers,
    this.padding = EdgeInsets.zero,
    this.hasMore,
    this.items,
  });

  final Future Function() onLoad;
  final Future Function() onRefresh;
  final EdgeInsetsGeometry padding;
  final List<Widget>? slivers;
  final bool? hasMore;

  final List<NoteModel>? items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        var padding =
            EdgeInsets.symmetric(horizontal: getPaddingForNote(constraints))
                .add(this.padding);
        return MkRefreshLoadList<NoteModel>(
          onLoad: onLoad,
          onRefresh: onRefresh,
          padding: padding,
          slivers: [
            ...?slivers,
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
                return RepaintBoundary(
                  child: NoteCard(
                      key: ValueKey(items![index].id),
                      borderRadius: borderRadius,
                      data: items![index]),
                );
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
              itemCount: items?.length ?? 0,
            )
          ],
          hasMore: hasMore,
        );
      },
    );
  }
}
