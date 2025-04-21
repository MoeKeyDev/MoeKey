// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko_KR locale. All the
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
  String get localeName => 'ko_KR';

  static String m0(selectListLength, maxSelect) =>
      "확인(${selectListLength}/${maxSelect})";

  static String m1(error) => "생성 실패\n\n ${error}";

  static String m2(days) => "${days}일 전";

  static String m3(thing) => "\"${thing}\"을 삭제하시겠습니까?";

  static String m4(name) =>
      "파일 \"${name}\" 을 삭제하시겠습니까? 이 파일이 첨부된 노트도 함께 삭제됩니다.";

  static String m5(name) =>
      "폴더 \"${name}\"을 삭제하시겠습니까? 폴더에 내용이 있다면, 먼저 폴더의 내용을 삭제하십시오.";

  static String m6(day, hour, minute, second) =>
      "${day}일 ${hour}시간 ${minute}분 ${second}초";

  static String m7(hour, minute, second) => "${hour}시간 ${minute}분 ${second}초";

  static String m8(minute, second) => "${minute}분 ${second}초";

  static String m9(second) => "${second}초";

  static String m10(error) => "노트 전송 실패\n\n${error}";

  static String m11(hours) => "${hours}시간 전";

  static String m12(server) => "${server}에 로그인 중";

  static String m13(minutes) => "${minutes}분 전";

  static String m14(months) => "${months}개월 전";

  static String m15(language) => "${language}에서 번역 \n";

  static String m16(type) => "지원하지 않는 알림 유형: ${type}";

  static String m17(seconds) => "${seconds}초 전";

  static String m18(msg) => "업로드 실패\n ${msg}";

  static String m19(count) => "총 투표수 ${count}";

  static String m20(count) => "${count}표";

  static String m21(index) => "${index} 옵션";

  static String m22(index) => "${index} 옵션은 비워둘 수 없습니다";

  static String m23(datetime) => "${datetime} 후 종료";

  static String m24(years) => "${years}년 전";

  final messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("계정"),
        "add": MessageLookupByLibrary.simpleMessage("추가"),
        "addAccount": MessageLookupByLibrary.simpleMessage("계정 추가"),
        "addFile": MessageLookupByLibrary.simpleMessage("파일 추가"),
        "addTitle": MessageLookupByLibrary.simpleMessage("캡션 추가"),
        "all": MessageLookupByLibrary.simpleMessage("전체"),
        "announcementActive": MessageLookupByLibrary.simpleMessage("현재 공지사항"),
        "announcementExpired": MessageLookupByLibrary.simpleMessage("과거 공지사항"),
        "announcements": MessageLookupByLibrary.simpleMessage("공지사항"),
        "back": MessageLookupByLibrary.simpleMessage("뒤로"),
        "cancel": MessageLookupByLibrary.simpleMessage("취소"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage("열람주의 해제"),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "clip": MessageLookupByLibrary.simpleMessage("클립"),
        "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
          "즐겨찾기를 해제하시겠습니까?",
        ),
        "clipCreate": MessageLookupByLibrary.simpleMessage("새 클립 만들기"),
        "clipFavorite": MessageLookupByLibrary.simpleMessage("즐겨찾기에 추가"),
        "clipFavoriteList": MessageLookupByLibrary.simpleMessage("즐겨찾기"),
        "clipRemove": MessageLookupByLibrary.simpleMessage("클립 해제"),
        "clipUpdate": MessageLookupByLibrary.simpleMessage("스티커 메모 업데이트"),
        "clips": MessageLookupByLibrary.simpleMessage("클립"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "confirmSelection": m0,
        "copyContent": MessageLookupByLibrary.simpleMessage("내용 복사"),
        "copyLink": MessageLookupByLibrary.simpleMessage("링크 복사"),
        "copyRSS": MessageLookupByLibrary.simpleMessage("RSS 복사"),
        "copyUserHomeLink": MessageLookupByLibrary.simpleMessage("사용자 홈 링크 복사"),
        "copyUsername": MessageLookupByLibrary.simpleMessage("유저 이름 복사"),
        "createFolder": MessageLookupByLibrary.simpleMessage("새 폴더 만들기"),
        "createNote": MessageLookupByLibrary.simpleMessage("새 노트를 게시"),
        "createNoteFormFile":
            MessageLookupByLibrary.simpleMessage("이 파일로 노트를 작성"),
        "createNoteHint":
            MessageLookupByLibrary.simpleMessage("무슨 일이 일어나고 있나요?"),
        "createdDate": MessageLookupByLibrary.simpleMessage("생성된 날짜"),
        "creationFailedDialog": m1,
        "cw": MessageLookupByLibrary.simpleMessage("콘텐츠 숨기기"),
        "day": MessageLookupByLibrary.simpleMessage("일"),
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("삭제"),
        "deleteConfirm": m3,
        "deleteFileConfirmation": m4,
        "deleteFolderConfirmation": m5,
        "description": MessageLookupByLibrary.simpleMessage("설명"),
        "done": MessageLookupByLibrary.simpleMessage("완료"),
        "download": MessageLookupByLibrary.simpleMessage("다운로드"),
        "drive": MessageLookupByLibrary.simpleMessage("드라이브"),
        "durationDay": m6,
        "durationHour": m7,
        "durationMinute": m8,
        "durationSecond": m9,
        "edit": MessageLookupByLibrary.simpleMessage("수정"),
        "emoji": MessageLookupByLibrary.simpleMessage("이모지"),
        "enterNewFileName":
            MessageLookupByLibrary.simpleMessage("바꿀 파일명을 입력해 주세요"),
        "enterNewTitle": MessageLookupByLibrary.simpleMessage("새 캡션을 입력해 주세요"),
        "enterUrl": MessageLookupByLibrary.simpleMessage("URL을 입력하세요"),
        "exceptionContentNull":
            MessageLookupByLibrary.simpleMessage("내용을 입력해 주세요"),
        "exceptionCwNull": MessageLookupByLibrary.simpleMessage("내용을 입력해 주세요"),
        "exceptionSendNote": m10,
        "explore": MessageLookupByLibrary.simpleMessage("둘러보기"),
        "exploreHot": MessageLookupByLibrary.simpleMessage("유행"),
        "exploreUserHot": MessageLookupByLibrary.simpleMessage("인기 유저"),
        "exploreUserLast": MessageLookupByLibrary.simpleMessage("최근에 가입한 유저"),
        "exploreUserPined": MessageLookupByLibrary.simpleMessage("고정된 유저"),
        "exploreUserUpdated": MessageLookupByLibrary.simpleMessage("최근 게시한 유저"),
        "exploreUsers": MessageLookupByLibrary.simpleMessage("유저"),
        "favorite": MessageLookupByLibrary.simpleMessage("즐겨찾기"),
        "filter": MessageLookupByLibrary.simpleMessage("필터"),
        "folderName": MessageLookupByLibrary.simpleMessage("폴더 이름"),
        "follow": MessageLookupByLibrary.simpleMessage("팔로우"),
        "followed": MessageLookupByLibrary.simpleMessage("팔로우함"),
        "followers": MessageLookupByLibrary.simpleMessage("팔로워"),
        "following": MessageLookupByLibrary.simpleMessage("팔로잉"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("드라이브에서"),
        "gotIt": MessageLookupByLibrary.simpleMessage("알겠어요"),
        "hashtag": MessageLookupByLibrary.simpleMessage("해시태그"),
        "hostnames": MessageLookupByLibrary.simpleMessage("도메인 이름"),
        "hour": MessageLookupByLibrary.simpleMessage("시간"),
        "hoursAgo": m11,
        "image": MessageLookupByLibrary.simpleMessage("사진"),
        "inputServer": MessageLookupByLibrary.simpleMessage("서버를 수동으로 입력"),
        "insertDriverFile": MessageLookupByLibrary.simpleMessage("파일 첨부"),
        "isFollowingYouNow": MessageLookupByLibrary.simpleMessage("당신을 팔로우함"),
        "justNow": MessageLookupByLibrary.simpleMessage("방금 전"),
        "keepOriginal": MessageLookupByLibrary.simpleMessage("원본 이미지를 유지"),
        "loadingServers": MessageLookupByLibrary.simpleMessage("서버 로딩 중"),
        "local": MessageLookupByLibrary.simpleMessage("로컬"),
        "localUpload": MessageLookupByLibrary.simpleMessage("장치에서 업로드"),
        "login": MessageLookupByLibrary.simpleMessage("로그인"),
        "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("로그인 실패"),
        "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
          "로그인 실패: 응용 프로그램 생성 실패",
        ),
        "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
          "로그인 실패: 토큰 가져오기 실패",
        ),
        "loginLoading": m12,
        "loginSuccess": MessageLookupByLibrary.simpleMessage("로그인 성공"),
        "manageAccount": MessageLookupByLibrary.simpleMessage("계정 관리"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage("열람주의로 설정"),
        "mention": MessageLookupByLibrary.simpleMessage("멘션"),
        "minute": MessageLookupByLibrary.simpleMessage("분"),
        "minutesAgo": m13,
        "monthsAgo": m14,
        "more": MessageLookupByLibrary.simpleMessage("더 보기"),
        "myCLips": MessageLookupByLibrary.simpleMessage("내 클립"),
        "name": MessageLookupByLibrary.simpleMessage("이름"),
        "nameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("이름은 비워둘 수 없습니다"),
        "next": MessageLookupByLibrary.simpleMessage("다음"),
        "noLists": MessageLookupByLibrary.simpleMessage("이 목록은 비어 있습니다."),
        "notFindServer": MessageLookupByLibrary.simpleMessage(
          "당신이 있는 서버를 찾지 못했습니까?",
        ),
        "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage("링크 복사"),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("접기"),
        "noteCwShow": MessageLookupByLibrary.simpleMessage("펼치기"),
        "noteFormLanguageTranslation": m15,
        "noteLocalOnly": MessageLookupByLibrary.simpleMessage("연합에 보내지 않기"),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage("리모트에서 보기"),
        "notePined": MessageLookupByLibrary.simpleMessage("고정된 노트"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("인용"),
        "noteReNote": MessageLookupByLibrary.simpleMessage("리노트"),
        "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("리노트했습니다"),
        "noteTranslate": MessageLookupByLibrary.simpleMessage("노트 번역"),
        "noteVisibility": MessageLookupByLibrary.simpleMessage("표시 설정"),
        "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage("팔로워"),
        "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
          "팔로워에게만 공개",
        ),
        "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("홈"),
        "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
          "홈 타임라인에만 공개",
        ),
        "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("공개"),
        "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
          "모든 유저에게 공개",
        ),
        "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage("다이렉트"),
        "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
          "지정한 유저에게만 공개",
        ),
        "notes": MessageLookupByLibrary.simpleMessage("노트"),
        "notesCount": MessageLookupByLibrary.simpleMessage("노트 수"),
        "notification": MessageLookupByLibrary.simpleMessage("알림"),
        "notifications": MessageLookupByLibrary.simpleMessage("알림"),
        "notifyAll": MessageLookupByLibrary.simpleMessage("전체"),
        "notifyFilter": MessageLookupByLibrary.simpleMessage("필터"),
        "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
          "팔로우가 수락되었습니다",
        ),
        "notifyFollowedYou":
            MessageLookupByLibrary.simpleMessage("새로운 팔로워가 있습니다"),
        "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage("모두 읽음으로 표시"),
        "notifyMention": MessageLookupByLibrary.simpleMessage("받은 멘션"),
        "notifyMessage": MessageLookupByLibrary.simpleMessage("다이렉트"),
        "notifyNotSupport": m16,
        "ok": MessageLookupByLibrary.simpleMessage("확인"),
        "openInNewTab": MessageLookupByLibrary.simpleMessage("새 탭에서 열기"),
        "overviews": MessageLookupByLibrary.simpleMessage("요약"),
        "pendingFollowRequest":
            MessageLookupByLibrary.simpleMessage("팔로우 승인 대기중"),
        "preview": MessageLookupByLibrary.simpleMessage("미리보기"),
        "previewNote": MessageLookupByLibrary.simpleMessage("본문 미리보기"),
        "processing": MessageLookupByLibrary.simpleMessage("처리 중"),
        "public": MessageLookupByLibrary.simpleMessage("공개"),
        "publish": MessageLookupByLibrary.simpleMessage("노트"),
        "reNoteHint": MessageLookupByLibrary.simpleMessage("이 노트를 리노트..."),
        "reNoteText": MessageLookupByLibrary.simpleMessage("노트를 리노트"),
        "reaction": MessageLookupByLibrary.simpleMessage("리액션"),
        "reactionAccepting": MessageLookupByLibrary.simpleMessage("리액션 수신"),
        "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("전체"),
        "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
          "좋아요만 받기",
        ),
        "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
          "리모트에서는 좋아요만 받기",
        ),
        "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
          "민감한 이모지를 제외하고 받기",
        ),
        "reactionAcceptingNoneSensitiveOrLocal":
            MessageLookupByLibrary.simpleMessage(
          "민감한 이모지를 제외하고 받기(리모트에서는 좋아요만 받기)",
        ),
        "recipient": MessageLookupByLibrary.simpleMessage("받는 사람"),
        "refresh": MessageLookupByLibrary.simpleMessage("새로고침"),
        "registration": MessageLookupByLibrary.simpleMessage("가입"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("초대만"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("공개"),
        "remote": MessageLookupByLibrary.simpleMessage("리모트"),
        "rename": MessageLookupByLibrary.simpleMessage("이름 변경"),
        "renameFile": MessageLookupByLibrary.simpleMessage("파일 이름 변경"),
        "renameFolder": MessageLookupByLibrary.simpleMessage("폴더 이름 변경"),
        "replyNoteHint": MessageLookupByLibrary.simpleMessage("이 노트에 답하기..."),
        "replyNoteText": MessageLookupByLibrary.simpleMessage("노트에 답하기"),
        "saveFailed": MessageLookupByLibrary.simpleMessage("저장 실패"),
        "saveImage": MessageLookupByLibrary.simpleMessage("이미지 저장"),
        "saveSuccess": MessageLookupByLibrary.simpleMessage("저장 성공"),
        "search": MessageLookupByLibrary.simpleMessage("검색"),
        "searchAll": MessageLookupByLibrary.simpleMessage("전체"),
        "searchHost": MessageLookupByLibrary.simpleMessage("도메인 지정"),
        "searchLocal": MessageLookupByLibrary.simpleMessage("로컬"),
        "searchRemote": MessageLookupByLibrary.simpleMessage("리모트"),
        "searchServers": MessageLookupByLibrary.simpleMessage("서버 검색"),
        "secondsAgo": m17,
        "selectHashtag": MessageLookupByLibrary.simpleMessage("해시태그 선택"),
        "selectServer": MessageLookupByLibrary.simpleMessage("서버를 선택해 주세요"),
        "selectUser": MessageLookupByLibrary.simpleMessage("유저 선택"),
        "sensitiveClickShow": MessageLookupByLibrary.simpleMessage("눌러서 확인하기"),
        "sensitiveContent": MessageLookupByLibrary.simpleMessage("민감한 내용"),
        "serverAddr": MessageLookupByLibrary.simpleMessage("서버 주소"),
        "serverList": MessageLookupByLibrary.simpleMessage("서버 목록"),
        "settings": MessageLookupByLibrary.simpleMessage("설정"),
        "share": MessageLookupByLibrary.simpleMessage("공유"),
        "showConversation": MessageLookupByLibrary.simpleMessage("타래 보기"),
        "somebodyNote": MessageLookupByLibrary.simpleMessage(" 님의 노트"),
        "timeline": MessageLookupByLibrary.simpleMessage("타임라인"),
        "timelineGlobal": MessageLookupByLibrary.simpleMessage("글로벌"),
        "timelineHome": MessageLookupByLibrary.simpleMessage("홈"),
        "timelineHybrid": MessageLookupByLibrary.simpleMessage("소셜"),
        "timelineLocal": MessageLookupByLibrary.simpleMessage("로컬"),
        "translate": MessageLookupByLibrary.simpleMessage("번역"),
        "uncategorized": MessageLookupByLibrary.simpleMessage("분류되지 않음"),
        "unfollow": MessageLookupByLibrary.simpleMessage("팔로우 취소"),
        "updatedDate": MessageLookupByLibrary.simpleMessage("업데이트한 날짜"),
        "uploadFailed": m18,
        "uploadFromUrl": MessageLookupByLibrary.simpleMessage("URL로부터"),
        "user": MessageLookupByLibrary.simpleMessage("유저"),
        "userAll": MessageLookupByLibrary.simpleMessage("전체"),
        "userDescriptionIsNull":
            MessageLookupByLibrary.simpleMessage("자기소개가 없습니다"),
        "userFile": MessageLookupByLibrary.simpleMessage("첨부파일"),
        "userHot": MessageLookupByLibrary.simpleMessage("유저"),
        "userNote": MessageLookupByLibrary.simpleMessage("노트"),
        "userRegisterBy": MessageLookupByLibrary.simpleMessage("가입 날짜"),
        "userWidgetUnSupport":
            MessageLookupByLibrary.simpleMessage("위젯 목록 (미완성)"),
        "username": MessageLookupByLibrary.simpleMessage("유저 이름"),
        "usersCount": MessageLookupByLibrary.simpleMessage("유저 수"),
        "video": MessageLookupByLibrary.simpleMessage("비디오"),
        "view": MessageLookupByLibrary.simpleMessage("조회"),
        "viewMore": MessageLookupByLibrary.simpleMessage("더 보기"),
        "vote": MessageLookupByLibrary.simpleMessage("투표"),
        "voteAllCount": m19,
        "voteCount": m20,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("투표 기한"),
        "voteEnableMultiChoice":
            MessageLookupByLibrary.simpleMessage("복수 응답 허용"),
        "voteExpired": MessageLookupByLibrary.simpleMessage("투표 종료됨"),
        "voteNoDueDate": MessageLookupByLibrary.simpleMessage("무기한"),
        "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
          "투표 항목이 최소 2개 필요합니다",
        ),
        "voteOptionHint": m21,
        "voteOptionNullIndex": m22,
        "voteResult": MessageLookupByLibrary.simpleMessage("투표 결과가 생성되었습니다"),
        "voteWillExpired": m23,
        "yearsAgo": m24,
      };
}
