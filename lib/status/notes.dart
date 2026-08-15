import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import 'misskey_api.dart';
import 'note_deletion_registry.dart';

part 'notes.g.dart';

class NotesState {
  late NoteModel data;
  List<NoteModel> conversation = [];
}

@riverpod
class Notes extends _$Notes {
  @override
  FutureOr<NotesState> build(String noteId) async {
    ref.listen(deletedNoteIdsProvider, (_, deletedNoteIds) {
      final notes = state.value;
      if (notes == null) return;
      final filtered = excludeDeletedNotes(notes.conversation, deletedNoteIds);
      if (filtered.length == notes.conversation.length) return;
      notes.conversation = filtered;
      state = AsyncData(notes);
      ref.notifyListeners();
    });
    var apis = ref.watch(misskeyApisProvider);
    var data = await apis.notes.show(noteId: noteId);
    var note = NotesState();
    note.data = data!;
    if (data.reply != null) {
      note.conversation = await _loadFullConversation(
        data.reply!,
        loadAncestors: (noteId) => apis.notes.conversation(noteId: noteId),
      );
      note.conversation = excludeDeletedNotes(
        note.conversation,
        ref.read(deletedNoteIdsProvider),
      );
    }
    return note;
  }
}

Future<List<NoteModel>> _loadFullConversation(
  NoteModel directReply, {
  required Future<List<NoteModel>> Function(String noteId) loadAncestors,
}) async {
  final conversation = <NoteModel>[directReply];
  final knownIds = <String>{directReply.id};
  var oldestNote = directReply;

  while (oldestNote.replyId != null) {
    final batch = await loadAncestors(oldestNote.id);
    final newAncestors = batch
        .where((ancestor) => knownIds.add(ancestor.id))
        .toList();
    if (newAncestors.isEmpty) break;

    conversation.insertAll(0, newAncestors.reversed);
    oldestNote = conversation.first;
  }

  return conversation;
}

// @riverpod
// class NotesChildTimeline extends _$NotesChildTimeline {
//   @override
//   FutureOr<List> build(String noteId) async {
//     List<NoteModel> list = await getRepliesList(id: noteId);
//     Map<String, List<NoteModel>> map = {};
//     for (var item in list) {
//       var id = item.replyId ?? noteId;
//       if (map[id] == null) {
//         map[id] = [];
//       }
//       map[id]!.add(item);
//     }
//     List<List<NoteModel>> list1 = [];
//     // 遍历一级回复
//     for (NoteModel item in map[noteId] ?? []) {
//       List<NoteModel> list2 = [item];
//       var tmp = getRepliesListByMap(id: item.id, map: map);
//
//       tmp.sort((obj1, obj2) {
//         int t = obj1.createdAt.compareTo(obj2.createdAt);
//         return t;
//       });
//       list2.addAll(tmp);
//       list1.add(list2);
//     }
//     list1.sort((obj1, obj2) {
//       int t = obj2[0].createdAt.compareTo(obj1[0].createdAt);
//       return t;
//     });
//     return list1;
//   }
//
//   List<NoteModel> getRepliesListByMap(
//       {required String id, required Map<String, List<NoteModel>> map}) {
//     List<NoteModel> list = [];
//     for (NoteModel item in map[id] ?? []) {
//       list.add(item);
//       var res1 = getRepliesListByMap(id: item.id, map: map);
//       list.addAll(res1);
//     }
//     return list;
//   }
//
//   Future<List<NoteModel>> getRepliesList({
//     required String id,
//     int maxCount = 10,
//   }) async {
//     if (maxCount <= 0) return [];
//     List<NoteModel> list = [];
//     List<NoteModel> res = await getData(id: id);
//     for (var item in res) {
//       list.add(item);
//       // if (item["repliesCount"] != null && item["repliesCount"] != 0) {
//       var res1 = await getRepliesList(id: item.id, maxCount: maxCount - 1);
//       list.addAll(res1);
//       // }
//     }
//     return list;
//   }
//
//   Future<List<NoteModel>> getData(
//       {required String id, int? limit, String? untilId}) async {
//     var apis = ref.read(misskeyApisProvider);
//
//     var data = await apis.notes
//         .children(noteId: noteId, untilId: untilId, limit: limit ?? 30);
//
//     return data;
//   }
// }
