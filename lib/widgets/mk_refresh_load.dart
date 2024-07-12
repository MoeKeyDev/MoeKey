import 'dart:io';

import 'package:flutter/material.dart';

import 'loading_weight.dart';
import 'mk_refresh_indicator.dart';

class MkRefreshLoadList<T> extends StatelessWidget {
  const MkRefreshLoadList({
    super.key,
    required this.onLoad,
    this.padding = EdgeInsets.zero,
    required this.onRefresh,
    required this.slivers,
    this.hasMore = true,
  });

  final Future Function() onLoad;
  final Future Function() onRefresh;
  final EdgeInsetsGeometry padding;
  final List<Widget> slivers;
  final bool? hasMore;

  @override
  Widget build(BuildContext context) {
    var mediaPadding = MediaQuery.paddingOf(context);
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
