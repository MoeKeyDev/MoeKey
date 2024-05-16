import 'package:moekey/apis/models/app.dart';
import 'package:moekey/apis/services/services.dart';

class AppService extends MisskeyApiServices {
  AppService({required super.client});

  Future<AppModel?> create() async {
    var data = await client.post(
      path: "/app/create",
      data: {
        "name": "MoeKey",
        "description": "app",
        "permission": [
          "read:account",
          "write:account",
          "read:blocks",
          "write:blocks",
          "read:drive",
          "write:drive",
          "read:favorites",
          "write:favorites",
          "read:following",
          "write:following",
          "read:messaging",
          "write:messaging",
          "read:mutes",
          "write:mutes",
          "write:notes",
          "read:notifications",
          "write:notifications",
          "write:reactions",
          "write:votes",
          "read:pages",
          "write:pages",
          "write:page-likes",
          "read:page-likes",
          "write:gallery-likes",
          "read:gallery-likes",
          "write:clip-favorite",
          "read:clip-favorite",
        ]
      },
      auth: false,
    );
    if (data != null) {
      return AppModel.fromMap(data);
    }
    return null;
  }
}
