import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:fvp/fvp.dart';
import 'package:image/image.dart' as img;
import 'video_thumbnail_cache.dart';
import 'package:moekey_video_pool/moekey_video_pool.dart';

/// Adds optional snapshots without coupling the reusable pool to FVP.
class FvpVideoPlayback extends VideoPlayerPlayback {
  FvpVideoPlayback(
    super.url, {
    super.videoPlayerOptions,
    this.thumbnailCache,
    String? thumbnailKey,
  }) : thumbnailKey = thumbnailKey ?? url;
  final VideoThumbnailCache? thumbnailCache;
  final String thumbnailKey;
  bool _released = false;

  @override
  Future<ImageProvider<Object>?> captureThumbnail() async {
    final cache = thumbnailCache;
    if (cache != null) return cache.getOrCreate(thumbnailKey, _captureJpeg);
    final jpeg = await _captureJpeg();
    return jpeg == null ? null : MemoryImage(jpeg);
  }

  Future<Uint8List?> _captureJpeg() async {
    if (_released || !initialized) return null;
    final size = controller.value.size;
    if (size.width <= 0 || size.height <= 0) return null;
    // Like resized network images, constrain decoded size as well as file size.
    final scale = math.min(1.0, 320 / math.max(size.width, size.height));
    final width = math.max(1, (size.width * scale).round());
    final height = math.max(1, (size.height * scale).round());
    final rgba = await controller
        .snapshot(width: width, height: height)
        .timeout(const Duration(seconds: 2));
    if (_released || rgba == null || rgba.length != width * height * 4) {
      return null;
    }
    // Encoding runs off the UI isolate on mobile/desktop. Never seek to zero or
    // play a hidden video to get a cover; use the available rendered frame.
    final jpeg = await compute(encodeVideoThumbnail, (rgba, width, height));
    if (_released) return null;
    return jpeg;
  }

  @override
  Future<void> release() async {
    _released = true;
    await super.release();
  }
}

@visibleForTesting
Uint8List encodeVideoThumbnail((Uint8List, int, int) data) {
  final (rgba, width, height) = data;
  final image = img.Image.fromBytes(
    width: width,
    height: height,
    bytes: rgba.buffer,
    bytesOffset: rgba.offsetInBytes,
    numChannels: 4,
    order: img.ChannelOrder.rgba,
  );
  return img.encodeJpg(image, quality: 75);
}
