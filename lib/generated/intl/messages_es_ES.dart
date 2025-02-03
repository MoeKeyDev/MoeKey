// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es_ES locale. All the
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
  String get localeName => 'es_ES';

  static String m0(selectListLength, maxSelect) =>
      "确定(${selectListLength}/${maxSelect})";

  static String m1(error) => "创建失败\n\n ${error}";

  static String m2(days) => "${days}天前";

  static String m3(thing) => "要删掉「${thing}」吗？";

  static String m4(name) => "要删除「${name}」文件吗？附加此文件的帖子也会被删除。";

  static String m5(name) => "要删除「${name}」文件夹吗？ 如果文件夹中存在内容，请先删除文件夹中的内容。";

  static String m6(day, hour, minute, second) =>
      "${day}天${hour}小时${minute}分钟${second}秒";

  static String m7(hour, minute, second) => "${hour}小时${minute}分钟${second}秒";

  static String m8(minute, second) => "${minute}分钟${second}秒";

  static String m9(second) => "${second}秒";

  static String m10(error) => "发送帖子失败\n\n${error}";

  static String m11(hours) => "${hours}小时前";

  static String m12(server) => "正在登录${server}";

  static String m13(minutes) => "${minutes}分钟前";

  static String m14(months) => "${months}个月前";

  static String m15(language) => "从${language}翻译 \n";

  static String m16(type) => "不支持的通知类型:${type}";

  static String m17(seconds) => "${seconds}秒前";

  static String m18(msg) => "上传失败\n ${msg}";

  static String m19(count) => "总票数 ${count}";

  static String m20(count) => "${count}票";

  static String m21(index) => "选项${index}";

  static String m22(index) => "选项${index}不能为空";

  static String m23(datetime) => "${datetime}后截止";

  static String m24(years) => "${years}年前";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("账号"),
        "add": MessageLookupByLibrary.simpleMessage("添加"),
        "addAccount": MessageLookupByLibrary.simpleMessage("添加账号"),
        "addFile": MessageLookupByLibrary.simpleMessage("添加文件"),
        "addTitle": MessageLookupByLibrary.simpleMessage("添加标题"),
        "all": MessageLookupByLibrary.simpleMessage("全部"),
        "announcementActive": MessageLookupByLibrary.simpleMessage("现在的公告"),
        "announcementExpired": MessageLookupByLibrary.simpleMessage("过去的公告"),
        "announcements": MessageLookupByLibrary.simpleMessage("公告"),
        "back": MessageLookupByLibrary.simpleMessage("返回"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage("取消标记为敏感内容"),
        "clip": MessageLookupByLibrary.simpleMessage("便签"),
        "clipCancelFavoriteText":
            MessageLookupByLibrary.simpleMessage("确定要取消收藏吗？"),
        "clipCreate": MessageLookupByLibrary.simpleMessage("新建便签"),
        "clipFavorite": MessageLookupByLibrary.simpleMessage("添加到收藏"),
        "clipFavoriteList": MessageLookupByLibrary.simpleMessage("收藏"),
        "clipRemove": MessageLookupByLibrary.simpleMessage("移除便签"),
        "clipUpdate":
            MessageLookupByLibrary.simpleMessage("Actualizar notas adhesivas"),
        "clips": MessageLookupByLibrary.simpleMessage("便签"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "confirmSelection": m0,
        "copyContent": MessageLookupByLibrary.simpleMessage("复制内容"),
        "copyLink": MessageLookupByLibrary.simpleMessage("复制链接"),
        "copyRSS": MessageLookupByLibrary.simpleMessage("复制RSS"),
        "copyUserHomeLink": MessageLookupByLibrary.simpleMessage("复制用户主页地址"),
        "copyUsername": MessageLookupByLibrary.simpleMessage("复制用户名"),
        "createFolder": MessageLookupByLibrary.simpleMessage("新建文件夹"),
        "createNote": MessageLookupByLibrary.simpleMessage("发布新帖子"),
        "createNoteFormFile": MessageLookupByLibrary.simpleMessage("从文件创建帖子"),
        "createNoteHint": MessageLookupByLibrary.simpleMessage("发生了什么..."),
        "createdDate": MessageLookupByLibrary.simpleMessage("创建日期"),
        "creationFailedDialog": m1,
        "cw": MessageLookupByLibrary.simpleMessage("隐藏内容"),
        "day": MessageLookupByLibrary.simpleMessage("天"),
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "deleteConfirm": m3,
        "deleteFileConfirmation": m4,
        "deleteFolderConfirmation": m5,
        "description": MessageLookupByLibrary.simpleMessage("描述"),
        "done": MessageLookupByLibrary.simpleMessage("完成"),
        "download": MessageLookupByLibrary.simpleMessage("下载"),
        "drive": MessageLookupByLibrary.simpleMessage("网盘"),
        "durationDay": m6,
        "durationHour": m7,
        "durationMinute": m8,
        "durationSecond": m9,
        "edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "emoji": MessageLookupByLibrary.simpleMessage("表情符号"),
        "enterNewFileName": MessageLookupByLibrary.simpleMessage("请输入新文件名"),
        "enterNewTitle": MessageLookupByLibrary.simpleMessage("请输入新标题"),
        "enterUrl": MessageLookupByLibrary.simpleMessage("请输入URL"),
        "exceptionContentNull": MessageLookupByLibrary.simpleMessage("内容不能为空"),
        "exceptionCwNull": MessageLookupByLibrary.simpleMessage("内容不能为空"),
        "exceptionSendNote": m10,
        "explore": MessageLookupByLibrary.simpleMessage("发现"),
        "exploreHot": MessageLookupByLibrary.simpleMessage("热门"),
        "exploreUserHot": MessageLookupByLibrary.simpleMessage("热门用户"),
        "exploreUserLast": MessageLookupByLibrary.simpleMessage("最近登录的用户"),
        "exploreUserPined": MessageLookupByLibrary.simpleMessage("置顶用户"),
        "exploreUserUpdated": MessageLookupByLibrary.simpleMessage("最近投稿的用户"),
        "exploreUsers": MessageLookupByLibrary.simpleMessage("用户"),
        "favorite": MessageLookupByLibrary.simpleMessage("收藏"),
        "filter": MessageLookupByLibrary.simpleMessage("过滤"),
        "folderName": MessageLookupByLibrary.simpleMessage("文件夹名称"),
        "follow": MessageLookupByLibrary.simpleMessage("关注"),
        "followed": MessageLookupByLibrary.simpleMessage("已关注"),
        "followers": MessageLookupByLibrary.simpleMessage("关注者"),
        "following": MessageLookupByLibrary.simpleMessage("关注中"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("从网盘中"),
        "gotIt": MessageLookupByLibrary.simpleMessage("我明白了"),
        "hashtag": MessageLookupByLibrary.simpleMessage("话题标签"),
        "hostnames": MessageLookupByLibrary.simpleMessage("域名"),
        "hour": MessageLookupByLibrary.simpleMessage("小时"),
        "hoursAgo": m11,
        "image": MessageLookupByLibrary.simpleMessage("图片"),
        "inputServer": MessageLookupByLibrary.simpleMessage("手动输入服务器"),
        "insertDriverFile": MessageLookupByLibrary.simpleMessage("插入附件"),
        "isFollowingYouNow": MessageLookupByLibrary.simpleMessage("正在关注你"),
        "justNow": MessageLookupByLibrary.simpleMessage("刚刚"),
        "keepOriginal": MessageLookupByLibrary.simpleMessage("保留原图"),
        "loadingServers": MessageLookupByLibrary.simpleMessage("服务器正在加载"),
        "local": MessageLookupByLibrary.simpleMessage("本地"),
        "localUpload": MessageLookupByLibrary.simpleMessage("本地上传"),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("登录失败"),
        "loginFailedWithAppCreate":
            MessageLookupByLibrary.simpleMessage("登录失败: 应用创建失败"),
        "loginFailedWithToken":
            MessageLookupByLibrary.simpleMessage("登录失败: token获取失败"),
        "loginLoading": m12,
        "loginSuccess": MessageLookupByLibrary.simpleMessage("登录成功"),
        "manageAccount": MessageLookupByLibrary.simpleMessage("管理账号"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage("标记为敏感内容"),
        "mention": MessageLookupByLibrary.simpleMessage("提及"),
        "minute": MessageLookupByLibrary.simpleMessage("分钟"),
        "minutesAgo": m13,
        "monthsAgo": m14,
        "more": MessageLookupByLibrary.simpleMessage("更多"),
        "myCLips": MessageLookupByLibrary.simpleMessage("我的便签"),
        "name": MessageLookupByLibrary.simpleMessage("名称"),
        "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage("名称不能为空"),
        "next": MessageLookupByLibrary.simpleMessage("下一步"),
        "noLists": MessageLookupByLibrary.simpleMessage("列表为空"),
        "notFindServer": MessageLookupByLibrary.simpleMessage("没有找到你所在的服务器？"),
        "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage("复制本站链接"),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("收起"),
        "noteCwShow": MessageLookupByLibrary.simpleMessage("显示内容"),
        "noteFormLanguageTranslation": m15,
        "noteLocalOnly": MessageLookupByLibrary.simpleMessage("不参与联合"),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage("转到所在服务器显示"),
        "notePined": MessageLookupByLibrary.simpleMessage("已置顶的帖子"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("引用"),
        "noteReNote": MessageLookupByLibrary.simpleMessage("转发"),
        "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("转发了"),
        "noteTranslate": MessageLookupByLibrary.simpleMessage("翻译帖子"),
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
        "notification": MessageLookupByLibrary.simpleMessage("通知"),
        "notifications": MessageLookupByLibrary.simpleMessage("通知"),
        "notifyAll": MessageLookupByLibrary.simpleMessage("全部"),
        "notifyFilter": MessageLookupByLibrary.simpleMessage("筛选"),
        "notifyFollowedAccepted":
            MessageLookupByLibrary.simpleMessage("你的关注请求被通过了"),
        "notifyFollowedYou": MessageLookupByLibrary.simpleMessage("你有新的关注者"),
        "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage("全部标记为已读"),
        "notifyMention": MessageLookupByLibrary.simpleMessage("提到我的"),
        "notifyMessage": MessageLookupByLibrary.simpleMessage("私信"),
        "notifyNotSupport": m16,
        "ok": MessageLookupByLibrary.simpleMessage("确定"),
        "openInNewTab": MessageLookupByLibrary.simpleMessage("转到浏览器显示"),
        "overviews": MessageLookupByLibrary.simpleMessage("概览"),
        "pendingFollowRequest": MessageLookupByLibrary.simpleMessage("关注请求批准中"),
        "preview": MessageLookupByLibrary.simpleMessage("预览"),
        "previewNote": MessageLookupByLibrary.simpleMessage("预览帖子"),
        "processing": MessageLookupByLibrary.simpleMessage("处理中"),
        "public": MessageLookupByLibrary.simpleMessage("公开"),
        "publish": MessageLookupByLibrary.simpleMessage("发布"),
        "reNoteHint": MessageLookupByLibrary.simpleMessage("引用这个帖子..."),
        "reNoteText": MessageLookupByLibrary.simpleMessage("引用帖子"),
        "reaction": MessageLookupByLibrary.simpleMessage("回应"),
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
        "remote": MessageLookupByLibrary.simpleMessage("远程"),
        "rename": MessageLookupByLibrary.simpleMessage("重命名"),
        "renameFile": MessageLookupByLibrary.simpleMessage("重命名文件"),
        "renameFolder": MessageLookupByLibrary.simpleMessage("重命名文件夹"),
        "replyNoteHint": MessageLookupByLibrary.simpleMessage("回复这个帖子..."),
        "replyNoteText": MessageLookupByLibrary.simpleMessage("回复帖子"),
        "saveFailed": MessageLookupByLibrary.simpleMessage("保存失败"),
        "saveImage": MessageLookupByLibrary.simpleMessage("保存图片"),
        "saveSuccess": MessageLookupByLibrary.simpleMessage("保存成功"),
        "search": MessageLookupByLibrary.simpleMessage("搜索"),
        "searchAll": MessageLookupByLibrary.simpleMessage("全部"),
        "searchHost": MessageLookupByLibrary.simpleMessage("指定域名"),
        "searchLocal": MessageLookupByLibrary.simpleMessage("本站"),
        "searchRemote": MessageLookupByLibrary.simpleMessage("远程"),
        "searchServers": MessageLookupByLibrary.simpleMessage("搜索服务器名称或者域名"),
        "secondsAgo": m17,
        "selectHashtag": MessageLookupByLibrary.simpleMessage("选择标签"),
        "selectServer": MessageLookupByLibrary.simpleMessage("请选择服务器"),
        "selectUser": MessageLookupByLibrary.simpleMessage("选择用户"),
        "sensitiveClickShow": MessageLookupByLibrary.simpleMessage("点击显示"),
        "sensitiveContent": MessageLookupByLibrary.simpleMessage("敏感内容"),
        "serverAddr": MessageLookupByLibrary.simpleMessage("服务器地址"),
        "serverList": MessageLookupByLibrary.simpleMessage("服务器列表"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "share": MessageLookupByLibrary.simpleMessage("分享"),
        "showConversation": MessageLookupByLibrary.simpleMessage("查看对话"),
        "somebodyNote": MessageLookupByLibrary.simpleMessage(" 的帖子"),
        "timeline": MessageLookupByLibrary.simpleMessage("时间线"),
        "timelineGlobal": MessageLookupByLibrary.simpleMessage("全局"),
        "timelineHome": MessageLookupByLibrary.simpleMessage("首页"),
        "timelineHybrid": MessageLookupByLibrary.simpleMessage("社交"),
        "timelineLocal": MessageLookupByLibrary.simpleMessage("本地"),
        "translate": MessageLookupByLibrary.simpleMessage("翻译"),
        "uncategorized": MessageLookupByLibrary.simpleMessage("未分类"),
        "unfollow": MessageLookupByLibrary.simpleMessage("取消关注"),
        "updatedDate": MessageLookupByLibrary.simpleMessage("更新日期"),
        "uploadFailed": m18,
        "uploadFromUrl": MessageLookupByLibrary.simpleMessage("从网址上传"),
        "user": MessageLookupByLibrary.simpleMessage("用户"),
        "userAll": MessageLookupByLibrary.simpleMessage("全部"),
        "userDescriptionIsNull":
            MessageLookupByLibrary.simpleMessage("此用户尚无自我介绍"),
        "userFile": MessageLookupByLibrary.simpleMessage("附件"),
        "userHot": MessageLookupByLibrary.simpleMessage("用户"),
        "userNote": MessageLookupByLibrary.simpleMessage("帖子"),
        "userRegisterBy": MessageLookupByLibrary.simpleMessage("注册于"),
        "userWidgetUnSupport":
            MessageLookupByLibrary.simpleMessage("小部件列表(未完成)"),
        "username": MessageLookupByLibrary.simpleMessage("用户名"),
        "usersCount": MessageLookupByLibrary.simpleMessage("用户数"),
        "video": MessageLookupByLibrary.simpleMessage("视频"),
        "view": MessageLookupByLibrary.simpleMessage("查看"),
        "viewMore": MessageLookupByLibrary.simpleMessage("查看更多"),
        "vote": MessageLookupByLibrary.simpleMessage("投票"),
        "voteAllCount": m19,
        "voteCount": m20,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("截止日期"),
        "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage("允许多个投票"),
        "voteExpired": MessageLookupByLibrary.simpleMessage("投票已结束"),
        "voteNoDueDate": MessageLookupByLibrary.simpleMessage("永久"),
        "voteOptionAtLeastTwo":
            MessageLookupByLibrary.simpleMessage("投票数量不能少于两个"),
        "voteOptionHint": m21,
        "voteOptionNullIndex": m22,
        "voteResult": MessageLookupByLibrary.simpleMessage("投票结果已经生成"),
        "voteWillExpired": m23,
        "yearsAgo": m24
      };
}
