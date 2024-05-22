import 'package:moekey/apis/index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'server.dart';

part 'misskey_api.g.dart';

@Riverpod(keepAlive: true)
MisskeyApis misskeyApis(MisskeyApisRef ref) {
  var user = ref.watch(currentLoginUserProvider);
  var instance = user?.serverUrl;
  var accessToken = user?.token;
  return MisskeyApis(
      instance: instance ?? "http://localhost", accessToken: accessToken ?? "");
}
