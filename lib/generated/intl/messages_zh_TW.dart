// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh_TW locale. All the
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
  String get localeName => 'zh_TW';

  static String m0(selectListLength, maxSelect) =>
      "確定(${selectListLength}/${maxSelect})";

  static String m1(error) => "創建失敗\n\n ${error}";

  static String m2(days) => "${days}天前";

  static String m3(thing) => "要刪除「${thing}」嗎？";

  static String m4(name) => "要刪除「${name}」文件嗎？附加此文件的帖子也會被刪除。";

  static String m5(name) => "要刪除「${name}」文件夾嗎？ 如果文件夾中存在內容，請先刪除文件夾中的內容。";

  static String m6(day, hour, minute, second) =>
      "${day}天${hour}小時${minute}分鐘${second}秒";

  static String m7(hour, minute, second) => "${hour}小時${minute}分鐘${second}秒";

  static String m8(minute, second) => "${minute}分鐘${second}秒";

  static String m9(second) => "${second}秒";

  static String m10(error) => "發送帖子失敗\n\n${error}";

  static String m11(hours) => "${hours}小時前";

  static String m12(server) => "正在登錄${server}";

  static String m13(minutes) => "${minutes}分鐘前";

  static String m14(months) => "${months}個月前";

  static String m15(language) => "從${language}翻譯 \n";

  static String m16(type) => "不支持的通知類型:${type}";

  static String m17(seconds) => "${seconds}秒前";

  static String m18(msg) => "上傳失敗\n ${msg}";

  static String m19(count) => "總票數 ${count}";

  static String m20(count) => "${count}票";

  static String m21(index) => "選項${index}";

  static String m22(index) => "選項${index}不能為空";

  static String m23(datetime) => "${datetime}後截止";

  static String m24(years) => "${years}年前";

  final messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("帳號"),
        "add": MessageLookupByLibrary.simpleMessage("添加"),
        "addAccount": MessageLookupByLibrary.simpleMessage("添加帳號"),
        "addFile": MessageLookupByLibrary.simpleMessage("添加文件"),
        "addTitle": MessageLookupByLibrary.simpleMessage("添加標題"),
        "all": MessageLookupByLibrary.simpleMessage("全部"),
        "announcementActive": MessageLookupByLibrary.simpleMessage("現在的公告"),
        "announcementExpired": MessageLookupByLibrary.simpleMessage("過去的公告"),
        "announcements": MessageLookupByLibrary.simpleMessage("公告"),
        "back": MessageLookupByLibrary.simpleMessage("返回"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage("取消標記為敏感內容"),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "clip": MessageLookupByLibrary.simpleMessage("便簽"),
        "clipCancelFavoriteText":
            MessageLookupByLibrary.simpleMessage("確定要取消收藏嗎？"),
        "clipCreate": MessageLookupByLibrary.simpleMessage("新建便簽"),
        "clipFavorite": MessageLookupByLibrary.simpleMessage("添加到收藏"),
        "clipFavoriteList": MessageLookupByLibrary.simpleMessage("收藏"),
        "clipRemove": MessageLookupByLibrary.simpleMessage("移除便簽"),
        "clipUpdate": MessageLookupByLibrary.simpleMessage("更新便签"),
        "clips": MessageLookupByLibrary.simpleMessage("便簽"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "confirmSelection": m0,
        "copyContent": MessageLookupByLibrary.simpleMessage("複製內容"),
        "copyLink": MessageLookupByLibrary.simpleMessage("複製鏈接"),
        "copyRSS": MessageLookupByLibrary.simpleMessage("複製RSS"),
        "copyUserHomeLink": MessageLookupByLibrary.simpleMessage("複製用戶主頁地址"),
        "copyUsername": MessageLookupByLibrary.simpleMessage("複製用戶名"),
        "createFolder": MessageLookupByLibrary.simpleMessage("新建文件夾"),
        "createNote": MessageLookupByLibrary.simpleMessage("發布新帖子"),
        "createNoteFormFile": MessageLookupByLibrary.simpleMessage("從文件創建帖子"),
        "createNoteHint": MessageLookupByLibrary.simpleMessage("發生了什麼..."),
        "createdDate": MessageLookupByLibrary.simpleMessage("創建日期"),
        "creationFailedDialog": m1,
        "cw": MessageLookupByLibrary.simpleMessage("隱藏內容"),
        "day": MessageLookupByLibrary.simpleMessage("天"),
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("刪除"),
        "deleteConfirm": m3,
        "deleteFileConfirmation": m4,
        "deleteFolderConfirmation": m5,
        "description": MessageLookupByLibrary.simpleMessage("描述"),
        "done": MessageLookupByLibrary.simpleMessage("完成"),
        "download": MessageLookupByLibrary.simpleMessage("下載"),
        "drive": MessageLookupByLibrary.simpleMessage("網盤"),
        "durationDay": m6,
        "durationHour": m7,
        "durationMinute": m8,
        "durationSecond": m9,
        "edit": MessageLookupByLibrary.simpleMessage("編輯"),
        "emoji": MessageLookupByLibrary.simpleMessage("表情符號"),
        "enterNewFileName": MessageLookupByLibrary.simpleMessage("請輸入新文件名"),
        "enterNewTitle": MessageLookupByLibrary.simpleMessage("請輸入新標題"),
        "enterUrl": MessageLookupByLibrary.simpleMessage("請輸入URL"),
        "exceptionContentNull": MessageLookupByLibrary.simpleMessage("內容不能為空"),
        "exceptionCwNull": MessageLookupByLibrary.simpleMessage("內容不能為空"),
        "exceptionSendNote": m10,
        "explore": MessageLookupByLibrary.simpleMessage("發現"),
        "exploreHot": MessageLookupByLibrary.simpleMessage("熱門"),
        "exploreUserHot": MessageLookupByLibrary.simpleMessage("熱門用戶"),
        "exploreUserLast": MessageLookupByLibrary.simpleMessage("最近登錄的用戶"),
        "exploreUserPined": MessageLookupByLibrary.simpleMessage("置頂用戶"),
        "exploreUserUpdated": MessageLookupByLibrary.simpleMessage("最近投稿的用戶"),
        "exploreUsers": MessageLookupByLibrary.simpleMessage("用戶"),
        "favorite": MessageLookupByLibrary.simpleMessage("收藏"),
        "filter": MessageLookupByLibrary.simpleMessage("過濾"),
        "folderName": MessageLookupByLibrary.simpleMessage("文件夾名稱"),
        "follow": MessageLookupByLibrary.simpleMessage("關注"),
        "followed": MessageLookupByLibrary.simpleMessage("已關注"),
        "followers": MessageLookupByLibrary.simpleMessage("關注者"),
        "following": MessageLookupByLibrary.simpleMessage("關注中"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("從網盤中"),
        "gotIt": MessageLookupByLibrary.simpleMessage("我明白了"),
        "hashtag": MessageLookupByLibrary.simpleMessage("話題標籤"),
        "hostnames": MessageLookupByLibrary.simpleMessage("域名"),
        "hour": MessageLookupByLibrary.simpleMessage("小時"),
        "hoursAgo": m11,
        "image": MessageLookupByLibrary.simpleMessage("圖片"),
        "inputServer": MessageLookupByLibrary.simpleMessage("手動輸入伺服器"),
        "insertDriverFile": MessageLookupByLibrary.simpleMessage("插入附件"),
        "isFollowingYouNow": MessageLookupByLibrary.simpleMessage("正在關注你"),
        "justNow": MessageLookupByLibrary.simpleMessage("剛剛"),
        "keepOriginal": MessageLookupByLibrary.simpleMessage("保留原圖"),
        "loadingServers": MessageLookupByLibrary.simpleMessage("伺服器正在加載"),
        "local": MessageLookupByLibrary.simpleMessage("本地"),
        "localUpload": MessageLookupByLibrary.simpleMessage("本地上傳"),
        "login": MessageLookupByLibrary.simpleMessage("登錄"),
        "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("登錄失敗"),
        "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
          "登錄失敗: 應用創建失敗",
        ),
        "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
          "登錄失敗: token獲取失敗",
        ),
        "loginLoading": m12,
        "loginSuccess": MessageLookupByLibrary.simpleMessage("登錄成功"),
        "manageAccount": MessageLookupByLibrary.simpleMessage("管理帳號"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage("標記為敏感內容"),
        "mention": MessageLookupByLibrary.simpleMessage("提及"),
        "minute": MessageLookupByLibrary.simpleMessage("分鐘"),
        "minutesAgo": m13,
        "monthsAgo": m14,
        "more": MessageLookupByLibrary.simpleMessage("更多"),
        "myCLips": MessageLookupByLibrary.simpleMessage("我的便簽"),
        "name": MessageLookupByLibrary.simpleMessage("名稱"),
        "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage("名稱不能為空"),
        "next": MessageLookupByLibrary.simpleMessage("下一步"),
        "noLists": MessageLookupByLibrary.simpleMessage("列表為空"),
        "notFindServer": MessageLookupByLibrary.simpleMessage("沒有找到你所在的伺服器？"),
        "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage("複製本站鏈接"),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("收起"),
        "noteCwShow": MessageLookupByLibrary.simpleMessage("顯示內容"),
        "noteFormLanguageTranslation": m15,
        "noteLocalOnly": MessageLookupByLibrary.simpleMessage("不參與聯合"),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage("轉到所在伺服器顯示"),
        "notePined": MessageLookupByLibrary.simpleMessage("已置頂的帖子"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("引用"),
        "noteReNote": MessageLookupByLibrary.simpleMessage("轉發"),
        "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("轉發了"),
        "noteTranslate": MessageLookupByLibrary.simpleMessage("翻譯帖子"),
        "noteVisibility": MessageLookupByLibrary.simpleMessage("可見性"),
        "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage("關注者"),
        "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
          "僅發送至關注者",
        ),
        "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("首頁"),
        "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
          "僅發送至首頁的時間線",
        ),
        "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("公開"),
        "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
          "您的帖子將出現在全局時間線上",
        ),
        "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage("私信"),
        "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
          "僅發送至指定用戶",
        ),
        "notes": MessageLookupByLibrary.simpleMessage("帖子"),
        "notesCount": MessageLookupByLibrary.simpleMessage("帖子數"),
        "notification": MessageLookupByLibrary.simpleMessage("通知"),
        "notifications": MessageLookupByLibrary.simpleMessage("通知"),
        "notifyAll": MessageLookupByLibrary.simpleMessage("全部"),
        "notifyFilter": MessageLookupByLibrary.simpleMessage("篩選"),
        "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
          "你的關注請求被通過了",
        ),
        "notifyFollowedYou": MessageLookupByLibrary.simpleMessage("你有新的關注者"),
        "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage("全部標記為已讀"),
        "notifyMention": MessageLookupByLibrary.simpleMessage("提到我的"),
        "notifyMessage": MessageLookupByLibrary.simpleMessage("私信"),
        "notifyNotSupport": m16,
        "ok": MessageLookupByLibrary.simpleMessage("確定"),
        "openInNewTab": MessageLookupByLibrary.simpleMessage("轉到瀏覽器顯示"),
        "overviews": MessageLookupByLibrary.simpleMessage("概覽"),
        "pendingFollowRequest": MessageLookupByLibrary.simpleMessage("關注請求批准中"),
        "preview": MessageLookupByLibrary.simpleMessage("預覽"),
        "previewNote": MessageLookupByLibrary.simpleMessage("預覽帖子"),
        "processing": MessageLookupByLibrary.simpleMessage("處理中"),
        "public": MessageLookupByLibrary.simpleMessage("公開"),
        "publish": MessageLookupByLibrary.simpleMessage("發布"),
        "reNoteHint": MessageLookupByLibrary.simpleMessage("引用這個帖子..."),
        "reNoteText": MessageLookupByLibrary.simpleMessage("引用帖子"),
        "reaction": MessageLookupByLibrary.simpleMessage("回應"),
        "reactionAccepting": MessageLookupByLibrary.simpleMessage("接受表情回應"),
        "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("全部"),
        "reactionAcceptingLikeOnly":
            MessageLookupByLibrary.simpleMessage("僅點贊"),
        "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
          "遠程僅點贊",
        ),
        "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
          "僅限非敏感內容",
        ),
        "reactionAcceptingNoneSensitiveOrLocal":
            MessageLookupByLibrary.simpleMessage("僅限非敏感內容（遠程僅點贊）"),
        "recipient": MessageLookupByLibrary.simpleMessage("收件人"),
        "refresh": MessageLookupByLibrary.simpleMessage("刷新"),
        "registration": MessageLookupByLibrary.simpleMessage("註冊模式"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("邀請制"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("開放"),
        "remote": MessageLookupByLibrary.simpleMessage("遠程"),
        "rename": MessageLookupByLibrary.simpleMessage("重命名"),
        "renameFile": MessageLookupByLibrary.simpleMessage("重命名文件"),
        "renameFolder": MessageLookupByLibrary.simpleMessage("重命名文件夾"),
        "replyNoteHint": MessageLookupByLibrary.simpleMessage("回覆這個帖子..."),
        "replyNoteText": MessageLookupByLibrary.simpleMessage("回覆帖子"),
        "saveFailed": MessageLookupByLibrary.simpleMessage("保存失敗"),
        "saveImage": MessageLookupByLibrary.simpleMessage("保存圖片"),
        "saveSuccess": MessageLookupByLibrary.simpleMessage("保存成功"),
        "search": MessageLookupByLibrary.simpleMessage("搜尋"),
        "searchAll": MessageLookupByLibrary.simpleMessage("全部"),
        "searchHost": MessageLookupByLibrary.simpleMessage("指定域名"),
        "searchLocal": MessageLookupByLibrary.simpleMessage("本站"),
        "searchRemote": MessageLookupByLibrary.simpleMessage("遠程"),
        "searchServers": MessageLookupByLibrary.simpleMessage("搜索伺服器名稱或者域名"),
        "secondsAgo": m17,
        "selectHashtag": MessageLookupByLibrary.simpleMessage("選擇標籤"),
        "selectServer": MessageLookupByLibrary.simpleMessage("請選擇伺服器"),
        "selectUser": MessageLookupByLibrary.simpleMessage("選擇用戶"),
        "sensitiveClickShow": MessageLookupByLibrary.simpleMessage("點擊顯示"),
        "sensitiveContent": MessageLookupByLibrary.simpleMessage("敏感內容"),
        "serverAddr": MessageLookupByLibrary.simpleMessage("伺服器地址"),
        "serverList": MessageLookupByLibrary.simpleMessage("伺服器列表"),
        "settings": MessageLookupByLibrary.simpleMessage("設置"),
        "share": MessageLookupByLibrary.simpleMessage("分享"),
        "showConversation": MessageLookupByLibrary.simpleMessage("查看對話"),
        "somebodyNote": MessageLookupByLibrary.simpleMessage(" 的帖子"),
        "timeline": MessageLookupByLibrary.simpleMessage("時間線"),
        "timelineGlobal": MessageLookupByLibrary.simpleMessage("全局"),
        "timelineHome": MessageLookupByLibrary.simpleMessage("首頁"),
        "timelineHybrid": MessageLookupByLibrary.simpleMessage("社交"),
        "timelineLocal": MessageLookupByLibrary.simpleMessage("本地"),
        "translate": MessageLookupByLibrary.simpleMessage("翻譯"),
        "uncategorized": MessageLookupByLibrary.simpleMessage("未分類"),
        "unfollow": MessageLookupByLibrary.simpleMessage("取消關注"),
        "updatedDate": MessageLookupByLibrary.simpleMessage("更新日期"),
        "uploadFailed": m18,
        "uploadFromUrl": MessageLookupByLibrary.simpleMessage("從網址上傳"),
        "user": MessageLookupByLibrary.simpleMessage("用戶"),
        "userAll": MessageLookupByLibrary.simpleMessage("全部"),
        "userDescriptionIsNull":
            MessageLookupByLibrary.simpleMessage("此用戶尚無自我介紹"),
        "userFile": MessageLookupByLibrary.simpleMessage("附件"),
        "userHot": MessageLookupByLibrary.simpleMessage("用戶"),
        "userNote": MessageLookupByLibrary.simpleMessage("帖子"),
        "userRegisterBy": MessageLookupByLibrary.simpleMessage("註冊於"),
        "userWidgetUnSupport":
            MessageLookupByLibrary.simpleMessage("小部件列表(未完成)"),
        "username": MessageLookupByLibrary.simpleMessage("用戶名"),
        "usersCount": MessageLookupByLibrary.simpleMessage("用戶數"),
        "video": MessageLookupByLibrary.simpleMessage("視頻"),
        "view": MessageLookupByLibrary.simpleMessage("檢視"),
        "viewMore": MessageLookupByLibrary.simpleMessage("查看更多"),
        "vote": MessageLookupByLibrary.simpleMessage("投票"),
        "voteAllCount": m19,
        "voteCount": m20,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("截止日期"),
        "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage("允許多個投票"),
        "voteExpired": MessageLookupByLibrary.simpleMessage("投票已結束"),
        "voteNoDueDate": MessageLookupByLibrary.simpleMessage("永久"),
        "voteOptionAtLeastTwo":
            MessageLookupByLibrary.simpleMessage("投票數量不能少於兩個"),
        "voteOptionHint": m21,
        "voteOptionNullIndex": m22,
        "voteResult": MessageLookupByLibrary.simpleMessage("投票結果已經生成"),
        "voteWillExpired": m23,
        "yearsAgo": m24,
      };
}
