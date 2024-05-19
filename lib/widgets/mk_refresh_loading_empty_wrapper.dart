import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'loading_weight.dart';

class MkRefreshLoadingEmptyBuilder extends HookConsumerWidget {
  const MkRefreshLoadingEmptyBuilder({
    super.key,
    required this.onRefresh,
    required this.loading,
    required this.empty,
    required this.builder,
  });

  final Future<void> Function() onRefresh;
  final bool loading;
  final bool empty;
  final Widget Function(BuildContext context, BoxConstraints constraints)
      builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var queryPadding = MediaQuery.paddingOf(context);
    return RefreshIndicator.adaptive(
      // 通知刷新指示器
      onRefresh: onRefresh,
      edgeOffset: queryPadding.top - 8,
      child: ScrollConfiguration(
        // 设置滑动配置，允许使用触摸和鼠标进行滑动
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        }),
        child: LoadingAndEmpty(
          loading: loading,
          empty: empty,
          refresh: onRefresh,
          child: LayoutBuilder(
            builder: builder,
          ),
        ),
      ),
    );
  }
}
