// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar_SA locale. All the
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
  String get localeName => 'ar_SA';

  static String m0(selectListLength, maxSelect) =>
      "تأكيد(${selectListLength}/${maxSelect})";

  static String m1(error) => "فشل الإنشاء\n\n ${error}";

  static String m2(days) => "قبل ${days} يومًا";

  static String m3(thing) => "هل تريد حذف \"${thing}\"؟";

  static String m4(name) =>
      "هل تريد حذف الملف \"${name}؟ سيتم أيضًا حذف المشاركات المرتبطة بهذا الملف.";

  static String m5(name) =>
      "هل تريد حذف المجلد \"${name}\"؟ إذا كان هناك محتوى في المجلد، يرجى حذف المحتوى أولاً.";

  static String m6(day, hour, minute, second) =>
      "${day} يوم ${hour} ساعة ${minute} دقيقة ${second} ثانية";

  static String m7(hour, minute, second) =>
      "${hour} ساعة ${minute} دقيقة ${second} ثانية";

  static String m8(minute, second) => "${minute} دقيقة ${second} ثانية";

  static String m9(second) => "${second} ثانية";

  static String m10(error) => "فشل في إرسال المشاركة\n\n${error}";

  static String m11(hours) => "قبل ${hours} ساعة";

  static String m12(server) => "جارِ تسجيل الدخول إلى ${server}";

  static String m13(minutes) => "قبل ${minutes} دقيقة";

  static String m14(months) => "قبل ${months} شهرًا";

  static String m15(language) => "تمت الترجمة من ${language} \n";

  static String m16(type) => "نوع الإشعار غير المدعوم: ${type}";

  static String m17(seconds) => "قبل ${seconds} ثانية";

  static String m18(msg) => "فشل التحميل\n ${msg}";

  static String m19(count) => "إجمالي الأصوات ${count}";

  static String m20(count) => "${count} تصويت";

  static String m21(index) => "الخيار ${index}";

  static String m22(index) => "لا يمكن أن يكون الخيار ${index} فارغًا";

  static String m23(datetime) => "ينتهي في ${datetime}";

  static String m24(years) => "قبل ${years} سنة";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("الحساب"),
    "add": MessageLookupByLibrary.simpleMessage("إضافة"),
    "addAccount": MessageLookupByLibrary.simpleMessage("إضافة حساب"),
    "addFile": MessageLookupByLibrary.simpleMessage("إضافة ملف"),
    "addTitle": MessageLookupByLibrary.simpleMessage("إضافة عنوان"),
    "all": MessageLookupByLibrary.simpleMessage("الكل"),
    "announcementActive": MessageLookupByLibrary.simpleMessage(
      "الإعلانات الحالية",
    ),
    "announcementExpired": MessageLookupByLibrary.simpleMessage(
      "الإعلانات السابقة",
    ),
    "announcements": MessageLookupByLibrary.simpleMessage("الإعلانات"),
    "back": MessageLookupByLibrary.simpleMessage("عودة"),
    "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "cancelSensitive": MessageLookupByLibrary.simpleMessage(
      "إلغاء وضع علامة كالمحتوى الحساس",
    ),
    "clip": MessageLookupByLibrary.simpleMessage("ملف"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "هل تريد بالتأكيد إلغاء المفضلة؟",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage("إنشاء ملف جديد"),
    "clipFavorite": MessageLookupByLibrary.simpleMessage("إضافة إلى المفضلة"),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage("قائمة المفضلة"),
    "clipRemove": MessageLookupByLibrary.simpleMessage("حذف الملف"),
    "clipUpdate": MessageLookupByLibrary.simpleMessage(
      "تحديث الملاحظات اللاصقة",
    ),
    "clips": MessageLookupByLibrary.simpleMessage("الملاحظات"),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage("نسخ المحتوى"),
    "copyLink": MessageLookupByLibrary.simpleMessage("نسخ الرابط"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("نسخ RSS"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "نسخ رابط الصفحة الرئيسية للمستخدم",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage("نسخ اسم المستخدم"),
    "createFolder": MessageLookupByLibrary.simpleMessage("إنشاء مجلد جديد"),
    "createNote": MessageLookupByLibrary.simpleMessage("نشر مشاركة جديدة"),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
      "إنشاء مشاركة من ملف",
    ),
    "createNoteHint": MessageLookupByLibrary.simpleMessage("ماذا حدث..."),
    "createdDate": MessageLookupByLibrary.simpleMessage("تاريخ الإنشاء"),
    "creationFailedDialog": m1,
    "cw": MessageLookupByLibrary.simpleMessage("إخفاء المحتوى"),
    "day": MessageLookupByLibrary.simpleMessage("أيام"),
    "daysAgo": m2,
    "delete": MessageLookupByLibrary.simpleMessage("حذف"),
    "deleteConfirm": m3,
    "deleteFileConfirmation": m4,
    "deleteFolderConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("الوصف"),
    "done": MessageLookupByLibrary.simpleMessage("إنهاء"),
    "download": MessageLookupByLibrary.simpleMessage("تنزيل"),
    "drive": MessageLookupByLibrary.simpleMessage("محرك السحابة"),
    "durationDay": m6,
    "durationHour": m7,
    "durationMinute": m8,
    "durationSecond": m9,
    "edit": MessageLookupByLibrary.simpleMessage("تحرير"),
    "emoji": MessageLookupByLibrary.simpleMessage("الرموز التعبيرية"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "الرجاء إدخال اسم ملف جديد",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage(
      "الرجاء إدخال عنوان جديد",
    ),
    "enterUrl": MessageLookupByLibrary.simpleMessage("يرجى إدخال عنوان URL"),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "لا يمكن أن يكون المحتوى فارغًا",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
      "لا يمكن أن يكون المحتوى فارغًا",
    ),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("استكشاف"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("الأكثر رواجاً"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage(
      "المستخدمون الرائجون",
    ),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage(
      "المستخدمون الذين قاموا بتسجيل دخول مؤخرًا",
    ),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage(
      "المستخدمون المثبتون",
    ),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
      "المستخدمون الذين قدموا المشاركات مؤخرًا",
    ),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("المستخدمين"),
    "favorite": MessageLookupByLibrary.simpleMessage("المفضلة"),
    "filter": MessageLookupByLibrary.simpleMessage("تصفية"),
    "folderName": MessageLookupByLibrary.simpleMessage("اسم المجلد"),
    "follow": MessageLookupByLibrary.simpleMessage("متابعة"),
    "followed": MessageLookupByLibrary.simpleMessage("تمت المتابعة"),
    "followers": MessageLookupByLibrary.simpleMessage("المتابعون"),
    "following": MessageLookupByLibrary.simpleMessage("متابعة"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("من السحابة"),
    "gotIt": MessageLookupByLibrary.simpleMessage("فهمت"),
    "hashtag": MessageLookupByLibrary.simpleMessage("وسم الموضوعات"),
    "hostnames": MessageLookupByLibrary.simpleMessage("النطاقات"),
    "hour": MessageLookupByLibrary.simpleMessage("ساعات"),
    "hoursAgo": m11,
    "image": MessageLookupByLibrary.simpleMessage("صورة"),
    "inputServer": MessageLookupByLibrary.simpleMessage("إدخال الخادم يدويًا"),
    "insertDriverFile": MessageLookupByLibrary.simpleMessage("إدراج مرفق"),
    "isFollowingYouNow": MessageLookupByLibrary.simpleMessage("يتابعك الآن"),
    "justNow": MessageLookupByLibrary.simpleMessage("الآن"),
    "keepOriginal": MessageLookupByLibrary.simpleMessage(
      "الاحتفاظ بالصورة الأصلية",
    ),
    "loadingServers": MessageLookupByLibrary.simpleMessage("جارٍ تحميل الخادم"),
    "local": MessageLookupByLibrary.simpleMessage("محلي"),
    "localUpload": MessageLookupByLibrary.simpleMessage("تحميل محلي"),
    "login": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("فشل تسجيل الدخول"),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "فشل تسجيل الدخول: فشل إنشاء التطبيق",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "فشل تسجيل الدخول: فشل في الحصول على الرمز المميز",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage(
      "تم تسجيل الدخول بنجاح",
    ),
    "manageAccount": MessageLookupByLibrary.simpleMessage("إدارة الحساب"),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage(
      "وضع علامة كالمحتوى الحساس",
    ),
    "mention": MessageLookupByLibrary.simpleMessage("إشارة"),
    "minute": MessageLookupByLibrary.simpleMessage("دقائق"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("المزيد"),
    "myCLips": MessageLookupByLibrary.simpleMessage("ملفاتي"),
    "name": MessageLookupByLibrary.simpleMessage("الاسم"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "لا يمكن أن يكون الاسم فارغًا",
    ),
    "next": MessageLookupByLibrary.simpleMessage("الخطوة التالية"),
    "noLists": MessageLookupByLibrary.simpleMessage("القائمة فارغة"),
    "notFindServer": MessageLookupByLibrary.simpleMessage(
      "لم يُعثر على الخادم الذي تستخدمه؟",
    ),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "نسخ رابط الموقع المحلي",
    ),
    "noteCwHide": MessageLookupByLibrary.simpleMessage("إخفاء"),
    "noteCwShow": MessageLookupByLibrary.simpleMessage("عرض المحتوى"),
    "noteFormLanguageTranslation": m15,
    "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
      "غير مشاركة في الاتحاد",
    ),
    "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
      "الانتقال إلى عرض خادم الموقع",
    ),
    "notePined": MessageLookupByLibrary.simpleMessage("المشاركة المثبتة"),
    "noteQuote": MessageLookupByLibrary.simpleMessage("اقتباس"),
    "noteReNote": MessageLookupByLibrary.simpleMessage("إعادة نشر"),
    "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("تمت إعادة النشر"),
    "noteTranslate": MessageLookupByLibrary.simpleMessage("ترجمة المشاركة"),
    "noteVisibility": MessageLookupByLibrary.simpleMessage("الرؤية"),
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage(
      "المتابعون",
    ),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "أرسل فقط إلى المتابعين",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage(
      "الصفحة الرئيسية",
    ),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "أرسل فقط إلى الجدول الزمني للصفحة الرئيسية",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("علني"),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "ستظهر مشاركتك في الجدول الزمني العالمي",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
      "رسالة خاصة",
    ),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "أرسل فقط إلى المستخدمين المحددين",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("المشاركات"),
    "notesCount": MessageLookupByLibrary.simpleMessage("عدد المشاركات"),
    "notification": MessageLookupByLibrary.simpleMessage("الإشعارات"),
    "notifications": MessageLookupByLibrary.simpleMessage("الإشعارات"),
    "notifyAll": MessageLookupByLibrary.simpleMessage("الكل"),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("تصفية"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "تم قبول طلب متابعتك",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
      "لديك متابعون جدد",
    ),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
      "وضع علامة للكل كمقروء",
    ),
    "notifyMention": MessageLookupByLibrary.simpleMessage("إشاراتي"),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("الرسائل الخاصة"),
    "notifyNotSupport": m16,
    "ok": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "openInNewTab": MessageLookupByLibrary.simpleMessage(
      "الانتقال إلى العرض في المتصفح",
    ),
    "overviews": MessageLookupByLibrary.simpleMessage("نظرة عامة"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "طلب المتابعة في انتظار الموافقة",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("معاينة"),
    "previewNote": MessageLookupByLibrary.simpleMessage("معاينة المشاركة"),
    "processing": MessageLookupByLibrary.simpleMessage("يعالج حالياً"),
    "public": MessageLookupByLibrary.simpleMessage("عام"),
    "publish": MessageLookupByLibrary.simpleMessage("نشر"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage(
      "اقتبس من هذه المشاركة...",
    ),
    "reNoteText": MessageLookupByLibrary.simpleMessage("اقتباس المشاركة"),
    "reaction": MessageLookupByLibrary.simpleMessage("الردود"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage(
      "قبول ردود الفعل التعبيرية",
    ),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("الكل"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
      "الإعجاب فقط",
    ),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "الإعجاب فقط عن بُعد",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "فقط من أجل المحتوى غير الحساس",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage(
          "فقط من أجل المحتوى غير الحساس (الإعجاب فقط عن بُعد)",
        ),
    "recipient": MessageLookupByLibrary.simpleMessage("المستلم"),
    "refresh": MessageLookupByLibrary.simpleMessage("تحديث"),
    "registration": MessageLookupByLibrary.simpleMessage("وضع التسجيل"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage(
      "عن طريق الدعوة فقط",
    ),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("مفتوح"),
    "remote": MessageLookupByLibrary.simpleMessage("بعيد"),
    "rename": MessageLookupByLibrary.simpleMessage("إعادة تسمية"),
    "renameFile": MessageLookupByLibrary.simpleMessage("إعادة تسمية الملف"),
    "renameFolder": MessageLookupByLibrary.simpleMessage("إعادة تسمية المجلد"),
    "replyNoteHint": MessageLookupByLibrary.simpleMessage(
      "رد على هذه المشاركة...",
    ),
    "replyNoteText": MessageLookupByLibrary.simpleMessage("الرد على المشاركة"),
    "saveFailed": MessageLookupByLibrary.simpleMessage("فشل الحفظ"),
    "saveImage": MessageLookupByLibrary.simpleMessage("حفظ الصورة"),
    "saveSuccess": MessageLookupByLibrary.simpleMessage("تم الحفظ بنجاح"),
    "search": MessageLookupByLibrary.simpleMessage("بحث"),
    "searchAll": MessageLookupByLibrary.simpleMessage("الكل"),
    "searchHost": MessageLookupByLibrary.simpleMessage("النطاق المخصص"),
    "searchLocal": MessageLookupByLibrary.simpleMessage("محلي"),
    "searchRemote": MessageLookupByLibrary.simpleMessage("عن بُعد"),
    "searchServers": MessageLookupByLibrary.simpleMessage(
      "البحث عن اسم الخادم أو النطاق",
    ),
    "secondsAgo": m17,
    "selectHashtag": MessageLookupByLibrary.simpleMessage("حدد الوسوم"),
    "selectServer": MessageLookupByLibrary.simpleMessage("من فضلك اختر الخادم"),
    "selectUser": MessageLookupByLibrary.simpleMessage("حدد المستخدم"),
    "sensitiveClickShow": MessageLookupByLibrary.simpleMessage("اضغط للعرض"),
    "sensitiveContent": MessageLookupByLibrary.simpleMessage("المحتوى الحساس"),
    "serverAddr": MessageLookupByLibrary.simpleMessage("عنوان الخادم"),
    "serverList": MessageLookupByLibrary.simpleMessage("قائمة الخوادم"),
    "settings": MessageLookupByLibrary.simpleMessage("إعدادات"),
    "share": MessageLookupByLibrary.simpleMessage("مشاركة"),
    "showConversation": MessageLookupByLibrary.simpleMessage("عرض المحادثة"),
    "somebodyNote": MessageLookupByLibrary.simpleMessage("منشورات المستخدم"),
    "timeline": MessageLookupByLibrary.simpleMessage("الجدول الزمني"),
    "timelineGlobal": MessageLookupByLibrary.simpleMessage("عالمي"),
    "timelineHome": MessageLookupByLibrary.simpleMessage("الصفحة الرئيسية"),
    "timelineHybrid": MessageLookupByLibrary.simpleMessage("اجتماعي"),
    "timelineLocal": MessageLookupByLibrary.simpleMessage("محلي"),
    "translate": MessageLookupByLibrary.simpleMessage("ترجمة"),
    "uncategorized": MessageLookupByLibrary.simpleMessage("غير مصنف"),
    "unfollow": MessageLookupByLibrary.simpleMessage("إلغاء المتابعة"),
    "updatedDate": MessageLookupByLibrary.simpleMessage("تاريخ التحديث"),
    "uploadFailed": m18,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage("تحميل من عنوان ويب"),
    "user": MessageLookupByLibrary.simpleMessage("المستخدم"),
    "userAll": MessageLookupByLibrary.simpleMessage("الكل"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
      "هذا المستخدم ليس له وصف ذاتي",
    ),
    "userFile": MessageLookupByLibrary.simpleMessage("المرفقات"),
    "userHot": MessageLookupByLibrary.simpleMessage("المستخدمون"),
    "userNote": MessageLookupByLibrary.simpleMessage("المشاركات"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage("مسجل في"),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "قائمة الأدوات (غير مكتمل)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("اسم المستخدم"),
    "usersCount": MessageLookupByLibrary.simpleMessage("عدد المستخدمين"),
    "video": MessageLookupByLibrary.simpleMessage("فيديو"),
    "view": MessageLookupByLibrary.simpleMessage("عرض"),
    "viewMore": MessageLookupByLibrary.simpleMessage("شاهد المزيد"),
    "vote": MessageLookupByLibrary.simpleMessage("التصويت"),
    "voteAllCount": m19,
    "voteCount": m20,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("تاريخ الانتهاء"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
      "السماح بتعدد الخيارات",
    ),
    "voteExpired": MessageLookupByLibrary.simpleMessage("انتهى التصويت"),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("دائم"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "لا يمكن أن يكون عدد خيارات التصويت أقل من خيارين",
    ),
    "voteOptionHint": m21,
    "voteOptionNullIndex": m22,
    "voteResult": MessageLookupByLibrary.simpleMessage(
      "تم إنشاء نتيجة التصويت",
    ),
    "voteWillExpired": m23,
    "yearsAgo": m24,
  };
}
