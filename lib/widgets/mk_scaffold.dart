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
    var themes = ref.watch(themeColorsProvider);
    var topPaddingHeight = mediaQueryData.padding.top;
    var body = this.body;

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
        return Material(
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
        );
      },
    );
  }
}
