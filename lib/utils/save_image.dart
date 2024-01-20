import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:gal/gal.dart';
import 'package:path/path.dart';

Future saveImage({
  required Dio http,
  required String url,
  String album = "misskey",
}) async {
  var name = basename(url);

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: name,
    );
    await http.download(url, outputFile);
  }
  if (Platform.isAndroid || Platform.isIOS) {
    final imagePath = '${Directory.systemTemp.path}/$name';

    await http.download(url, imagePath);
    await Gal.putImage(imagePath, album: album);
  }
}
