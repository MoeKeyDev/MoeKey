// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a sv_SE locale. All the
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
  String get localeName => 'sv_SE';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Bestäm ( / )";

  static String m1(error) => "\n\n ${error}Skapandet misslyckades";

  static String m2(days) => "${days}dagar sedan";

  static String m3(thing) => "${thing}Vill du ta bort \" \"?";

  static String m4(name) =>
      "${name}Vill du ta bort filen \" \"? Inlägg med den här filen bifogad kommer också att raderas.";

  static String m5(name) =>
      "${name}Vill du ta bort mappen \" \"? Om det finns innehåll i mappen ska du först radera innehållet i mappen.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Dagar timmar minuter sekunder";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Timmar Minuter Sekunder";

  static String m8(minute, second) => "${minute}${second}Minuter sekunder";

  static String m9(second) =>
      "${second}enhet för vinkel eller båge motsvarande en sextiondels grad";

  static String m10(error) => "\n\n${error}Misslyckades med att skicka post";

  static String m11(hours) => "${hours}timmar sedan";

  static String m12(server) => "${server}För närvarande inloggad";

  static String m13(minutes) => "${minutes}minuter sedan";

  static String m14(months) => "${months}månader sedan";

  static String m15(language) => "${language} \nÖversätt från till";

  static String m16(type) => "${type}Meddelandetyper som inte stöds:";

  static String m17(seconds) => "${seconds}sekunder sedan";

  static String m18(msg) => "\n ${msg}Uppladdningen misslyckades";

  static String m19(count) => "${count}Totalt antal röster";

  static String m20(count) => "${count}person som hålls kvar för lösensumma";

  static String m21(index) => "${index}Alternativ";

  static String m22(index) => "${index}Alternativet kan inte vara tomt";

  static String m23(datetime) => "${datetime}tidsfrist efter slutförandet";

  static String m24(years) => "${years}...år sedan";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("Användarnamn"),
    "add": MessageLookupByLibrary.simpleMessage("öka"),
    "addAccount": MessageLookupByLibrary.simpleMessage("Lägg till konto"),
    "addFile": MessageLookupByLibrary.simpleMessage("Lägg till fil"),
    "addTitle": MessageLookupByLibrary.simpleMessage("Lägg till titel"),
    "all": MessageLookupByLibrary.simpleMessage("full"),
    "announcementActive": MessageLookupByLibrary.simpleMessage(
      "Tillkännagivande nu",
    ),
    "announcementExpired": MessageLookupByLibrary.simpleMessage(
      "Tidigare tillkännagivanden",
    ),
    "announcements": MessageLookupByLibrary.simpleMessage("bulletin"),
    "back": MessageLookupByLibrary.simpleMessage("komma (eller gå) tillbaka"),
    "cancel": MessageLookupByLibrary.simpleMessage("avbokningar"),
    "cancelSensitive": MessageLookupByLibrary.simpleMessage(
      "Avflagga känsligt innehåll",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clip": MessageLookupByLibrary.simpleMessage("memo"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "Är du säker på att du vill avbryta insamlingen?",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage("Nya klisterlappar"),
    "clipFavorite": MessageLookupByLibrary.simpleMessage(
      "Lägg till bland favoriter",
    ),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage(
      "bokmärke (Internet)",
    ),
    "clipRemove": MessageLookupByLibrary.simpleMessage("Ta bort klisterlappar"),
    "clipUpdate": MessageLookupByLibrary.simpleMessage(
      "Uppdatera klisterlappar",
    ),
    "clips": MessageLookupByLibrary.simpleMessage("memo"),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage("Kopiera innehåll"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Kopiera länk"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("Kopiera RSS"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "Kopiera adressen till användarens hemsida",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage(
      "Kopiera användarnamn",
    ),
    "createFolder": MessageLookupByLibrary.simpleMessage("Ny mapp"),
    "createNote": MessageLookupByLibrary.simpleMessage("Lägg upp en ny tråd"),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
      "Skapa ett inlägg från en fil",
    ),
    "createNoteHint": MessageLookupByLibrary.simpleMessage("Vad hände..."),
    "createdDate": MessageLookupByLibrary.simpleMessage("Datum för skapande"),
    "creationFailedDialog": m1,
    "cw": MessageLookupByLibrary.simpleMessage("dolt innehåll"),
    "day": MessageLookupByLibrary.simpleMessage("dag"),
    "daysAgo": m2,
    "delete": MessageLookupByLibrary.simpleMessage("avlägsnande"),
    "deleteConfirm": m3,
    "deleteFileConfirmation": m4,
    "deleteFolderConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("beskrivningar"),
    "done": MessageLookupByLibrary.simpleMessage("uppfylla"),
    "download": MessageLookupByLibrary.simpleMessage("nedladdning"),
    "drive": MessageLookupByLibrary.simpleMessage("lagring av filer i molnet"),
    "durationDay": m6,
    "durationHour": m7,
    "durationMinute": m8,
    "durationSecond": m9,
    "edit": MessageLookupByLibrary.simpleMessage("kompilator"),
    "emoji": MessageLookupByLibrary.simpleMessage("emoticon"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "Ange ett nytt filnamn",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage(
      "Vänligen ange en ny titel",
    ),
    "enterUrl": MessageLookupByLibrary.simpleMessage("Vänligen ange URL"),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "Innehållet kan inte vara tomt",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
      "Innehållet kan inte vara tomt",
    ),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("Upptäckter"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("på modet"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage("populär användare"),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage(
      "Nyligen inloggade användare",
    ),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage(
      "användaren högst upp på listan",
    ),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
      "Senaste bidragsgivarna",
    ),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("användare"),
    "favorite": MessageLookupByLibrary.simpleMessage("bokmärke (Internet)"),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "folderName": MessageLookupByLibrary.simpleMessage("Mappens namn"),
    "follow": MessageLookupByLibrary.simpleMessage("fokus"),
    "followed": MessageLookupByLibrary.simpleMessage("Följt av"),
    "followers": MessageLookupByLibrary.simpleMessage("observatör"),
    "following": MessageLookupByLibrary.simpleMessage("Bekymrad"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("Från netbooken"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
    "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
    "hostnames": MessageLookupByLibrary.simpleMessage("domännamn"),
    "hour": MessageLookupByLibrary.simpleMessage("timmar"),
    "hoursAgo": m11,
    "image": MessageLookupByLibrary.simpleMessage("fotografi"),
    "inputServer": MessageLookupByLibrary.simpleMessage(
      "Server för manuell inmatning",
    ),
    "insertDriverFile": MessageLookupByLibrary.simpleMessage(
      "Insättning av tillbehör",
    ),
    "isFollowingYouNow": MessageLookupByLibrary.simpleMessage(
      "Jag håller ögonen på dig.",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("alldeles nyligen"),
    "keepOriginal": MessageLookupByLibrary.simpleMessage(
      "Bevara den ursprungliga bilden",
    ),
    "loadingServers": MessageLookupByLibrary.simpleMessage("Server Loading"),
    "local": MessageLookupByLibrary.simpleMessage("denna plats"),
    "localUpload": MessageLookupByLibrary.simpleMessage("lokal uppladdning"),
    "login": MessageLookupByLibrary.simpleMessage("logga in"),
    "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Felaktig inloggning"),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "Inloggning misslyckades: Skapande av applikation misslyckades",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "Inloggning misslyckades: förvärv av token misslyckades",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage(
      "Inloggning framgångsrik",
    ),
    "manageAccount": MessageLookupByLibrary.simpleMessage("Hantera konto"),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage(
      "Flagga som känsligt innehåll",
    ),
    "mention": MessageLookupByLibrary.simpleMessage("höja (ett ämne)"),
    "minute": MessageLookupByLibrary.simpleMessage("Protokoll"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("mer"),
    "myCLips": MessageLookupByLibrary.simpleMessage("Min anmärkning."),
    "name": MessageLookupByLibrary.simpleMessage("namn (på en sak)"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Namnet får inte vara tomt",
    ),
    "next": MessageLookupByLibrary.simpleMessage("nästa steg"),
    "noLists": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any lists",
    ),
    "notFindServer": MessageLookupByLibrary.simpleMessage(
      "Hittade du inte din server?",
    ),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "Kopiera länken till den här webbplatsen",
    ),
    "noteCwHide": MessageLookupByLibrary.simpleMessage("lägga undan"),
    "noteCwShow": MessageLookupByLibrary.simpleMessage("Visa innehåll"),
    "noteFormLanguageTranslation": m15,
    "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
      "Icke-deltagande i gemensam",
    ),
    "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
      "Gå till värdservern för att visa",
    ),
    "notePined": MessageLookupByLibrary.simpleMessage("Bästa inlägg"),
    "noteQuote": MessageLookupByLibrary.simpleMessage("citat"),
    "noteReNote": MessageLookupByLibrary.simpleMessage(
      "vidarebefordran (e-post, SMS, datapaket)",
    ),
    "noteReNoteByUser": MessageLookupByLibrary.simpleMessage(
      "Vidarebefordrad.",
    ),
    "noteTranslate": MessageLookupByLibrary.simpleMessage(
      "Översättning av inlägg",
    ),
    "noteVisibility": MessageLookupByLibrary.simpleMessage("synlighet"),
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage(
      "observatör",
    ),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "Skicka endast till följare",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("fig. början"),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "Tidslinjen skickas endast till startsidan",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("öppet"),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "Ditt inlägg kommer att visas på den globala tidslinjen",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
      "privat brev",
    ),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "Skicka endast till angivna användare",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("kort"),
    "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
    "notification": MessageLookupByLibrary.simpleMessage("meddelanden"),
    "notifications": MessageLookupByLibrary.simpleMessage("meddelanden"),
    "notifyAll": MessageLookupByLibrary.simpleMessage("full"),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("screening"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "Din begäran om uppmärksamhet har godkänts.",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
      "Du har nya följare.",
    ),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
      "Markera alla som lästa",
    ),
    "notifyMention": MessageLookupByLibrary.simpleMessage("På tal om min"),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("privat brev"),
    "notifyNotSupport": m16,
    "ok": MessageLookupByLibrary.simpleMessage("definiera"),
    "openInNewTab": MessageLookupByLibrary.simpleMessage(
      "Gå till webbläsarens display",
    ),
    "overviews": MessageLookupByLibrary.simpleMessage("skumma igenom"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "Oro för att förfrågningar ska beviljas",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("förhandsvisningar"),
    "previewNote": MessageLookupByLibrary.simpleMessage(
      "Förhandsgranska inlägg",
    ),
    "processing": MessageLookupByLibrary.simpleMessage("pågår"),
    "public": MessageLookupByLibrary.simpleMessage("öppet"),
    "publish": MessageLookupByLibrary.simpleMessage("post"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage(
      "Citerar detta inlägg...",
    ),
    "reNoteText": MessageLookupByLibrary.simpleMessage("Citat inlägg"),
    "reaction": MessageLookupByLibrary.simpleMessage("svar"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage(
      "Acceptera Emoji-svar",
    ),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("full"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
      "Gillar bara",
    ),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "Endast fjärrstyrda Kudos",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "Endast icke-känsligt innehåll",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage(
          "Endast icke-känsligt innehåll (endast fjärrstyrning)",
        ),
    "recipient": MessageLookupByLibrary.simpleMessage("Till: (e-posthuvud)"),
    "refresh": MessageLookupByLibrary.simpleMessage("uppdatera (datorfönster)"),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
    "remote": MessageLookupByLibrary.simpleMessage("på distans"),
    "rename": MessageLookupByLibrary.simpleMessage("byta namn på"),
    "renameFile": MessageLookupByLibrary.simpleMessage("Byt namn på fil"),
    "renameFolder": MessageLookupByLibrary.simpleMessage("Byt namn på en mapp"),
    "replyNoteHint": MessageLookupByLibrary.simpleMessage(
      "Svara på detta inlägg...",
    ),
    "replyNoteText": MessageLookupByLibrary.simpleMessage(
      "Svara på ett inlägg",
    ),
    "saveFailed": MessageLookupByLibrary.simpleMessage(
      "misslyckas med att spara",
    ),
    "saveImage": MessageLookupByLibrary.simpleMessage("Spara bild"),
    "saveSuccess": MessageLookupByLibrary.simpleMessage("Spara framgångsrikt"),
    "search": MessageLookupByLibrary.simpleMessage("leta efter något"),
    "searchAll": MessageLookupByLibrary.simpleMessage("full"),
    "searchHost": MessageLookupByLibrary.simpleMessage("Ange domännamn"),
    "searchLocal": MessageLookupByLibrary.simpleMessage("denna webbplats"),
    "searchRemote": MessageLookupByLibrary.simpleMessage("på distans"),
    "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
    "secondsAgo": m17,
    "selectHashtag": MessageLookupByLibrary.simpleMessage("Välj tagg"),
    "selectServer": MessageLookupByLibrary.simpleMessage(
      "Please Select Your Server",
    ),
    "selectUser": MessageLookupByLibrary.simpleMessage("Välj användare"),
    "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
      "Klicka för att visa",
    ),
    "sensitiveContent": MessageLookupByLibrary.simpleMessage(
      "Känsligt innehåll",
    ),
    "serverAddr": MessageLookupByLibrary.simpleMessage("serveradress"),
    "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
    "settings": MessageLookupByLibrary.simpleMessage("ställa upp"),
    "share": MessageLookupByLibrary.simpleMessage(
      "dela (glädjeämnen, förmåner, privilegier etc.) med andra",
    ),
    "showConversation": MessageLookupByLibrary.simpleMessage("Visa dialog"),
    "somebodyNote": MessageLookupByLibrary.simpleMessage(" inlägg"),
    "timeline": MessageLookupByLibrary.simpleMessage("Tidslinje"),
    "timelineGlobal": MessageLookupByLibrary.simpleMessage("säkerhetsläget"),
    "timelineHome": MessageLookupByLibrary.simpleMessage("fig. början"),
    "timelineHybrid": MessageLookupByLibrary.simpleMessage("socialisering"),
    "timelineLocal": MessageLookupByLibrary.simpleMessage("denna plats"),
    "translate": MessageLookupByLibrary.simpleMessage("rendering"),
    "uncategorized": MessageLookupByLibrary.simpleMessage("Okategoriserade"),
    "unfollow": MessageLookupByLibrary.simpleMessage("Avföljning"),
    "updatedDate": MessageLookupByLibrary.simpleMessage(
      "Datum för uppdatering",
    ),
    "uploadFailed": m18,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
      "Ladda upp från webbplatsen",
    ),
    "user": MessageLookupByLibrary.simpleMessage("användare"),
    "userAll": MessageLookupByLibrary.simpleMessage("full"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
      "Denna användare har ännu inte presenterat sig",
    ),
    "userFile": MessageLookupByLibrary.simpleMessage("bifogad fil (e-post)"),
    "userHot": MessageLookupByLibrary.simpleMessage("användare"),
    "userNote": MessageLookupByLibrary.simpleMessage("kort"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage("registrerad i"),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "Lista över widgets (oavslutad)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("Användar-ID"),
    "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
    "video": MessageLookupByLibrary.simpleMessage("video"),
    "view": MessageLookupByLibrary.simpleMessage("checka ut"),
    "viewMore": MessageLookupByLibrary.simpleMessage("Visa mer"),
    "vote": MessageLookupByLibrary.simpleMessage("folkomröstning"),
    "voteAllCount": m19,
    "voteCount": m20,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("brytdatum"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
      "Flera röster tillåtna",
    ),
    "voteExpired": MessageLookupByLibrary.simpleMessage(
      "Omröstningen är avslutad.",
    ),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("permanent"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "Antalet röster får inte understiga två",
    ),
    "voteOptionHint": m21,
    "voteOptionNullIndex": m22,
    "voteResult": MessageLookupByLibrary.simpleMessage(
      "Röstningsresultat har genererats",
    ),
    "voteWillExpired": m23,
    "yearsAgo": m24,
  };
}
