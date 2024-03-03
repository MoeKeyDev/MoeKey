import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
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
  const MkImage(this.url,
      {super.key,
      this.width,
      this.height,
      this.fit = BoxFit.cover,
      this.shape,
      this.blurHash});

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
    return ExtendedImage(
      image: getExtendedResizeImage(url),
      shape: shape,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              height: height,
              width: width,
              fit: fit,
              filterQuality: FilterQuality.medium,
            );
          case LoadState.loading:
            if (blurHash != null) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  // 当某些情况拿不到最大高度的时候，用最小高度代替
                  var height = constraints.maxHeight;
                  if (constraints.maxHeight == double.infinity) {
                    height = constraints.minHeight;
                  }
                  return SizedBox(
                    height: height,
                    width: width,
                    child: BlurHash(hash: blurHash!),
                  );
                },
              );
            }
            return const SizedBox(width: 0, height: 0);
          case LoadState.failed:
            return const SizedBox(width: 0, height: 0);
        }
      },
    );
  }
}
