import 'dart:async';

import 'package:moekey/status/misskey_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtag_select_dialog_state.g.dart';

@riverpod
class HashtagSelectDialogState extends _$HashtagSelectDialogState {
  Timer? timer;

  @override
  FutureOr<List> build() async {
    return [];
  }

  search({String? query}) {
    // 防抖
    timer?.cancel();
    state = const AsyncLoading();
    timer = Timer(const Duration(seconds: 1), () {
      _search(query: query);
    });
  }

  _search({String? query}) async {
    if (query == null) {
      state = const AsyncData([]);
      return;
    }

    var http = ref.read(misskeyApisProvider);
    var data = await http.hashtags.search(query: query);
    state = AsyncData(data);
  }
}
