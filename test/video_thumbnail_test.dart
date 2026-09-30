import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:flutter/painting.dart';
import 'package:moekey/video/video_thumbnail_cache.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:moekey/video/fvp_video_playback.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'disk covers survive new cache instance and retain full URL queries',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'video-covers-test',
      );
      try {
        final cache = VideoThumbnailCache(directory: () async => directory);
        const a = 'https://proxy/image.webp?url=one';
        const b = 'https://proxy/image.webp?url=two';
        expect(await cache.read(a), isNull);
        var captures = 0;
        final result = Completer<Uint8List?>();
        Future<Uint8List?> capture() {
          captures++;
          return result.future;
        }

        final first = cache.getOrCreate(a, capture);
        final duplicate = cache.getOrCreate(a, capture);
        result.complete(encodeVideoThumbnail((Uint8List(8 * 8 * 4), 8, 8)));
        final cover = await first;
        expect(await duplicate, same(cover));
        expect(captures, 1);
        expect(cover, isA<FileImage>());
        final reopened = VideoThumbnailCache(directory: () async => directory);
        expect(await reopened.read(a), isA<FileImage>());
        expect(await reopened.read(b), isNull);
        expect((await reopened.getOrCreate(a, capture)), isA<FileImage>());
        expect(captures, 1);
      } finally {
        await directory.delete(recursive: true);
      }
    },
  );

  test(
    'RGBA snapshot becomes compressed JPEG with correct dimensions and channels',
    () {
      final rgba = Uint8List(64 * 32 * 4);
      for (var i = 0; i < rgba.length; i += 4) {
        rgba[i] = 240;
        rgba[i + 1] = 20;
        rgba[i + 2] = 10;
        rgba[i + 3] = 255;
      }
      final encoded = encodeVideoThumbnail((rgba, 64, 32));
      final decoded = img.decodeJpg(encoded)!;
      expect(decoded.width, 64);
      expect(decoded.height, 32);
      expect(encoded.length, lessThan(rgba.length));
      expect(decoded.getPixel(20, 10).r, greaterThan(220));
      expect(decoded.getPixel(20, 10).b, lessThan(30));
    },
  );
}
