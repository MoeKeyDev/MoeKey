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

  static String m1(error) => "作成に失敗しました\n\n ${error}";

  static String m2(days) => "${days}日前";

  static String m3(thing) => "「${thing}」を削除してもよろしいですか？";

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

  static String m16(type) => "サポートされていない通知タイプ:${type}";

  static String m17(count) => "${count}件のリアクション";

  static String m18(count) => "${count}件のリノート";

  static String m19(seconds) => "${seconds} 秒前";

  static String m20(msg) => "アップロードに失敗しました\n ${msg}";

  static String m21(count) => "総得票数${count}";

  static String m27(choice) => "「${choice}」に投票しますか？";

  static String m22(count) => "${count}票";

  static String m23(index) => "${index} オプション";

  static String m24(index) => "${index}は必須項目です";

  static String m25(datetime) => "${datetime}以内に締め切り";

  static String m26(years) => "${years}年前";

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
    "clear": MessageLookupByLibrary.simpleMessage("クリア"),
    "clip": MessageLookupByLibrary.simpleMessage("クリップ"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "お気に入り解除しますか？",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage("新しいクリップを作成"),
    "clipFavorite": MessageLookupByLibrary.simpleMessage("お気に入りに追加"),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage("お気に入り"),
    "clipRemove": MessageLookupByLibrary.simpleMessage("クリップ解除"),
    "clipUpdate": MessageLookupByLibrary.simpleMessage("ノートの更新"),
    "clips": MessageLookupByLibrary.simpleMessage("クリップ"),
    "close": MessageLookupByLibrary.simpleMessage("閉じる"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage("内容をコピー"),
    "copyLink": MessageLookupByLibrary.simpleMessage("リンクをコピー"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("RSSをコピー"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "ユーザーホームの URL をコピー",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage("ユーザー名をコピー"),
    "createFolder": MessageLookupByLibrary.simpleMessage("新しいフォルダー"),
    "createNote": MessageLookupByLibrary.simpleMessage("新しいノートを投稿"),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage("ファイルから投稿を作成"),
    "createNoteHint": MessageLookupByLibrary.simpleMessage("何かありましたか？"),
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
    "emoji": MessageLookupByLibrary.simpleMessage("絵文字"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "新しいファイル名を入力してください",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage("新しいタイトルを入力してください"),
    "enterUrl": MessageLookupByLibrary.simpleMessage("URLを入力してください"),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "このフィールドが必要です",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage("このフィールドが必要です"),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("見つける"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("人気"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage("人気のユーザー"),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage("最近登録したユーザー"),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage("ピン留めユーザー"),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage("最近投稿したユーザー"),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("ユーザー"),
    "exportEntityAntenna": MessageLookupByLibrary.simpleMessage("アンテナ"),
    "exportEntityBlocking": MessageLookupByLibrary.simpleMessage("ブロック"),
    "exportEntityClip": MessageLookupByLibrary.simpleMessage("クリップ"),
    "exportEntityCustomEmoji": MessageLookupByLibrary.simpleMessage("カスタム絵文字"),
    "exportEntityFavorite": MessageLookupByLibrary.simpleMessage("お気に入り"),
    "exportEntityFollowing": MessageLookupByLibrary.simpleMessage("フォロー"),
    "exportEntityMuting": MessageLookupByLibrary.simpleMessage("ミュート"),
    "exportEntityNote": MessageLookupByLibrary.simpleMessage("ノート"),
    "exportEntityUserList": MessageLookupByLibrary.simpleMessage("リスト"),
    "favorite": MessageLookupByLibrary.simpleMessage("お気に入り"),
    "filter": MessageLookupByLibrary.simpleMessage("フィルタ"),
    "folderName": MessageLookupByLibrary.simpleMessage("フォルダ名"),
    "follow": MessageLookupByLibrary.simpleMessage("フォロー"),
    "followed": MessageLookupByLibrary.simpleMessage("フォロー済"),
    "followers": MessageLookupByLibrary.simpleMessage("フォロワー"),
    "following": MessageLookupByLibrary.simpleMessage("フォロー中"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("ドライブから"),
    "gotIt": MessageLookupByLibrary.simpleMessage("わかった"),
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
    "loginExpired": MessageLookupByLibrary.simpleMessage(
      "ログイン情報が有効ではありません。再度ログインしてください。",
    ),
    "loginFailed": MessageLookupByLibrary.simpleMessage("ログインに失敗しました"),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "ログイン失敗: アプリケーションの作成に失敗しました",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "ログイン失敗: トークン取得に失敗しました。",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage("ログインに成功しました"),
    "manageAccount": MessageLookupByLibrary.simpleMessage("アカウントを管理"),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage("閲覧注意にする"),
    "mention": MessageLookupByLibrary.simpleMessage("メンション"),
    "minute": MessageLookupByLibrary.simpleMessage("分"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("もっと"),
    "myCLips": MessageLookupByLibrary.simpleMessage("自分のクリップ"),
    "name": MessageLookupByLibrary.simpleMessage("名前"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage("名前は空欄にできません"),
    "next": MessageLookupByLibrary.simpleMessage("次へ"),
    "noLists": MessageLookupByLibrary.simpleMessage("リストがありません"),
    "notFindServer": MessageLookupByLibrary.simpleMessage("サーバーが見つかりませんか？"),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "このウェブサイトのリンクをコピーする",
    ),
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
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage("フォロワー"),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "自分のフォロワーにのみ公開",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("ホーム"),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "ホームタイムラインにのみ公開",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("公開"),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "全てのユーザーに公開",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage("特定"),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "指定したユーザーにのみ公開",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("ノート"),
    "notesCount": MessageLookupByLibrary.simpleMessage("ノート数"),
    "notification": MessageLookupByLibrary.simpleMessage("通知"),
    "notifications": MessageLookupByLibrary.simpleMessage("通知"),
    "notifyAccept": MessageLookupByLibrary.simpleMessage("承認"),
    "notifyAccepted": MessageLookupByLibrary.simpleMessage("フォローリクエストを承認しました"),
    "notifyAchievementEarned": MessageLookupByLibrary.simpleMessage(
      "実績を獲得しました",
    ),
    "notifyActionFailed": MessageLookupByLibrary.simpleMessage(
      "操作に失敗しました。もう一度お試しください",
    ),
    "notifyAll": MessageLookupByLibrary.simpleMessage("すべて"),
    "notifyApp": MessageLookupByLibrary.simpleMessage("アプリ通知"),
    "notifyChatRoomInvitationUnsupported": MessageLookupByLibrary.simpleMessage(
      "チャットルームへの招待は未対応です",
    ),
    "notifyCreateToken": MessageLookupByLibrary.simpleMessage(
      "新しいアクセストークンが作成されました",
    ),
    "notifyCreateTokenDescription": MessageLookupByLibrary.simpleMessage(
      "心当たりがない場合は、Webクライアントですぐにトークンを無効化してください",
    ),
    "notifyExportCompleted": MessageLookupByLibrary.simpleMessage(
      "エクスポートが完了しました",
    ),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("フィルター"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "フォローリクエストが承認されました",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage("フォローされました"),
    "notifyLogin": MessageLookupByLibrary.simpleMessage("ログインを検出しました"),
    "notifyLoginDescription": MessageLookupByLibrary.simpleMessage(
      "あなたのアカウントにログインがありました",
    ),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage("全て既読にする"),
    "notifyMention": MessageLookupByLibrary.simpleMessage("メンション"),
    "notifyMentionedYou": MessageLookupByLibrary.simpleMessage(
      "ノートであなたに言及しました",
    ),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("指名"),
    "notifyNewNote": MessageLookupByLibrary.simpleMessage("新しいノートを投稿しました"),
    "notifyNotSupport": m16,
    "notifyPollEnded": MessageLookupByLibrary.simpleMessage("アンケートが終了しました"),
    "notifyQuoted": MessageLookupByLibrary.simpleMessage("あなたのノートを引用しました"),
    "notifyReacted": MessageLookupByLibrary.simpleMessage("あなたのノートにリアクションしました"),
    "notifyReactionGrouped": m17,
    "notifyReceiveFollowRequest": MessageLookupByLibrary.simpleMessage(
      "フォローをリクエストしました",
    ),
    "notifyReject": MessageLookupByLibrary.simpleMessage("拒否"),
    "notifyRejected": MessageLookupByLibrary.simpleMessage("フォローリクエストを拒否しました"),
    "notifyRenoteGrouped": m18,
    "notifyRenoted": MessageLookupByLibrary.simpleMessage("あなたのノートをリノートしました"),
    "notifyRepliedToYou": MessageLookupByLibrary.simpleMessage(
      "あなたのノートに返信しました",
    ),
    "notifyRoleAssigned": MessageLookupByLibrary.simpleMessage("ロールが付与されました"),
    "notifyScheduledNotePostFailed": MessageLookupByLibrary.simpleMessage(
      "予約ノートの投稿に失敗しました",
    ),
    "notifyScheduledNotePostFailedDescription":
        MessageLookupByLibrary.simpleMessage("予約していたノートを投稿できませんでした"),
    "notifyScheduledNotePosted": MessageLookupByLibrary.simpleMessage(
      "予約ノートを投稿しました",
    ),
    "notifyScheduledNotePostedDescription":
        MessageLookupByLibrary.simpleMessage("予約していたノートが投稿されました"),
    "notifyTest": MessageLookupByLibrary.simpleMessage("テスト通知"),
    "notifyTestDescription": MessageLookupByLibrary.simpleMessage(
      "通知はこのように表示されます",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "openInNewTab": MessageLookupByLibrary.simpleMessage("ブラウザで表示"),
    "overviews": MessageLookupByLibrary.simpleMessage("概要"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "フォローリクエスト承認中",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("プレビュー"),
    "previewNote": MessageLookupByLibrary.simpleMessage("投稿をプレビュー"),
    "processing": MessageLookupByLibrary.simpleMessage("処理中"),
    "public": MessageLookupByLibrary.simpleMessage("公開"),
    "publish": MessageLookupByLibrary.simpleMessage("公開"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage("このノートを引用..."),
    "reNoteText": MessageLookupByLibrary.simpleMessage("引用"),
    "reaction": MessageLookupByLibrary.simpleMessage("返信する"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage("リアクションに同意する"),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("すべて"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage("いいねのみ"),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "リモートからはいいねのみ",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "非センシティブのみ",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage("非センシティブのみ (リモートはいいねのみ)"),
    "recipient": MessageLookupByLibrary.simpleMessage("宛先"),
    "refresh": MessageLookupByLibrary.simpleMessage("更新"),
    "registration": MessageLookupByLibrary.simpleMessage("新規登録"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage("招待のみ"),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("開放"),
    "remote": MessageLookupByLibrary.simpleMessage("オンライン"),
    "rename": MessageLookupByLibrary.simpleMessage("名前を変更"),
    "renameFile": MessageLookupByLibrary.simpleMessage("ファイル名を変更"),
    "renameFolder": MessageLookupByLibrary.simpleMessage("フォルダ名を変更"),
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
    "searchServers": MessageLookupByLibrary.simpleMessage("サーバー名またはドメイン名で検索"),
    "secondsAgo": m19,
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
    "uploadFailed": m20,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage("URLからアップロード"),
    "user": MessageLookupByLibrary.simpleMessage("ユーザー"),
    "userAll": MessageLookupByLibrary.simpleMessage("すべて"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage("自己紹介はありません"),
    "userFile": MessageLookupByLibrary.simpleMessage("添付ファイル"),
    "userHot": MessageLookupByLibrary.simpleMessage("ユーザー"),
    "userNote": MessageLookupByLibrary.simpleMessage("ノート"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage("登録日"),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "ウィジェットリスト（未完了）",
    ),
    "username": MessageLookupByLibrary.simpleMessage("ユーザー名"),
    "usersCount": MessageLookupByLibrary.simpleMessage("ユーザー数"),
    "video": MessageLookupByLibrary.simpleMessage("動画"),
    "view": MessageLookupByLibrary.simpleMessage("表示"),
    "viewMore": MessageLookupByLibrary.simpleMessage("詳細"),
    "vote": MessageLookupByLibrary.simpleMessage("投票"),
    "voteAllCount": m21,
    "voteConfirm": m27,
    "voteCount": m22,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("期限"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage("複数の投票を許可する"),
    "voteExpired": MessageLookupByLibrary.simpleMessage("投票は終了しました。"),
    "voteFailed": MessageLookupByLibrary.simpleMessage("投票に失敗しました。もう一度お試しください"),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("無期限"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "投票数は2つ未満にすることはできません。",
    ),
    "voteOptionHint": m23,
    "voteOptionNullIndex": m24,
    "voteResult": MessageLookupByLibrary.simpleMessage("投票結果が生成されました"),
    "voteShowResult": MessageLookupByLibrary.simpleMessage("結果を見る"),
    "voteVoted": MessageLookupByLibrary.simpleMessage("投票済み"),
    "voteWillExpired": m25,
    "yearsAgo": m26,
  };
}
