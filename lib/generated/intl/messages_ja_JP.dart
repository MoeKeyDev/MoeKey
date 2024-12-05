// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja_JP locale. All the
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
  String get localeName => 'ja_JP';

  static String m0(selectListLength, maxSelect) =>
      "はい(${selectListLength}/${maxSelect})";

  static String m1(error) => "\n\n ${error} の作成に失敗しました";

  static String m2(days) => "${days}日前";

  static String m3(thing) => "削除したい「${thing}」を削除してもよろしいですか？";

  static String m4(name) =>
      "ファイル「${name}」を削除しますか？このファイルを使用した全てのコンテンツからも削除されます。";

  static String m5(name) =>
      "フォルダ「${name}」フォルダを削除してもよろしいですか？フォルダ内にコンテンツがある場合は、フォルダ内のコンテンツを削除してください。";

  static String m6(day, hour, minute, second) =>
      "${day}日${hour}時${minute}分${second}秒";

  static String m7(hour, minute, second) => "${hour}時${minute}分${second}秒";

  static String m8(minute, second) => "${minute}分${second}秒";

  static String m9(second) => "${second}秒";

  static String m10(error) => "ポストを送信できませんでした\n\n${error}";

  static String m11(hours) => "${hours} 時間前";

  static String m12(server) => "${server} にサインイン中";

  static String m13(minutes) => "${minutes} 分前";

  static String m14(months) => "${months}ヶ月前";

  static String m15(language) => "${language}からの翻訳";

  static String m16(type) => "サポートされていない通知タイプ：${type}。";

  static String m17(seconds) => "${seconds} 秒前";

  static String m18(msg) => "\n ${msg} のアップロードに失敗しました";

  static String m19(count) => "総得票数${count}";

  static String m20(count) => "${count}票";

  static String m21(index) => "${index} オプション";

  static String m22(index) => "${index}は必須項目です";

  static String m23(datetime) => "${datetime}以内に締め切り";

  static String m24(years) => "${years}年前";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("アカウント"),
        "add": MessageLookupByLibrary.simpleMessage("追加"),
        "addAccount": MessageLookupByLibrary.simpleMessage("アカウントを追加"),
        "addFile": MessageLookupByLibrary.simpleMessage("ファイルを追加"),
        "addTitle": MessageLookupByLibrary.simpleMessage("タイトルを追加"),
        "all": MessageLookupByLibrary.simpleMessage("すべて"),
        "announcementActive": MessageLookupByLibrary.simpleMessage("現在のお知らせ"),
        "announcementExpired": MessageLookupByLibrary.simpleMessage("過去のお知らせ"),
        "announcements": MessageLookupByLibrary.simpleMessage("お知らせ"),
        "back": MessageLookupByLibrary.simpleMessage("戻る"),
        "cancel": MessageLookupByLibrary.simpleMessage("取り消し"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage("閲覧注意を解除する"),
        "clip": MessageLookupByLibrary.simpleMessage("クリップ"),
        "clipCancelFavoriteText":
            MessageLookupByLibrary.simpleMessage("お気に入り解除しますか？"),
        "clipCreate": MessageLookupByLibrary.simpleMessage("新しいクリップを作成"),
        "clipFavorite": MessageLookupByLibrary.simpleMessage("お気に入りに追加"),
        "clipFavoriteList": MessageLookupByLibrary.simpleMessage("お気に入り"),
        "clipRemove": MessageLookupByLibrary.simpleMessage("クリップ解除"),
        "clips": MessageLookupByLibrary.simpleMessage("クリップ"),
        "confirmSelection": m0,
        "copyContent": MessageLookupByLibrary.simpleMessage("内容をコピー"),
        "copyLink": MessageLookupByLibrary.simpleMessage("リンクをコピー"),
        "copyRSS": MessageLookupByLibrary.simpleMessage("RSSをコピー"),
        "copyUserHomeLink":
            MessageLookupByLibrary.simpleMessage("ユーザーホームの URL をコピー"),
        "copyUsername": MessageLookupByLibrary.simpleMessage("ユーザー名をコピー"),
        "createFolder": MessageLookupByLibrary.simpleMessage("新しいフォルダー"),
        "createNote": MessageLookupByLibrary.simpleMessage("新しい投稿を投稿"),
        "createNoteFormFile":
            MessageLookupByLibrary.simpleMessage("ファイルから投稿を作成"),
        "createNoteHint": MessageLookupByLibrary.simpleMessage("何が起こってる..."),
        "createdDate": MessageLookupByLibrary.simpleMessage("作成日"),
        "creationFailedDialog": m1,
        "cw": MessageLookupByLibrary.simpleMessage("内容を隠す"),
        "day": MessageLookupByLibrary.simpleMessage("日"),
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("削除"),
        "deleteConfirm": m3,
        "deleteFileConfirmation": m4,
        "deleteFolderConfirmation": m5,
        "description": MessageLookupByLibrary.simpleMessage("説明"),
        "done": MessageLookupByLibrary.simpleMessage("OK"),
        "download": MessageLookupByLibrary.simpleMessage("ダウンロード"),
        "drive": MessageLookupByLibrary.simpleMessage("ドライブ"),
        "durationDay": m6,
        "durationHour": m7,
        "durationMinute": m8,
        "durationSecond": m9,
        "edit": MessageLookupByLibrary.simpleMessage("編集"),
        "emoji": MessageLookupByLibrary.simpleMessage("エモーティコン"),
        "enterNewFileName":
            MessageLookupByLibrary.simpleMessage("新しいファイル名を入力してください"),
        "enterNewTitle":
            MessageLookupByLibrary.simpleMessage("新しいタイトルを入力してください"),
        "enterUrl": MessageLookupByLibrary.simpleMessage("URLを入力してくださ"),
        "exceptionContentNull":
            MessageLookupByLibrary.simpleMessage("このフィールドが必要です"),
        "exceptionCwNull": MessageLookupByLibrary.simpleMessage("このフィールドが必要です"),
        "exceptionSendNote": m10,
        "explore": MessageLookupByLibrary.simpleMessage("見つける"),
        "exploreHot": MessageLookupByLibrary.simpleMessage("人気"),
        "exploreUserHot": MessageLookupByLibrary.simpleMessage("人気のユーザー"),
        "exploreUserLast": MessageLookupByLibrary.simpleMessage("最近登録したユーザー"),
        "exploreUserPined": MessageLookupByLibrary.simpleMessage("ピン留めユーザー"),
        "exploreUserUpdated":
            MessageLookupByLibrary.simpleMessage("最近投稿したユーザー"),
        "exploreUsers": MessageLookupByLibrary.simpleMessage("ユーザー"),
        "favorite": MessageLookupByLibrary.simpleMessage("お気に入り"),
        "filter": MessageLookupByLibrary.simpleMessage("フィルタ"),
        "folderName": MessageLookupByLibrary.simpleMessage("フォルダ名"),
        "follow": MessageLookupByLibrary.simpleMessage("フォロー"),
        "followed": MessageLookupByLibrary.simpleMessage("フォロー済"),
        "followers": MessageLookupByLibrary.simpleMessage("フォロワー"),
        "following": MessageLookupByLibrary.simpleMessage("フォロー中"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("ドライブから"),
        "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
        "hashtag": MessageLookupByLibrary.simpleMessage("ハッシュタグ"),
        "hostnames": MessageLookupByLibrary.simpleMessage("ホスト名"),
        "hour": MessageLookupByLibrary.simpleMessage("時"),
        "hoursAgo": m11,
        "image": MessageLookupByLibrary.simpleMessage("写真"),
        "inputServer": MessageLookupByLibrary.simpleMessage("サーバーを手動で入力します"),
        "insertDriverFile": MessageLookupByLibrary.simpleMessage("ファイルを添付"),
        "isFollowingYouNow": MessageLookupByLibrary.simpleMessage("フォローされています"),
        "justNow": MessageLookupByLibrary.simpleMessage("たった今"),
        "keepOriginal": MessageLookupByLibrary.simpleMessage("オリジナル画像を保持"),
        "loadingServers": MessageLookupByLibrary.simpleMessage("サーバーの読込み中"),
        "local": MessageLookupByLibrary.simpleMessage("ローカル"),
        "localUpload": MessageLookupByLibrary.simpleMessage("アップロード"),
        "login": MessageLookupByLibrary.simpleMessage("ログイン"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("ログインに失敗しました。"),
        "loginFailedWithAppCreate":
            MessageLookupByLibrary.simpleMessage("ログイン失敗: アプリケーションの作成に失敗しました"),
        "loginFailedWithToken":
            MessageLookupByLibrary.simpleMessage("ログイン失敗: トークン取得失敗"),
        "loginLoading": m12,
        "loginSuccess": MessageLookupByLibrary.simpleMessage("ログイン成功"),
        "manageAccount": MessageLookupByLibrary.simpleMessage("アカウントを管理"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage("閲覧注意にする"),
        "mention": MessageLookupByLibrary.simpleMessage("メンション"),
        "minute": MessageLookupByLibrary.simpleMessage("分"),
        "minutesAgo": m13,
        "monthsAgo": m14,
        "more": MessageLookupByLibrary.simpleMessage("もっと"),
        "myCLips": MessageLookupByLibrary.simpleMessage("自分のクリップ"),
        "name": MessageLookupByLibrary.simpleMessage("名前"),
        "nameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("名前は空欄にできません"),
        "next": MessageLookupByLibrary.simpleMessage("次へ"),
        "noLists":
            MessageLookupByLibrary.simpleMessage("You don\'t have any lists"),
        "notFindServer": MessageLookupByLibrary.simpleMessage("サーバーが見つかりませんか？"),
        "noteCopyLocalLink":
            MessageLookupByLibrary.simpleMessage("このウェブサイトのリンクをコピーする"),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("折りたたむ"),
        "noteCwShow": MessageLookupByLibrary.simpleMessage("もっと見る"),
        "noteFormLanguageTranslation": m15,
        "noteLocalOnly": MessageLookupByLibrary.simpleMessage("連合なし"),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage("リモートで表示"),
        "notePined": MessageLookupByLibrary.simpleMessage("ピン留めされたノート"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("引用"),
        "noteReNote": MessageLookupByLibrary.simpleMessage("転送"),
        "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("転送済"),
        "noteTranslate": MessageLookupByLibrary.simpleMessage("ノートを翻訳する"),
        "noteVisibility": MessageLookupByLibrary.simpleMessage("公開/非公開"),
        "noteVisibilityFollowers":
            MessageLookupByLibrary.simpleMessage("フォロワー"),
        "noteVisibilityFollowersText":
            MessageLookupByLibrary.simpleMessage("自分のフォロワーにのみ公開"),
        "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("ホーム"),
        "noteVisibilityHomeText":
            MessageLookupByLibrary.simpleMessage("ホームタイムラインにのみ公開"),
        "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("公開"),
        "noteVisibilityPublicText":
            MessageLookupByLibrary.simpleMessage("全てのユーザーに公開"),
        "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage("特定"),
        "noteVisibilitySpecifiedText":
            MessageLookupByLibrary.simpleMessage("指定したユーザーにのみ公開"),
        "notes": MessageLookupByLibrary.simpleMessage("ノート"),
        "notesCount": MessageLookupByLibrary.simpleMessage("投稿数"),
        "notification": MessageLookupByLibrary.simpleMessage("お知らせ"),
        "notifications": MessageLookupByLibrary.simpleMessage("お知らせ"),
        "notifyAll": MessageLookupByLibrary.simpleMessage("すべて"),
        "notifyFilter": MessageLookupByLibrary.simpleMessage("フィルター"),
        "notifyFollowedAccepted":
            MessageLookupByLibrary.simpleMessage("フォローリクエストが承認されました"),
        "notifyFollowedYou": MessageLookupByLibrary.simpleMessage("フォローされました"),
        "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage("全て既読にする"),
        "notifyMention": MessageLookupByLibrary.simpleMessage("私に言及する"),
        "notifyMessage": MessageLookupByLibrary.simpleMessage("特定"),
        "notifyNotSupport": m16,
        "ok": MessageLookupByLibrary.simpleMessage("はい"),
        "openInNewTab": MessageLookupByLibrary.simpleMessage("ブラウザで表示"),
        "overviews": MessageLookupByLibrary.simpleMessage("概要"),
        "pendingFollowRequest":
            MessageLookupByLibrary.simpleMessage("フォローリクエスト承認中"),
        "preview": MessageLookupByLibrary.simpleMessage("プレビュー"),
        "previewNote": MessageLookupByLibrary.simpleMessage("投稿をプレビュー"),
        "processing": MessageLookupByLibrary.simpleMessage("処理中"),
        "public": MessageLookupByLibrary.simpleMessage("公開"),
        "publish": MessageLookupByLibrary.simpleMessage("公開"),
        "reNoteHint": MessageLookupByLibrary.simpleMessage("このノートを引用..."),
        "reNoteText": MessageLookupByLibrary.simpleMessage("引用"),
        "reaction": MessageLookupByLibrary.simpleMessage("返信する"),
        "reactionAccepting":
            MessageLookupByLibrary.simpleMessage("リアクションに同意する"),
        "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("すべて"),
        "reactionAcceptingLikeOnly":
            MessageLookupByLibrary.simpleMessage("いいねのみ"),
        "reactionAcceptingLikeOnlyRemote":
            MessageLookupByLibrary.simpleMessage("リモートからはいいねのみ"),
        "reactionAcceptingNoneSensitive":
            MessageLookupByLibrary.simpleMessage("非センシティブのみ"),
        "reactionAcceptingNoneSensitiveOrLocal":
            MessageLookupByLibrary.simpleMessage("非センシティブのみ (リモートはいいねのみ)"),
        "recipient": MessageLookupByLibrary.simpleMessage("受信者"),
        "refresh": MessageLookupByLibrary.simpleMessage("更新"),
        "registration": MessageLookupByLibrary.simpleMessage("新規登録受付方式"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("招待のみ"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("開く"),
        "remote": MessageLookupByLibrary.simpleMessage("オンライン"),
        "rename": MessageLookupByLibrary.simpleMessage("名前を変更"),
        "renameFile": MessageLookupByLibrary.simpleMessage("ファイル名を変更"),
        "renameFolder": MessageLookupByLibrary.simpleMessage("フォルダ名の変更"),
        "replyNoteHint": MessageLookupByLibrary.simpleMessage("このノートに返信..."),
        "replyNoteText": MessageLookupByLibrary.simpleMessage("返信"),
        "saveFailed": MessageLookupByLibrary.simpleMessage("保存に失敗しました"),
        "saveImage": MessageLookupByLibrary.simpleMessage("画像を保存"),
        "saveSuccess": MessageLookupByLibrary.simpleMessage("保存完了"),
        "search": MessageLookupByLibrary.simpleMessage("検索"),
        "searchAll": MessageLookupByLibrary.simpleMessage("すべて"),
        "searchHost": MessageLookupByLibrary.simpleMessage("ドメイン指定"),
        "searchLocal": MessageLookupByLibrary.simpleMessage("ローカルタイムライン"),
        "searchRemote": MessageLookupByLibrary.simpleMessage("リモート"),
        "searchServers":
            MessageLookupByLibrary.simpleMessage("サーバー名またはドメイン名で検索"),
        "secondsAgo": m17,
        "selectHashtag": MessageLookupByLibrary.simpleMessage("タグを選択"),
        "selectServer": MessageLookupByLibrary.simpleMessage("サーバーを選択してください"),
        "selectUser": MessageLookupByLibrary.simpleMessage("ユーザーを選択"),
        "sensitiveClickShow": MessageLookupByLibrary.simpleMessage("クリックして表示"),
        "sensitiveContent": MessageLookupByLibrary.simpleMessage("閲覧注意"),
        "serverAddr": MessageLookupByLibrary.simpleMessage("サーバーアドレス"),
        "serverList": MessageLookupByLibrary.simpleMessage("サーバーリスト"),
        "settings": MessageLookupByLibrary.simpleMessage("設定"),
        "share": MessageLookupByLibrary.simpleMessage("シェア"),
        "showConversation": MessageLookupByLibrary.simpleMessage("会話を表示"),
        "somebodyNote": MessageLookupByLibrary.simpleMessage(" の投稿"),
        "timeline": MessageLookupByLibrary.simpleMessage("タイムライン"),
        "timelineGlobal": MessageLookupByLibrary.simpleMessage("グローバル"),
        "timelineHome": MessageLookupByLibrary.simpleMessage("ホーム"),
        "timelineHybrid": MessageLookupByLibrary.simpleMessage("ハイブリッド"),
        "timelineLocal": MessageLookupByLibrary.simpleMessage("ローカル"),
        "translate": MessageLookupByLibrary.simpleMessage("翻訳"),
        "uncategorized": MessageLookupByLibrary.simpleMessage("未分類"),
        "unfollow": MessageLookupByLibrary.simpleMessage("フォロー解除"),
        "updatedDate": MessageLookupByLibrary.simpleMessage("更新日"),
        "uploadFailed": m18,
        "uploadFromUrl": MessageLookupByLibrary.simpleMessage("URLアップロード"),
        "user": MessageLookupByLibrary.simpleMessage("ユーザー"),
        "userAll": MessageLookupByLibrary.simpleMessage("すべて"),
        "userDescriptionIsNull":
            MessageLookupByLibrary.simpleMessage("自己紹介はありません"),
        "userFile": MessageLookupByLibrary.simpleMessage("添付ファイル"),
        "userHot": MessageLookupByLibrary.simpleMessage("ユーザー"),
        "userNote": MessageLookupByLibrary.simpleMessage("ノート"),
        "userRegisterBy": MessageLookupByLibrary.simpleMessage("登録日"),
        "userWidgetUnSupport":
            MessageLookupByLibrary.simpleMessage("ウィジェットリスト（未完了）"),
        "username": MessageLookupByLibrary.simpleMessage("ユーザー名"),
        "usersCount": MessageLookupByLibrary.simpleMessage("ユーザ数"),
        "video": MessageLookupByLibrary.simpleMessage("動画"),
        "view": MessageLookupByLibrary.simpleMessage("表示"),
        "viewMore": MessageLookupByLibrary.simpleMessage("詳細"),
        "vote": MessageLookupByLibrary.simpleMessage("投票"),
        "voteAllCount": m19,
        "voteCount": m20,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("期限"),
        "voteEnableMultiChoice":
            MessageLookupByLibrary.simpleMessage("複数の投票を許可する"),
        "voteExpired": MessageLookupByLibrary.simpleMessage("投票は終了しました。"),
        "voteNoDueDate": MessageLookupByLibrary.simpleMessage("無期限"),
        "voteOptionAtLeastTwo":
            MessageLookupByLibrary.simpleMessage("投票数は2つ未満にすることはできません。"),
        "voteOptionHint": m21,
        "voteOptionNullIndex": m22,
        "voteResult": MessageLookupByLibrary.simpleMessage("投票結果が生成されました"),
        "voteWillExpired": m23,
        "yearsAgo": m24
      };
}
