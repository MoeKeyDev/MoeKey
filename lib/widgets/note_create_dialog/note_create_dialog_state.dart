import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:moekey/widgets/driver/driver_select_dialog/driver_select_dialog_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../apis/models/drive.dart';
import '../../apis/models/note.dart';
import '../../apis/models/user_full.dart';
import '../../generated/l10n.dart';
import '../../logger.dart';
import '../../status/dio.dart';
import '../../status/misskey_api.dart';
import '../../status/note_posted.dart';
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
  NotePollModel? poll;
  bool isNotePoll = false;
  bool isShowEmoji = false;
  bool preview = false;
  num emojiListHeight = 0;
  bool sendLoading = false;

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
      if (!never)
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
      ref.notifyListeners();
    }
  }

  void setPollTime({int? days, int? hours, int? minutes}) {
    if (state.poll != null) {
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

  void removeFile(int index) {
    if (state.files.length > index) {
      state.files.removeAt(index);
      ref.notifyListeners();
    }
  }

  Future<NoteModel?> send(BuildContext context) async {
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
      var data = state.toMap();
      data['i'] = user?.token ?? "";
      var res = await http.post("/notes/create", data: data);
      final createdNote = decodeCreatedNoteResponse(res.data);
      emitNotePosted(createdNote);
      state = NoteCreateDialogStateModel();
      ref.invalidate(driverSelectDialogStateProvider);
      ref.invalidate(noteCreateDialogStateProvider);
      ref.notifyListeners();
      return createdNote;
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
