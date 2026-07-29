import 'package:blurhash_shader/blurhash_shader.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/server.dart';

enum MkImageProxyType { image, emoji, avatar, preview }

class MkImageProxyOptions {
  const MkImageProxyOptions({
    this.type = MkImageProxyType.image,
    this.staticImage = false,
    this.fallback = false,
    this.origin = false,
  });

  /// Selects the proxy's mutually exclusive image conversion mode.
  final MkImageProxyType type;

  /// Requests a static image, such as when animated images are disabled.
  final bool staticImage;

  /// Requests the proxy's fallback image when the source cannot be loaded.
  final bool fallback;

  /// Forces the current instance to handle the request without forwarding it.
  final bool origin;
}

@visibleForTesting
String resolveMkImageUrl(
  String url, {
  MkImageProxyOptions? proxy,
  String? serverUrl,
}) {
  if (proxy == null || serverUrl == null || url.isEmpty) {
    return url;
  }

  final source = Uri.tryParse(url);
  final server = Uri.tryParse(serverUrl);
  if (source == null ||
      server == null ||
      (source.scheme != 'http' && source.scheme != 'https')) {
    return url;
  }

  // Resources from the current instance, including /proxy URLs, are already
  // reachable without another proxy hop.
  if (source.host == server.host && source.port == server.port) {
    return url;
  }

  final queryParameters = <String, String>{'url': url};
  switch (proxy.type) {
    case MkImageProxyType.emoji:
      queryParameters['emoji'] = '1';
    case MkImageProxyType.avatar:
      queryParameters['avatar'] = '1';
    case MkImageProxyType.image:
    case MkImageProxyType.preview:
      break;
  }
  if (proxy.staticImage) queryParameters['static'] = '1';
  if (proxy.fallback) queryParameters['fallback'] = '1';
  if (proxy.origin) queryParameters['origin'] = '1';

  return server
      .replace(
        pathSegments: [
          ...server.pathSegments.where((segment) => segment.isNotEmpty),
          'proxy',
          proxy.type == MkImageProxyType.preview
              ? 'preview.webp'
              : 'image.webp',
        ],
        queryParameters: queryParameters,
      )
      .toString();
}

ImageProvider<Object> getExtendedResizeImage(
  String url, {
  int? cacheWidth,
  int? cacheHeight,
}) {
  final provider = ExtendedNetworkImageProvider(
    url,
    cache: true,
    // Failed external responses are represented by MkImage's placeholder.
    // The package otherwise prints the same decode exception once for the
    // disk cache attempt and again for the network retry.
    printError: false,
  );
  if (kIsWeb) {
    return provider;
  }
  return ExtendedResizeImage(
    provider,
    // Explicit dimensions take precedence over the generic 500 KiB limit.
    // This is particularly important for emoji grids, where decoding source
    // images at their native size causes scroll-time raster work.
    maxBytes: cacheWidth == null && cacheHeight == null ? 500 << 10 : null,
    width: cacheWidth,
    height: cacheHeight,
  );
}

class MkImage extends ConsumerWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BoxShape? shape;
  final String? blurHash;
  final UniqueKey? heroKey;
  final MkImageProxyOptions? proxy;
  final int? cacheWidth;
  final int? cacheHeight;

  const MkImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.shape,
    this.blurHash,
    this.heroKey,
    this.proxy,
    this.cacheWidth,
    this.cacheHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageUrl = proxy == null
        ? url
        : resolveMkImageUrl(
            url,
            proxy: proxy,
            serverUrl: ref.watch(currentLoginUserProvider)?.serverUrl,
          );

    // 额外判断svg
    if (Uri.tryParse(imageUrl)?.path.toLowerCase().endsWith('.svg') ?? false) {
      return DecoratedBox(
        decoration: BoxDecoration(shape: shape ?? BoxShape.rectangle),
        child: SvgPicture.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    }
    Widget image = ExtendedImage(
      image: getExtendedResizeImage(
        imageUrl,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      ),
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
