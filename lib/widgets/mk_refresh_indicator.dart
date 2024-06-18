import 'dart:ui';

import 'package:flutter/material.dart';

class MkRefreshIndicator extends StatelessWidget {
  const MkRefreshIndicator(
      {super.key,
      required this.child,
      required this.onRefresh,
      this.edgeOffset});

  final Widget child;
  final Future<void> Function() onRefresh;
  final int? edgeOffset;

  @override
  Widget build(BuildContext context) {
    var mediaPadding = MediaQuery.of(context).padding;
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      edgeOffset: mediaPadding.top + (edgeOffset ?? 0),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: child,
      ),
    );
  }
}
