import 'dart:io';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gal/gal.dart';
import 'package:path/path.dart';

Future<bool> saveImage({
  required Dio http,
  required String url,
  String album = "moekey",
}) async {
  var name = basename(url);
  var data = await getNetworkImageData(url, useCache: true);
  if (data == null) {
    return false;
  }
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: name,
    );
    if (outputFile == null) {
      return false;
    }
    var file = File(outputFile);
    await file.writeAsBytes(data);
  }
  if (Platform.isAndroid || Platform.isIOS) {
    final imagePath = '${Directory.systemTemp.path}/$name';

    await http.download(url, imagePath);
    await Gal.putImageBytes(data, album: album);
  }
  return true;
}
