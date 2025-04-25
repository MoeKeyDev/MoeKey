// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a cs_CZ locale. All the
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
  String get localeName => 'cs_CZ';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Určete ( / )";

  static String m1(error) => "\n\n ${error}Vytvoření se nezdařilo";

  static String m2(days) => "${days}před několika dny";

  static String m3(thing) => "${thing}Chcete odstranit \" \"?";

  static String m4(name) =>
      "${name}Chcete odstranit soubor \" \"? Příspěvky s tímto souborem budou také smazány.";

  static String m5(name) =>
      "${name}Chcete odstranit složku \" \"? Pokud je ve složce obsah, odstraňte nejprve obsah složky.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Dny hodiny minuty sekundy";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Hodiny Minuty Sekundy";

  static String m8(minute, second) => "${minute}${second}Minuty sekundy";

  static String m9(second) =>
      "${second}jednotka úhlu nebo oblouku odpovídající jedné šedesátině stupně";

  static String m10(error) => "\n\n${error}Nepodařilo se odeslat poštu";

  static String m11(hours) => "${hours}před několika hodinami";

  static String m12(server) => "${server}Aktuálně přihlášený";

  static String m13(minutes) => "${minutes}před několika minutami";

  static String m14(months) => "${months}před několika měsíci";

  static String m15(language) => "${language} \nPřeložit z na";

  static String m16(type) => "${type}Nepodporované typy oznámení:";

  static String m17(seconds) => "${seconds}před několika sekundami";

  static String m18(msg) => "\n ${msg}Odeslání se nezdařilo";

  static String m19(count) => "${count}Celkový počet hlasů";

  static String m20(count) => "${count}osoba držená za výkupné";

  static String m21(index) => "${index}Možnosti";

  static String m22(index) => "${index}Tato možnost nesmí být prázdná";

  static String m23(datetime) => "${datetime}lhůta po dokončení";

  static String m24(years) => "${years}...před lety";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("uživatelské jméno"),
    "add": MessageLookupByLibrary.simpleMessage("zvýšit"),
    "addAccount": MessageLookupByLibrary.simpleMessage("Přidat účet"),
    "addFile": MessageLookupByLibrary.simpleMessage("Přidat soubor"),
    "addTitle": MessageLookupByLibrary.simpleMessage("Přidat název"),
    "all": MessageLookupByLibrary.simpleMessage("kompletní"),
    "announcementActive": MessageLookupByLibrary.simpleMessage("Oznámení nyní"),
    "announcementExpired": MessageLookupByLibrary.simpleMessage(
      "Minulá oznámení",
    ),
    "announcements": MessageLookupByLibrary.simpleMessage("bulletiny"),
    "back": MessageLookupByLibrary.simpleMessage("vrátit se (nebo odejít)"),
    "cancel": MessageLookupByLibrary.simpleMessage("zrušení"),
    "cancelSensitive": MessageLookupByLibrary.simpleMessage(
      "Zrušení označení jako citlivého obsahu",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clip": MessageLookupByLibrary.simpleMessage("memo"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "Určitě chcete sbírku zrušit?",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage(
      "Nové samolepicí poznámky",
    ),
    "clipFavorite": MessageLookupByLibrary.simpleMessage(
      "Přidat do oblíbených",
    ),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage(
      "záložka (Internet)",
    ),
    "clipRemove": MessageLookupByLibrary.simpleMessage(
      "Odstranění samolepicích poznámek",
    ),
    "clipUpdate": MessageLookupByLibrary.simpleMessage(
      "Aktualizace samolepicích poznámek",
    ),
    "clips": MessageLookupByLibrary.simpleMessage("memo"),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage("Kopírování obsahu"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Kopírovat odkaz"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("Kopírovat RSS"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "Zkopírování adresy domovské stránky uživatele",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage(
      "Kopírovat uživatelské jméno",
    ),
    "createFolder": MessageLookupByLibrary.simpleMessage("Nová složka"),
    "createNote": MessageLookupByLibrary.simpleMessage("Přidat nové vlákno"),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
      "Vytvoření příspěvku ze souboru",
    ),
    "createNoteHint": MessageLookupByLibrary.simpleMessage("Co se stalo..."),
    "createdDate": MessageLookupByLibrary.simpleMessage("Datum vytvoření"),
    "creationFailedDialog": m1,
    "cw": MessageLookupByLibrary.simpleMessage("skrytý obsah"),
    "day": MessageLookupByLibrary.simpleMessage("den"),
    "daysAgo": m2,
    "delete": MessageLookupByLibrary.simpleMessage("odstranění"),
    "deleteConfirm": m3,
    "deleteFileConfirmation": m4,
    "deleteFolderConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("popisy"),
    "done": MessageLookupByLibrary.simpleMessage("splnit"),
    "download": MessageLookupByLibrary.simpleMessage("stahování"),
    "drive": MessageLookupByLibrary.simpleMessage("cloudové úložiště souborů"),
    "durationDay": m6,
    "durationHour": m7,
    "durationMinute": m8,
    "durationSecond": m9,
    "edit": MessageLookupByLibrary.simpleMessage("kompilátor"),
    "emoji": MessageLookupByLibrary.simpleMessage("emotikon"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "Zadejte prosím nový název souboru",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage(
      "Zadejte prosím nový název",
    ),
    "enterUrl": MessageLookupByLibrary.simpleMessage(
      "Zadejte prosím adresu URL",
    ),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "Obsah nemůže být prázdný",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
      "Obsah nemůže být prázdný",
    ),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("objevy"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("v módě"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage(
      "populární uživatel",
    ),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage(
      "Nedávno přihlášení uživatelé",
    ),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage(
      "uživatel na začátku seznamu",
    ),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
      "Nedávní přispěvatelé",
    ),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("uživatel"),
    "favorite": MessageLookupByLibrary.simpleMessage("záložka (Internet)"),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "folderName": MessageLookupByLibrary.simpleMessage("Název složky"),
    "follow": MessageLookupByLibrary.simpleMessage("zaměření"),
    "followed": MessageLookupByLibrary.simpleMessage("Sledováno"),
    "followers": MessageLookupByLibrary.simpleMessage("watcher"),
    "following": MessageLookupByLibrary.simpleMessage("Znepokojený"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("Z netbooku"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
    "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
    "hostnames": MessageLookupByLibrary.simpleMessage("název domény"),
    "hour": MessageLookupByLibrary.simpleMessage("hodin"),
    "hoursAgo": m11,
    "image": MessageLookupByLibrary.simpleMessage("fotografie"),
    "inputServer": MessageLookupByLibrary.simpleMessage("Ruční vstupní server"),
    "insertDriverFile": MessageLookupByLibrary.simpleMessage(
      "Vložení příslušenství",
    ),
    "isFollowingYouNow": MessageLookupByLibrary.simpleMessage("Sleduji tě."),
    "justNow": MessageLookupByLibrary.simpleMessage("nedávno"),
    "keepOriginal": MessageLookupByLibrary.simpleMessage(
      "Zachování původního obrazu",
    ),
    "loadingServers": MessageLookupByLibrary.simpleMessage("Server Loading"),
    "local": MessageLookupByLibrary.simpleMessage("tato lokalita"),
    "localUpload": MessageLookupByLibrary.simpleMessage("místní nahrávání"),
    "login": MessageLookupByLibrary.simpleMessage("přihlásit se"),
    "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Selhání přihlášení"),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "Přihlášení se nezdařilo: Vytvoření aplikace se nezdařilo",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "Přihlášení se nezdařilo: získání tokenu se nezdařilo",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage("Úspěšné přihlášení"),
    "manageAccount": MessageLookupByLibrary.simpleMessage("Správa účtu"),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage(
      "Označit jako citlivý obsah",
    ),
    "mention": MessageLookupByLibrary.simpleMessage("zvýšit (předmět)"),
    "minute": MessageLookupByLibrary.simpleMessage("minuty"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("více"),
    "myCLips": MessageLookupByLibrary.simpleMessage("Moje poznámky."),
    "name": MessageLookupByLibrary.simpleMessage("název (věci)"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Název nesmí být prázdný",
    ),
    "next": MessageLookupByLibrary.simpleMessage("další krok"),
    "noLists": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any lists",
    ),
    "notFindServer": MessageLookupByLibrary.simpleMessage(
      "Nenašli jste svůj server?",
    ),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "Zkopírujte odkaz na tuto stránku",
    ),
    "noteCwHide": MessageLookupByLibrary.simpleMessage("uklidit"),
    "noteCwShow": MessageLookupByLibrary.simpleMessage("Zobrazení obsahu"),
    "noteFormLanguageTranslation": m15,
    "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
      "Neúčast na společném",
    ),
    "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
      "Přejděte na hostitelský server a zobrazte",
    ),
    "notePined": MessageLookupByLibrary.simpleMessage("Nejlepší příspěvky"),
    "noteQuote": MessageLookupByLibrary.simpleMessage("citace"),
    "noteReNote": MessageLookupByLibrary.simpleMessage(
      "přeposílání (pošta, SMS, datové pakety).",
    ),
    "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Předáno."),
    "noteTranslate": MessageLookupByLibrary.simpleMessage("Překlad příspěvků"),
    "noteVisibility": MessageLookupByLibrary.simpleMessage("viditelnost"),
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage("watcher"),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "Odeslat pouze následovníkům",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("obr. začátek"),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "Časová osa odeslaná pouze na domovskou stránku",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("otevřeně"),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "Váš příspěvek se zobrazí na globální časové ose",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
      "soukromý dopis",
    ),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "Odesílání pouze zadaným uživatelům",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("karta"),
    "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
    "notification": MessageLookupByLibrary.simpleMessage("oznámení"),
    "notifications": MessageLookupByLibrary.simpleMessage("oznámení"),
    "notifyAll": MessageLookupByLibrary.simpleMessage("kompletní"),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("screening"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "Vaše žádost o pozornost byla schválena.",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
      "Máte nové příznivce.",
    ),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
      "Označit vše jako přečtené",
    ),
    "notifyMention": MessageLookupByLibrary.simpleMessage(
      "Když už mluvíme o mém",
    ),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("soukromý dopis"),
    "notifyNotSupport": m16,
    "ok": MessageLookupByLibrary.simpleMessage("definovat"),
    "openInNewTab": MessageLookupByLibrary.simpleMessage(
      "Přejít na zobrazení prohlížeče",
    ),
    "overviews": MessageLookupByLibrary.simpleMessage("zběžně projít"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "Obavy z vyhovění žádostem",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("náhledy"),
    "previewNote": MessageLookupByLibrary.simpleMessage("Náhled příspěvků"),
    "processing": MessageLookupByLibrary.simpleMessage("probíhá"),
    "public": MessageLookupByLibrary.simpleMessage("otevřeně"),
    "publish": MessageLookupByLibrary.simpleMessage("příspěvek"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage(
      "Citace tohoto příspěvku...",
    ),
    "reNoteText": MessageLookupByLibrary.simpleMessage("Citovat příspěvek"),
    "reaction": MessageLookupByLibrary.simpleMessage("odpověď"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage(
      "Přijímání odpovědí Emoji",
    ),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("kompletní"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
      "Líbí se pouze",
    ),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "Pouze vzdálené Kudos",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "Pouze necitlivý obsah",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage(
          "Pouze necitlivý obsah (pouze vzdálené lajky)",
        ),
    "recipient": MessageLookupByLibrary.simpleMessage(
      "Komu: (záhlaví e-mailu)",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("refresh (okno počítače)"),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
    "remote": MessageLookupByLibrary.simpleMessage("na dálku"),
    "rename": MessageLookupByLibrary.simpleMessage("přejmenovat"),
    "renameFile": MessageLookupByLibrary.simpleMessage("Přejmenování souboru"),
    "renameFolder": MessageLookupByLibrary.simpleMessage("Přejmenování složky"),
    "replyNoteHint": MessageLookupByLibrary.simpleMessage(
      "Odpovědět na tento příspěvek...",
    ),
    "replyNoteText": MessageLookupByLibrary.simpleMessage(
      "Odpovědět na příspěvek",
    ),
    "saveFailed": MessageLookupByLibrary.simpleMessage(
      "se nepodařilo zachránit",
    ),
    "saveImage": MessageLookupByLibrary.simpleMessage("Uložit obrázek"),
    "saveSuccess": MessageLookupByLibrary.simpleMessage("Uložit úspěšné"),
    "search": MessageLookupByLibrary.simpleMessage("hledat něco"),
    "searchAll": MessageLookupByLibrary.simpleMessage("kompletní"),
    "searchHost": MessageLookupByLibrary.simpleMessage("Zadejte název domény"),
    "searchLocal": MessageLookupByLibrary.simpleMessage("tato stránka"),
    "searchRemote": MessageLookupByLibrary.simpleMessage("na dálku"),
    "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
    "secondsAgo": m17,
    "selectHashtag": MessageLookupByLibrary.simpleMessage("Vybrat značku"),
    "selectServer": MessageLookupByLibrary.simpleMessage(
      "Please Select Your Server",
    ),
    "selectUser": MessageLookupByLibrary.simpleMessage("Vybrat uživatele"),
    "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
      "Klikněte pro zobrazení",
    ),
    "sensitiveContent": MessageLookupByLibrary.simpleMessage("Citlivý obsah"),
    "serverAddr": MessageLookupByLibrary.simpleMessage("adresa serveru"),
    "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
    "settings": MessageLookupByLibrary.simpleMessage("nastavit"),
    "share": MessageLookupByLibrary.simpleMessage(
      "sdílet (radosti, výhody, privilegia atd.) s ostatními.",
    ),
    "showConversation": MessageLookupByLibrary.simpleMessage("Zobrazit dialog"),
    "somebodyNote": MessageLookupByLibrary.simpleMessage(" příspěvky"),
    "timeline": MessageLookupByLibrary.simpleMessage("časová osa"),
    "timelineGlobal": MessageLookupByLibrary.simpleMessage(
      "bezpečnostní situace",
    ),
    "timelineHome": MessageLookupByLibrary.simpleMessage("obr. začátek"),
    "timelineHybrid": MessageLookupByLibrary.simpleMessage("socializace"),
    "timelineLocal": MessageLookupByLibrary.simpleMessage("tato lokalita"),
    "translate": MessageLookupByLibrary.simpleMessage("vykreslování"),
    "uncategorized": MessageLookupByLibrary.simpleMessage("Nekategorizované"),
    "unfollow": MessageLookupByLibrary.simpleMessage("Zrušit sledování"),
    "updatedDate": MessageLookupByLibrary.simpleMessage("Datum aktualizace"),
    "uploadFailed": m18,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
      "Nahrávání z webové stránky",
    ),
    "user": MessageLookupByLibrary.simpleMessage("uživatel"),
    "userAll": MessageLookupByLibrary.simpleMessage("kompletní"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
      "Tento uživatel se ještě nepředstavil",
    ),
    "userFile": MessageLookupByLibrary.simpleMessage("příloha (e-mail)"),
    "userHot": MessageLookupByLibrary.simpleMessage("uživatel"),
    "userNote": MessageLookupByLibrary.simpleMessage("karta"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage("registrovaná v"),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "Seznam widgetů (nedokončený)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("ID uživatele"),
    "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
    "video": MessageLookupByLibrary.simpleMessage("video"),
    "view": MessageLookupByLibrary.simpleMessage("podívejte se"),
    "viewMore": MessageLookupByLibrary.simpleMessage("Zobrazit více"),
    "vote": MessageLookupByLibrary.simpleMessage("referendum"),
    "voteAllCount": m19,
    "voteCount": m20,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("datum uzávěrky"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
      "Povoleno více hlasů",
    ),
    "voteExpired": MessageLookupByLibrary.simpleMessage(
      "Hlasování je ukončeno.",
    ),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("trvale"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "Počet hlasů nesmí být menší než dva",
    ),
    "voteOptionHint": m21,
    "voteOptionNullIndex": m22,
    "voteResult": MessageLookupByLibrary.simpleMessage(
      "Byly vygenerovány výsledky hlasování",
    ),
    "voteWillExpired": m23,
    "yearsAgo": m24,
  };
}
