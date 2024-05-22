import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:moekey/widgets/driver/driver_select_dialog/driver_select_dialog_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../apis/models/note.dart';
import '../../main.dart';
import '../../status/dio.dart';
import '../../status/server.dart';
import '../mk_info_dialog.dart';

part 'note_create_dialog_state.g.dart';

class NoteCreateDialogStateModel {
  NoteVisibility visibility = NoteVisibility.public; // 可见性
  LinkedHashMap visibleUserIds = LinkedHashMap(); // 当 可见性为specified 时的可见用户列表
  String? text; // 文本
  String cw = ''; //敏感内容
  bool isCw = false;
  bool localOnly = false; // 禁用联合
  NoteReactionAcceptance? reactionAcceptance; // 表情回应限制
  List fileIds = [];
  String? replyId; // 回复
  String? renoteId; // 转发/引用
  String? channelId; // 频道id
  NotePollModel? poll;
  bool isNotePoll = false;
  bool isShowEmoji = false;
  bool preview = false;
  num emojiListHeight = 0;

  Map<String, dynamic> toMap() {
    return {
      'visibility': visibility.value,
      if (visibility == NoteVisibility.specified)
        'visibleUserIds': visibleUserIds.keys.toList(),
      'text': text ?? "",
      if (isCw) 'cw': cw,
      'localOnly': localOnly,
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
        'expiredAfter':
            Duration(hours: hours, days: days, minutes: minutes).inMilliseconds,
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
  channel
}

@Riverpod(keepAlive: true)
class NoteCreateDialogState extends _$NoteCreateDialogState {
  @override
  NoteCreateDialogStateModel build(String? noteId, NoteType type) {
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

  setVisibility(NoteVisibility visibility) {
    state.visibility = visibility;
    ref.notifyListeners();
  }

  setLocalOnly(bool localOnly) {
    state.localOnly = localOnly;
    ref.notifyListeners();
  }

  setReactionAcceptance(NoteReactionAcceptance? reactionAcceptance) {
    state.reactionAcceptance = reactionAcceptance;
    ref.notifyListeners();
  }

  setText(String text) {
    state.text = text;
    ref.notifyListeners();
  }

  createPoll() {
    state.poll ??= NotePollModel();
    state.isNotePoll = true;

    ref.notifyListeners();
  }

  removePoll() {
    state.isNotePoll = false;
    ref.notifyListeners();
  }

  setPollChoices(index, string) {
    if (state.poll != null) {
      state.poll?.choices[index] = (state.poll!.choices[index].$1, string);
      ref.notifyListeners();
    }
  }

  addPollChoices() {
    if (state.poll != null) {
      state.poll?.choices.add((UniqueKey(), ""));
      ref.notifyListeners();
    }
  }

  removePollChoices(index) {
    if (state.poll != null) {
      state.poll?.choices.removeAt(index);
      ref.notifyListeners();
    }
  }

  setPollMultiple(bool multiple) {
    if (state.poll != null) {
      state.poll?.multiple = multiple;
      ref.notifyListeners();
    }
  }

  setPollNever(bool never) {
    if (state.poll != null) {
      state.poll?.never = never;
      ref.notifyListeners();
    }
  }

  setPollTime({int? days, int? hours, int? minutes}) {
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

  setIsCw(bool isCw) {
    state.isCw = isCw;
    ref.notifyListeners();
  }

  setCw(String cw) {
    state.cw = cw;
    ref.notifyListeners();
  }

  setIsShowEmoji(bool isShowEmoji) {
    state.isShowEmoji = isShowEmoji;
    ref.notifyListeners();
  }

  setPreview(bool preview) {
    state.preview = preview;
    ref.notifyListeners();
  }

  setEmojiListHeight(num emojiListHeight) {
    state.emojiListHeight = emojiListHeight;
    ref.notifyListeners();
  }

  addVisibleUser(String id, data) {
    state.visibleUserIds[id] = data;
    ref.notifyListeners();
  }

  removeVisibleUser(String id) {
    if (state.visibleUserIds[id] != null) {
      state.visibleUserIds.remove(id);
      ref.notifyListeners();
    }
  }

  String getDriverSelectId() {
    return "$type::$noteId";
  }

  DriverSelectDialogStateProvider getDriverSelectDialogStateProvider() {
    return driverSelectDialogStateProvider(getDriverSelectId());
  }

  bool sendLoading = false;

  Future<dynamic> send() async {
    if (sendLoading) return;
    sendLoading = true;
    try {
      var http = await ref.read(httpProvider.future);
      var user = ref.read(currentLoginUserProvider);
      var imageSelect = ref.read(getDriverSelectDialogStateProvider());
      state.fileIds = imageSelect.keys.toList();

      // 参数验证
      if (state.text != null && state.text!.isEmpty) {
        throw Exception("内容不能为空");
      }
      if (state.isCw && state.cw.isEmpty) {
        throw Exception("隐藏内容不能为空");
      }

      if (state.isNotePoll) {
        // 投票
        if (state.poll!.choices.length < 2) {
          throw Exception("投票数量不能少于2个");
        }
        for (var (index, item) in state.poll!.choices.indexed) {
          if (item.$2.isEmpty) {
            throw Exception("第${index + 1}个投票选项为空");
          }
        }
      }

      // 用户token
      var data = state.toMap();
      data['i'] = user?.token ?? "";
      var res = await http.post("/notes/create", data: data);
      state = NoteCreateDialogStateModel();
      ref.invalidate(driverSelectDialogStateProvider);
      ref.invalidate(noteCreateDialogStateProvider);
      ref.notifyListeners();
      return res.data;
    } on DioException catch (e) {
      logger.d(e.response);
      MkInfoDialog.show(
          info: "发布失败\n\n ${e.response?.data.toString() ?? e.toString()}",
          isError: true);
    } catch (e) {
      MkInfoDialog.show(info: "$e", isError: true);
    }
    sendLoading = false;
    return null;
  }
}
