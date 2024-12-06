import 'package:blurhash_shader/blurhash_shader.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/hook/useExtendedPageController.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/dio.dart';
import 'package:moekey/utils/save_image.dart';
import 'package:moekey/widgets/mk_image.dart';

import '../../apis/models/drive.dart';
import '../../generated/l10n.dart';
import '../../logger.dart';

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
        getExtendedResizeImage(url),
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
    var meta = ref.watch(instanceMetaProvider);
    var doubleClickAnimationController =
        useAnimationController(duration: const Duration(milliseconds: 180));
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
    GestureConfig initGestureConfigHandler(ExtendedImageState state) {
      return GestureConfig(
        inPageView: true,
        initialScale: 1.0,
        maxScale: 5.0,
        animationMaxScale: 6.0,
        initialAlignment: InitialAlignment.center,
      );
    }

    onDoubleTap(ExtendedImageGestureState state) {
      try {
        ///you can use define pointerDownPosition as you can,
        ///default value is double tap pointer down postion.
        final Offset? pointerDownPosition = state.pointerDownPosition;
        final double? begin = state.gestureDetails!.totalScale;
        double end;

        //remove old
        doubleClickAnimation?.removeListener(doubleClickAnimationListener);

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

        doubleClickAnimation!.addListener(doubleClickAnimationListener);

        doubleClickAnimationController.forward();
      } catch (e) {
        logger.e(e);
      }
    }

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
                    Widget image = FutureBuilder(
                      future: precacheImage(
                        ExtendedNetworkImageProvider(item, cache: true),
                        context,
                      ),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState != ConnectionState.done &&
                            galleryItems[index].thumbnailUrl != null) {
                          return ExtendedImage(
                            image: getExtendedResizeImage(
                                galleryItems[index].thumbnailUrl!),
                            fit: BoxFit.contain,
                            mode: ExtendedImageMode.gesture,
                            enableSlideOutPage: true,
                            loadStateChanged: (state) {
                              if (galleryItems[index].blurhash == null) {
                                return null;
                              }
                              if (state.extendedImageLoadState !=
                                  LoadState.completed) {
                                return Center(
                                  child: AspectRatio(
                                    aspectRatio: (galleryItems[index]
                                                .properties
                                                ?.width ??
                                            16) /
                                        (galleryItems[index]
                                                .properties
                                                ?.height ??
                                            9),
                                    child:
                                        BlurHash(galleryItems[index].blurhash!),
                                  ),
                                );
                              }
                              return null;
                            },
                            heroBuilderForSlidingPage: (widget) {
                              if (galleryItems[index].hero != null) {
                                return Hero(
                                  tag: galleryItems[index].hero!,
                                  child: widget,
                                );
                              }
                              return widget;
                            },
                            initGestureConfigHandler: initGestureConfigHandler,
                            onDoubleTap: onDoubleTap,
                          );
                        }
                        return ExtendedImage(
                          image:
                              ExtendedNetworkImageProvider(item, cache: true),
                          fit: BoxFit.contain,
                          mode: ExtendedImageMode.gesture,
                          enableSlideOutPage: true,
                          heroBuilderForSlidingPage: (widget) {
                            // print(galleryItems[index]);
                            if (galleryItems[index].hero != null) {
                              return Hero(
                                tag: galleryItems[index].hero!,
                                child: widget,
                              );
                            }
                            return widget;
                          },
                          initGestureConfigHandler: initGestureConfigHandler,
                          onDoubleTap: onDoubleTap,
                        );
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
                                    album: meta.valueOrNull?.name ?? "MoeKey",
                                    name:
                                        galleryItems[currentIndex.value].name);
                                if (context.mounted) {
                                  var snackBar = SnackBar(
                                    content: Text(res
                                        ? S.current.saveSuccess
                                        : S.current.saveFailed),
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
