import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/widgets/mk_image.dart';

import 'loading_weight.dart';
import 'mk_refresh_indicator.dart';

class MkRefreshLoadList<T> extends StatelessWidget {
  const MkRefreshLoadList(
      {super.key,
      required this.onLoad,
      this.padding = EdgeInsets.zero,
      required this.onRefresh,
      required this.slivers,
      required this.hasMore,
      required this.empty});

  final Future Function() onLoad;
  final Future Function() onRefresh;
  final EdgeInsetsGeometry padding;
  final List<Widget> slivers;
  final bool? empty;
  final bool? hasMore;

  @override
  Widget build(BuildContext context) {
    var mediaPadding = MediaQuery.paddingOf(context);

    var isEmpty = !(hasMore ?? true) && (empty ?? false);
    return MkRefreshIndicator(
      onRefresh: () => onRefresh(),
      child: RepaintBoundary(
        child: CustomScrollView(
          primary: true,
          cacheExtent: (Platform.isAndroid || Platform.isIOS) ? null : 4000,
          slivers: [
            SliverPadding(
              padding: mediaPadding.add(padding),
              sliver: SliverMainAxisGroup(
                slivers: [
                  ...slivers,
                  if (isEmpty)
                    SliverToBoxAdapter(
                      child: _Empty(
                        height: 300,
                        onTap: onRefresh,
                      ),
                    ),
                  SliverLayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.remainingPaintExtent > 0 &&
                          (hasMore ?? true)) {
                        Future.delayed(
                          Duration.zero,
                          () => onLoad(),
                        );
                      }
                      if (!(hasMore ?? true)) {
                        return const SliverToBoxAdapter(
                          child: SizedBox(
                            height: 10,
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
            )
          ],
        ),
      ),
    );
  }
}

class _Empty extends ConsumerWidget {
  const _Empty({
    super.key,
    required this.height,
    this.onTap,
  });

  final double height;
  final Future Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var infoUrl = ref.watch(instanceMetaProvider.select(
      (value) => value.valueOrNull?.infoImageUrl,
    ));
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: const EmptyWidget(),
      ),
    );
  }
}
