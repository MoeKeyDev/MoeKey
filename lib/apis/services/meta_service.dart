import 'package:moekey/apis/models/meta.dart';
import 'package:moekey/apis/services/services.dart';

import '../models/emojis.dart';

class MetaService extends MisskeyApiServices {
  MetaService({required super.client});

  Future<MetaDetailedModel?> meta() async {
    var res = await client.post(path: "/meta", data: {"detail": true});
    if (res != null) {
      return MetaDetailedModel.fromMap(res);
    }
    return null;
  }

  Future<List<EmojiSimple>> emojis() async {
    var data = await client.post(path: "/emojis");
    if (data == null) {
      return [];
    }
    return List<EmojiSimple>.from(
        data["emojis"].map((x) => EmojiSimple.fromMap(x)));
  }
}
