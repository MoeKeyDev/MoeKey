import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/sliver_load_more.dart';

import 'loading_weight.dart';
import 'mk_refresh_indicator.dart';

class MkRefreshLoadListController extends ChangeNotifier {
  MkRefreshController refreshController = MkRefreshController();
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    refreshController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void refresh() {
    if (!scrollController.hasClients) return;
    if (scrollController.offset > 0) {
      scrollController.animateTo(
        0,
        duration: Duration(
          milliseconds: (scrollController.offset).toInt().clamp(100, 300),
        ),
        curve: Curves.easeInOut,
      );
    } else {
      refreshController.refresh();
    }
  }
}

class DefaultMkRefreshLoadListController<T> extends InheritedWidget {
  const DefaultMkRefreshLoadListController({
    super.key,
    required this.controller,
    required super.child,
  });

  final MkRefreshLoadListController controller;

  static MkRefreshLoadListController? of<T>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<
          DefaultMkRefreshLoadListController
        >()
        ?.controller;
  }

  @override
  bool updateShouldNotify(
    covariant DefaultMkRefreshLoadListController oldWidget,
  ) {
    return oldWidget.controller != controller;
  }
}

class MkRefreshLoadList<T> extends StatelessWidget {
  const MkRefreshLoadList({
    super.key,
    required this.onLoad,
    this.padding = EdgeInsets.zero,
    required this.onRefresh,
    required this.slivers,
    required this.hasMore,
    required this.empty,
    this.controller,
    this.initialLoading = false,
    this.initialError,
    this.onRetry,
    this.loadMoreError,
    this.onRetryLoadMore,
  });

  final Future Function() onLoad;
  final Future Function() onRefresh;
  final EdgeInsetsGeometry padding;
  final List<Widget> slivers;
  final bool? empty;
  final bool? hasMore;
  final MkRefreshLoadListController? controller;
  final bool initialLoading;
  final Object? initialError;
  final VoidCallback? onRetry;
  final Object? loadMoreError;
  final VoidCallback? onRetryLoadMore;

  @override
  Widget build(BuildContext context) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var isEmpty = !(hasMore ?? true) && (empty ?? false);
    var defaultController =
        controller ?? DefaultMkRefreshLoadListController.of(context);
    var refreshController = defaultController?.refreshController;
    var scrollController = defaultController?.scrollController;

    final isInitialError = initialError != null;
    final isInitialState = initialLoading || isInitialError;

    Widget child = CustomScrollView(
      primary: true,
      scrollCacheExtent: (Platform.isAndroid || Platform.isIOS)
          ? null
          : const ScrollCacheExtent.pixels(4000),
      slivers: [
        SliverPadding(
          padding: mediaPadding.add(padding),
          sliver: SliverMainAxisGroup(
            slivers: [
              if (isInitialState)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: initialLoading
                      ? const Center(child: LoadingCircularProgress(size: 28))
                      : MkErrorState(onRetry: onRetry),
                )
              else ...[
                ...slivers,
                if (isEmpty)
                  SliverToBoxAdapter(
                    child: _Empty(height: 300, onTap: onRefresh),
                  ),
                if (loadMoreError != null)
                  SliverToBoxAdapter(
                    child: MkErrorState(
                      compact: true,
                      onRetry: onRetryLoadMore,
                    ),
                  )
                else
                  SliverLoadMore(hasMore: hasMore, onLoad: onLoad),
              ],
            ],
          ),
        ),
      ],
    );

    if (refreshController != null) {
      child = MkRefreshIndicator(
        controller: refreshController,
        onRefresh: onRefresh,
        child: child,
      );
    }

    if (scrollController != null) {
      child = PrimaryScrollController(
        controller: scrollController,
        child: child,
      );
    }

    return child;
  }
}

class _Empty extends ConsumerWidget {
  const _Empty({required this.height, this.onTap});

  final double height;
  final Future Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // var infoUrl = ref.watch(instanceMetaProvider.select(
    //   (value) => value.value?.infoImageUrl,
    // ));
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(height: height, child: const EmptyWidget()),
    );
  }
}
