import 'package:moekey/apis/models/announcement.dart';
import 'package:moekey/apis/models/meta.dart';
import 'package:moekey/apis/services/services.dart';

import '../models/emojis.dart';

class MetaService extends MisskeyApiServices {
  MetaService({required super.client});

  Future<MetaDetailedModel?> meta() async {
    var res = await client.post("/meta", data: {"detail": true});
    if (res != null) {
      return MetaDetailedModel.fromJson(res);
    }
    return null;
  }

  Future<List<EmojiSimple>> emojis() async {
    var data = await client.post("/emojis");
    if (data == null) {
      return [];
    }
    return List<EmojiSimple>.from(
        data["emojis"].map((x) => EmojiSimple.fromJson(x)));
  }

  Future<List<Announcement>> announcements(
      {int limit = 10,
      String? sinceId,
      String? untilId,
      bool isActive = true}) async {
    var data = await client.post<List?>("/announcements", data: {
      "limit": limit,
      if (sinceId != null) 'sinceId': sinceId,
      if (untilId != null) 'untilId': untilId,
      "isActive": isActive,
    });
    if (data == null) {
      return [];
    }
    return List<Announcement>.from(data.map((x) => Announcement.fromJson(x)));
  }

  readAnnouncement({required String announcementId}) async {
    return client.post("/i/read-announcement", data: {
      "announcementId": announcementId,
    });
  }
}
