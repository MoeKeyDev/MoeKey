import 'dart:async';

import 'package:flutter/material.dart';

import '../generated/l10n.dart';
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

enum _LoadMoreStatus { inactive, done, loading }

class _SliverLoadMoreState extends State<SliverLoadMore> {
  _LoadMoreStatus currentState = _LoadMoreStatus.inactive;
  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final nextScrollPosition = Scrollable.maybeOf(context)?.position;
    if (identical(_scrollPosition, nextScrollPosition)) return;

    _scrollPosition?.removeListener(_onScroll);
    _scrollPosition = nextScrollPosition;
    _scrollPosition?.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollPosition;
    if (position == null || !(widget.hasMore ?? true)) return;

    const loadThreshold = 200.0;
    if (position.extentAfter > loadThreshold) {
      if (currentState == _LoadMoreStatus.done) {
        setState(() => currentState = _LoadMoreStatus.inactive);
      }
      return;
    }

    if (currentState != _LoadMoreStatus.inactive) return;
    _startLoading();
  }

  void _startLoading() {
    if (currentState == _LoadMoreStatus.loading || !(widget.hasMore ?? true)) {
      return;
    }
    setState(() => currentState = _LoadMoreStatus.loading);
    unawaited(_loadMore());
  }

  Future<void> _loadMore() async {
    try {
      await widget.onLoad();
    } catch (_) {
      // The owning list provider is responsible for exposing its error state.
    } finally {
      if (mounted) {
        setState(() => currentState = _LoadMoreStatus.done);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!(widget.hasMore ?? true)) {
      return const SliverToBoxAdapter(child: SizedBox(height: 10));
    }

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final listDoesNotFillViewport =
            constraints.precedingScrollExtent <=
            constraints.viewportMainAxisExtent;
        final showManualLoad =
            listDoesNotFillViewport && currentState != _LoadMoreStatus.loading;

        return SliverToBoxAdapter(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 150),
            child: currentState == _LoadMoreStatus.loading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: LoadingCircularProgress()),
                  )
                : showManualLoad
                ? Center(
                    child: TextButton(
                      onPressed: _startLoading,
                      child: Text(S.current.viewMore),
                    ),
                  )
                : const SizedBox(height: 10),
          ),
        );
      },
    );
  }
}
