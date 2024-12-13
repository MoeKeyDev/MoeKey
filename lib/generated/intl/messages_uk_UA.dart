// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a uk_UA locale. All the
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
  String get localeName => 'uk_UA';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Визначити ( / )";

  static String m1(error) => "\n\n ${error}Створення не вдалося";

  static String m2(days) => "${days}кілька днів тому.";

  static String m3(thing) => "${thing}Хочете видалити \" \"?";

  static String m4(name) =>
      "${name}Хочете видалити файл \" \"? Дописи з цим файлом також буде видалено.";

  static String m5(name) =>
      "${name}Хочете видалити теку \" \"? Якщо у теці є вміст, спочатку видаліть його.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Дні години хвилини секунди";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Години Хвилини Секунди";

  static String m8(minute, second) => "${minute}${second}Хвилини секунди";

  static String m9(second) =>
      "${second}одиниця кута або дуги, еквівалентна одній шістдесятій градуса";

  static String m10(error) => "\n\n${error}Не вдалося надіслати повідомлення";

  static String m11(hours) => "${hours}кілька годин тому.";

  static String m12(server) => "${server}Ви увійшли в систему";

  static String m13(minutes) => "${minutes}Кілька хвилин тому.";

  static String m14(months) => "${months}кілька місяців тому.";

  static String m15(language) => "${language} \nПерекладіть з на";

  static String m16(type) => "${type}Непідтримувані типи сповіщень:";

  static String m17(seconds) => "${seconds}кілька секунд тому.";

  static String m18(msg) => "\n ${msg}Не вдалося завантажити";

  static String m19(count) => "${count}Загальна кількість голосів";

  static String m20(count) => "${count}людина, яку утримують заради викупу";

  static String m21(index) => "${index}Параметри";

  static String m22(index) => "${index}Опція не може бути порожньою";

  static String m23(datetime) => "${datetime}кінцевий термін після завершення";

  static String m24(years) => "${years}...багато років тому.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("ім\'я користувача"),
        "add": MessageLookupByLibrary.simpleMessage("збільшення"),
        "addAccount":
            MessageLookupByLibrary.simpleMessage("Додати обліковий запис"),
        "addFile": MessageLookupByLibrary.simpleMessage("Додати файл"),
        "addTitle": MessageLookupByLibrary.simpleMessage("Додати назву"),
        "all": MessageLookupByLibrary.simpleMessage("повний"),
        "announcementActive":
            MessageLookupByLibrary.simpleMessage("Анонс зараз"),
        "announcementExpired":
            MessageLookupByLibrary.simpleMessage("Попередні анонси"),
        "announcements": MessageLookupByLibrary.simpleMessage("бюлетень"),
        "back": MessageLookupByLibrary.simpleMessage(
            "повернутися (або піти) назад"),
        "cancel": MessageLookupByLibrary.simpleMessage("скасування"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage(
            "Зняття прапорця як чутливого вмісту"),
        "clip": MessageLookupByLibrary.simpleMessage("записка"),
        "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
            "Впевнені, що хочете скасувати збір?"),
        "clipCreate": MessageLookupByLibrary.simpleMessage("Нові стікери"),
        "clipFavorite":
            MessageLookupByLibrary.simpleMessage("Додати в обране Обране"),
        "clipFavoriteList":
            MessageLookupByLibrary.simpleMessage("закладка (Інтернет)"),
        "clipRemove":
            MessageLookupByLibrary.simpleMessage("Видаліть липкі нотатки"),
        "clips": MessageLookupByLibrary.simpleMessage("записка"),
        "confirmSelection": m0,
        "copyContent": MessageLookupByLibrary.simpleMessage("Скопіювати вміст"),
        "copyLink":
            MessageLookupByLibrary.simpleMessage("Скопіювати посилання"),
        "copyRSS": MessageLookupByLibrary.simpleMessage("Скопіювати RSS"),
        "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
            "Скопіюйте адресу домашньої сторінки користувача"),
        "copyUsername":
            MessageLookupByLibrary.simpleMessage("Копіювати ім\'я користувача"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Нова папка"),
        "createNote":
            MessageLookupByLibrary.simpleMessage("Створити нову тему"),
        "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
            "Створення публікації з файлу"),
        "createNoteHint": MessageLookupByLibrary.simpleMessage("Що сталося..."),
        "createdDate": MessageLookupByLibrary.simpleMessage("Дата створення"),
        "creationFailedDialog": m1,
        "cw": MessageLookupByLibrary.simpleMessage("прихований вміст"),
        "day": MessageLookupByLibrary.simpleMessage("небо"),
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("видалення"),
        "deleteConfirm": m3,
        "deleteFileConfirmation": m4,
        "deleteFolderConfirmation": m5,
        "description": MessageLookupByLibrary.simpleMessage("описи"),
        "done": MessageLookupByLibrary.simpleMessage("виконати"),
        "download": MessageLookupByLibrary.simpleMessage("завантаження"),
        "drive": MessageLookupByLibrary.simpleMessage("хмарне сховище файлів"),
        "durationDay": m6,
        "durationHour": m7,
        "durationMinute": m8,
        "durationSecond": m9,
        "edit": MessageLookupByLibrary.simpleMessage("компілятор"),
        "emoji": MessageLookupByLibrary.simpleMessage("смайлик"),
        "enterNewFileName": MessageLookupByLibrary.simpleMessage(
            "Будь ласка, введіть нове ім\'я файлу"),
        "enterNewTitle": MessageLookupByLibrary.simpleMessage(
            "Будь ласка, введіть нову назву"),
        "enterUrl": MessageLookupByLibrary.simpleMessage(
            "Будь ласка, введіть URL-адресу"),
        "exceptionContentNull":
            MessageLookupByLibrary.simpleMessage("Вміст не може бути порожнім"),
        "exceptionCwNull":
            MessageLookupByLibrary.simpleMessage("Вміст не може бути порожнім"),
        "exceptionSendNote": m10,
        "explore": MessageLookupByLibrary.simpleMessage("відкриття"),
        "exploreHot": MessageLookupByLibrary.simpleMessage("в моді"),
        "exploreUserHot":
            MessageLookupByLibrary.simpleMessage("популярний користувач"),
        "exploreUserLast": MessageLookupByLibrary.simpleMessage(
            "Нещодавно зареєстровані користувачі"),
        "exploreUserPined": MessageLookupByLibrary.simpleMessage(
            "користувач на початку списку"),
        "exploreUserUpdated":
            MessageLookupByLibrary.simpleMessage("Нещодавні дописувачі"),
        "exploreUsers": MessageLookupByLibrary.simpleMessage("користувач"),
        "favorite": MessageLookupByLibrary.simpleMessage("закладка (Інтернет)"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "folderName": MessageLookupByLibrary.simpleMessage("Ім\'я папки"),
        "follow": MessageLookupByLibrary.simpleMessage("фокус"),
        "followed": MessageLookupByLibrary.simpleMessage("Слідкували за"),
        "followers": MessageLookupByLibrary.simpleMessage("спостерігач"),
        "following": MessageLookupByLibrary.simpleMessage("Занепокоєні"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("З нетбука"),
        "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
        "hashtag": MessageLookupByLibrary.simpleMessage("хештег"),
        "hostnames": MessageLookupByLibrary.simpleMessage("доменне ім\'я"),
        "hour": MessageLookupByLibrary.simpleMessage("годин"),
        "hoursAgo": m11,
        "image": MessageLookupByLibrary.simpleMessage("фотографія"),
        "inputServer":
            MessageLookupByLibrary.simpleMessage("Сервер ручного введення"),
        "insertDriverFile":
            MessageLookupByLibrary.simpleMessage("Вставлення аксесуарів"),
        "isFollowingYouNow":
            MessageLookupByLibrary.simpleMessage("Я спостерігаю за тобою."),
        "justNow": MessageLookupByLibrary.simpleMessage("Нещодавно"),
        "keepOriginal": MessageLookupByLibrary.simpleMessage(
            "Збережіть оригінальне зображення"),
        "loadingServers":
            MessageLookupByLibrary.simpleMessage("Server Loading"),
        "local": MessageLookupByLibrary.simpleMessage("ця місцевість"),
        "localUpload":
            MessageLookupByLibrary.simpleMessage("локальне завантаження"),
        "login": MessageLookupByLibrary.simpleMessage("увійти"),
        "loginFailed":
            MessageLookupByLibrary.simpleMessage("Помилка входу в систему"),
        "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
            "Помилка входу: не вдалося створити додаток"),
        "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
            "Не вдалося увійти: не вдалося придбати токен"),
        "loginLoading": m12,
        "loginSuccess":
            MessageLookupByLibrary.simpleMessage("Успішний вхід в систему"),
        "manageAccount":
            MessageLookupByLibrary.simpleMessage("Керування обліковим записом"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage(
            "Позначити як конфіденційний вміст"),
        "mention": MessageLookupByLibrary.simpleMessage("піднімати (тему)"),
        "minute": MessageLookupByLibrary.simpleMessage("хвилини"),
        "minutesAgo": m13,
        "monthsAgo": m14,
        "more": MessageLookupByLibrary.simpleMessage("більше"),
        "myCLips": MessageLookupByLibrary.simpleMessage("Моя записка."),
        "name": MessageLookupByLibrary.simpleMessage("назва (речі)"),
        "nameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Ім\'я не може бути порожнім"),
        "next": MessageLookupByLibrary.simpleMessage("наступний крок"),
        "noLists":
            MessageLookupByLibrary.simpleMessage("You don\'t have any lists"),
        "notFindServer":
            MessageLookupByLibrary.simpleMessage("Не знайшли свій сервер?"),
        "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
            "Скопіюйте посилання на цей сайт"),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("прибрати."),
        "noteCwShow": MessageLookupByLibrary.simpleMessage("Відобразити вміст"),
        "noteFormLanguageTranslation": m15,
        "noteLocalOnly":
            MessageLookupByLibrary.simpleMessage("Неучасть у спільних"),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
            "Перейдіть на хост-сервер, щоб відобразити"),
        "notePined":
            MessageLookupByLibrary.simpleMessage("Найкращі публікації"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("цитата"),
        "noteReNote": MessageLookupByLibrary.simpleMessage(
            "пересилання (пошта, SMS, пакети даних)"),
        "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Переслано."),
        "noteTranslate":
            MessageLookupByLibrary.simpleMessage("Переклад дописів"),
        "noteVisibility": MessageLookupByLibrary.simpleMessage("видимість"),
        "noteVisibilityFollowers":
            MessageLookupByLibrary.simpleMessage("спостерігач"),
        "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
            "Надсилати тільки підписникам"),
        "noteVisibilityHome":
            MessageLookupByLibrary.simpleMessage("рис. початок"),
        "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
            "Хронологія надсилається лише на головну сторінку"),
        "noteVisibilityPublic":
            MessageLookupByLibrary.simpleMessage("відкрито"),
        "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
            "Ваш допис з\'явиться на глобальній часовій шкалі"),
        "noteVisibilitySpecified":
            MessageLookupByLibrary.simpleMessage("приватний лист"),
        "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
            "Надсилати лише вказаним користувачам"),
        "notes": MessageLookupByLibrary.simpleMessage("картка"),
        "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
        "notification": MessageLookupByLibrary.simpleMessage("сповіщення"),
        "notifications": MessageLookupByLibrary.simpleMessage("сповіщення"),
        "notifyAll": MessageLookupByLibrary.simpleMessage("повний"),
        "notifyFilter": MessageLookupByLibrary.simpleMessage("скринінг"),
        "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
            "Ваш запит на увагу схвалено."),
        "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
            "У вас з\'явилися нові підписники."),
        "notifyMarkAllRead":
            MessageLookupByLibrary.simpleMessage("Позначте все як прочитане"),
        "notifyMention":
            MessageLookupByLibrary.simpleMessage("Говорячи про мою"),
        "notifyMessage": MessageLookupByLibrary.simpleMessage("приватний лист"),
        "notifyNotSupport": m16,
        "ok": MessageLookupByLibrary.simpleMessage("визначити"),
        "openInNewTab": MessageLookupByLibrary.simpleMessage(
            "Перейдіть до Відображення в браузері"),
        "overviews": MessageLookupByLibrary.simpleMessage("переглянути"),
        "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
            "Занепокоєння щодо задоволення запитів"),
        "preview": MessageLookupByLibrary.simpleMessage("попередні перегляди"),
        "previewNote": MessageLookupByLibrary.simpleMessage(
            "Попередній перегляд публікацій"),
        "processing": MessageLookupByLibrary.simpleMessage("у процесі"),
        "public": MessageLookupByLibrary.simpleMessage("відкрито"),
        "publish": MessageLookupByLibrary.simpleMessage("пост"),
        "reNoteHint":
            MessageLookupByLibrary.simpleMessage("Цитуючи цей пост..."),
        "reNoteText": MessageLookupByLibrary.simpleMessage("Цитувати допис"),
        "reaction": MessageLookupByLibrary.simpleMessage("відповідь"),
        "reactionAccepting":
            MessageLookupByLibrary.simpleMessage("Прийом відповідей на емодзі"),
        "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("повний"),
        "reactionAcceptingLikeOnly":
            MessageLookupByLibrary.simpleMessage("Тільки лайки."),
        "reactionAcceptingLikeOnlyRemote":
            MessageLookupByLibrary.simpleMessage("Тільки віддалений кудос"),
        "reactionAcceptingNoneSensitive":
            MessageLookupByLibrary.simpleMessage("Тільки нечутливий вміст"),
        "reactionAcceptingNoneSensitiveOrLocal":
            MessageLookupByLibrary.simpleMessage(
                "Тільки нечутливий контент (тільки віддалені вподобання)"),
        "recipient":
            MessageLookupByLibrary.simpleMessage("Кому: (заголовок листа)"),
        "refresh":
            MessageLookupByLibrary.simpleMessage("оновити (вікно комп\'ютера)"),
        "registration": MessageLookupByLibrary.simpleMessage("Registration"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
        "remote": MessageLookupByLibrary.simpleMessage("віддалено"),
        "rename": MessageLookupByLibrary.simpleMessage("перейменувати"),
        "renameFile":
            MessageLookupByLibrary.simpleMessage("Перейменувати файл"),
        "renameFolder":
            MessageLookupByLibrary.simpleMessage("Перейменування теки"),
        "replyNoteHint": MessageLookupByLibrary.simpleMessage(
            "Відповісти на цю публікацію..."),
        "replyNoteText":
            MessageLookupByLibrary.simpleMessage("Відповісти на публікацію"),
        "saveFailed":
            MessageLookupByLibrary.simpleMessage("не вдасться врятувати"),
        "saveImage":
            MessageLookupByLibrary.simpleMessage("Зберегти зображення"),
        "saveSuccess": MessageLookupByLibrary.simpleMessage("Зберегти успішно"),
        "search": MessageLookupByLibrary.simpleMessage("шукати що-л."),
        "searchAll": MessageLookupByLibrary.simpleMessage("повний"),
        "searchHost":
            MessageLookupByLibrary.simpleMessage("Вкажіть ім\'я домену"),
        "searchLocal": MessageLookupByLibrary.simpleMessage("цей сайт"),
        "searchRemote": MessageLookupByLibrary.simpleMessage("віддалено"),
        "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
        "secondsAgo": m17,
        "selectHashtag": MessageLookupByLibrary.simpleMessage("Виберіть тег"),
        "selectServer":
            MessageLookupByLibrary.simpleMessage("Please Select Your Server"),
        "selectUser":
            MessageLookupByLibrary.simpleMessage("Виберіть користувача"),
        "sensitiveClickShow":
            MessageLookupByLibrary.simpleMessage("Натисніть, щоб показати"),
        "sensitiveContent":
            MessageLookupByLibrary.simpleMessage("Делікатний вміст"),
        "serverAddr": MessageLookupByLibrary.simpleMessage("адреса сервера"),
        "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
        "settings": MessageLookupByLibrary.simpleMessage("налаштований"),
        "share": MessageLookupByLibrary.simpleMessage(
            "ділитися (радощами, благами, привілеями тощо) з іншими"),
        "showConversation":
            MessageLookupByLibrary.simpleMessage("Переглянути діалог"),
        "somebodyNote": MessageLookupByLibrary.simpleMessage(" пости"),
        "timeline": MessageLookupByLibrary.simpleMessage("часовий графік"),
        "timelineGlobal":
            MessageLookupByLibrary.simpleMessage("ситуація з безпекою"),
        "timelineHome": MessageLookupByLibrary.simpleMessage("рис. початок"),
        "timelineHybrid": MessageLookupByLibrary.simpleMessage("соціалізація"),
        "timelineLocal": MessageLookupByLibrary.simpleMessage("ця місцевість"),
        "translate": MessageLookupByLibrary.simpleMessage("рендеринг"),
        "uncategorized": MessageLookupByLibrary.simpleMessage("Без категорії"),
        "unfollow": MessageLookupByLibrary.simpleMessage("Скасувати відповідь"),
        "updatedDate": MessageLookupByLibrary.simpleMessage("Дата оновлення"),
        "uploadFailed": m18,
        "uploadFromUrl":
            MessageLookupByLibrary.simpleMessage("Завантажити з веб-сайту"),
        "user": MessageLookupByLibrary.simpleMessage("користувач"),
        "userAll": MessageLookupByLibrary.simpleMessage("повний"),
        "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
            "Цей користувач ще не представився"),
        "userFile": MessageLookupByLibrary.simpleMessage(
            "вкладення (електронною поштою)"),
        "userHot": MessageLookupByLibrary.simpleMessage("користувач"),
        "userNote": MessageLookupByLibrary.simpleMessage("картка"),
        "userRegisterBy":
            MessageLookupByLibrary.simpleMessage("зареєстровано в"),
        "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
            "Список віджетів (незавершений)"),
        "username":
            MessageLookupByLibrary.simpleMessage("ідентифікатор користувача"),
        "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
        "video": MessageLookupByLibrary.simpleMessage("відео"),
        "view": MessageLookupByLibrary.simpleMessage("перевірте."),
        "viewMore": MessageLookupByLibrary.simpleMessage("Переглянути більше"),
        "vote": MessageLookupByLibrary.simpleMessage("референдум"),
        "voteAllCount": m19,
        "voteCount": m20,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("дата закінчення"),
        "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
            "Допускається багаторазове голосування"),
        "voteExpired":
            MessageLookupByLibrary.simpleMessage("Голосування закрито."),
        "voteNoDueDate": MessageLookupByLibrary.simpleMessage("назавжди"),
        "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
            "Кількість голосів не може бути менше двох"),
        "voteOptionHint": m21,
        "voteOptionNullIndex": m22,
        "voteResult": MessageLookupByLibrary.simpleMessage(
            "Підбито підсумки голосування"),
        "voteWillExpired": m23,
        "yearsAgo": m24
      };
}
