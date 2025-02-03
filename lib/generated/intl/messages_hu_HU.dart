// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a hu_HU locale. All the
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
  String get localeName => 'hu_HU';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Határozza meg ( / )";

  static String m1(error) => "\n\n ${error}A teremtés meghiúsult";

  static String m2(days) => "${days}napokkal ezelőtt";

  static String m3(thing) => "${thing}Szeretné törölni a \" \"?";

  static String m4(name) =>
      "${name}Szeretné törölni a \" \" fájlt? A hozzászólások, amelyekhez ez a fájl csatolva van, szintén törlésre kerülnek.";

  static String m5(name) =>
      "${name}Szeretné törölni a \" \" mappát? Ha van tartalom a mappában, kérjük, először törölje a mappa tartalmát.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Napok órák percek másodpercek";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Órák Percek Másodpercek";

  static String m8(minute, second) => "${minute}${second}Percek másodpercek";

  static String m9(second) =>
      "${second}szög vagy ív egy hatvanad foknak megfelelő egysége";

  static String m10(error) => "\n\n${error}Nem sikerült elküldeni a postát";

  static String m11(hours) => "${hours}órákkal ezelőtt";

  static String m12(server) => "${server}Jelenleg bejelentkezve";

  static String m13(minutes) => "${minutes}percekkel ezelőtt";

  static String m14(months) => "${months}hónapokkal ezelőtt";

  static String m15(language) => "${language} \nFordítás a következőre";

  static String m16(type) => "${type}Nem támogatott értesítési típusok:";

  static String m17(seconds) => "${seconds}másodpercekkel ezelőtt";

  static String m18(msg) => "\n ${msg}A feltöltés sikertelen";

  static String m19(count) => "${count}Összes szavazat";

  static String m20(count) => "${count}váltságdíjért fogva tartott személy";

  static String m21(index) => "${index}Opciók";

  static String m22(index) => "${index}Az opció nem lehet üres";

  static String m23(datetime) => "${datetime}a befejezés utáni határidő";

  static String m24(years) => "${years}...évvel ezelőtt";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("felhasználónév"),
        "add": MessageLookupByLibrary.simpleMessage("növelje a  címet."),
        "addAccount": MessageLookupByLibrary.simpleMessage("Számla hozzáadása"),
        "addFile": MessageLookupByLibrary.simpleMessage("Fájl hozzáadása"),
        "addTitle": MessageLookupByLibrary.simpleMessage("Cím hozzáadása"),
        "all": MessageLookupByLibrary.simpleMessage("teljes"),
        "announcementActive":
            MessageLookupByLibrary.simpleMessage("Bejelentés most"),
        "announcementExpired":
            MessageLookupByLibrary.simpleMessage("Korábbi bejelentések"),
        "announcements": MessageLookupByLibrary.simpleMessage("Hírlevél"),
        "back": MessageLookupByLibrary.simpleMessage(
            "visszajönni (vagy visszamenni)"),
        "cancel": MessageLookupByLibrary.simpleMessage("törlések"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage(
            "Érzékeny tartalmak megjelölésének törlése"),
        "clip": MessageLookupByLibrary.simpleMessage("memo"),
        "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
            "Biztos, hogy le akarja mondani a gyűjtést?"),
        "clipCreate":
            MessageLookupByLibrary.simpleMessage("Új öntapadós jegyzetek"),
        "clipFavorite":
            MessageLookupByLibrary.simpleMessage("Hozzáadás a kedvencekhez"),
        "clipFavoriteList":
            MessageLookupByLibrary.simpleMessage("könyvjelző (Internet)"),
        "clipRemove": MessageLookupByLibrary.simpleMessage(
            "Öntapadós jegyzetek eltávolítása"),
        "clipUpdate": MessageLookupByLibrary.simpleMessage(
            "Frissítés öntapadós jegyzetek"),
        "clips": MessageLookupByLibrary.simpleMessage("memo"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "confirmSelection": m0,
        "copyContent":
            MessageLookupByLibrary.simpleMessage("Tartalom másolása"),
        "copyLink": MessageLookupByLibrary.simpleMessage("Link másolása"),
        "copyRSS": MessageLookupByLibrary.simpleMessage("RSS másolása"),
        "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
            "A felhasználó honlapjának címének másolása"),
        "copyUsername":
            MessageLookupByLibrary.simpleMessage("Felhasználónév másolása"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Új mappa"),
        "createNote":
            MessageLookupByLibrary.simpleMessage("Új téma közzététele"),
        "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
            "Hozzászólások létrehozása fájlokból"),
        "createNoteHint": MessageLookupByLibrary.simpleMessage("Mi történt..."),
        "createdDate":
            MessageLookupByLibrary.simpleMessage("A létrehozás dátuma"),
        "creationFailedDialog": m1,
        "cw": MessageLookupByLibrary.simpleMessage("rejtett tartalom"),
        "day": MessageLookupByLibrary.simpleMessage("nap"),
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("a  eltávolítása"),
        "deleteConfirm": m3,
        "deleteFileConfirmation": m4,
        "deleteFolderConfirmation": m5,
        "description": MessageLookupByLibrary.simpleMessage("leírások"),
        "done": MessageLookupByLibrary.simpleMessage("teljesíteni"),
        "download": MessageLookupByLibrary.simpleMessage("letöltés"),
        "drive": MessageLookupByLibrary.simpleMessage("felhőalapú fájltárolás"),
        "durationDay": m6,
        "durationHour": m7,
        "durationMinute": m8,
        "durationSecond": m9,
        "edit": MessageLookupByLibrary.simpleMessage("fordító"),
        "emoji": MessageLookupByLibrary.simpleMessage("emoticon"),
        "enterNewFileName": MessageLookupByLibrary.simpleMessage(
            "Kérjük, adjon meg egy új fájlnevet"),
        "enterNewTitle": MessageLookupByLibrary.simpleMessage(
            "Kérjük, adjon meg egy új címet"),
        "enterUrl":
            MessageLookupByLibrary.simpleMessage("Kérjük, adja meg az URL-t"),
        "exceptionContentNull":
            MessageLookupByLibrary.simpleMessage("A tartalom nem lehet üres"),
        "exceptionCwNull":
            MessageLookupByLibrary.simpleMessage("A tartalom nem lehet üres"),
        "exceptionSendNote": m10,
        "explore": MessageLookupByLibrary.simpleMessage("felfedezések"),
        "exploreHot": MessageLookupByLibrary.simpleMessage("divatban"),
        "exploreUserHot":
            MessageLookupByLibrary.simpleMessage("népszerű felhasználó"),
        "exploreUserLast": MessageLookupByLibrary.simpleMessage(
            "Nemrég bejelentkezett felhasználók"),
        "exploreUserPined":
            MessageLookupByLibrary.simpleMessage("felhasználó a lista elején"),
        "exploreUserUpdated":
            MessageLookupByLibrary.simpleMessage("Legutóbbi hozzájárulók"),
        "exploreUsers": MessageLookupByLibrary.simpleMessage("felhasználó"),
        "favorite":
            MessageLookupByLibrary.simpleMessage("könyvjelző (Internet)"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "folderName": MessageLookupByLibrary.simpleMessage("Mappa neve"),
        "follow": MessageLookupByLibrary.simpleMessage("fókusz"),
        "followed": MessageLookupByLibrary.simpleMessage("Követett"),
        "followers": MessageLookupByLibrary.simpleMessage("watcher"),
        "following": MessageLookupByLibrary.simpleMessage("Aggódó"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("A netbookról"),
        "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
        "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
        "hostnames": MessageLookupByLibrary.simpleMessage("domain név"),
        "hour": MessageLookupByLibrary.simpleMessage("órák"),
        "hoursAgo": m11,
        "image": MessageLookupByLibrary.simpleMessage("fénykép"),
        "inputServer":
            MessageLookupByLibrary.simpleMessage("Kézi beviteli szerver"),
        "insertDriverFile":
            MessageLookupByLibrary.simpleMessage("Tartozékok behelyezése"),
        "isFollowingYouNow":
            MessageLookupByLibrary.simpleMessage("Figyellek téged."),
        "justNow": MessageLookupByLibrary.simpleMessage("nemrég"),
        "keepOriginal":
            MessageLookupByLibrary.simpleMessage("Az eredeti kép megőrzése"),
        "loadingServers":
            MessageLookupByLibrary.simpleMessage("Server Loading"),
        "local": MessageLookupByLibrary.simpleMessage("ez a helység"),
        "localUpload": MessageLookupByLibrary.simpleMessage("helyi feltöltés"),
        "login": MessageLookupByLibrary.simpleMessage("bejelentkezés"),
        "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
        "loginFailed":
            MessageLookupByLibrary.simpleMessage("Bejelentkezési hiba"),
        "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
            "Sikertelen bejelentkezés: Az alkalmazás létrehozása sikertelen"),
        "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
            "A bejelentkezés sikertelen: a token megszerzése sikertelen"),
        "loginLoading": m12,
        "loginSuccess":
            MessageLookupByLibrary.simpleMessage("Bejelentkezés sikeres"),
        "manageAccount":
            MessageLookupByLibrary.simpleMessage("Számla kezelése"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage(
            "Érzékeny tartalomként megjelölni"),
        "mention":
            MessageLookupByLibrary.simpleMessage("felemelni (egy tárgyat)"),
        "minute": MessageLookupByLibrary.simpleMessage("percek"),
        "minutesAgo": m13,
        "monthsAgo": m14,
        "more": MessageLookupByLibrary.simpleMessage("további"),
        "myCLips": MessageLookupByLibrary.simpleMessage("Az én megjegyzésem."),
        "name": MessageLookupByLibrary.simpleMessage("név (egy dolog neve)"),
        "nameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("A név nem lehet üres"),
        "next": MessageLookupByLibrary.simpleMessage("a következő lépés"),
        "noLists":
            MessageLookupByLibrary.simpleMessage("You don\'t have any lists"),
        "notFindServer":
            MessageLookupByLibrary.simpleMessage("Nem találta a szerverét?"),
        "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
            "Másolja a linket erre az oldalra"),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("elrakni"),
        "noteCwShow":
            MessageLookupByLibrary.simpleMessage("Tartalom megjelenítése"),
        "noteFormLanguageTranslation": m15,
        "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
            "A közös munkában való részvétel hiánya"),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
            "Menjen a gazdaszerverre a megjelenítéshez"),
        "notePined":
            MessageLookupByLibrary.simpleMessage("Legjobb hozzászólások"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("idézet"),
        "noteReNote": MessageLookupByLibrary.simpleMessage(
            "továbbítás (levelek, SMS-ek, adatcsomagok)"),
        "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Továbbítva."),
        "noteTranslate":
            MessageLookupByLibrary.simpleMessage("A hozzászólások fordítása"),
        "noteVisibility": MessageLookupByLibrary.simpleMessage("láthatóság"),
        "noteVisibilityFollowers":
            MessageLookupByLibrary.simpleMessage("watcher"),
        "noteVisibilityFollowersText":
            MessageLookupByLibrary.simpleMessage("Csak követőknek küldje el"),
        "noteVisibilityHome":
            MessageLookupByLibrary.simpleMessage("ábra kezdet"),
        "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
            "Csak a kezdőlapra küldött idővonal"),
        "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("nyíltan"),
        "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
            "A posztod megjelenik a globális idővonalon"),
        "noteVisibilitySpecified":
            MessageLookupByLibrary.simpleMessage("magánlevél"),
        "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
            "Csak megadott felhasználóknak küldés"),
        "notes": MessageLookupByLibrary.simpleMessage("kártya"),
        "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
        "notification": MessageLookupByLibrary.simpleMessage("értesítések"),
        "notifications": MessageLookupByLibrary.simpleMessage("értesítések"),
        "notifyAll": MessageLookupByLibrary.simpleMessage("teljes"),
        "notifyFilter": MessageLookupByLibrary.simpleMessage("szűrés"),
        "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
            "A figyelemfelhívást jóváhagyták."),
        "notifyFollowedYou":
            MessageLookupByLibrary.simpleMessage("Új követőid vannak."),
        "notifyMarkAllRead":
            MessageLookupByLibrary.simpleMessage("Mindent olvasottnak jelölni"),
        "notifyMention": MessageLookupByLibrary.simpleMessage("Ha már az én"),
        "notifyMessage": MessageLookupByLibrary.simpleMessage("magánlevél"),
        "notifyNotSupport": m16,
        "ok": MessageLookupByLibrary.simpleMessage("define"),
        "openInNewTab": MessageLookupByLibrary.simpleMessage(
            "Menjen a böngésző megjelenítéséhez"),
        "overviews": MessageLookupByLibrary.simpleMessage("átfutni"),
        "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
            "A kérelmek teljesítésével kapcsolatos aggályok"),
        "preview": MessageLookupByLibrary.simpleMessage("előnézetek"),
        "previewNote":
            MessageLookupByLibrary.simpleMessage("Előnézet Hozzászólások"),
        "processing": MessageLookupByLibrary.simpleMessage("folyamatban"),
        "public": MessageLookupByLibrary.simpleMessage("nyíltan"),
        "publish": MessageLookupByLibrary.simpleMessage("post"),
        "reNoteHint": MessageLookupByLibrary.simpleMessage(
            "Idézem ezt a hozzászólást..."),
        "reNoteText": MessageLookupByLibrary.simpleMessage("Idézet Post"),
        "reaction": MessageLookupByLibrary.simpleMessage("válasz"),
        "reactionAccepting":
            MessageLookupByLibrary.simpleMessage("Emoji válaszok elfogadása"),
        "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("teljes"),
        "reactionAcceptingLikeOnly":
            MessageLookupByLibrary.simpleMessage("Csak szereti"),
        "reactionAcceptingLikeOnlyRemote":
            MessageLookupByLibrary.simpleMessage("Csak távoli Kudos"),
        "reactionAcceptingNoneSensitive":
            MessageLookupByLibrary.simpleMessage("Csak nem érzékeny tartalom"),
        "reactionAcceptingNoneSensitiveOrLocal":
            MessageLookupByLibrary.simpleMessage(
                "Csak nem érzékeny tartalom (csak távoli kedvelők)"),
        "recipient":
            MessageLookupByLibrary.simpleMessage("To: (e-mail fejléc)"),
        "refresh": MessageLookupByLibrary.simpleMessage(
            "frissítés (számítógép ablak)"),
        "registration": MessageLookupByLibrary.simpleMessage("Registration"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
        "remote": MessageLookupByLibrary.simpleMessage("távolról"),
        "rename": MessageLookupByLibrary.simpleMessage("átnevezni"),
        "renameFile": MessageLookupByLibrary.simpleMessage("Fájl átnevezése"),
        "renameFolder":
            MessageLookupByLibrary.simpleMessage("Mappa átnevezése"),
        "replyNoteHint": MessageLookupByLibrary.simpleMessage(
            "Válaszolj erre a bejegyzésre..."),
        "replyNoteText":
            MessageLookupByLibrary.simpleMessage("Válasz egy bejegyzésre"),
        "saveFailed": MessageLookupByLibrary.simpleMessage("nem menteni"),
        "saveImage": MessageLookupByLibrary.simpleMessage("Kép mentése"),
        "saveSuccess": MessageLookupByLibrary.simpleMessage("Sikeres mentés"),
        "search": MessageLookupByLibrary.simpleMessage("keresni valamit"),
        "searchAll": MessageLookupByLibrary.simpleMessage("teljes"),
        "searchHost":
            MessageLookupByLibrary.simpleMessage("Domainnév megadása"),
        "searchLocal": MessageLookupByLibrary.simpleMessage("ez az oldal"),
        "searchRemote": MessageLookupByLibrary.simpleMessage("távolról"),
        "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
        "secondsAgo": m17,
        "selectHashtag":
            MessageLookupByLibrary.simpleMessage("Címke kiválasztása"),
        "selectServer":
            MessageLookupByLibrary.simpleMessage("Please Select Your Server"),
        "selectUser":
            MessageLookupByLibrary.simpleMessage("Felhasználó kiválasztása"),
        "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
            "Kattintson a megjelenítéshez"),
        "sensitiveContent":
            MessageLookupByLibrary.simpleMessage("Érzékeny tartalom"),
        "serverAddr": MessageLookupByLibrary.simpleMessage("kiszolgáló címe"),
        "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
        "settings": MessageLookupByLibrary.simpleMessage("felállítása"),
        "share": MessageLookupByLibrary.simpleMessage(
            "megosztani (örömök, előnyök, kiváltságok stb.) másokkal"),
        "showConversation":
            MessageLookupByLibrary.simpleMessage("Párbeszéd megtekintése"),
        "somebodyNote": MessageLookupByLibrary.simpleMessage(" hozzászólások"),
        "timeline": MessageLookupByLibrary.simpleMessage("idővonal"),
        "timelineGlobal":
            MessageLookupByLibrary.simpleMessage("biztonsági helyzet"),
        "timelineHome": MessageLookupByLibrary.simpleMessage("ábra kezdet"),
        "timelineHybrid": MessageLookupByLibrary.simpleMessage("szocializáció"),
        "timelineLocal": MessageLookupByLibrary.simpleMessage("ez a helység"),
        "translate": MessageLookupByLibrary.simpleMessage("renderelés"),
        "uncategorized":
            MessageLookupByLibrary.simpleMessage("Nem kategorizált"),
        "unfollow": MessageLookupByLibrary.simpleMessage("Unfollow"),
        "updatedDate": MessageLookupByLibrary.simpleMessage("Frissítés dátuma"),
        "uploadFailed": m18,
        "uploadFromUrl":
            MessageLookupByLibrary.simpleMessage("Feltöltés a weboldalról"),
        "user": MessageLookupByLibrary.simpleMessage("felhasználó"),
        "userAll": MessageLookupByLibrary.simpleMessage("teljes"),
        "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
            "Ez a felhasználó még nem mutatkozott be"),
        "userFile": MessageLookupByLibrary.simpleMessage("melléklet (e-mail)"),
        "userHot": MessageLookupByLibrary.simpleMessage("felhasználó"),
        "userNote": MessageLookupByLibrary.simpleMessage("kártya"),
        "userRegisterBy": MessageLookupByLibrary.simpleMessage("bejegyezve"),
        "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
            "Widgetek listája (befejezetlen)"),
        "username":
            MessageLookupByLibrary.simpleMessage("felhasználói azonosító"),
        "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
        "video": MessageLookupByLibrary.simpleMessage("videó"),
        "view": MessageLookupByLibrary.simpleMessage("nézd meg"),
        "viewMore": MessageLookupByLibrary.simpleMessage("Bővebben"),
        "vote": MessageLookupByLibrary.simpleMessage("népszavazás"),
        "voteAllCount": m19,
        "voteCount": m20,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("határnap"),
        "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
            "Több szavazat leadása megengedett"),
        "voteExpired":
            MessageLookupByLibrary.simpleMessage("A szavazás lezárult."),
        "voteNoDueDate": MessageLookupByLibrary.simpleMessage("állandóan"),
        "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
            "A szavazatok száma nem lehet kevesebb kettőnél"),
        "voteOptionHint": m21,
        "voteOptionNullIndex": m22,
        "voteResult": MessageLookupByLibrary.simpleMessage(
            "A szavazás eredményei elkészültek"),
        "voteWillExpired": m23,
        "yearsAgo": m24
      };
}
