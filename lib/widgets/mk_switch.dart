import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/themes.dart';

class MkSwitch extends ConsumerWidget {
  const MkSwitch({
    super.key,
    required this.value,
    this.onChanged,
  });

  final bool value;
  final void Function(bool value)? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return Switch(
      value: value,
      activeColor: themes.switchOnFgColor,
      inactiveThumbColor: themes.switchOffFgColor,
      activeTrackColor: themes.switchOnBgColor,
      inactiveTrackColor: themes.switchOffBgColor,
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      onChanged: onChanged,
    );
  }
}
