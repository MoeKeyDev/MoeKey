import 'package:moekey/apis/index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'server.dart';

part 'misskey_api.g.dart';

@Riverpod(keepAlive: true)
Future<MisskeyApis> misskeyApis(MisskeyApisRef ref) async {
  var user = await ref.watch(currentLoginUserProvider.future);
  var instance = user?.serverUrl;
  var accessToken = user?.token;
  return MisskeyApis(
      instance: instance ?? "http://localhost", accessToken: accessToken ?? "");
}
