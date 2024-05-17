import 'package:moekey/apis/dio.dart';
import 'package:moekey/apis/services/account_service.dart';
import 'package:moekey/apis/services/app_service.dart';
import 'package:moekey/apis/services/auth_service.dart';
import 'package:moekey/apis/services/drive_service.dart';
import 'package:moekey/apis/services/following_service.dart';
import 'package:moekey/apis/services/meta_service.dart';
import 'package:moekey/apis/services/notes_service.dart';
import 'package:moekey/apis/services/user_service.dart';

class MisskeyApis {
  MisskeyApis({
    required this.instance,
    required this.accessToken,
  }) {
    client = MisskeyApisHttpClient(host: instance, accessToken: accessToken);
    account = AccountService(client: client);
    app = AppService(client: client);
    auth = AuthService(client: client);
    meta = MetaService(client: client);
    notes = NotesService(client: client);
    drive = DriveService(client: client);
    user = UserService(client: client);
    following = FollowingService(client: client);
  }

  String instance;
  String accessToken;
  late MisskeyApisHttpClient client;
  late AccountService account;
  late AppService app;
  late AuthService auth;
  late MetaService meta;
  late NotesService notes;
  late DriveService drive;
  late UserService user;
  late FollowingService following;
}
