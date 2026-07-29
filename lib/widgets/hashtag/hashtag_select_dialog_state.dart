import 'dart:async';

import 'package:moekey/status/misskey_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'hashtag_select_dialog_state.g.dart';

@riverpod
class HashtagSelectDialogState extends _$HashtagSelectDialogState {
  Timer? timer;
  int _searchGeneration = 0;

  @override
  FutureOr<List> build() async {
    ref.onDispose(() {
      timer?.cancel();
      _searchGeneration++;
    });
    return [];
  }

  void search({String? query}) {
    // 防抖
    timer?.cancel();
    final generation = ++_searchGeneration;
    state = const AsyncLoading();
    timer = Timer(const Duration(seconds: 1), () {
      unawaited(_search(query: query, generation: generation));
    });
  }

  Future<void> _search({String? query, required int generation}) async {
    if (!ref.mounted || generation != _searchGeneration) return;
    if (query == null) {
      state = const AsyncData([]);
      return;
    }

    try {
      var http = ref.read(misskeyApisProvider);
      var data = await http.hashtags.search(query: query);
      if (!ref.mounted || generation != _searchGeneration) return;
      state = AsyncData(data);
    } catch (error, stackTrace) {
      if (!ref.mounted || generation != _searchGeneration) return;
      state = AsyncError(error, stackTrace);
    }
  }
}
