import 'package:blurhash_shader/blurhash_shader.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

ImageProvider<Object> getExtendedResizeImage(String url) {
  final provider = ExtendedNetworkImageProvider(url, cache: true);
  if (kIsWeb) {
    return provider;
  }
  return ExtendedResizeImage(provider, maxBytes: 500 << 10);
}

class MkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BoxShape? shape;
  final String? blurHash;
  final UniqueKey? heroKey;

  const MkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.shape,
    this.blurHash,
    this.heroKey,
  });

  @override
  Widget build(BuildContext context) {
    // 额外判断svg
    if (url.endsWith(".svg")) {
      return DecoratedBox(
        decoration: BoxDecoration(shape: shape ?? BoxShape.rectangle),
        child: SvgPicture.network(url, width: width, height: height, fit: fit),
      );
    }
    Widget image = ExtendedImage(
      image: getExtendedResizeImage(url),
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.medium,
      shape: shape,
      loadStateChanged: (state) {
        Widget child = LayoutBuilder(
          builder: (context, constraints) {
            var constraintsHeight = constraints.maxHeight;
            var constraintsWidth = constraints.maxWidth;
            if (constraints.maxHeight == double.infinity) {
              constraintsHeight = constraints.minHeight;
            }
            if (constraints.maxWidth == double.infinity) {
              constraintsWidth = constraints.minWidth;
            }
            Widget child = ColoredBox(color: const Color.fromARGB(40, 0, 0, 0));
            if (blurHash != null && blurHash!.isNotEmpty) {
              child = BlurHash(blurHash!);
            }
            return SizedBox(
              width: width ?? height ?? constraintsWidth,
              height: height ?? constraintsHeight,
              child: child,
            );
          },
        );

        if (state.extendedImageLoadState == LoadState.completed) {
          child = state.completedWidget;
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: child,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      },
    );

    if (heroKey != null) {
      image = Hero(tag: heroKey!, child: image);
    }
    return RepaintBoundary(child: image);
  }
}
