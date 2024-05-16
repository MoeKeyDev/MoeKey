import 'dart:io';

import 'package:moekey/apis/services/services.dart';

import '../models/translate.dart';

class NotesService extends MisskeyApiServices {
  NotesService({required super.client});

  translate({required String noteId}) async {
    var data = await client.post("/notes/translate", data: {
      "noteId": noteId,
      "targetLang": Platform.localeName.replaceAll("_", "-"),
    });
    if (data == null) {
      return null;
    }
    return NoteTranslate.fromMap(data);
  }

  linkPreview({required String url}) {
    String myLocale = Platform.localeName.replaceAll("_", "-");
    client.get("${client.host}/url", data: {
      "url": url,
      "lang": myLocale,
    });
  }
}
