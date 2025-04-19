// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru_RU locale. All the
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
  String get localeName => 'ru_RU';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Определите ( / )";

  static String m1(error) => "\n\n ${error}Создание не удалось";

  static String m2(days) => "${days}дней назад";

  static String m3(thing) => "${thing}Хотите удалить \" \"?";

  static String m4(name) =>
      "${name}Хотите удалить файл \" \"? Сообщения с прикрепленным файлом также будут удалены.";

  static String m5(name) =>
      "${name}Хотите удалить папку \" \"? Если в папке есть содержимое, сначала удалите содержимое папки.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Дни часы минуты секунды";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Часы Минуты Секунды";

  static String m8(minute, second) => "${minute}${second}Минуты секунды";

  static String m9(second) =>
      "${second}единица угла или дуги, эквивалентная одной шестидесятой градуса";

  static String m10(error) => "\n\n${error}Не удалось отправить почту";

  static String m11(hours) => "${hours}несколько часов назад";

  static String m12(server) => "${server}В настоящее время вошел в систему";

  static String m13(minutes) => "${minutes}минут назад";

  static String m14(months) => "${months}месяцев назад";

  static String m15(language) => "${language} \nПеревести с на";

  static String m16(type) => "${type}Неподдерживаемые типы уведомлений:";

  static String m17(seconds) => "${seconds}несколько секунд назад";

  static String m18(msg) => "\n ${msg}Загрузка не удалась";

  static String m19(count) => "${count}Всего голосов";

  static String m20(count) =>
      "${count}человек, удерживаемый с целью получения выкупа";

  static String m21(index) => "${index}Опции";

  static String m22(index) => "${index}Опция не может быть пустой";

  static String m23(datetime) => "${datetime}срок после завершения работ";

  static String m24(years) => "${years}...лет назад";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("имя пользователя"),
    "add": MessageLookupByLibrary.simpleMessage("увеличить"),
    "addAccount": MessageLookupByLibrary.simpleMessage("Добавить аккаунт"),
    "addFile": MessageLookupByLibrary.simpleMessage("Добавить файл"),
    "addTitle": MessageLookupByLibrary.simpleMessage("Добавить название"),
    "all": MessageLookupByLibrary.simpleMessage("полный"),
    "announcementActive": MessageLookupByLibrary.simpleMessage(
      "Объявление сейчас",
    ),
    "announcementExpired": MessageLookupByLibrary.simpleMessage(
      "Прошлые объявления",
    ),
    "announcements": MessageLookupByLibrary.simpleMessage("бюллетень"),
    "back": MessageLookupByLibrary.simpleMessage("возвращаться (или уходить)"),
    "cancel": MessageLookupByLibrary.simpleMessage("отмены"),
    "cancelSensitive": MessageLookupByLibrary.simpleMessage(
      "Снимите флаги с чувствительного содержимого",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clip": MessageLookupByLibrary.simpleMessage("памятка"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите отказаться от коллекции?",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage("Новые липкие заметки"),
    "clipFavorite": MessageLookupByLibrary.simpleMessage(
      "Добавить в избранное",
    ),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage(
      "закладка (Интернет)",
    ),
    "clipRemove": MessageLookupByLibrary.simpleMessage(
      "Удалить липкие заметки",
    ),
    "clipUpdate": MessageLookupByLibrary.simpleMessage(
      "Обновление липких заметок",
    ),
    "clips": MessageLookupByLibrary.simpleMessage("памятка"),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage("Копирование контента"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Копировать ссылку"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("Копирование RSS"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "Скопируйте адрес домашней страницы пользователя",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage(
      "Скопировать имя пользователя",
    ),
    "createFolder": MessageLookupByLibrary.simpleMessage("Новая папка"),
    "createNote": MessageLookupByLibrary.simpleMessage(
      "Опубликуйте новую тему",
    ),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
      "Создание сообщения из файла",
    ),
    "createNoteHint": MessageLookupByLibrary.simpleMessage("Что случилось..."),
    "createdDate": MessageLookupByLibrary.simpleMessage("Дата создания"),
    "creationFailedDialog": m1,
    "cw": MessageLookupByLibrary.simpleMessage("скрытое содержимое"),
    "day": MessageLookupByLibrary.simpleMessage("небо"),
    "daysAgo": m2,
    "delete": MessageLookupByLibrary.simpleMessage("удаление"),
    "deleteConfirm": m3,
    "deleteFileConfirmation": m4,
    "deleteFolderConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("описания"),
    "done": MessageLookupByLibrary.simpleMessage("выполнить"),
    "download": MessageLookupByLibrary.simpleMessage("загрузка"),
    "drive": MessageLookupByLibrary.simpleMessage("облачное хранилище файлов"),
    "durationDay": m6,
    "durationHour": m7,
    "durationMinute": m8,
    "durationSecond": m9,
    "edit": MessageLookupByLibrary.simpleMessage("компилятор"),
    "emoji": MessageLookupByLibrary.simpleMessage("смайлик"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "Введите новое имя файла",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите новое название",
    ),
    "enterUrl": MessageLookupByLibrary.simpleMessage("Пожалуйста, введите URL"),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "Содержимое не может быть пустым",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
      "Содержимое не может быть пустым",
    ),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("открытия"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("в моде"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage(
      "популярный пользователь",
    ),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage(
      "Недавно вошедшие пользователи",
    ),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage(
      "пользователь в верхней части списка",
    ),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
      "Последние вкладчики",
    ),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("пользователь"),
    "favorite": MessageLookupByLibrary.simpleMessage("закладка (Интернет)"),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "folderName": MessageLookupByLibrary.simpleMessage("Имя папки"),
    "follow": MessageLookupByLibrary.simpleMessage("фокус"),
    "followed": MessageLookupByLibrary.simpleMessage("Следовать"),
    "followers": MessageLookupByLibrary.simpleMessage("наблюдатель"),
    "following": MessageLookupByLibrary.simpleMessage("Озабоченные"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("С нетбука"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
    "hashtag": MessageLookupByLibrary.simpleMessage("хэштег"),
    "hostnames": MessageLookupByLibrary.simpleMessage("доменное имя"),
    "hour": MessageLookupByLibrary.simpleMessage("часы"),
    "hoursAgo": m11,
    "image": MessageLookupByLibrary.simpleMessage("фотография"),
    "inputServer": MessageLookupByLibrary.simpleMessage("Сервер ручного ввода"),
    "insertDriverFile": MessageLookupByLibrary.simpleMessage(
      "Установка аксессуаров",
    ),
    "isFollowingYouNow": MessageLookupByLibrary.simpleMessage(
      "Я слежу за тобой.",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("совсем недавно"),
    "keepOriginal": MessageLookupByLibrary.simpleMessage(
      "Сохраните исходное изображение",
    ),
    "loadingServers": MessageLookupByLibrary.simpleMessage("Server Loading"),
    "local": MessageLookupByLibrary.simpleMessage("эта местность"),
    "localUpload": MessageLookupByLibrary.simpleMessage("локальная загрузка"),
    "login": MessageLookupByLibrary.simpleMessage("войти в систему"),
    "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Сбой входа в систему"),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "Вход в систему невозможен: Не удалось создать приложение",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "Вход в систему не удался: не удалось получить токен",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage(
      "Вход в систему успешный",
    ),
    "manageAccount": MessageLookupByLibrary.simpleMessage(
      "Управление аккаунтом",
    ),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage(
      "Отметить как чувствительное содержимое",
    ),
    "mention": MessageLookupByLibrary.simpleMessage("поднимать (предмет)"),
    "minute": MessageLookupByLibrary.simpleMessage("минут"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("подробнее"),
    "myCLips": MessageLookupByLibrary.simpleMessage("Моя заметка."),
    "name": MessageLookupByLibrary.simpleMessage("название (вещи)"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Имя не может быть пустым",
    ),
    "next": MessageLookupByLibrary.simpleMessage("следующий шаг"),
    "noLists": MessageLookupByLibrary.simpleMessage("Список пуст"),
    "notFindServer": MessageLookupByLibrary.simpleMessage(
      "Не нашли свой сервер?",
    ),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "Скопируйте ссылку на этот сайт",
    ),
    "noteCwHide": MessageLookupByLibrary.simpleMessage("убирать"),
    "noteCwShow": MessageLookupByLibrary.simpleMessage("Содержание дисплея"),
    "noteFormLanguageTranslation": m15,
    "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
      "Неучастие в совместной деятельности",
    ),
    "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
      "Перейдите на главный сервер, чтобы отобразить",
    ),
    "notePined": MessageLookupByLibrary.simpleMessage("Top Posts"),
    "noteQuote": MessageLookupByLibrary.simpleMessage("цитировать"),
    "noteReNote": MessageLookupByLibrary.simpleMessage(
      "пересылка (почта, SMS, пакеты данных)",
    ),
    "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Переслано."),
    "noteTranslate": MessageLookupByLibrary.simpleMessage("Перевод сообщений"),
    "noteVisibility": MessageLookupByLibrary.simpleMessage("видимость"),
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage(
      "наблюдатель",
    ),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "Отправляйте только подписчикам",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("рис. начало"),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "Временная шкала отправляется только на главную страницу",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("открыто"),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "Ваше сообщение появится в глобальной временной шкале",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
      "частное письмо",
    ),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "Отправка только указанным пользователям",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("карта"),
    "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
    "notification": MessageLookupByLibrary.simpleMessage("уведомления"),
    "notifications": MessageLookupByLibrary.simpleMessage("уведомления"),
    "notifyAll": MessageLookupByLibrary.simpleMessage("полный"),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("грохочение"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "Ваш запрос на внимание был одобрен.",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
      "У вас появились новые последователи.",
    ),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
      "Отметить все как прочитанные",
    ),
    "notifyMention": MessageLookupByLibrary.simpleMessage("Говоря о моем"),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("частное письмо"),
    "notifyNotSupport": m16,
    "ok": MessageLookupByLibrary.simpleMessage("определить"),
    "openInNewTab": MessageLookupByLibrary.simpleMessage(
      "Перейти к отображению браузера",
    ),
    "overviews": MessageLookupByLibrary.simpleMessage("просмотреть"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "Опасения по поводу удовлетворения запросов",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("превью"),
    "previewNote": MessageLookupByLibrary.simpleMessage(
      "Предварительные сообщения",
    ),
    "processing": MessageLookupByLibrary.simpleMessage("в процессе"),
    "public": MessageLookupByLibrary.simpleMessage("открыто"),
    "publish": MessageLookupByLibrary.simpleMessage("почта"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage("Цитирую этот пост..."),
    "reNoteText": MessageLookupByLibrary.simpleMessage("Цитировать пост"),
    "reaction": MessageLookupByLibrary.simpleMessage("ответ"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage(
      "Принятие ответов Emoji",
    ),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("полный"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
      "Любит только",
    ),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "Только пульт дистанционного управления Kudos",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "Только нечувствительное содержимое",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage(
          "Только нечувствительное содержимое (только удаленные лайки)",
        ),
    "recipient": MessageLookupByLibrary.simpleMessage(
      "Кому: (заголовок сообщения электронной почты)",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage(
      "обновить (окно компьютера)",
    ),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
    "remote": MessageLookupByLibrary.simpleMessage("удаленно"),
    "rename": MessageLookupByLibrary.simpleMessage("переименовать"),
    "renameFile": MessageLookupByLibrary.simpleMessage("Переименовать файл"),
    "renameFolder": MessageLookupByLibrary.simpleMessage("Переименовать папку"),
    "replyNoteHint": MessageLookupByLibrary.simpleMessage(
      "Ответить на это сообщение...",
    ),
    "replyNoteText": MessageLookupByLibrary.simpleMessage(
      "Ответить на сообщение",
    ),
    "saveFailed": MessageLookupByLibrary.simpleMessage("не спасти"),
    "saveImage": MessageLookupByLibrary.simpleMessage("Сохранить изображение"),
    "saveSuccess": MessageLookupByLibrary.simpleMessage("Сохранить успешный"),
    "search": MessageLookupByLibrary.simpleMessage("искать что-л."),
    "searchAll": MessageLookupByLibrary.simpleMessage("полный"),
    "searchHost": MessageLookupByLibrary.simpleMessage("Укажите доменное имя"),
    "searchLocal": MessageLookupByLibrary.simpleMessage("этот сайт"),
    "searchRemote": MessageLookupByLibrary.simpleMessage("удаленно"),
    "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
    "secondsAgo": m17,
    "selectHashtag": MessageLookupByLibrary.simpleMessage("Выберите тег"),
    "selectServer": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, выберите сервер",
    ),
    "selectUser": MessageLookupByLibrary.simpleMessage("Выберите пользователя"),
    "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
      "Нажмите, чтобы показать",
    ),
    "sensitiveContent": MessageLookupByLibrary.simpleMessage(
      "Чувствительный контент",
    ),
    "serverAddr": MessageLookupByLibrary.simpleMessage("адрес сервера"),
    "serverList": MessageLookupByLibrary.simpleMessage("Список серверов"),
    "settings": MessageLookupByLibrary.simpleMessage("устанавливать"),
    "share": MessageLookupByLibrary.simpleMessage(
      "делиться с другими (радостями, благами, привилегиями и т.д.)",
    ),
    "showConversation": MessageLookupByLibrary.simpleMessage(
      "Просмотр диалога",
    ),
    "somebodyNote": MessageLookupByLibrary.simpleMessage(" посты"),
    "timeline": MessageLookupByLibrary.simpleMessage("хронология"),
    "timelineGlobal": MessageLookupByLibrary.simpleMessage(
      "ситуация с безопасностью",
    ),
    "timelineHome": MessageLookupByLibrary.simpleMessage("рис. начало"),
    "timelineHybrid": MessageLookupByLibrary.simpleMessage("социализация"),
    "timelineLocal": MessageLookupByLibrary.simpleMessage("эта местность"),
    "translate": MessageLookupByLibrary.simpleMessage("рендеринг"),
    "uncategorized": MessageLookupByLibrary.simpleMessage("Без категории"),
    "unfollow": MessageLookupByLibrary.simpleMessage("Отклонить"),
    "updatedDate": MessageLookupByLibrary.simpleMessage("Дата обновления"),
    "uploadFailed": m18,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
      "Загрузка с веб-сайта",
    ),
    "user": MessageLookupByLibrary.simpleMessage("пользователь"),
    "userAll": MessageLookupByLibrary.simpleMessage("полный"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
      "Этот пользователь еще не представился",
    ),
    "userFile": MessageLookupByLibrary.simpleMessage(
      "вложение (электронная почта)",
    ),
    "userHot": MessageLookupByLibrary.simpleMessage("пользователь"),
    "userNote": MessageLookupByLibrary.simpleMessage("карта"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage(
      "зарегистрированный в",
    ),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "Список виджетов (незакончено)",
    ),
    "username": MessageLookupByLibrary.simpleMessage(
      "идентификатор пользователя",
    ),
    "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
    "video": MessageLookupByLibrary.simpleMessage("видео"),
    "view": MessageLookupByLibrary.simpleMessage("проверять"),
    "viewMore": MessageLookupByLibrary.simpleMessage("Смотреть далее"),
    "vote": MessageLookupByLibrary.simpleMessage("референдум"),
    "voteAllCount": m19,
    "voteCount": m20,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("дата прекращения"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
      "Разрешено несколько голосований",
    ),
    "voteExpired": MessageLookupByLibrary.simpleMessage("Голосование закрыто."),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("постоянно"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "Количество голосов не может быть меньше двух",
    ),
    "voteOptionHint": m21,
    "voteOptionNullIndex": m22,
    "voteResult": MessageLookupByLibrary.simpleMessage(
      "Результаты голосования были получены",
    ),
    "voteWillExpired": m23,
    "yearsAgo": m24,
  };
}
