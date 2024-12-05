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

  static String m5(day, hour, minute, second) =>
      "${day}天${hour}小时${minute}分钟${second}秒";

  static String m6(hour, minute, second) => "${hour}小时${minute}分钟${second}秒";

  static String m7(minute, second) => "${minute}分钟${second}秒";

  static String m8(second) => "${second}秒";

  static String m9(error) => "发送帖子失败\n\n${error}";

  static String m10(hours) => "${hours}小时前";

  static String m11(server) => "正在登录${server}";

  static String m12(minutes) => "${minutes}分钟前";

  static String m13(months) => "${months}个月前";

  static String m14(language) => "从${language}翻译 \n";

  static String m15(seconds) => "${seconds}秒前";

  static String m16(msg) => "上传失败\n ${msg}";

  static String m17(count) => "总票数 ${count}";

  static String m18(count) => "${count}票";

  static String m19(index) => "选项${index}";

  static String m20(index) => "选项${index}不能为空";

  static String m21(datetime) => "${datetime}后截止";

  static String m22(years) => "${years}年前";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("添加"),
        "addFile": MessageLookupByLibrary.simpleMessage("添加文件"),
        "addTitle": MessageLookupByLibrary.simpleMessage("添加标题"),
        "announcements": MessageLookupByLibrary.simpleMessage("公告"),
        "back": MessageLookupByLibrary.simpleMessage("返回"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage("取消标记为敏感内容"),
        "clip": MessageLookupByLibrary.simpleMessage("便签"),
        "clipCreate": MessageLookupByLibrary.simpleMessage("新建便签"),
        "clips": MessageLookupByLibrary.simpleMessage("便签"),
        "confirmSelection": m0,
        "copyContent": MessageLookupByLibrary.simpleMessage("复制内容"),
        "copyLink": MessageLookupByLibrary.simpleMessage("复制链接"),
        "createFolder": MessageLookupByLibrary.simpleMessage("新建文件夹"),
        "createNote": MessageLookupByLibrary.simpleMessage("发布新帖子"),
        "createNoteFormFile": MessageLookupByLibrary.simpleMessage("从文件创建帖子"),
        "createNoteHint": MessageLookupByLibrary.simpleMessage("发生了什么..."),
        "creationFailedDialog": m1,
        "cw": MessageLookupByLibrary.simpleMessage("隐藏内容"),
        "day": MessageLookupByLibrary.simpleMessage("天"),
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "deleteFileConfirmation": m3,
        "deleteFolderConfirmation": m4,
        "description": MessageLookupByLibrary.simpleMessage("描述"),
        "done": MessageLookupByLibrary.simpleMessage("完成"),
        "download": MessageLookupByLibrary.simpleMessage("下载"),
        "drive": MessageLookupByLibrary.simpleMessage("网盘"),
        "durationDay": m5,
        "durationHour": m6,
        "durationMinute": m7,
        "durationSecond": m8,
        "emoji": MessageLookupByLibrary.simpleMessage("表情符号"),
        "enterNewFileName": MessageLookupByLibrary.simpleMessage("请输入新文件名"),
        "enterNewTitle": MessageLookupByLibrary.simpleMessage("请输入新标题"),
        "enterUrl": MessageLookupByLibrary.simpleMessage("请输入URL"),
        "exceptionContentNull": MessageLookupByLibrary.simpleMessage("内容不能为空"),
        "exceptionCwNull": MessageLookupByLibrary.simpleMessage("内容不能为空"),
        "exceptionSendNote": m9,
        "explore": MessageLookupByLibrary.simpleMessage("发现"),
        "filter": MessageLookupByLibrary.simpleMessage("过滤"),
        "folderName": MessageLookupByLibrary.simpleMessage("文件夹名称"),
        "follow": MessageLookupByLibrary.simpleMessage("关注"),
        "followed": MessageLookupByLibrary.simpleMessage("已关注"),
        "followers": MessageLookupByLibrary.simpleMessage("关注者"),
        "following": MessageLookupByLibrary.simpleMessage("关注中"),
        "followingYouNow": MessageLookupByLibrary.simpleMessage("正在关注你"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("从网盘中"),
        "gotIt": MessageLookupByLibrary.simpleMessage("我明白了"),
        "hashtag": MessageLookupByLibrary.simpleMessage("话题标签"),
        "hostnames": MessageLookupByLibrary.simpleMessage("域名"),
        "hour": MessageLookupByLibrary.simpleMessage("小时"),
        "hoursAgo": m10,
        "image": MessageLookupByLibrary.simpleMessage("图片"),
        "inputServer": MessageLookupByLibrary.simpleMessage("手动输入服务器"),
        "insertDriverFile": MessageLookupByLibrary.simpleMessage("插入附件"),
        "justNow": MessageLookupByLibrary.simpleMessage("刚刚"),
        "keepOriginal": MessageLookupByLibrary.simpleMessage("保留原图"),
        "loadingServers": MessageLookupByLibrary.simpleMessage("服务器正在加载"),
        "localUpload": MessageLookupByLibrary.simpleMessage("本地上传"),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("登录失败"),
        "loginFailedWithAppCreate":
            MessageLookupByLibrary.simpleMessage("登录失败: 应用创建失败"),
        "loginFailedWithToken":
            MessageLookupByLibrary.simpleMessage("登录失败: token获取失败"),
        "loginLoading": m11,
        "loginSuccess": MessageLookupByLibrary.simpleMessage("登录成功"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage("标记为敏感内容"),
        "mention": MessageLookupByLibrary.simpleMessage("提及"),
        "minute": MessageLookupByLibrary.simpleMessage("分钟"),
        "minutesAgo": m12,
        "monthsAgo": m13,
        "more": MessageLookupByLibrary.simpleMessage("更多"),
        "name": MessageLookupByLibrary.simpleMessage("名称"),
        "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage("名称不能为空"),
        "next": MessageLookupByLibrary.simpleMessage("下一步"),
        "noLists": MessageLookupByLibrary.simpleMessage("列表为空"),
        "notFindServer": MessageLookupByLibrary.simpleMessage("没有找到你所在的服务器？"),
        "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage("复制本站链接"),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("收起"),
        "noteCwShow": MessageLookupByLibrary.simpleMessage("显示内容"),
        "noteFormLanguageTranslation": m14,
        "noteLocalOnly": MessageLookupByLibrary.simpleMessage("不参与联合"),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage("转到所在服务器显示"),
        "notePined": MessageLookupByLibrary.simpleMessage("已置顶的帖子"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("引用"),
        "noteReNote": MessageLookupByLibrary.simpleMessage("转发"),
        "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("转发了"),
        "noteVisibility": MessageLookupByLibrary.simpleMessage("可见性"),
        "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage("关注者"),
        "noteVisibilityFollowersText":
            MessageLookupByLibrary.simpleMessage("仅发送至关注者"),
        "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("首页"),
        "noteVisibilityHomeText":
            MessageLookupByLibrary.simpleMessage("仅发送至首页的时间线"),
        "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("公开"),
        "noteVisibilityPublicText":
            MessageLookupByLibrary.simpleMessage("您的帖子将出现在全局时间线上"),
        "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage("私信"),
        "noteVisibilitySpecifiedText":
            MessageLookupByLibrary.simpleMessage("仅发送至指定用户"),
        "notes": MessageLookupByLibrary.simpleMessage("帖子"),
        "notesCount": MessageLookupByLibrary.simpleMessage("帖子数"),
        "notifications": MessageLookupByLibrary.simpleMessage("通知"),
        "ok": MessageLookupByLibrary.simpleMessage("确定"),
        "preview": MessageLookupByLibrary.simpleMessage("预览"),
        "previewNote": MessageLookupByLibrary.simpleMessage("预览帖子"),
        "public": MessageLookupByLibrary.simpleMessage("公开"),
        "publish": MessageLookupByLibrary.simpleMessage("发布"),
        "reNoteHint": MessageLookupByLibrary.simpleMessage("引用这个帖子..."),
        "reNoteText": MessageLookupByLibrary.simpleMessage("引用帖子"),
        "reactionAccepting": MessageLookupByLibrary.simpleMessage("接受表情回应"),
        "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("全部"),
        "reactionAcceptingLikeOnly":
            MessageLookupByLibrary.simpleMessage("仅点赞"),
        "reactionAcceptingLikeOnlyRemote":
            MessageLookupByLibrary.simpleMessage("远程仅点赞"),
        "reactionAcceptingNoneSensitive":
            MessageLookupByLibrary.simpleMessage("仅限非敏感内容"),
        "reactionAcceptingNoneSensitiveOrLocal":
            MessageLookupByLibrary.simpleMessage("仅限非敏感内容（远程仅点赞）"),
        "recipient": MessageLookupByLibrary.simpleMessage("收件人"),
        "refresh": MessageLookupByLibrary.simpleMessage("刷新"),
        "registration": MessageLookupByLibrary.simpleMessage("注册模式"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("邀请制"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("开放"),
        "rename": MessageLookupByLibrary.simpleMessage("重命名"),
        "renameFile": MessageLookupByLibrary.simpleMessage("重命名文件"),
        "renameFolder": MessageLookupByLibrary.simpleMessage("重命名文件夹"),
        "replyNoteHint": MessageLookupByLibrary.simpleMessage("回复这个帖子..."),
        "replyNoteText": MessageLookupByLibrary.simpleMessage("回复帖子"),
        "search": MessageLookupByLibrary.simpleMessage("搜索"),
        "searchServers": MessageLookupByLibrary.simpleMessage("搜索服务器名称或者域名"),
        "secondsAgo": m15,
        "selectHashtag": MessageLookupByLibrary.simpleMessage("选择标签"),
        "selectServer": MessageLookupByLibrary.simpleMessage("请选择服务器"),
        "selectUser": MessageLookupByLibrary.simpleMessage("选择用户"),
        "sensitiveClickShow": MessageLookupByLibrary.simpleMessage("点击显示"),
        "sensitiveContent": MessageLookupByLibrary.simpleMessage("敏感内容"),
        "serverAddr": MessageLookupByLibrary.simpleMessage("服务器地址"),
        "serverList": MessageLookupByLibrary.simpleMessage("服务器列表"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "share": MessageLookupByLibrary.simpleMessage("分享"),
        "timeline": MessageLookupByLibrary.simpleMessage("时间线"),
        "translate": MessageLookupByLibrary.simpleMessage("翻译"),
        "uncategorized": MessageLookupByLibrary.simpleMessage("未分类"),
        "unfollow": MessageLookupByLibrary.simpleMessage("取消关注"),
        "uploadFailed": m16,
        "uploadFromUrl": MessageLookupByLibrary.simpleMessage("从网址上传"),
        "user": MessageLookupByLibrary.simpleMessage("用户"),
        "userDescriptionIsNull":
            MessageLookupByLibrary.simpleMessage("此用户尚无自我介绍"),
        "username": MessageLookupByLibrary.simpleMessage("用户名"),
        "usersCount": MessageLookupByLibrary.simpleMessage("用户数"),
        "video": MessageLookupByLibrary.simpleMessage("视频"),
        "view": MessageLookupByLibrary.simpleMessage("查看"),
        "viewMore": MessageLookupByLibrary.simpleMessage("查看更多"),
        "vote": MessageLookupByLibrary.simpleMessage("投票"),
        "voteAllCount": m17,
        "voteCount": m18,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("截止日期"),
        "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage("允许多个投票"),
        "voteExpired": MessageLookupByLibrary.simpleMessage("投票已结束"),
        "voteNoDueDate": MessageLookupByLibrary.simpleMessage("永久"),
        "voteOptionAtLeastTwo":
            MessageLookupByLibrary.simpleMessage("投票数量不能少于两个"),
        "voteOptionHint": m19,
        "voteOptionNullIndex": m20,
        "voteWillExpired": m21,
        "yearsAgo": m22
      };
}
