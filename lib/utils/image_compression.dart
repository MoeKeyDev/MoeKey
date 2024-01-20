import 'dart:io';

import 'package:image_compression/image_compression.dart';

Future<ImageFile> imageCompression(String path) async {
  final file = File(path);

  final input = ImageFile(
    rawBytes: file.readAsBytesSync(),
    filePath: file.path,
  );
  final output = await compressInQueue(ImageFileConfiguration(input: input));
  return output;
}
