import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';

class MkFolder extends HookConsumerWidget {
  const MkFolder({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 使用flutter_hooks来管理状态
    var expanded = useState(false);
    var themes = ref.watch(themeColorsProvider);
    // 使用AnimatedCrossFade来实现展开和收起的动画效果
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: themes.panelColor,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                expanded.value = !expanded.value;
              },
              child: Container(
                color: themes.folderHeaderBg,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  spacing: 5,
                  children: [
                    if (icon != null)
                      Icon(
                        icon,
                        color: themes.fgColor,
                        size: 18,
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: themes.fgColor.withAlpha(190)),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      expanded.value
                          ? TablerIcons.chevron_up
                          : TablerIcons.chevron_down,
                      size: 18,
                      color: themes.fgColor,
                    ),
                  ],
                ),
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(height: 0, width: double.infinity),
              secondChild: child,
              crossFadeState: expanded.value
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 250),
              firstCurve: Curves.easeOut,
              secondCurve: Curves.easeOut,
            )
          ],
        ),
      ),
    );
  }
}
