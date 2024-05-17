import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';

class MkCard extends ConsumerWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool shadow;
  final BorderRadius borderRadius;

  const MkCard(
      {super.key,
      required this.child,
      this.padding,
      this.shadow = true,
      this.borderRadius = const BorderRadius.all(
        Radius.circular(12),
      )});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return ClipRRect(
      borderRadius: borderRadius,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: themes.panelColor,
          boxShadow: [
            if (shadow)
              BoxShadow(
                color: Colors.black.withAlpha(64),
                blurRadius: 20,
                offset: const Offset(0, 4),
              )
          ],
        ),
        duration: const Duration(milliseconds: 300),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16),
          child: DefaultTextStyle(
            style: DefaultTextStyle.of(context).style,
            child: child,
          ),
        ),
      ),
    );
  }
}
