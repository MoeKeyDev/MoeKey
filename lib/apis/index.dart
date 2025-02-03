import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/services/account_service.dart';
import 'package:moekey/apis/services/app_service.dart';
import 'package:moekey/apis/services/auth_service.dart';
import 'package:moekey/apis/services/clips_service.dart';
import 'package:moekey/apis/services/drive_service.dart';
import 'package:moekey/apis/services/following_service.dart';
import 'package:moekey/apis/services/hashtags_service.dart';
import 'package:moekey/apis/services/meta_service.dart';
import 'package:moekey/apis/services/notes_service.dart';
import 'package:moekey/apis/services/user_service.dart';

class MisskeyApis {
  MisskeyApis({
    required this.instance,
    required this.accessToken,
    required this.onUnauthorized,
  }) {
    client = MisskeyApisHttpClient(
      host: instance,
      accessToken: accessToken,
      onUnauthorized: onUnauthorized,
    );
    account = AccountService(client: client);
    app = AppService(client: client);
    auth = AuthService(client: client);
    meta = MetaService(client: client);
    notes = NotesService(client: client);
    drive = DriveService(client: client);
    user = UserService(client: client);
    following = FollowingService(client: client);
    clips = ClipsService(client: client);
    hashtags = HashtagsService(client: client);
  }

  String instance;
  String accessToken;
  Function? onUnauthorized;
  late MisskeyApisHttpClient client;
  late AccountService account;
  late AppService app;
  late AuthService auth;
  late MetaService meta;
  late NotesService notes;
  late DriveService drive;
  late UserService user;
  late FollowingService following;
  late ClipsService clips;
  late HashtagsService hashtags;
}
