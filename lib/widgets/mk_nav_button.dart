import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/themes.dart';

class MkNavButton extends HookConsumerWidget {
  const MkNavButton({
    super.key,
    required this.active,
    required this.text,
    required this.onTap,
  });

  final bool active;
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
            color: active ? themes.accentedBgColor : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(100))),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
              color: active ? themes.accentColor : themes.fgColor,
              fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class MkNavButtonBar extends StatelessWidget {
  const MkNavButtonBar({
    super.key,
    required this.onSelect,
    required this.index,
    required this.navs,
  });

  final void Function(int index) onSelect;
  final int index;
  final List<String> navs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var (i, nav) in navs.indexed)
          Expanded(
            child: MkNavButton(
              active: index == i,
              text: nav,
              onTap: () {
                onSelect(i);
              },
            ),
          ),
      ],
    );
  }
}
