import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/themes.dart';

class MkPrimaryButton extends HookConsumerWidget {
  const MkPrimaryButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.onLongPress,
      this.clipBehavior});

  final Widget child;
  final void Function() onPressed;
  final VoidCallback? onLongPress;
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return ElevatedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        clipBehavior: clipBehavior,
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(themes.accentColor),
            foregroundColor: WidgetStateProperty.all(themes.fgOnAccentColor),
            elevation: WidgetStateProperty.all(0)),
        child: child);
  }
}

class MkSecondaryButton extends HookConsumerWidget {
  const MkSecondaryButton(
      {super.key,
      required this.child,
      required this.onPressed,
      this.onLongPress,
      this.clipBehavior});

  final Widget child;
  final void Function() onPressed;
  final VoidCallback? onLongPress;
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return ElevatedButton(
        onPressed: onPressed,
        onLongPress: onLongPress,
        clipBehavior: clipBehavior,
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(themes.buttonBgColor),
            foregroundColor: WidgetStateProperty.all(themes.fgColor),
            elevation: WidgetStateProperty.all(0)),
        child: child);
  }
}
