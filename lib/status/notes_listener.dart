import 'dart:async';

import 'package:moekey/status/server.dart';
import 'package:moekey/status/websocket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import '../database/notes.dart';
import '../logger.dart';

part 'notes_listener.g.dart';

/// NotesListener 负责保存当前需要更新状态的note id列表，并且从ws中拉取Note的更新，并且调用NoteListener更新Note
@Riverpod(keepAlive: true)
class NotesListener extends _$NotesListener {
  Set<String> noteList = {};
  StreamSubscription<MoekeyEvent>? listen;

  @override
  Raw<Stream<Map>> build() {
    StreamController<Map> stream = StreamController.broadcast();
    for (var item in noteList) {
      _s(item);
    }
    listen = moekeyStreamController.stream.listen((event) {
      if (event.type == MoekeyEventType.data) {
        if (event.data["type"] == "noteUpdated") {
          print("Notes Listener");
          print(event.data["body"]);
          stream.add(event.data["body"]);
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
    return stream.stream;
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

/// 负责提供Note更新监听服务、注册/取消注册Note更新事件监听
@riverpod
class NoteIdListener extends _$NoteIdListener {
  StreamSubscription<Map>? listen;

  @override
  Raw<Stream<Map>> build(String noteId) {
    var listener = ref.read(notesListenerProvider.notifier);
    StreamController<Map> streamController = StreamController.broadcast();
    var event = ref.watch(notesListenerProvider);
    listen?.cancel();
    listen = event.listen((event) {
      if (noteId == event["id"]) {
        return streamController.add(event);
      }
    });
    listener.subNote(noteId);
    ref.onDispose(() {
      listener.unsubNote(noteId);
      listen?.cancel();
    });

    return streamController.stream;
  }
}

@riverpod
class NoteListener extends _$NoteListener {
  StreamSubscription<Map>? listen;

  @override
  NoteModel build(NoteModel noteModel) {
    var stream = ref.watch(noteIdListenerProvider(noteModel.id));
    var user = ref.watch(currentLoginUserProvider);
    listen?.cancel();
    listen = stream.listen((event) {
      var type = event["type"];
      var reactions = this.noteModel.reactions;
      if (type == "reacted") {
        var reaction = event["body"]["reaction"];
        var userId = event["body"]["userId"];
        var emoji = event["body"]["emoji"];
        if (reactions[reaction] == null) {
          reactions[reaction] = 0;
        }
        reactions[reaction] = reactions[reaction]! + 1;
        if (emoji != null) {
          noteModel.reactionEmojis[emoji["name"]] = emoji["url"];
        }
        // 处理用户
        if (userId == user?.id) {
          noteModel.myReaction = reaction;
        }
      }
      // 取消反应
      if (type == "unreacted") {
        var reaction = event["body"]["reaction"];
        var userId = event["body"]["userId"];
        if (reactions[reaction] != null) {
          reactions[reaction] = reactions[reaction]! - 1;
          if (reactions[reaction]! <= 0) {
            reactions.remove(reaction);
          }
        }
        // 处理用户
        if (userId == user?.id) {
          noteModel.myReaction = null;
        }
      }
      ref.notifyListeners();
    });
    ref.onDispose(() {
      listen?.cancel();
    });
    return noteModel;
  }

  updateNote(void Function(NoteModel noteModel) update) {
    update(noteModel);
    ref.notifyListeners();
  }
}
