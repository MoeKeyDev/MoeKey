import 'package:moekey/status/misskey_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../apis/models/clips.dart';
import '../../apis/models/note.dart';
import '../../logger.dart';

part 'clips.g.dart';

@Riverpod(keepAlive: true)
class Clips extends _$Clips {
  @override
  FutureOr<List<ClipsModel>> build() async {
    return clipsList();
  }

  Future<List<ClipsModel>> clipsList() async {
    var apis = ref.watch(misskeyApisProvider);

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
    state.list = await clipsNotesList(clipId: clipId);
    return state;
  }

  Future<List<NoteModel>> clipsNotesList(
      {required String clipId, int limit = 10, String? untilId}) async {
    try {
      var apis = ref.read(misskeyApisProvider);
      return await apis.clips
          .notes(clipId: clipId, untilId: untilId, limit: limit);
    } finally {}
  }

  load() async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    var model = state.valueOrNull ?? ClipsNoteListState();
    try {
      var untilId = model.list.lastOrNull?.id;
      var list = await clipsNotesList(clipId: clipId, untilId: untilId);

      if (list.isEmpty) {
        model.haveMore = false;
      } else {
        model.list += list;
      }
    } catch (e) {
      logger.e(e);
    }
    state = AsyncData(model);
  }
}

@riverpod
class ClipsShow extends _$ClipsShow {
  @override
  FutureOr<ClipsModel?> build(String clipId) async {
    try {
      var apis = ref.watch(misskeyApisProvider);

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
    var apis = ref.watch(misskeyApisProvider);
    return apis.clips.myFavorites();
  }
}
