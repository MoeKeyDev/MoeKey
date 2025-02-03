import 'package:moekey/status/misskey_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/me_detailed.dart';

part 'me_detailed.g.dart';

@Riverpod(keepAlive: true)
class CurrentMeDetailed extends _$CurrentMeDetailed {
  @override
  FutureOr<MeDetailed?> build() async {
    var api = ref.watch(misskeyApisProvider);
    var info = await api.account.i();
    return info;
  }
}
