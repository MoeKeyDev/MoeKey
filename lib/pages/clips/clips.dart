import 'package:moekey/status/misskey_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../apis/models/clips.dart';
import '../../apis/models/note.dart';

part 'clips.g.dart';

@Riverpod(keepAlive: true)
class Clips extends _$Clips {
  @override
  FutureOr<List<ClipsModel>> build() async {
    return clipsList();
  }

  Future<List<ClipsModel>> clipsList() async {
    var apis = await ref.read(misskeyApisProvider.future);

    var list = await apis.clips.list();
    // 将list反序排列
    list = list.reversed.toList();
    return list;
  }
}

class ClipsNoteListState {
  List<NoteModel> list = [];
  var haveMore = true;
}

@riverpod
class ClipsNotesList extends _$ClipsNotesList {
  @override
  FutureOr<ClipsNoteListState> build(String clipId) async {
    var state = ClipsNoteListState();
    try {
      loading = true;
      state.list = await clipsNotesList(clipId: clipId);
    } finally {
      loading = false;
    }
    return state;
  }

  Future<List<NoteModel>> clipsNotesList(
      {required String clipId, int limit = 10, String? untilId}) async {
    try {
      var apis = await ref.read(misskeyApisProvider.future);
      return await apis.clips
          .notes(clipId: clipId, untilId: untilId, limit: limit);
    } finally {}
  }

  var loading = false;

  load() async {
    if (loading) return;
    loading = true;
    try {
      var untilId = state.valueOrNull?.list.lastOrNull?.id;
      var list = await clipsNotesList(clipId: clipId, untilId: untilId);

      if (list.isEmpty) {
        state = AsyncData(state.valueOrNull!..haveMore = false);
      } else {
        state = AsyncData(state.valueOrNull!
          ..list.addAll(list)
          ..haveMore = true);
      }
    } finally {
      loading = false;
    }
  }
}

@riverpod
class ClipsShow extends _$ClipsShow {
  @override
  FutureOr<ClipsModel?> build(String clipId) async {
    try {
      var apis = await ref.read(misskeyApisProvider.future);

      return await apis.clips.show(clipId: clipId);
    } finally {}
  }
}

@riverpod
class ClipsMyFavorites extends _$ClipsMyFavorites {
  @override
  FutureOr<List<ClipsModel>> build() async {
    return clipsMyFavorites();
  }

  Future<List<ClipsModel>> clipsMyFavorites() async {
    var apis = await ref.read(misskeyApisProvider.future);
    return apis.clips.myFavorites();
  }
}
