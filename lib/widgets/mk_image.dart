import 'dart:math';

import 'package:blurhash_shader/blurhash_shader.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

ExtendedResizeImage getExtendedResizeImage(String url) {
  return ExtendedResizeImage(ExtendedNetworkImageProvider(url, cache: true),
      maxBytes: 500 << 10);
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
        decoration: BoxDecoration(
          shape: shape ?? BoxShape.rectangle,
        ),
        child: SvgPicture.network(url, width: width, height: height, fit: fit),
      );
    }
    Widget image = ExtendedImage(
      image: getExtendedResizeImage(url),
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
            Widget child = ColoredBox(
              color: const Color.fromARGB(40, 0, 0, 0),
            );
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
          child = ExtendedRawImage(
            image: state.extendedImageInfo?.image,
            height: height,
            width: width,
            fit: fit,
            filterQuality: FilterQuality.medium,
          );
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: child,
        );
      },
    );

    if (heroKey != null) {
      image = Hero(tag: heroKey!, child: image);
    }
    return RepaintBoundary(
      child: image,
    );
  }
}
