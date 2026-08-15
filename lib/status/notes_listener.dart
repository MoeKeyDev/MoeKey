import 'dart:async';

import 'package:moekey/status/server.dart';
import 'package:moekey/status/websocket.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import '../database/notes.dart';
import '../logger.dart';
import 'note_posted.dart';

part 'notes_listener.g.dart';

void applyEditableNoteFields(NoteModel target, NoteModel updated) {
  target.text = updated.text;
  target.textAst = updated.textAst;
  target.cw = updated.cw;
  target.cwAst = updated.cwAst;
  target.files = updated.files;
}

/// NotesListener 负责保存当前需要更新状态的note id列表，并且从ws中拉取Note的更新，并且调用NoteListener更新Note
@Riverpod(keepAlive: true)
class NotesListener extends _$NotesListener {
  final Map<String, Set<Object>> _noteSubscriptions = {};
  late StreamController<Map> _noteEvents;

  @override
  Raw<Stream<Map>> build() {
    _noteEvents = StreamController<Map>.broadcast(sync: true);
    for (var item in _noteSubscriptions.keys) {
      _s(item);
    }
    final eventSubscription = moekeyStreamController.stream.listen((event) {
      if (event.type == MoekeyEventType.data) {
        if (event.data["type"] == "noteUpdated") {
          logger.d("Notes Listener");
          logger.d(event.data["body"]);
          _noteEvents.add(event.data["body"]);
        }
      }
      if (event.type == MoekeyEventType.load) {
        logger.d("========= NotesListener load ===================");
        logger.d(_noteSubscriptions.keys);
        for (var item in _noteSubscriptions.keys) {
          _s(item);
        }
      }
    });
    ref.onDispose(() {
      eventSubscription.cancel();
      _noteEvents.close();
    });
    return _noteEvents.stream;
  }

  /// Routes a successful local edit through the same per-note event pipeline
  /// used by WebSocket updates.
  void emitNoteUpdated(NoteModel note) {
    if (!ref.mounted) return;
    _noteEvents.add({"id": note.id, "type": "localNoteUpdated", "body": note});
  }

  void _s(String id) {
    if (!ref.mounted) return;
    ref.read(moekeyGlobalEventProvider.notifier).send({
      "type": "s",
      "body": {"id": id},
    });
  }

  void _un(String id) {
    if (!ref.mounted) return;
    ref.read(moekeyGlobalEventProvider.notifier).send({
      "type": "un",
      "body": {"id": id},
    });
  }

  Object subNote(String noteId) {
    final subscription = Object();
    final subscriptions = _noteSubscriptions.putIfAbsent(
      noteId,
      () => <Object>{},
    );
    final shouldSubscribe = subscriptions.isEmpty;
    subscriptions.add(subscription);
    if (shouldSubscribe) {
      _s(noteId);
    }
    return subscription;
  }

  void unsubNote(String noteId, Object subscription) {
    final subscriptions = _noteSubscriptions[noteId];
    if (subscriptions == null || !subscriptions.remove(subscription)) return;
    if (subscriptions.isEmpty) {
      _noteSubscriptions.remove(noteId);
      _un(noteId);
    }
  }
}

/// 维护当前服务器的帖子缓存
@riverpod
Future<NotesDatabase> notesDatabase(Ref ref) async {
  var user = ref.watch(currentLoginUserProvider);
  var instance = user?.serverUrl;
  return NotesDatabase(server: instance ?? "default");
}

/// 负责提供Note更新监听服务、注册/取消注册Note更新事件监听
@riverpod
class NoteIdListener extends _$NoteIdListener {
  @override
  Raw<Stream<Map>> build(String noteId) {
    var listener = ref.read(notesListenerProvider.notifier);
    // Local edits must reach the active NoteListener before the composer
    // route is popped. Keeping both routing stages synchronous also avoids
    // losing an edit when the originating card is disposed immediately.
    StreamController<Map> streamController = StreamController.broadcast(
      sync: true,
    );
    var event = ref.watch(notesListenerProvider);
    final eventSubscription = event.listen((event) {
      if (noteId == event["id"]) {
        return streamController.add(event);
      }
    });
    final noteSubscription = listener.subNote(noteId);
    ref.onDispose(() {
      eventSubscription.cancel();
      streamController.close();
      scheduleMicrotask(() => listener.unsubNote(noteId, noteSubscription));
    });

    return streamController.stream;
  }
}

@riverpod
class NoteListener extends _$NoteListener {
  @override
  NoteModel build(NoteModel noteModel) {
    var stream = ref.watch(noteIdListenerProvider(noteModel.id));
    var user = ref.watch(currentLoginUserProvider);
    final eventSubscription = stream.listen((event) {
      var type = event["type"];
      if (type == "localNoteUpdated") {
        final updatedNote = event["body"];
        if (updatedNote is NoteModel) {
          updateNote((noteModel) {
            applyEditableNoteFields(noteModel, updatedNote);
          });
        }
        return;
      }
      final currentNote = state;
      var reactions = currentNote.reactions;
      if (type == "reacted") {
        var reaction = event["body"]["reaction"];
        var userId = event["body"]["userId"];
        var emoji = event["body"]["emoji"];
        if (reactions[reaction] == null) {
          reactions[reaction] = 0;
        }
        reactions[reaction] = reactions[reaction]! + 1;
        if (emoji != null) {
          currentNote.reactionEmojis[emoji["name"]] = emoji["url"];
        }
        // 处理用户
        if (userId == user?.id) {
          currentNote.myReaction = reaction;
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
          currentNote.myReaction = null;
        }
      }
      if (type == "pollVoted" && currentNote.poll != null) {
        final choice = event["body"]["choice"];
        final userId = event["body"]["userId"];
        final choices = [...currentNote.poll!.choices];
        if (choice is int && choice >= 0 && choice < choices.length) {
          final currentChoice = choices[choice];
          final votedByCurrentUser = userId == user?.id;
          // A local vote is applied as soon as its API request succeeds.
          // Do not count it twice when its stream event arrives.
          if (!(votedByCurrentUser && currentChoice.isVoted)) {
            choices[choice] = currentChoice.copyWith(
              votes: currentChoice.votes + 1,
              isVoted: currentChoice.isVoted || votedByCurrentUser,
            );
            currentNote.poll = currentNote.poll!.copyWith(choices: choices);
          }
        }
      }
      ref.notifyListeners();
    });
    final locallyCountedReplyIds = <String>{};
    final notePostedSubscription = notePostedStream.listen((postedNote) {
      if (postedNote.replyId != state.id ||
          !locallyCountedReplyIds.add(postedNote.id)) {
        return;
      }
      state.repliesCount += 1;
      ref.notifyListeners();
    });
    ref.onDispose(() {
      eventSubscription.cancel();
      notePostedSubscription.cancel();
    });
    return noteModel;
  }

  void updateNote(void Function(NoteModel noteModel) update) {
    update(state);
    ref.notifyListeners();
  }
}
