// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_CN locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh_CN';

  static String m0(selectListLength, maxSelect) =>
      "确定(${selectListLength}/${maxSelect})";

  static String m1(error) => "创建失败\n\n ${error}";

  static String m2(days) => "${days}天前";

  static String m3(name) => "要删除「${name}」文件吗？附加此文件的帖子也会被删除。";

  static String m4(name) => "要删除「${name}」文件夹吗？ 如果文件夹中存在内容，请先删除文件夹中的内容。";

  static String m5(hours) => "${hours}小时前";

  static String m6(server) => "正在登录${server}";

  static String m7(minutes) => "${minutes}分钟前";

  static String m8(months) => "${months}个月前";

  static String m9(seconds) => "${seconds}秒前";

  static String m10(msg) => "上传失败\n ${msg}";

  static String m11(years) => "${years}年前";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addFile": MessageLookupByLibrary.simpleMessage("添加文件"),
        "addTitle": MessageLookupByLibrary.simpleMessage("添加标题"),
        "announcements": MessageLookupByLibrary.simpleMessage("公告"),
        "back": MessageLookupByLibrary.simpleMessage("返回"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage("取消标记为敏感内容"),
        "clips": MessageLookupByLibrary.simpleMessage("便签"),
        "confirmSelection": m0,
        "copyLink": MessageLookupByLibrary.simpleMessage("复制链接"),
        "createFolder": MessageLookupByLibrary.simpleMessage("新建文件夹"),
        "createNoteFormFile": MessageLookupByLibrary.simpleMessage("从文件创建帖子"),
        "creationFailedDialog": m1,
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "deleteFileConfirmation": m3,
        "deleteFolderConfirmation": m4,
        "description": MessageLookupByLibrary.simpleMessage("描述"),
        "done": MessageLookupByLibrary.simpleMessage("完成"),
        "download": MessageLookupByLibrary.simpleMessage("下载"),
        "drive": MessageLookupByLibrary.simpleMessage("网盘"),
        "enterNewFileName": MessageLookupByLibrary.simpleMessage("请输入新文件名"),
        "enterNewTitle": MessageLookupByLibrary.simpleMessage("请输入新标题"),
        "enterUrl": MessageLookupByLibrary.simpleMessage("请输入URL"),
        "explore": MessageLookupByLibrary.simpleMessage("发现"),
        "filter": MessageLookupByLibrary.simpleMessage("过滤"),
        "folderName": MessageLookupByLibrary.simpleMessage("文件夹名称"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("从网盘中"),
        "gotIt": MessageLookupByLibrary.simpleMessage("我明白了"),
        "hoursAgo": m5,
        "inputServer": MessageLookupByLibrary.simpleMessage("手动输入服务器"),
        "justNow": MessageLookupByLibrary.simpleMessage("刚刚"),
        "keepOriginal": MessageLookupByLibrary.simpleMessage("保留原图"),
        "loadingServers": MessageLookupByLibrary.simpleMessage("服务器正在加载"),
        "localUpload": MessageLookupByLibrary.simpleMessage("本地上传"),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "loginLoading": m6,
        "loginSuccess": MessageLookupByLibrary.simpleMessage("登录成功"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage("标记为敏感内容"),
        "minutesAgo": m7,
        "monthsAgo": m8,
        "more": MessageLookupByLibrary.simpleMessage("更多"),
        "name": MessageLookupByLibrary.simpleMessage("名称"),
        "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage("名称不能为空"),
        "next": MessageLookupByLibrary.simpleMessage("下一步"),
        "noLists": MessageLookupByLibrary.simpleMessage("列表为空"),
        "notFindServer": MessageLookupByLibrary.simpleMessage("没有找到你所在的服务器？"),
        "notesCount": MessageLookupByLibrary.simpleMessage("帖子数"),
        "notifications": MessageLookupByLibrary.simpleMessage("通知"),
        "ok": MessageLookupByLibrary.simpleMessage("确定"),
        "preview": MessageLookupByLibrary.simpleMessage("预览"),
        "public": MessageLookupByLibrary.simpleMessage("公开"),
        "refresh": MessageLookupByLibrary.simpleMessage("刷新"),
        "registration": MessageLookupByLibrary.simpleMessage("注册模式"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("邀请制"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("开放"),
        "rename": MessageLookupByLibrary.simpleMessage("重命名"),
        "renameFile": MessageLookupByLibrary.simpleMessage("重命名文件"),
        "renameFolder": MessageLookupByLibrary.simpleMessage("重命名文件夹"),
        "search": MessageLookupByLibrary.simpleMessage("搜索"),
        "searchServers": MessageLookupByLibrary.simpleMessage("搜索服务器名称或者域名"),
        "secondsAgo": m9,
        "selectHashtag": MessageLookupByLibrary.simpleMessage("选择标签"),
        "selectServer": MessageLookupByLibrary.simpleMessage("请选择服务器"),
        "serverAddr": MessageLookupByLibrary.simpleMessage("服务器地址"),
        "serverList": MessageLookupByLibrary.simpleMessage("服务器列表"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "timeline": MessageLookupByLibrary.simpleMessage("时间线"),
        "uploadFailed": m10,
        "uploadFromUrl": MessageLookupByLibrary.simpleMessage("从网址上传"),
        "usersCount": MessageLookupByLibrary.simpleMessage("用户数"),
        "viewMore": MessageLookupByLibrary.simpleMessage("查看更多"),
        "yearsAgo": m11
      };
}
