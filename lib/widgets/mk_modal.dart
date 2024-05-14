import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../state/themes.dart';
import 'blur_widget.dart';
import 'mk_card.dart';

class MkModal extends HookConsumerWidget {
  const MkModal({
    super.key,
    required this.body,
    required this.appbar,
    required this.width,
    required this.height,
    this.padding = EdgeInsets.zero,
    this.maskClosable = true,
  });

  final Widget body;
  final Widget appbar;
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final bool maskClosable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var queryPadding = MediaQuery.of(context).padding;
    var querySize = MediaQuery.of(context).size;
    var themes = ref.watch(themeColorsProvider);

    var borderRadius = const BorderRadius.all(
      Radius.circular(12),
    );
    return GestureDetector(
      onTap: maskClosable
          ? () {
              Navigator.pop(context);
            }
          : null,
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Center(
                // duration: const Duration(milliseconds: 500),
                // top: isFullscreen ? 0 : 40,
                child: GestureDetector(
                  // 防止事件冒泡
                  onTap: () {},
                  child: Padding(
                    padding: padding,
                    child: AnimatedContainer(
                      width: querySize.width > width ? width : querySize.width,
                      height:
                          querySize.height > height ? height : querySize.height,
                      duration: const Duration(milliseconds: 500),
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 50 + queryPadding.top,
                              child: BlurWidget(
                                color: themes.windowHeaderColor,
                                child: appbar,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: themes.panelColor,
                                child: body,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
