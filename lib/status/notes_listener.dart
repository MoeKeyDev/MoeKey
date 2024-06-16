import 'dart:async';

import 'package:moekey/status/server.dart';
import 'package:moekey/status/websocket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import '../database/notes.dart';
import '../main.dart';

part 'notes_listener.g.dart';

/// NotesListener 负责保存当前需要更新状态的note id列表，并且从ws中拉取Note的更新，并且调用NoteListener更新Note
@Riverpod(keepAlive: true)
class NotesListener extends _$NotesListener {
  Set<String> noteList = {};
  StreamSubscription<MoekeyEvent>? listen;

  @override
  Future build() async {
    try {
      ref.onDispose(() {
        logger.d("========= NotesListener dispose ===================");
        listen?.cancel();
        listen = null;
      });
      var user = ref.watch(currentLoginUserProvider);
      listen?.cancel();
      listen = null;
      listen = moekeyStreamController.stream.listen((event) async {
        if (event.type == MoekeyEventType.data) {
          if (event.data["type"] == "noteUpdated") {
            var eventData = event.data;
            logger.d(eventData);
            var noteId = eventData["body"]["id"];
            var type = eventData["body"]["type"];
            var note = await ref.read(noteListenerProvider(noteId).future);
            logger.d(note);
            if (note != null) {
              var data = note;
              // 反应
              var reactions = data.reactions;
              if (type == "reacted") {
                var reaction = eventData["body"]["body"]["reaction"];
                var userId = eventData["body"]["body"]["userId"];
                var emoji = eventData["body"]["body"]["emoji"];
                if (reactions[reaction] == null) {
                  reactions[reaction] = 0;
                }
                reactions[reaction] = reactions[reaction]! + 1;
                if (emoji != null) {
                  data.reactionEmojis[emoji["name"]] = emoji["url"];
                }
                // 处理用户
                if (userId == user?.id) {
                  data.myReaction = reaction;
                }
              }
              // 取消反应
              if (type == "unreacted") {
                var reaction = eventData["body"]["body"]["reaction"];
                var userId = eventData["body"]["body"]["userId"];
                if (reactions[reaction] != null) {
                  reactions[reaction] = reactions[reaction]! - 1;
                  if (reactions[reaction]! <= 0) {
                    reactions.remove(reaction);
                  }
                }

                // 处理用户
                if (userId == user?.id) {
                  data.myReaction = null;
                }
              }
              logger.d(noteId);
              ref.read(noteListenerProvider(noteId).notifier).updateModel(data);
            }
          }
        }
        if (event.type == MoekeyEventType.load) {
          logger.d("========= NotesListener load ===================");
          logger.d(noteList);
          for (var item in noteList) {
            _s(item);
          }
        }
      });
      for (var item in noteList) {
        _s(item);
      }
    } catch (e) {
      logger.e(e);
    }
  }

  _s(String id) {
    ref.read(moekeyGlobalEventProvider.notifier).send({
      "type": "s",
      "body": {"id": id}
    });
  }

  _un(String id) {
    ref.read(moekeyGlobalEventProvider.notifier).send({
      "type": "un",
      "body": {"id": id}
    });
  }

  subNote(String noteId) {
    noteList.add(noteId);
    _s(noteId);
  }

  unsubNote(String noteId) {
    noteList.remove(noteId);
    _un(noteId);
  }
}

/// 维护当前服务器的帖子缓存
@riverpod
Future<NotesDatabase> notesDatabase(NotesDatabaseRef ref) async {
  var user = ref.watch(currentLoginUserProvider);
  var instance = user?.serverUrl;
  return NotesDatabase(server: instance ?? "default");
}

/// 负责面向组件提供Note更新监听服务、注册/取消注册Note更新事件监听
@riverpod
class NoteListener extends _$NoteListener {
  @override
  FutureOr<NoteModel?> build(String noteId) async {
    var db = await ref.watch(notesDatabaseProvider.future);
    var model = await db.get(noteId);
    var listener = ref.watch(notesListenerProvider.notifier);
    listener.subNote(noteId);
    ref.onDispose(() {
      listener.unsubNote(noteId);
    });
    return model;
  }

  updateModel(NoteModel model, {bool onlySelf = false}) async {
    var db = await ref.read(notesDatabaseProvider.future);
    await db.put(noteId, model);
    if (model.renote != null && !onlySelf) {
      ref
          .read(noteListenerProvider(model.renote!.id).notifier)
          .updateModel(model.renote!, onlySelf: true);
    }
    if (model.reply != null && !onlySelf) {
      ref
          .read(noteListenerProvider(model.reply!.id).notifier)
          .updateModel(model.reply!, onlySelf: true);
    }
    state = AsyncData(model);
  }
}
