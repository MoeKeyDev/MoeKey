import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/hook/useExtendedPageController.dart';
import 'package:moekey/main.dart';
import 'package:moekey/networks/apis.dart';
import 'package:moekey/networks/dio.dart';
import 'package:moekey/utils/save_image.dart';

import '../../models/drive.dart';
import '../../widgets/mk_image.dart';

List<double> _doubleTapScales = <double>[1.0, 2.0];

class ImagePreviewPage extends HookConsumerWidget {
  final List<DriveFileModel> galleryItems;

  final void Function(int)? onPageChanged;

  final BoxDecoration? backgroundDecoration;

  final int initialIndex;

  const ImagePreviewPage({
    super.key,
    required this.initialIndex,
    required this.galleryItems,
    this.onPageChanged,
    required this.backgroundDecoration,
  });

  void setBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.black.withOpacity(0.9),
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light),
    );
  }

  void removeBar() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark),
    );
  }

  // final List<int> _cachedIndexes = <int>[];
  void _preloadImage(int index, BuildContext context) {
    // if (_cachedIndexes.contains(index)) {
    //   return;
    // }
    if (0 <= index && index < galleryItems.length) {
      final String url = galleryItems[index].url;

      precacheImage(
        ExtendedNetworkImageProvider(
          url,
          cache: true,
          imageCacheName: 'CropImage',
        ),
        context,
      );

      // _cachedIndexes.add(index);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pageController = useExtendedPageController(initialPage: initialIndex);
    var currentIndex = useState(initialIndex);
    var http = ref.watch(httpProvider);
    var meta = ref.watch(apiMetaProvider);
    var doubleClickAnimationController =
        useAnimationController(duration: const Duration(milliseconds: 150));
    void Function() doubleClickAnimationListener = useMemoized(() => () {});
    Animation<double>? doubleClickAnimation = useMemoized(() => null);
    useEffect(() {
      setBar();
      Future.microtask(() {
        _preloadImage(initialIndex - 1, context);
        _preloadImage(initialIndex + 1, context);
      });

      return removeBar;
    }, const []);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              ExtendedImageSlidePage(
                slideAxis: SlideAxis.vertical,
                // slideType: SlideType.wholePage,
                slidePageBackgroundHandler: (offset, pageSize) {
                  var tmp = (pageSize.height / 2 - offset.dy.abs()) /
                      (pageSize.height / 2);
                  return Colors.black.withOpacity((tmp - 0.1).clamp(0, 0.9));
                },
                child: ExtendedImageGesturePageView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    var item = galleryItems[index].url;
                    Widget image = ExtendedImage.network(
                      item,
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                      enableSlideOutPage: true,
                      loadStateChanged: (state) {
                        Widget? child;
                        switch (state.extendedImageLoadState) {
                          case LoadState.completed:
                            child = ExtendedRawImage(
                              fit: BoxFit.contain,
                              image: state.extendedImageInfo?.image,
                              filterQuality: FilterQuality.medium,
                            );
                          case LoadState.loading:
                          case LoadState.failed:
                        }

                        if (child == null) {
                          if (galleryItems[index].thumbnailUrl != null) {
                            child = Center(
                              child: AspectRatio(
                                aspectRatio:
                                    (galleryItems[index].properties?["width"] ??
                                            16) /
                                        (galleryItems[index]
                                                .properties?["height"] ??
                                            9),
                                child: MkImage(
                                  galleryItems[index].thumbnailUrl!,
                                  fit: BoxFit.contain,
                                  blurHash: galleryItems[index].blurhash,
                                ),
                              ),
                            );
                          } else {
                            child = const SizedBox(width: 0, height: 0);
                          }
                        }
                        // print(state.widget!);
                        child = ExtendedImageSlidePageHandler(
                          extendedImageSlidePageState: state.slidePageState,
                          heroBuilderForSlidingPage: (widget) {
                            print(galleryItems[index].hero);
                            return Hero(
                              tag: galleryItems[index].hero,
                              child: widget,
                            );
                          },
                          child: child,
                        );
                        // child = ExtendedImageSlidePageHandler(state.);
                        print(child);
                        return child;
                      },
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                          inPageView: true,
                          initialScale: 1.0,
                          maxScale: 5.0,
                          animationMaxScale: 6.0,
                          initialAlignment: InitialAlignment.center,
                        );
                      },
                      onDoubleTap: (ExtendedImageGestureState state) {
                        try {
                          ///you can use define pointerDownPosition as you can,
                          ///default value is double tap pointer down postion.
                          final Offset? pointerDownPosition =
                              state.pointerDownPosition;
                          final double? begin =
                              state.gestureDetails!.totalScale;
                          double end;

                          //remove old
                          doubleClickAnimation
                              ?.removeListener(doubleClickAnimationListener);

                          //stop pre
                          doubleClickAnimationController.stop();

                          //reset to use
                          doubleClickAnimationController.reset();

                          if (begin == _doubleTapScales[0]) {
                            end = _doubleTapScales[1];
                          } else {
                            end = _doubleTapScales[0];
                          }

                          doubleClickAnimationListener = () {
                            //print(_animation.value);
                            state.handleDoubleTap(
                                scale: doubleClickAnimation!.value,
                                doubleTapPosition: pointerDownPosition);
                          };
                          doubleClickAnimation = doubleClickAnimationController
                              .drive(Tween<double>(begin: begin, end: end));

                          doubleClickAnimation!
                              .addListener(doubleClickAnimationListener);

                          doubleClickAnimationController.forward();
                        } catch (e) {
                          logger.e(e);
                        }
                      },
                    );

                    image = Container(
                      padding: const EdgeInsets.all(5.0),
                      child: image,
                    );

                    return image;
                  },
                  itemCount: galleryItems.length,
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (value) {
                    currentIndex.value = value;
                    _preloadImage(value - 1, context);
                    _preloadImage(value + 1, context);
                  },
                ),
              ),
              Positioned(
                top: 0,
                child: AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: AppBar(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      iconTheme: const IconThemeData(color: Colors.white),
                      title: Text(
                        "${currentIndex.value + 1} / ${galleryItems.length} ",
                        style: const TextStyle(color: Colors.white),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () async {
                              if (http.valueOrNull != null) {
                                var res = await saveImage(
                                    http: http.valueOrNull!,
                                    url: galleryItems[currentIndex.value].url,
                                    album: meta.valueOrNull?["name"]);
                                if (context.mounted) {
                                  var snackBar = SnackBar(
                                    content: Text(res ? "保存成功" : "保存失败"),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              }
                            },
                            icon: const Icon(Icons.download))
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
