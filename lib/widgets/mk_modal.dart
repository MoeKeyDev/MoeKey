import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/themes.dart';
import 'blur_widget.dart';
import 'mk_card.dart';

class MkModal extends HookConsumerWidget {
  const MkModal({
    super.key,
    required this.body,
    required this.appbar,
    this.width = 450,
    this.height = 500,
    this.padding,
    this.maskClosable = true,
  });

  final Widget body;
  final Widget appbar;
  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final bool maskClosable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    padding: padding ?? const EdgeInsets.all(12),
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
                              height: 50,
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

showModel({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) {
  var page = PageRouteBuilder(
    opaque: false,
    transitionDuration: const Duration(milliseconds: 150),
    reverseTransitionDuration: const Duration(milliseconds: 210),
    pageBuilder: (context, animation, secondaryAnimation) {
      return builder(context);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = animation.drive(Tween(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut)));
      var tween1 = animation.drive(Tween(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut)));
      var tween2 = animation.drive(Tween(begin: 0.9, end: 1.0)
          .chain(CurveTween(curve: Curves.easeInOut)));
      Widget background = Consumer(
        builder: (context, ref, child) {
          var themes = ref.watch(themeColorsProvider);
          return Container(
            color: themes.modalBgColor
                .withOpacity(themes.modalBgColor.opacity * tween1.value),
          );
        },
      );
      if (!(Platform.isAndroid || Platform.isIOS)) {
        background = BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: tween1.value * 5, sigmaY: tween1.value * 5),
          child: background,
        );
      }
      return Stack(
        children: [
          background,
          FadeTransition(
            opacity: tween,
            child: ScaleTransition(
              alignment: Alignment.center,
              scale: tween2,
              child: child,
            ),
          )
        ],
      );
    },
  );
  Navigator.of(context, rootNavigator: true).push(page);
}
