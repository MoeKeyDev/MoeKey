import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:misskey/state/themes.dart';

class BlurWidget extends ConsumerWidget {
  final Widget? child;
  final Color? color;
  const BlurWidget({
    super.key,
    this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: DecoratedBox(
          decoration: BoxDecoration(color: color ?? themes.headerColor),
          child: child,
        ),
      ),
    );
  }
}
