import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/painting.dart';
import 'package:path_provider/path_provider.dart';

/// Generated covers are separate from network-image cache entries. Hash the
/// complete URL: proxy query parameters identify different source videos.
class VideoThumbnailCache {
  VideoThumbnailCache({Future<Directory> Function()? directory})
    : _directory = directory ?? getTemporaryDirectory;
  final Future<Directory> Function() _directory;
  final Map<String, Future<ImageProvider<Object>?>> _pending = {};

  Future<File> _file(String url) async {
    final directory = await _directory();
    final key = sha256.convert(utf8.encode(url));
    return File('${directory.path}/video_covers_v1/$key.jpg');
  }

  Future<ImageProvider<Object>?> read(String url) async {
    final file = await _file(url);
    if (!await file.exists() || await file.length() == 0) return null;
    return FileImage(file);
  }

  Future<ImageProvider<Object>?> getOrCreate(
    String url,
    Future<Uint8List?> Function() capture,
  ) => _pending.putIfAbsent(url, () async {
    try {
      final existing = await read(url);
      if (existing != null) return existing;
      final jpeg = await capture();
      if (jpeg == null) return null;
      final file = await _file(url);
      await file.parent.create(recursive: true);
      // Readers must never see a partially written JPEG.
      final temporary = File('${file.path}.tmp');
      await temporary.writeAsBytes(jpeg, flush: true);
      await temporary.rename(file.path);
      return FileImage(file);
    } finally {
      _pending.remove(url);
    }
  });
}
