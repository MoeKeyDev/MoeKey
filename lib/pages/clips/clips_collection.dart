import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/networks/clips/clips.dart';

import '../../networks/notifications.dart';
import '../../state/themes.dart';
import '../../widgets/loading_weight.dart';

class ClipsCollection extends HookConsumerWidget {
  const ClipsCollection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var res = ref.watch(clipsProvider);

    return RefreshIndicator.adaptive(
      // 通知刷新指示器
        onRefresh: () => ref.refresh(clipsProvider.future),
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
                child: Placeholder()
            ),
          ),
        ));
  }
}
