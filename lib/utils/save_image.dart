import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

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
  'image/webp': 'webp',
  'image/gif': 'gif',
  'image/heif': 'heif',
  'image/heic': 'heic',
  'image/bmp': 'bmp',
};

Future<bool> saveImage({
  required Dio http,
  required String url,
  String album = "moekey",
}) async {
  var name = basename(url);
  var ext = extension(name);
  var fileBasename = basenameWithoutExtension(name);

  var data = await getNetworkImageData(url, useCache: true);
  if (data == null) {
    return false;
  }
  var type = lookupMimeType(url, headerBytes: data);
  ext = defaultExtensionMap[type] ?? ext;
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
    String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: name,
        type: FileType.image,
        initialDirectory: initialDirectory);
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
