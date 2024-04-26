import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/models/clips.dart';
import 'package:moekey/networks/clips/clips.dart';
import 'package:moekey/widgets/clips/clips_folder.dart';

import '../../networks/notifications.dart';
import '../../utils/get_padding_note.dart';
import '../../widgets/loading_weight.dart';

class ClipsMy extends HookConsumerWidget {
  const ClipsMy({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var queryPadding = MediaQuery.of(context).padding;
    var res = ref.watch(clipsProvider);
    var scrollController = useScrollController();

    return RefreshIndicator.adaptive(
        // 通知刷新指示器
        onRefresh: () => ref.refresh(clipsProvider.future),
        edgeOffset: 20,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: ScrollConfiguration(
            // 设置滑动配置，允许使用触摸和鼠标进行滑动
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            }),
            child: LoadingAndEmpty(
                loading: res.isLoading,
                empty: res.valueOrNull?.isEmpty ?? true,
                refresh: () {
                  ref.invalidate(notificationsProvider);
                },
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    var padding = getPaddingForNote(constraints);
                    return ListView.builder(
                      itemCount: res.valueOrNull!.length,
                      padding: EdgeInsets.only(
                          left: padding,
                          right: padding,
                          top: queryPadding.top,
                          bottom: queryPadding.bottom),
                      controller: scrollController,
                      itemBuilder: (BuildContext context, int index) {
                        return buildClipsListItem(res, index);
                      },
                    );
                  },
                )),
          ),
        ));
  }

  Widget buildClipsListItem(AsyncValue<List<ClipsModel>> clipsList, int index) {
    return ClipsFolder(
      data: clipsList.valueOrNull![index],
    );
  }
}
