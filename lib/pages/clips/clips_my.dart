import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:moekey/pages/clips/clips.dart';
import 'package:moekey/widgets/clips/clips_folder.dart';

import '../../apis/models/clips.dart';
import '../../utils/get_padding_note.dart';
import '../../widgets/loading_weight.dart';

class ClipsMy extends HookConsumerWidget {
  const ClipsMy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var queryPadding = MediaQuery.of(context).padding;
    var res = ref.watch(clipsProvider);
    var scrollController = useScrollController();

    return LayoutBuilder(
      builder: (context, constraints) {
        var padding = getPaddingForNote(constraints);
        return RefreshIndicator.adaptive(
          // 通知刷新指示器
          onRefresh: () => ref.refresh(clipsProvider.future),
          edgeOffset: queryPadding.top - 8,
          child: ScrollConfiguration(
            // 设置滑动配置，允许使用触摸和鼠标进行滑动
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            }),
            child: LoadingAndEmpty(
              loading: res.isLoading,
              empty: res.valueOrNull?.isEmpty ?? true,
              refresh: () => ref.refresh(clipsProvider.future),
              child: ImplicitlyAnimatedList<ClipsModel>(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: scrollController,
                items: res.valueOrNull ?? [],
                padding: EdgeInsets.only(
                  left: padding,
                  right: padding,
                  top: queryPadding.top,
                  bottom: queryPadding.bottom,
                ),
                itemBuilder: (BuildContext context, Animation<double> animation,
                    item, int i) {
                  return SizeFadeTransition(
                    animation: animation,
                    child: buildClipsListItem(item),
                  );
                },
                areItemsTheSame: (oldItem, newItem) {
                  return oldItem.id == newItem.id;
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildClipsListItem(ClipsModel clips) {
    return Column(
      children: [
        ClipsFolder(
          data: clips,
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
