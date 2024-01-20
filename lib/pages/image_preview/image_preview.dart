import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:misskey/hook/useExtendedPageController.dart';
import 'package:misskey/networks/apis.dart';
import 'package:misskey/networks/dio.dart';
import 'package:misskey/utils/save_image.dart';

import '../../models/drive.dart';

class ImagePreviewPage extends HookConsumerWidget {
  final List<DriveFileModel> galleryItems;

  final void Function(int)? onPageChanged;

  final BoxDecoration? backgroundDecoration;

  final int initialIndex;

  const ImagePreviewPage(
      {super.key,
      required this.initialIndex,
      required this.galleryItems,
      this.onPageChanged,
      required this.backgroundDecoration});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var pageController = useExtendedPageController(initialPage: initialIndex);
    var currentIndex = useState(initialIndex);
    var http = ref.watch(httpProvider);
    var meta = ref.watch(apiMetaProvider);
    useEffect(() {
      setBar();
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
                slideType: SlideType.wholePage,
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
                      initGestureConfigHandler: (state) {
                        return GestureConfig(
                          minScale: 0.9,
                          animationMinScale: 0.7,
                          maxScale: 3.0,
                          animationMaxScale: 3.5,
                          speed: 1.0,
                          inertialSpeed: 100.0,
                          initialScale: 1.0,
                          inPageView: true,
                          initialAlignment: InitialAlignment.center,
                        );
                      },
                    );
                    image = Container(
                      padding: const EdgeInsets.all(5.0),
                      child: image,
                    );

                    return GestureDetector(child: image, onTap: () {});
                  },
                  itemCount: galleryItems.length,
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (value) {
                    currentIndex.value = value;
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
                        "${galleryItems.length} / ${currentIndex.value + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () async {
                              if (http.valueOrNull != null) {
                                await saveImage(
                                    http: http.valueOrNull!,
                                    url: galleryItems[currentIndex.value].url,
                                    album: meta.valueOrNull?["name"]);
                                if (context.mounted) {
                                  const snackBar = SnackBar(
                                    content: Text('保存成功'),
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
