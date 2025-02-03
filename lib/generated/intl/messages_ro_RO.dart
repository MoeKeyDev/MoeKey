// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ro_RO locale. All the
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
  String get localeName => 'ro_RO';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Determinați ( / )";

  static String m1(error) => "\n\n ${error}Creație eșuată";

  static String m2(days) => "${days}zile în urmă";

  static String m3(thing) => "${thing}Doriți să ștergeți \" \"?";

  static String m4(name) =>
      "${name}Doriți să ștergeți fișierul \" \"? Mesajele cu acest fișier atașat vor fi, de asemenea, șterse.";

  static String m5(name) =>
      "${name}Doriți să ștergeți folderul \" \"? Dacă există conținut în folder, vă rugăm să ștergeți mai întâi conținutul folderului.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Zile ore minute secunde";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Ore Minute Secunde";

  static String m8(minute, second) => "${minute}${second}Minute secunde";

  static String m9(second) =>
      "${second}unitate de unghi sau arc echivalent cu o șaizecime de grad";

  static String m10(error) => "\n\n${error}A eșuat trimiterea mesajului";

  static String m11(hours) => "${hours}ore în urmă";

  static String m12(server) => "${server}Conectat în prezent";

  static String m13(minutes) => "${minutes}acum câteva minute";

  static String m14(months) => "${months}luni în urmă";

  static String m15(language) => "${language} \nTradu din în";

  static String m16(type) => "${type}Tipuri de notificări nesupuse:";

  static String m17(seconds) => "${seconds}secunde în urmă";

  static String m18(msg) => "\n ${msg}Upload eșuat";

  static String m19(count) => "${count}Total voturi";

  static String m20(count) => "${count}persoană reținută pentru răscumpărare";

  static String m21(index) => "${index}Opțiuni";

  static String m22(index) => "${index}Opțiunea nu poate fi goală";

  static String m23(datetime) => "${datetime}termen de finalizare ulterioară";

  static String m24(years) => "${years}...ani în urmă";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("nume de utilizator"),
        "add": MessageLookupByLibrary.simpleMessage("creștere"),
        "addAccount": MessageLookupByLibrary.simpleMessage("Adăugare cont"),
        "addFile": MessageLookupByLibrary.simpleMessage("Adăugați fișier"),
        "addTitle": MessageLookupByLibrary.simpleMessage("Adaugă titlu"),
        "all": MessageLookupByLibrary.simpleMessage("complet"),
        "announcementActive":
            MessageLookupByLibrary.simpleMessage("Anunț acum"),
        "announcementExpired":
            MessageLookupByLibrary.simpleMessage("Anunțuri anterioare"),
        "announcements": MessageLookupByLibrary.simpleMessage("buletin"),
        "back": MessageLookupByLibrary.simpleMessage("a reveni (sau a pleca)"),
        "cancel": MessageLookupByLibrary.simpleMessage("anulări"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage(
            "Deblocați conținutul sensibil"),
        "clip": MessageLookupByLibrary.simpleMessage("memo"),
        "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
            "Sunteți sigur că doriți să anulați colecția?"),
        "clipCreate":
            MessageLookupByLibrary.simpleMessage("Noi notițe lipicioase"),
        "clipFavorite":
            MessageLookupByLibrary.simpleMessage("Adăugați la favorite"),
        "clipFavoriteList":
            MessageLookupByLibrary.simpleMessage("marcaj (Internet)"),
        "clipRemove": MessageLookupByLibrary.simpleMessage(
            "Eliminarea notițelor lipicioase"),
        "clipUpdate": MessageLookupByLibrary.simpleMessage(
            "Actualizarea notițelor lipicioase"),
        "clips": MessageLookupByLibrary.simpleMessage("memo"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "confirmSelection": m0,
        "copyContent":
            MessageLookupByLibrary.simpleMessage("Copiați conținutul"),
        "copyLink": MessageLookupByLibrary.simpleMessage("Copiere link"),
        "copyRSS": MessageLookupByLibrary.simpleMessage("Copiere RSS"),
        "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
            "Copiați adresa paginii de pornire a utilizatorului"),
        "copyUsername": MessageLookupByLibrary.simpleMessage(
            "Copiați numele de utilizator"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Dosar nou"),
        "createNote":
            MessageLookupByLibrary.simpleMessage("Postați un nou subiect"),
        "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
            "Crearea de posturi din fișiere"),
        "createNoteHint":
            MessageLookupByLibrary.simpleMessage("Ce s-a întâmplat..."),
        "createdDate": MessageLookupByLibrary.simpleMessage("Data creării"),
        "creationFailedDialog": m1,
        "cw": MessageLookupByLibrary.simpleMessage("conținut ascuns"),
        "day": MessageLookupByLibrary.simpleMessage("zi"),
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("îndepărtarea"),
        "deleteConfirm": m3,
        "deleteFileConfirmation": m4,
        "deleteFolderConfirmation": m5,
        "description": MessageLookupByLibrary.simpleMessage("descrieri"),
        "done": MessageLookupByLibrary.simpleMessage("îndeplinesc"),
        "download": MessageLookupByLibrary.simpleMessage("descărcare"),
        "drive":
            MessageLookupByLibrary.simpleMessage("stocare fișiere în cloud"),
        "durationDay": m6,
        "durationHour": m7,
        "durationMinute": m8,
        "durationSecond": m9,
        "edit": MessageLookupByLibrary.simpleMessage("compilator"),
        "emoji": MessageLookupByLibrary.simpleMessage("emoticon"),
        "enterNewFileName": MessageLookupByLibrary.simpleMessage(
            "Vă rugăm să introduceți un nou nume de fișier"),
        "enterNewTitle": MessageLookupByLibrary.simpleMessage(
            "Vă rugăm să introduceți un titlu nou"),
        "enterUrl": MessageLookupByLibrary.simpleMessage(
            "Vă rugăm să introduceți URL-ul"),
        "exceptionContentNull":
            MessageLookupByLibrary.simpleMessage("Conținutul nu poate fi gol"),
        "exceptionCwNull":
            MessageLookupByLibrary.simpleMessage("Conținutul nu poate fi gol"),
        "exceptionSendNote": m10,
        "explore": MessageLookupByLibrary.simpleMessage("descoperiri"),
        "exploreHot": MessageLookupByLibrary.simpleMessage("în vogă"),
        "exploreUserHot":
            MessageLookupByLibrary.simpleMessage("utilizator popular"),
        "exploreUserLast": MessageLookupByLibrary.simpleMessage(
            "Utilizatori conectați recent"),
        "exploreUserPined": MessageLookupByLibrary.simpleMessage(
            "utilizator în fruntea listei"),
        "exploreUserUpdated":
            MessageLookupByLibrary.simpleMessage("Contribuții recente"),
        "exploreUsers": MessageLookupByLibrary.simpleMessage("utilizator"),
        "favorite": MessageLookupByLibrary.simpleMessage("marcaj (Internet)"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "folderName": MessageLookupByLibrary.simpleMessage("Numele dosarului"),
        "follow": MessageLookupByLibrary.simpleMessage("focalizare"),
        "followed": MessageLookupByLibrary.simpleMessage("Urmărit"),
        "followers": MessageLookupByLibrary.simpleMessage("observator"),
        "following": MessageLookupByLibrary.simpleMessage("Îngrijorat"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("De la netbook"),
        "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
        "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
        "hostnames": MessageLookupByLibrary.simpleMessage("nume de domeniu"),
        "hour": MessageLookupByLibrary.simpleMessage("ore"),
        "hoursAgo": m11,
        "image": MessageLookupByLibrary.simpleMessage("fotografie"),
        "inputServer":
            MessageLookupByLibrary.simpleMessage("Server de intrare manuală"),
        "insertDriverFile":
            MessageLookupByLibrary.simpleMessage("Introducerea accesoriilor"),
        "isFollowingYouNow":
            MessageLookupByLibrary.simpleMessage("Sunt cu ochii pe tine."),
        "justNow": MessageLookupByLibrary.simpleMessage("chiar recent"),
        "keepOriginal":
            MessageLookupByLibrary.simpleMessage("Păstrați imaginea originală"),
        "loadingServers":
            MessageLookupByLibrary.simpleMessage("Server Loading"),
        "local": MessageLookupByLibrary.simpleMessage("această localitate"),
        "localUpload": MessageLookupByLibrary.simpleMessage("încărcare locală"),
        "login": MessageLookupByLibrary.simpleMessage("conectați-vă"),
        "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
        "loginFailed":
            MessageLookupByLibrary.simpleMessage("Eșec de conectare"),
        "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
            "Login eșuat: Crearea aplicației a eșuat"),
        "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
            "Autentificare eșuată: achiziția de jetoane a eșuat"),
        "loginLoading": m12,
        "loginSuccess":
            MessageLookupByLibrary.simpleMessage("Autentificare reușită"),
        "manageAccount":
            MessageLookupByLibrary.simpleMessage("Gestionați contul"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage(
            "Marcați ca conținut sensibil"),
        "mention":
            MessageLookupByLibrary.simpleMessage("a ridica (un subiect)"),
        "minute": MessageLookupByLibrary.simpleMessage("minute"),
        "minutesAgo": m13,
        "monthsAgo": m14,
        "more": MessageLookupByLibrary.simpleMessage("mai mult"),
        "myCLips": MessageLookupByLibrary.simpleMessage("Nota mea."),
        "name": MessageLookupByLibrary.simpleMessage("nume (al unui lucru)"),
        "nameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Numele nu poate fi gol"),
        "next": MessageLookupByLibrary.simpleMessage("pasul următor"),
        "noLists":
            MessageLookupByLibrary.simpleMessage("You don\'t have any lists"),
        "notFindServer":
            MessageLookupByLibrary.simpleMessage("Nu v-ați găsit serverul?"),
        "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
            "Copiați link-ul către acest site"),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("pus deoparte"),
        "noteCwShow":
            MessageLookupByLibrary.simpleMessage("Afișați conținutul"),
        "noteFormLanguageTranslation": m15,
        "noteLocalOnly":
            MessageLookupByLibrary.simpleMessage("Neparticiparea în comun"),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
            "Mergeți la serverul gazdă pentru a afișa"),
        "notePined": MessageLookupByLibrary.simpleMessage("Mesaje de top"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("citat"),
        "noteReNote": MessageLookupByLibrary.simpleMessage(
            "redirecționare (e-mail, SMS, pachete de date)"),
        "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Transmis."),
        "noteTranslate":
            MessageLookupByLibrary.simpleMessage("Traducerea mesajelor"),
        "noteVisibility": MessageLookupByLibrary.simpleMessage("vizibilitate"),
        "noteVisibilityFollowers":
            MessageLookupByLibrary.simpleMessage("observator"),
        "noteVisibilityFollowersText":
            MessageLookupByLibrary.simpleMessage("Trimite doar adepților"),
        "noteVisibilityHome":
            MessageLookupByLibrary.simpleMessage("fig. început"),
        "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
            "Timeline trimis doar la pagina de pornire"),
        "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("deschis"),
        "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
            "Mesajul dvs. va apărea în cronologia globală"),
        "noteVisibilitySpecified":
            MessageLookupByLibrary.simpleMessage("scrisoare privată"),
        "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
            "Trimite numai către utilizatorii specificați"),
        "notes": MessageLookupByLibrary.simpleMessage("card"),
        "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
        "notification": MessageLookupByLibrary.simpleMessage("notificări"),
        "notifications": MessageLookupByLibrary.simpleMessage("notificări"),
        "notifyAll": MessageLookupByLibrary.simpleMessage("complet"),
        "notifyFilter": MessageLookupByLibrary.simpleMessage("screening"),
        "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
            "Cererea dumneavoastră de atenție a fost aprobată."),
        "notifyFollowedYou":
            MessageLookupByLibrary.simpleMessage("Aveți noi adepți."),
        "notifyMarkAllRead":
            MessageLookupByLibrary.simpleMessage("Marcați toate ca citite"),
        "notifyMention": MessageLookupByLibrary.simpleMessage("Vorbind despre"),
        "notifyMessage":
            MessageLookupByLibrary.simpleMessage("scrisoare privată"),
        "notifyNotSupport": m16,
        "ok": MessageLookupByLibrary.simpleMessage("definiție"),
        "openInNewTab": MessageLookupByLibrary.simpleMessage(
            "Mergeți la Afișarea browserului"),
        "overviews": MessageLookupByLibrary.simpleMessage("trece cu vederea"),
        "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
            "Îngrijorări cu privire la acordarea cererilor"),
        "preview": MessageLookupByLibrary.simpleMessage("avanpremiere"),
        "previewNote":
            MessageLookupByLibrary.simpleMessage("Previzualizare postări"),
        "processing":
            MessageLookupByLibrary.simpleMessage("în curs de desfășurare"),
        "public": MessageLookupByLibrary.simpleMessage("deschis"),
        "publish": MessageLookupByLibrary.simpleMessage("post"),
        "reNoteHint":
            MessageLookupByLibrary.simpleMessage("Citând acest post..."),
        "reNoteText": MessageLookupByLibrary.simpleMessage("Post de citare"),
        "reaction": MessageLookupByLibrary.simpleMessage("răspuns"),
        "reactionAccepting": MessageLookupByLibrary.simpleMessage(
            "Acceptarea răspunsurilor Emoji"),
        "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("complet"),
        "reactionAcceptingLikeOnly":
            MessageLookupByLibrary.simpleMessage("Îi place doar"),
        "reactionAcceptingLikeOnlyRemote":
            MessageLookupByLibrary.simpleMessage("Numai la distanță Kudos"),
        "reactionAcceptingNoneSensitive":
            MessageLookupByLibrary.simpleMessage("Numai conținut nesensibil"),
        "reactionAcceptingNoneSensitiveOrLocal":
            MessageLookupByLibrary.simpleMessage(
                "Numai conținut nesensibil (numai pentru aprecieri de la distanță)"),
        "recipient":
            MessageLookupByLibrary.simpleMessage("Către: (antet e-mail)"),
        "refresh": MessageLookupByLibrary.simpleMessage(
            "refresh (fereastra computerului)"),
        "registration": MessageLookupByLibrary.simpleMessage("Registration"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
        "remote": MessageLookupByLibrary.simpleMessage("de la distanță"),
        "rename": MessageLookupByLibrary.simpleMessage("redenumire"),
        "renameFile":
            MessageLookupByLibrary.simpleMessage("Redenumiți fișierul"),
        "renameFolder":
            MessageLookupByLibrary.simpleMessage("Redenumiți un dosar"),
        "replyNoteHint": MessageLookupByLibrary.simpleMessage(
            "Răspundeți la acest mesaj..."),
        "replyNoteText":
            MessageLookupByLibrary.simpleMessage("Răspundeți la o postare"),
        "saveFailed":
            MessageLookupByLibrary.simpleMessage("nu reușesc să salveze"),
        "saveImage": MessageLookupByLibrary.simpleMessage("Salvare imagine"),
        "saveSuccess":
            MessageLookupByLibrary.simpleMessage("Salvați cu succes"),
        "search": MessageLookupByLibrary.simpleMessage("să caute qth."),
        "searchAll": MessageLookupByLibrary.simpleMessage("complet"),
        "searchHost": MessageLookupByLibrary.simpleMessage(
            "Specificați numele domeniului"),
        "searchLocal": MessageLookupByLibrary.simpleMessage("acest site"),
        "searchRemote": MessageLookupByLibrary.simpleMessage("de la distanță"),
        "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
        "secondsAgo": m17,
        "selectHashtag":
            MessageLookupByLibrary.simpleMessage("Selectați eticheta"),
        "selectServer":
            MessageLookupByLibrary.simpleMessage("Please Select Your Server"),
        "selectUser":
            MessageLookupByLibrary.simpleMessage("Selectați utilizatorul"),
        "sensitiveClickShow":
            MessageLookupByLibrary.simpleMessage("Faceți clic pentru a afișa"),
        "sensitiveContent":
            MessageLookupByLibrary.simpleMessage("Conținut sensibil"),
        "serverAddr": MessageLookupByLibrary.simpleMessage("adresa serverului"),
        "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
        "settings": MessageLookupByLibrary.simpleMessage("înființat"),
        "share": MessageLookupByLibrary.simpleMessage(
            "să împărtășească (bucurii, beneficii, privilegii etc.) cu alții"),
        "showConversation":
            MessageLookupByLibrary.simpleMessage("Vezi dialogul"),
        "somebodyNote": MessageLookupByLibrary.simpleMessage(" posturi"),
        "timeline": MessageLookupByLibrary.simpleMessage("cronologie"),
        "timelineGlobal":
            MessageLookupByLibrary.simpleMessage("situația de securitate"),
        "timelineHome": MessageLookupByLibrary.simpleMessage("fig. început"),
        "timelineHybrid": MessageLookupByLibrary.simpleMessage("socializare"),
        "timelineLocal":
            MessageLookupByLibrary.simpleMessage("această localitate"),
        "translate": MessageLookupByLibrary.simpleMessage("redare"),
        "uncategorized": MessageLookupByLibrary.simpleMessage("Fără categorie"),
        "unfollow": MessageLookupByLibrary.simpleMessage("Unfollow"),
        "updatedDate":
            MessageLookupByLibrary.simpleMessage("Data actualizării"),
        "uploadFailed": m18,
        "uploadFromUrl":
            MessageLookupByLibrary.simpleMessage("Încărcare de pe site-ul web"),
        "user": MessageLookupByLibrary.simpleMessage("utilizator"),
        "userAll": MessageLookupByLibrary.simpleMessage("complet"),
        "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
            "Acest utilizator nu s-a prezentat încă"),
        "userFile": MessageLookupByLibrary.simpleMessage("atașament (e-mail)"),
        "userHot": MessageLookupByLibrary.simpleMessage("utilizator"),
        "userNote": MessageLookupByLibrary.simpleMessage("card"),
        "userRegisterBy":
            MessageLookupByLibrary.simpleMessage("înregistrat în"),
        "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
            "Lista de widget-uri (neterminată)"),
        "username": MessageLookupByLibrary.simpleMessage("ID utilizator"),
        "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
        "video": MessageLookupByLibrary.simpleMessage("video"),
        "view": MessageLookupByLibrary.simpleMessage("verificați"),
        "viewMore": MessageLookupByLibrary.simpleMessage("Vezi mai multe"),
        "vote": MessageLookupByLibrary.simpleMessage("referendum"),
        "voteAllCount": m19,
        "voteCount": m20,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("data limită"),
        "voteEnableMultiChoice":
            MessageLookupByLibrary.simpleMessage("Voturi multiple permise"),
        "voteExpired":
            MessageLookupByLibrary.simpleMessage("Votul este închis."),
        "voteNoDueDate": MessageLookupByLibrary.simpleMessage("permanent"),
        "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
            "Numărul de voturi nu poate fi mai mic de două"),
        "voteOptionHint": m21,
        "voteOptionNullIndex": m22,
        "voteResult": MessageLookupByLibrary.simpleMessage(
            "Rezultatele votării au fost generate"),
        "voteWillExpired": m23,
        "yearsAgo": m24
      };
}
