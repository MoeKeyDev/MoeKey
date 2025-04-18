import 'package:blurhash_shader/blurhash_shader.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/meta.dart';
import 'package:moekey/hook/useExtendedPageController.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/dio.dart';
import 'package:moekey/utils/save_image.dart';
import 'package:moekey/widgets/mk_image.dart';

import '../../apis/models/drive.dart';
import '../../generated/l10n.dart';
import '../../logger.dart';
import '../../utils/custom_rect_tween.dart';

List<double> _doubleTapScales = <double>[1.0, 2.0];

class ImagePreviewPage extends HookConsumerWidget {
  final List<DriveFileModel> galleryItems;

  final void Function(int)? onPageChanged;

  final BoxDecoration? backgroundDecoration;

  final int initialIndex;

  final List<UniqueKey> heroKeys;

  const ImagePreviewPage({
    super.key,
    required this.initialIndex,
    required this.galleryItems,
    this.onPageChanged,
    required this.backgroundDecoration,
    required this.heroKeys,
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

    var appBarOpacity = useState(1.0);
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
                    var item = galleryItems[index];
                    Widget image = FutureBuilder(
                      future: precacheImage(
                        getExtendedResizeImage(item.url),
                        context,
                      ),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        print(snapshot);
                        var isLoaded =
                            snapshot.connectionState == ConnectionState.done ||
                                snapshot.hasError;
                        Widget image = _Image(
                          heroKey: currentIndex.value == index
                              ? heroKeys[index]
                              : null,
                          initGestureConfigHandler: initGestureConfigHandler,
                          onDoubleTap: onDoubleTap,
                          src: isLoaded ? item.url : item.thumbnailUrl,
                          blurhash: isLoaded ? null : item.blurhash,
                          width: item.properties?.width,
                          height: item.properties?.height,
                        );

                        return GestureDetector(
                          onTap: () {
                            if (appBarOpacity.value == 1.0) {
                              appBarOpacity.value = 0.0;
                            } else {
                              appBarOpacity.value = 1.0;
                            }
                          },
                          onDoubleTap: () {
                            onDoubleTap(ExtendedImageGestureState());
                          },
                          child: image,
                        );
                      },
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
              ImagePreviewTabbar(
                  appBarOpacity: appBarOpacity,
                  currentIndex: currentIndex,
                  galleryItems: galleryItems,
                  http: http,
                  meta: meta)
            ],
          ),
        );
      },
    );
  }
}

class _Image extends StatefulWidget {
  const _Image({
    required this.heroKey,
    required this.initGestureConfigHandler,
    required this.onDoubleTap,
    required this.src,
    this.blurhash,
    this.width,
    this.height,
  });

  final String? blurhash;
  final String? src;
  final double? width;
  final double? height;
  final UniqueKey? heroKey;
  final GestureConfig Function(ExtendedImageState)? initGestureConfigHandler;
  final void Function(ExtendedImageGestureState) onDoubleTap;

  @override
  State<_Image> createState() => _ImageState();
}

class _ImageState extends State<_Image> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.src == null) {
      return const SizedBox();
    }
    return ExtendedImage(
      image: getExtendedResizeImage(widget.src!),
      fit: BoxFit.contain,
      mode: ExtendedImageMode.gesture,
      enableSlideOutPage: true,
      loadStateChanged: (state) {
        if (widget.blurhash == null) {
          return null;
        }
        if (state.extendedImageLoadState != LoadState.completed) {
          return Center(
            child: AspectRatio(
              aspectRatio: (widget.width ?? 16) / (widget.height ?? 9),
              child: BlurHash(widget.blurhash!),
            ),
          );
        }
        return null;
      },
      heroBuilderForSlidingPage: (child) {
        return Hero(
          createRectTween: (begin, end) {
            return CustomRectTween(a: begin, b: end);
          },
          tag: widget.heroKey ?? UniqueKey(),
          child: child,
        );
      },
      initGestureConfigHandler: widget.initGestureConfigHandler,
      onDoubleTap: widget.onDoubleTap,
    );
  }
}

class ImagePreviewTabbar extends StatelessWidget {
  const ImagePreviewTabbar({
    super.key,
    required this.appBarOpacity,
    required this.currentIndex,
    required this.galleryItems,
    required this.http,
    required this.meta,
  });

  final ValueNotifier<double> appBarOpacity;
  final ValueNotifier<int> currentIndex;
  final List<DriveFileModel> galleryItems;
  final AsyncValue<Dio> http;
  final AsyncValue<MetaDetailedModel?> meta;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: appBarOpacity.value,
        duration: const Duration(milliseconds: 200),
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
                        name: galleryItems[currentIndex.value].name);
                    if (context.mounted) {
                      var snackBar = SnackBar(
                        content: Text(
                            res ? S.current.saveSuccess : S.current.saveFailed),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                },
                icon: const Icon(Icons.download))
          ],
        ),
      ),
    );
  }
}
