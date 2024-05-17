import 'dart:async';

import 'package:moekey/status/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../status/server.dart';

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

    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    var data = await http.post("/hashtags/search",
        data: {"query": query, "limit": 30, "i": user!.token});
    state = AsyncData(data.data);
  }
}
