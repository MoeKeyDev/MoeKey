import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mfm_parser/mfm_parser.dart';
import 'package:moekey/widgets/driver/driver_select_dialog/driver_select_dialog_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../apis/models/drive.dart';
import '../../apis/models/note.dart';
import '../../apis/models/user_full.dart';
import '../../generated/l10n.dart';
import '../../logger.dart';
import '../../status/dio.dart';
import '../../status/misskey_api.dart';
import '../../status/note_deletion_registry.dart';
import '../../status/note_posted.dart';
import '../../status/notes_listener.dart';
import '../../status/server.dart';
import '../mk_info_dialog.dart';

part 'note_create_dialog_state.g.dart';

NoteModel decodeCreatedNoteResponse(Object? responseData) {
  if (responseData is! Map || responseData['createdNote'] is! Map) {
    throw const FormatException('notes/create did not return createdNote');
  }
  return NoteModel.fromJson(
    jsonDecode(jsonEncode(responseData['createdNote'])) as Map<String, dynamic>,
  );
}

NoteModel decodeUpdatedNoteResponse(
  Object? responseData, {
  NoteModel? fallback,
}) {
  if (responseData is! Map || responseData['updatedNote'] is! Map) {
    if (fallback != null) return fallback;
    throw const FormatException('notes/update did not return updatedNote');
  }
  return NoteModel.fromJson(
    jsonDecode(jsonEncode(responseData['updatedNote'])) as Map<String, dynamic>,
  );
}

/// Applies the fields accepted by notes/update from the submitted form.
///
/// Some Misskey forks return no note, or return a packed pre-update object.
/// Once the update request succeeds, the submitted values are authoritative.
NoteModel applySubmittedEditFields(
  NoteModel note,
  NoteCreateDialogStateModel state,
) {
  final text = state.text ?? '';
  final cw = state.isCw ? state.cw : null;
  note.text = text;
  note.textAst = const MfmParser().parse(text);
  note.cw = cw;
  note.cwAst = cw == null || cw.isEmpty
      ? const []
      : const MfmParser().parse(cw);
  note.files = List<DriveFileModel>.from(state.files);
  return note;
}

Map<String, dynamic> buildNoteUpdateData(NoteCreateDialogStateModel state) {
  final noteId = state.editId;
  if (noteId == null) {
    throw StateError('Cannot build notes/update data without a note id');
  }
  return {
    'noteId': noteId,
    'text': state.text ?? '',
    'cw': state.isCw ? state.cw : null,
    if (state.fileIds.isNotEmpty) 'fileIds': state.fileIds,
  };
}

Future<T> publishAfterDeletingOriginal<T>({
  required String? deleteOnPostId,
  required Future<void> Function(String noteId) deleteOriginal,
  required Future<T> Function() publish,
}) async {
  if (deleteOnPostId != null) {
    await deleteOriginal(deleteOnPostId);
  }
  return publish();
}

NoteVisibility resolveReplyVisibility(
  NoteVisibility selected,
  NoteVisibility target,
) {
  return switch (target) {
    NoteVisibility.public => selected,
    NoteVisibility.home => switch (selected) {
      NoteVisibility.followers => NoteVisibility.followers,
      NoteVisibility.specified => NoteVisibility.specified,
      _ => NoteVisibility.home,
    },
    NoteVisibility.followers =>
      selected == NoteVisibility.specified
          ? NoteVisibility.specified
          : NoteVisibility.followers,
    NoteVisibility.specified => NoteVisibility.specified,
  };
}

class NoteCreateDialogStateModel {
  NoteVisibility visibility = NoteVisibility.public; // 可见性
  LinkedHashSet<String> visibleUserIds = LinkedHashSet<String>();
  LinkedHashMap<String, UserFullModel> visibleUsers =
      LinkedHashMap<String, UserFullModel>(); // 当 可见性为specified 时的可见用户列表
  String? text; // 文本
  String cw = ''; //敏感内容
  bool isCw = false;
  bool localOnly = false; // 禁用联合
  NoteReactionAcceptance? reactionAcceptance; // 表情回应限制
  List fileIds = [];
  List<DriveFileModel> files = []; // 附件
  String? replyId; // 回复
  String? renoteId; // 转发/引用
  String? channelId; // 频道id
  String? editId; // 编辑的帖子 id（Misskey notes/update）
  String? deleteOnPostId; // 点击发布时先删除的原帖 id（删除并编辑）
  NotePollModel? poll;
  bool isNotePoll = false;
  bool isShowEmoji = false;
  bool preview = false;
  num emojiListHeight = 0;
  bool sendLoading = false;

  void applyInitialNote(NoteModel note) {
    visibility = note.visibility;
    visibleUserIds = LinkedHashSet<String>.from(note.visibleUserIds);
    text = note.text ?? '';
    cw = note.cw ?? '';
    isCw = note.cw != null;
    localOnly = note.localOnly;
    reactionAcceptance = note.reactionAcceptance;
    files = List<DriveFileModel>.from(note.files);
    replyId = note.replyId;
    renoteId = note.renoteId;

    final sourcePoll = note.poll;
    if (sourcePoll == null) {
      poll = null;
      isNotePoll = false;
    } else {
      poll = NotePollModel()
        ..choices = [
          for (final choice in sourcePoll.choices) (UniqueKey(), choice.text),
        ]
        ..multiple = sourcePoll.multiple
        ..never = sourcePoll.expiresAt == null
        ..expiresAt = sourcePoll.expiresAt?.millisecondsSinceEpoch;
      isNotePoll = true;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'visibility': visibility.value,
      if (visibility == NoteVisibility.specified)
        'visibleUserIds': visibleUserIds.toList(),
      'text': text ?? "",
      if (isCw) 'cw': cw,
      'localOnly': visibility == NoteVisibility.specified ? false : localOnly,
      if (reactionAcceptance != null && visibility != NoteVisibility.specified)
        'reactionAcceptance': reactionAcceptance?.value,
      if (fileIds.isNotEmpty) 'fileIds': fileIds,
      if (replyId != null) 'replyId': replyId,
      if (renoteId != null) 'renoteId': renoteId,
      if (channelId != null) 'channelId': channelId,
      'poll': isNotePoll ? poll?.toMap() : null,
    };
  }
}

class NotePollModel {
  List<(LocalKey, String)> choices = [(UniqueKey(), ""), (UniqueKey(), "")];
  bool multiple = false;
  bool never = false;
  int? expiresAt;
  int days = 0;
  int hours = 0;
  int minutes = 1;

  Map<String, dynamic> toMap() {
    var choices1 = [];
    for (var item in choices) {
      choices1.add(item.$2);
    }
    return {
      'choices': choices1,
      'multiple': multiple,
      if (!never && expiresAt != null) 'expiresAt': expiresAt,
      if (!never && expiresAt == null)
        'expiredAfter': Duration(
          hours: hours,
          days: days,
          minutes: minutes,
        ).inMilliseconds,
    };
  }
}

/// Note 类型
enum NoteType {
  /// 帖子
  note,

  /// 回复
  reply,

  /// 引用/转发
  reNote,

  /// 频道
  channel,

  /// 编辑现有帖子
  edit,
}

@Riverpod(keepAlive: true)
class NoteCreateDialogState extends _$NoteCreateDialogState {
  NoteVisibility? _replyTargetVisibility;
  bool _replyInitialized = false;

  @override
  NoteCreateDialogStateModel build(String? noteId, NoteType type) {
    _replyTargetVisibility = null;
    _replyInitialized = false;
    var state = NoteCreateDialogStateModel();
    if (type != NoteType.note) {
      assert(noteId != null);
    }

    // 回复
    switch (type) {
      case NoteType.note:
        break;
      case NoteType.reply:
        state.replyId = noteId;
        break;
      case NoteType.reNote:
        state.renoteId = noteId;
        break;
      case NoteType.channel:
        state.channelId = noteId;
        break;
      case NoteType.edit:
        state.editId = noteId;
        break;
    }
    return state;
  }

  void setVisibility(NoteVisibility visibility) {
    state.visibility = _replyTargetVisibility == null
        ? visibility
        : resolveReplyVisibility(visibility, _replyTargetVisibility!);
    ref.notifyListeners();
  }

  Future<void> initializeReply(NoteModel targetNote) async {
    if (type != NoteType.reply || _replyInitialized) return;
    _replyInitialized = true;
    _replyTargetVisibility = targetNote.visibility;
    state.visibility = resolveReplyVisibility(
      state.visibility,
      targetNote.visibility,
    );

    if (state.visibility != NoteVisibility.specified) {
      ref.notifyListeners();
      return;
    }

    state.localOnly = false;
    final currentUserId = ref.read(currentLoginUserProvider)?.id;
    final recipientIds = LinkedHashSet<String>.from(targetNote.visibleUserIds)
      ..remove(currentUserId);
    if (targetNote.userId != currentUserId) {
      recipientIds.add(targetNote.userId);
    }
    state.visibleUserIds = recipientIds;
    ref.notifyListeners();

    final api = ref.read(misskeyApisProvider);
    try {
      final users = await api.user.showMany(userIds: recipientIds);
      if (!ref.mounted) return;
      state.visibleUsers = LinkedHashMap<String, UserFullModel>.fromEntries(
        users.map((user) => MapEntry(user.id, user)),
      );
      ref.notifyListeners();
    } catch (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);
    }
  }

  void setLocalOnly(bool localOnly) {
    state.localOnly = localOnly;
    ref.notifyListeners();
  }

  void setReactionAcceptance(NoteReactionAcceptance? reactionAcceptance) {
    state.reactionAcceptance = reactionAcceptance;
    ref.notifyListeners();
  }

  void setText(String text) {
    state.text = text;
    ref.notifyListeners();
  }

  void createPoll() {
    state.poll ??= NotePollModel();
    state.isNotePoll = true;

    ref.notifyListeners();
  }

  void removePoll() {
    state.isNotePoll = false;
    ref.notifyListeners();
  }

  void setPollChoices(int index, String string) {
    if (state.poll != null) {
      state.poll?.choices[index] = (state.poll!.choices[index].$1, string);
      ref.notifyListeners();
    }
  }

  void addPollChoices() {
    if (state.poll != null) {
      state.poll?.choices.add((UniqueKey(), ""));
      ref.notifyListeners();
    }
  }

  void removePollChoices(int index) {
    if (state.poll != null) {
      state.poll?.choices.removeAt(index);
      ref.notifyListeners();
    }
  }

  void setPollMultiple(bool multiple) {
    if (state.poll != null) {
      state.poll?.multiple = multiple;
      ref.notifyListeners();
    }
  }

  void setPollNever(bool never) {
    if (state.poll != null) {
      state.poll?.never = never;
      if (never) state.poll?.expiresAt = null;
      ref.notifyListeners();
    }
  }

  void setPollTime({int? days, int? hours, int? minutes}) {
    if (state.poll != null) {
      state.poll!.expiresAt = null;
      if (days != null) {
        state.poll!.days = days;
      }
      if (hours != null) {
        state.poll!.hours = hours;
      }
      if (minutes != null) {
        state.poll!.minutes = minutes;
      }
      ref.notifyListeners();
    }
  }

  void setIsCw(bool isCw) {
    state.isCw = isCw;
    ref.notifyListeners();
  }

  void setCw(String cw) {
    state.cw = cw;
    ref.notifyListeners();
  }

  void setIsShowEmoji(bool isShowEmoji) {
    state.isShowEmoji = isShowEmoji;
    ref.notifyListeners();
  }

  void setPreview(bool preview) {
    state.preview = preview;
    ref.notifyListeners();
  }

  void setEmojiListHeight(num emojiListHeight) {
    state.emojiListHeight = emojiListHeight;
    ref.notifyListeners();
  }

  void addVisibleUser(String id, UserFullModel data) {
    state.visibleUserIds.add(id);
    state.visibleUsers = LinkedHashMap<String, UserFullModel>.of(
      state.visibleUsers,
    )..[id] = data;
    ref.notifyListeners();
  }

  void removeVisibleUser(String id) {
    if (state.visibleUsers[id] != null || state.visibleUserIds.contains(id)) {
      state.visibleUserIds.remove(id);
      state.visibleUsers = LinkedHashMap<String, UserFullModel>.of(
        state.visibleUsers,
      )..remove(id);
      ref.notifyListeners();
    }
  }

  String getDriverSelectId() {
    return "$type::$noteId";
  }

  void addFile(DriveFileModel file) {
    state.files.add(file);
    ref.notifyListeners();
  }

  void addFileList(List<DriveFileModel> files) {
    state.files.addAll(files);
    ref.notifyListeners();
  }

  void setFileList(List<DriveFileModel> files) {
    state.files = List.of(files);
    ref.notifyListeners();
  }

  Future<void> loadVisibleUsers() async {
    final ids = LinkedHashSet<String>.from(state.visibleUserIds);
    if (ids.isEmpty) return;
    try {
      final users = await ref
          .read(misskeyApisProvider)
          .user
          .showMany(userIds: ids);
      if (!ref.mounted) return;
      state.visibleUsers = LinkedHashMap<String, UserFullModel>.fromEntries(
        users.map((user) => MapEntry(user.id, user)),
      );
      ref.notifyListeners();
    } catch (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);
    }
  }

  void removeFile(int index) {
    if (state.files.length > index) {
      state.files.removeAt(index);
      ref.notifyListeners();
    }
  }

  Future<NoteModel?> send(
    BuildContext context, {
    NoteModel? editingNote,
  }) async {
    if (state.sendLoading) return null;
    state.sendLoading = true;
    ref.notifyListeners();
    try {
      var http = await ref.read(httpProvider.future);
      var user = ref.read(currentLoginUserProvider);
      state.fileIds = [];
      for (var item in state.files) {
        state.fileIds.add(item.id);
      }

      // 参数验证
      if (state.isCw && state.cw.isEmpty) {
        throw Exception(S.current.exceptionCwNull);
      }

      if (state.isNotePoll) {
        // 投票
        if (state.poll!.choices.length < 2) {
          throw Exception(S.current.voteOptionAtLeastTwo);
        }
        for (var (index, item) in state.poll!.choices.indexed) {
          if (item.$2.isEmpty) {
            throw Exception(S.current.voteOptionNullIndex(index + 1));
          }
        }
      }

      // 用户token
      final isEditing = state.editId != null;
      var data = isEditing ? buildNoteUpdateData(state) : state.toMap();
      data['i'] = user?.token ?? "";
      final res = isEditing
          ? await http.post("/notes/update", data: data)
          : await publishAfterDeletingOriginal(
              deleteOnPostId: state.deleteOnPostId,
              deleteOriginal: (noteId) async {
                await http.post(
                  "/notes/delete",
                  data: {"noteId": noteId, "i": user?.token ?? ""},
                );
                ref.read(deletedNoteIdsProvider.notifier).markDeleted(noteId);
                // If creating the replacement fails, a retry must not try to
                // delete the already removed original again.
                state.deleteOnPostId = null;
              },
              publish: () => http.post("/notes/create", data: data),
            );
      final resultNote = isEditing
          ? applySubmittedEditFields(
              decodeUpdatedNoteResponse(res.data, fallback: editingNote),
              state,
            )
          : decodeCreatedNoteResponse(res.data);
      if (isEditing) {
        ref.read(notesListenerProvider.notifier).emitNoteUpdated(resultNote);
      } else {
        emitNotePosted(resultNote);
      }
      state = NoteCreateDialogStateModel();
      ref.invalidate(driverSelectDialogStateProvider);
      ref.invalidate(noteCreateDialogStateProvider);
      ref.notifyListeners();
      return resultNote;
    } on DioException catch (e) {
      logger.d(e.response);
      if (!context.mounted) return null;
      MkInfoDialog.show(
        info: S.current.exceptionSendNote(
          e.response?.data.toString() ?? e.toString(),
        ),
        isError: true,
        context: context,
      );
    } catch (e) {
      if (!context.mounted) return null;
      MkInfoDialog.show(info: "$e", isError: true, context: context);
    } finally {
      if (ref.mounted) {
        state.sendLoading = false;
        ref.notifyListeners();
      }
    }

    return null;
  }
}
