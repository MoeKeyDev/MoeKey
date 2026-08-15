import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gal/gal.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Map<String, String> defaultExtensionMap = {
  'image/png': 'png',
  'image/jpeg': 'jpg',
  'image/webp': 'webp',
  'image/gif': 'gif',
  'image/heif': 'heif',
  'image/heic': 'heic',
  'image/bmp': 'bmp',
};

Future<bool> saveMedia({
  required Dio http,
  required String url,
  required String mimeType,
  String? name,
  String album = 'moekey',
}) async {
  if (mimeType.startsWith('image/')) {
    return saveImage(http: http, url: url, name: name, album: album);
  }

  try {
    final response = await http.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final bytes = response.data;
    if (bytes == null) return false;

    final safeName = basename(name ?? Uri.parse(url).path);
    final outputName = safeName.isEmpty
        ? '${md5.convert(utf8.encode(url))}.mp4'
        : safeName;

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      final prefs = await SharedPreferences.getInstance();
      final outputPath = await FilePicker.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: outputName,
        type: FileType.any,
        initialDirectory: prefs.getString('saveInitialDirectory'),
      );
      if (outputPath == null) return false;
      await prefs.setString('saveInitialDirectory', dirname(outputPath));
      await File(outputPath).writeAsBytes(bytes);
    } else if (Platform.isAndroid || Platform.isIOS) {
      final path = '${(await getTemporaryDirectory()).path}/$outputName';
      await File(path).writeAsBytes(bytes);
      await Gal.putVideo(path, album: album);
    }
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> saveImage({
  required Dio http,
  required String url,
  String? name,
  String album = "moekey",
}) async {
  name = name != null
      ? basename(name)
      : md5.convert(utf8.encode(url)).toString();

  var ext = extension(name).substring(1);
  var fileBasename = basenameWithoutExtension(name);

  var data = await getNetworkImageData(url, useCache: true);
  if (data == null) {
    return false;
  }
  var type = lookupMimeType(url, headerBytes: data);

  ext = defaultExtensionMap[type] ?? ext;

  name = "$fileBasename.$ext";

  var codec = await ui.instantiateImageCodec(data);

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // webp 单帧图片转换成png
    if (ext.toLowerCase().contains("webp") && codec.frameCount == 1) {
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      if (byteData == null) {
        return false;
      }
      data = Uint8List.view(byteData.buffer);
      name = "$fileBasename.png";
    }

    var prefs = await SharedPreferences.getInstance();
    var initialDirectory = prefs.getString("saveInitialDirectory");
    String? outputFile = await FilePicker.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: name,
      type: FileType.image,
      initialDirectory: initialDirectory,
    );
    if (outputFile == null) {
      return false;
    }
    await prefs.setString("saveInitialDirectory", dirname(outputFile));
    var file = File(outputFile);
    await file.writeAsBytes(data);
  }
  if (Platform.isAndroid || Platform.isIOS) {
    final imagePath = "${(await getTemporaryDirectory()).path}/$name";
    var file = File(imagePath);
    await file.writeAsBytes(data);
    // print(await getTemporaryDirectory());
    await Gal.putImage(imagePath, album: album);
  }
  return true;
}
