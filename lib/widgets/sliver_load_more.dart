import 'package:flutter/widgets.dart';

import 'loading_weight.dart';

/// Sliver 滑动加载更多
class SliverLoadMore extends StatefulWidget {
  const SliverLoadMore({
    super.key,
    required this.hasMore,
    required this.onLoad,
  });

  /// 是否还存在更多内容
  /// 当此项为false时，会停止调用onload方法
  final bool? hasMore;

  /// 加载更多的回调函数
  final Future Function() onLoad;

  @override
  State<SliverLoadMore> createState() => _SliverLoadMoreState();
}

enum _LoadMoreStatus {
  inactive,
  done,
  loading,
}

class _SliverLoadMoreState extends State<SliverLoadMore> {
  _LoadMoreStatus currentState = _LoadMoreStatus.inactive;

  void handleNextState(double offset) {
    switch (currentState) {
      case _LoadMoreStatus.inactive:
        // 当滑动不超过阈值
        if (offset < 10) break;
        // 超过就触发回调并且更新状态
        currentState = _LoadMoreStatus.loading;
        // isTriggered = true;
        widget.onLoad().whenComplete(() {
          // 当加载完成之后回退状态
          currentState = _LoadMoreStatus.done;
          // isTriggered = false;
        });
        break;
      case _LoadMoreStatus.loading:
        break;
      case _LoadMoreStatus.done:
        // 执行完毕之后，检查offset是是否为1
        // 这里判断为1是因为在滑动的时候，会有一点点的误差，导致offset某些情况不会为0，而是比0大一点点
        if (offset <= 1) {
          currentState = _LoadMoreStatus.inactive;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        // 没有更多了

        if (!(widget.hasMore ?? true)) {
          return const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          );
        }
        // 更新状态
        Future(() {
          handleNextState(constraints.remainingPaintExtent);
        });

        // 显示当前状态
        return const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: LoadingCircularProgress(),
            ),
          ),
        );
      },
    );
  }
}
