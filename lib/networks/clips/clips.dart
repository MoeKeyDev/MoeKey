import 'package:moekey/models/clips.dart';
import 'package:moekey/models/note.dart';
import 'package:moekey/networks/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../state/server.dart';

part 'clips.g.dart';

@riverpod
class Clips extends _$Clips {
  @override
  FutureOr<List<ClipsModel>> build() async {
    return clipsList();
  }

  Future<List<ClipsModel>> clipsList(
      {num? limit = 10, bool? allowPartial = true}) async {
    try {
      // 获取httpProvider和currentLoginUserProvider的实例
      var http = await ref.watch(httpProvider.future);
      var user = await ref.watch(currentLoginUserProvider.future);
      // 发送post请求，获取数据
      var res = await http.post("/clips/list", data: {
        "allowPartial": allowPartial,
        "i": user?.token,
        "limit": limit,
      });

      // 将数据转换为ClipsModel列表
      List<ClipsModel> list = [];
      for (var item in res.data) {
        var data = ClipsModel.fromMap(item);
        list.add(data);
      }
      // 将list反序排列
      list = list.reversed.toList();

      return list;
    } finally {
      // 设置加载状态为false
      loading = false;
    }
  }

  var loading = false;

  load() async {
    if (loading) return;
    loading = true;
    try {
      state = AsyncData((state.valueOrNull ?? []) + await clipsList());
    } finally {
      loading = false;
    }
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
    var list = await clipsNotesList(clipId: clipId);

    return ClipsNoteListState()..list = list;
  }

  Future<List<NoteModel>> clipsNotesList(
      {required String clipId, num? limit = 10, String? untilId}) async {
    try {
      var http = await ref.watch(httpProvider.future);
      var user = await ref.watch(currentLoginUserProvider.future);
      var res = await http.post("/clips/notes", data: {
        "clipId": clipId,
        "limit": limit,
        if (untilId != null) "untilId": untilId,
        "i": user?.token,
      });

      List<NoteModel> list = [];
      for (var item in res.data) {
        var data = NoteModel.fromMap(item);
        list.add(data);
      }

      return list;
    } finally {}
  }

  var loading = false;

  load() async {
    if (loading) return;
    loading = true;
    try {
      var untilId = state.valueOrNull?.list.last.id;
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
