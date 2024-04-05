import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gal/gal.dart';
import 'package:jpeg_encode/jpeg_encode.dart';
import 'package:path/path.dart';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  var codec = await ui.instantiateImageCodec(data);

  // webp 单帧图片转换成jpeg
  if(ext.toLowerCase().contains("webp") && codec.frameCount == 1){
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final byteData = await image.toByteData(format: ImageByteFormat.rawRgba);
    data = JpegEncoder().compress(byteData!.buffer.asUint8List(), image.width, image.height, 100);
    name = "$fileBasename.jpg";
  }


  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    var prefs = await SharedPreferences.getInstance();
    var initialDirectory = prefs.getString("saveInitialDirectory");
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: name,
      type: FileType.image,
      initialDirectory: initialDirectory
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
