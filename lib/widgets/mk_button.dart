import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/themes.dart';

ButtonStyle _mkButtonStyle({
  required Color backgroundColor,
  required Color foregroundColor,
}) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.all(backgroundColor),
    foregroundColor: WidgetStateProperty.all(foregroundColor),
    elevation: WidgetStateProperty.all(0),
  );
}

class MkPrimaryButton extends HookConsumerWidget {
  const MkPrimaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.onLongPress,
    this.clipBehavior,
  });

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
      style: _mkButtonStyle(
        backgroundColor: themes.accentColor,
        foregroundColor: themes.fgOnAccentColor,
      ),
      child: child,
    );
  }
}

class MkSecondaryButton extends HookConsumerWidget {
  const MkSecondaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.onLongPress,
    this.clipBehavior,
  });

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
      style: _mkButtonStyle(
        backgroundColor: themes.buttonBgColor,
        foregroundColor: themes.fgColor,
      ),
      child: child,
    );
  }
}
