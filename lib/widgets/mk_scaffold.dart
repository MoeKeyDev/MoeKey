import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/themes.dart';

class MkScaffold extends ConsumerWidget {
  const MkScaffold({super.key, this.header, required this.body});

  final PreferredSizeWidget? header;
  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // logger.d(mediaQueryData);
    var topPaddingHeight = mediaQueryData.padding.top;
    // 嵌套的 Scaffold 来保证
    Widget body = Scaffold(
      body: this.body,
    );
    var themes = ref.watch(themeColorsProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (header != null) {
          topPaddingHeight += header!.preferredSize.height;
          body = MediaQuery(
            data: mediaQueryData.copyWith(
              padding: mediaQueryData.padding.copyWith(
                top: topPaddingHeight + 8,
              ),
              size: Size(constraints.maxWidth, constraints.maxHeight),
            ),
            child: body,
          );
        }
        // 颜色与 RGBA(255,255,255,255) 叠加
        // 叠加颜色
        return Material(
          color: themes.isDark ? Colors.black : Colors.white,
          child: Material(
            color: themes.bgColor,
            child: Stack(
              children: [
                body,
                if (header != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: header!,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
