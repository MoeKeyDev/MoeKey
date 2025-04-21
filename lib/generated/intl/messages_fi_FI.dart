// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fi_FI locale. All the
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
  String get localeName => 'fi_FI';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Määritä ( / )";

  static String m1(error) => "\n\n ${error}Luominen epäonnistui";

  static String m2(days) => "${days}päivää sitten";

  static String m3(thing) => "${thing}Haluatko poistaa \" \"?";

  static String m4(name) =>
      "${name}Haluatko poistaa tiedoston \" \"? Viestit, joihin on liitetty tämä tiedosto, poistetaan myös.";

  static String m5(name) =>
      "${name}Haluatko poistaa kansion \" \"? Jos kansiossa on sisältöä, poista ensin kansion sisältö.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Päivät tunnit minuutit sekunnit";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Tunnit Minuutit Sekunnit";

  static String m8(minute, second) => "${minute}${second}Minuutit sekunnit";

  static String m9(second) =>
      "${second}kulman tai kaaren yksikkö, joka vastaa yhtä asteen kuudeskymmenesosaa.";

  static String m10(error) => "\n\n${error}Postin lähettäminen epäonnistui";

  static String m11(hours) => "${hours}tuntia sitten";

  static String m12(server) => "${server}Tällä hetkellä kirjautuneena sisään";

  static String m13(minutes) => "${minutes}minuuttia sitten";

  static String m14(months) => "${months}kuukautta sitten";

  static String m15(language) => "${language} \nKäännä from to";

  static String m16(type) => "${type}Ei tuettuja ilmoitustyyppejä:";

  static String m17(seconds) => "${seconds}sekuntia sitten";

  static String m18(msg) => "\n ${msg}Lataus epäonnistui";

  static String m19(count) => "${count}Ääniä yhteensä";

  static String m20(count) => "${count}lunnaita vastaan pidetty henkilö";

  static String m21(index) => "${index}Vaihtoehdot";

  static String m22(index) => "${index}Vaihtoehto ei voi olla tyhjä";

  static String m23(datetime) => "${datetime}valmistumisen jälkeinen määräaika";

  static String m24(years) => "${years}...vuotta sitten";

  final messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("käyttäjätunnus"),
        "add": MessageLookupByLibrary.simpleMessage("lisätä"),
        "addAccount": MessageLookupByLibrary.simpleMessage("Lisää tili"),
        "addFile": MessageLookupByLibrary.simpleMessage("Lisää tiedosto"),
        "addTitle": MessageLookupByLibrary.simpleMessage("Lisää otsikko"),
        "all": MessageLookupByLibrary.simpleMessage("full"),
        "announcementActive":
            MessageLookupByLibrary.simpleMessage("Ilmoitus nyt"),
        "announcementExpired": MessageLookupByLibrary.simpleMessage(
          "Aiemmat ilmoitukset",
        ),
        "announcements": MessageLookupByLibrary.simpleMessage("Tiedote"),
        "back":
            MessageLookupByLibrary.simpleMessage("tulla (tai mennä) takaisin"),
        "cancel": MessageLookupByLibrary.simpleMessage("peruutukset"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage(
          "Arkaluonteisen sisällön lipun poistaminen",
        ),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "clip": MessageLookupByLibrary.simpleMessage("muistio"),
        "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
          "Haluatko varmasti peruuttaa keräyksen?",
        ),
        "clipCreate":
            MessageLookupByLibrary.simpleMessage("Uudet muistiinpanot"),
        "clipFavorite":
            MessageLookupByLibrary.simpleMessage("Lisää suosikkeihin"),
        "clipFavoriteList": MessageLookupByLibrary.simpleMessage(
          "kirjanmerkki (Internet)",
        ),
        "clipRemove": MessageLookupByLibrary.simpleMessage(
          "Poista tahmeat muistiinpanot",
        ),
        "clipUpdate":
            MessageLookupByLibrary.simpleMessage("Päivitä muistiinpanot"),
        "clips": MessageLookupByLibrary.simpleMessage("muistio"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "confirmSelection": m0,
        "copyContent": MessageLookupByLibrary.simpleMessage("Kopioi sisältö"),
        "copyLink": MessageLookupByLibrary.simpleMessage("Kopioi linkki"),
        "copyRSS": MessageLookupByLibrary.simpleMessage("Kopioi RSS"),
        "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
          "Kopioi käyttäjän kotisivun osoite.",
        ),
        "copyUsername": MessageLookupByLibrary.simpleMessage(
          "Kopioi käyttäjätunnus",
        ),
        "createFolder": MessageLookupByLibrary.simpleMessage("Uusi kansio"),
        "createNote": MessageLookupByLibrary.simpleMessage(
          "Lähetä uusi viestiketju",
        ),
        "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
          "Postin luominen tiedostosta",
        ),
        "createNoteHint":
            MessageLookupByLibrary.simpleMessage("Mitä tapahtui..."),
        "createdDate": MessageLookupByLibrary.simpleMessage("Luontipäivämäärä"),
        "creationFailedDialog": m1,
        "cw": MessageLookupByLibrary.simpleMessage("piilotettu sisältö"),
        "day": MessageLookupByLibrary.simpleMessage("päivä"),
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("poistaminen"),
        "deleteConfirm": m3,
        "deleteFileConfirmation": m4,
        "deleteFolderConfirmation": m5,
        "description": MessageLookupByLibrary.simpleMessage("kuvaukset"),
        "done": MessageLookupByLibrary.simpleMessage("täyttää"),
        "download": MessageLookupByLibrary.simpleMessage("lataaminen"),
        "drive":
            MessageLookupByLibrary.simpleMessage("pilvitiedostojen tallennus"),
        "durationDay": m6,
        "durationHour": m7,
        "durationMinute": m8,
        "durationSecond": m9,
        "edit": MessageLookupByLibrary.simpleMessage("kääntäjä"),
        "emoji": MessageLookupByLibrary.simpleMessage("emoticon"),
        "enterNewFileName": MessageLookupByLibrary.simpleMessage(
          "Anna uusi tiedostonimi",
        ),
        "enterNewTitle": MessageLookupByLibrary.simpleMessage(
          "Kirjoita uusi otsikko",
        ),
        "enterUrl": MessageLookupByLibrary.simpleMessage("Kirjoita URL-osoite"),
        "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
          "Sisältö ei voi olla tyhjä",
        ),
        "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
          "Sisältö ei voi olla tyhjä",
        ),
        "exceptionSendNote": m10,
        "explore": MessageLookupByLibrary.simpleMessage("löytöjä"),
        "exploreHot": MessageLookupByLibrary.simpleMessage("muodissa"),
        "exploreUserHot":
            MessageLookupByLibrary.simpleMessage("suosittu käyttäjä"),
        "exploreUserLast": MessageLookupByLibrary.simpleMessage(
          "Viimeksi kirjautuneet käyttäjät",
        ),
        "exploreUserPined": MessageLookupByLibrary.simpleMessage(
          "käyttäjä listan kärjessä",
        ),
        "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
          "Viimeaikaiset avustajat",
        ),
        "exploreUsers": MessageLookupByLibrary.simpleMessage("käyttäjä"),
        "favorite":
            MessageLookupByLibrary.simpleMessage("kirjanmerkki (Internet)"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "folderName": MessageLookupByLibrary.simpleMessage("Kansion nimi"),
        "follow": MessageLookupByLibrary.simpleMessage("focus"),
        "followed": MessageLookupByLibrary.simpleMessage("Seurattu"),
        "followers": MessageLookupByLibrary.simpleMessage("watcher"),
        "following": MessageLookupByLibrary.simpleMessage("Huolestunut"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("Netbookista"),
        "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
        "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
        "hostnames": MessageLookupByLibrary.simpleMessage("verkkotunnus"),
        "hour": MessageLookupByLibrary.simpleMessage("tuntia"),
        "hoursAgo": m11,
        "image": MessageLookupByLibrary.simpleMessage("valokuva"),
        "inputServer": MessageLookupByLibrary.simpleMessage(
          "Manuaalinen syöttöpalvelin",
        ),
        "insertDriverFile": MessageLookupByLibrary.simpleMessage(
          "Lisävarusteiden asettaminen paikalleen",
        ),
        "isFollowingYouNow": MessageLookupByLibrary.simpleMessage(
          "Minä katson sinua.",
        ),
        "justNow": MessageLookupByLibrary.simpleMessage("juuri äskettäin"),
        "keepOriginal": MessageLookupByLibrary.simpleMessage(
          "Säilytä alkuperäinen kuva",
        ),
        "loadingServers":
            MessageLookupByLibrary.simpleMessage("Server Loading"),
        "local": MessageLookupByLibrary.simpleMessage("tämä paikkakunta"),
        "localUpload":
            MessageLookupByLibrary.simpleMessage("paikallinen lataus"),
        "login": MessageLookupByLibrary.simpleMessage("kirjaudu sisään"),
        "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
        "loginFailed": MessageLookupByLibrary.simpleMessage(
          "Kirjautumisen epäonnistuminen",
        ),
        "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
          "Kirjautuminen epäonnistui: Sovelluksen luominen epäonnistui",
        ),
        "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
          "Sisäänkirjautuminen epäonnistui: Tokenin hankinta epäonnistui",
        ),
        "loginLoading": m12,
        "loginSuccess": MessageLookupByLibrary.simpleMessage(
          "Sisäänkirjautuminen onnistui",
        ),
        "manageAccount": MessageLookupByLibrary.simpleMessage("Hallitse tiliä"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage(
          "Merkitse arkaluontoiseksi sisällöksi",
        ),
        "mention": MessageLookupByLibrary.simpleMessage("nostaa (aihe)"),
        "minute": MessageLookupByLibrary.simpleMessage("minuuttia"),
        "minutesAgo": m13,
        "monthsAgo": m14,
        "more": MessageLookupByLibrary.simpleMessage("lisää"),
        "myCLips": MessageLookupByLibrary.simpleMessage("Minun huomautukseni."),
        "name":
            MessageLookupByLibrary.simpleMessage("nimi (jonkin asian nimi)"),
        "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
          "Nimi ei voi olla tyhjä",
        ),
        "next": MessageLookupByLibrary.simpleMessage("seuraava askel"),
        "noLists": MessageLookupByLibrary.simpleMessage(
          "You don\'t have any lists",
        ),
        "notFindServer": MessageLookupByLibrary.simpleMessage(
          "Etkö löytänyt palvelintasi?",
        ),
        "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
          "Kopioi linkki tälle sivustolle",
        ),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("laittaa pois"),
        "noteCwShow": MessageLookupByLibrary.simpleMessage("Näytä sisältö"),
        "noteFormLanguageTranslation": m15,
        "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
          "Osallistumattomuus yhteiseen",
        ),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
          "Siirry isäntäpalvelimelle näyttämään",
        ),
        "notePined": MessageLookupByLibrary.simpleMessage("Top Posts"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("quote"),
        "noteReNote": MessageLookupByLibrary.simpleMessage(
          "edelleenlähetys (posti, tekstiviestit, datapaketit)",
        ),
        "noteReNoteByUser": MessageLookupByLibrary.simpleMessage(
          "Lähetetty eteenpäin.",
        ),
        "noteTranslate":
            MessageLookupByLibrary.simpleMessage("Virkojen käännös"),
        "noteVisibility": MessageLookupByLibrary.simpleMessage("näkyvyys"),
        "noteVisibilityFollowers":
            MessageLookupByLibrary.simpleMessage("watcher"),
        "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
          "Lähetä vain seuraajille",
        ),
        "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("kuva alku"),
        "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
          "Aikajana lähetetään vain etusivulle",
        ),
        "noteVisibilityPublic":
            MessageLookupByLibrary.simpleMessage("avoimesti"),
        "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
          "Postauksesi näkyy globaalilla aikajanalla",
        ),
        "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
          "yksityinen kirje",
        ),
        "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
          "Lähetä vain tietyille käyttäjille",
        ),
        "notes": MessageLookupByLibrary.simpleMessage("kortti"),
        "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
        "notification": MessageLookupByLibrary.simpleMessage("ilmoitukset"),
        "notifications": MessageLookupByLibrary.simpleMessage("ilmoitukset"),
        "notifyAll": MessageLookupByLibrary.simpleMessage("full"),
        "notifyFilter": MessageLookupByLibrary.simpleMessage("seulonta"),
        "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
          "Pyyntösi huomiosta on hyväksytty.",
        ),
        "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
          "Sinulla on uusia seuraajia.",
        ),
        "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
          "Merkitse kaikki luetuiksi",
        ),
        "notifyMention":
            MessageLookupByLibrary.simpleMessage("Puhuttaessa minun"),
        "notifyMessage":
            MessageLookupByLibrary.simpleMessage("yksityinen kirje"),
        "notifyNotSupport": m16,
        "ok": MessageLookupByLibrary.simpleMessage("define"),
        "openInNewTab": MessageLookupByLibrary.simpleMessage(
          "Siirry selaimen näyttöön",
        ),
        "overviews": MessageLookupByLibrary.simpleMessage("selata läpi"),
        "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
          "Huoli pyyntöjen hyväksymisestä",
        ),
        "preview": MessageLookupByLibrary.simpleMessage("esikatselut"),
        "previewNote":
            MessageLookupByLibrary.simpleMessage("Esikatselu Viestit"),
        "processing": MessageLookupByLibrary.simpleMessage("käynnissä"),
        "public": MessageLookupByLibrary.simpleMessage("avoimesti"),
        "publish": MessageLookupByLibrary.simpleMessage("post"),
        "reNoteHint": MessageLookupByLibrary.simpleMessage(
          "Lainaan tätä viestiä...",
        ),
        "reNoteText": MessageLookupByLibrary.simpleMessage("Lainaa viestiä"),
        "reaction": MessageLookupByLibrary.simpleMessage("vastaus"),
        "reactionAccepting": MessageLookupByLibrary.simpleMessage(
          "Emoji-vastausten hyväksyminen",
        ),
        "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("full"),
        "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
          "Tykkää vain",
        ),
        "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
          "Vain kaukosäädin Kudos",
        ),
        "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
          "Ainoastaan ei-herkkä sisältö",
        ),
        "reactionAcceptingNoneSensitiveOrLocal":
            MessageLookupByLibrary.simpleMessage(
          "Vain ei-herkkä sisältö (vain etätykkäykset)",
        ),
        "recipient": MessageLookupByLibrary.simpleMessage(
          "To: (sähköpostin otsikko)",
        ),
        "refresh": MessageLookupByLibrary.simpleMessage(
          "refresh (tietokoneen ikkuna)",
        ),
        "registration": MessageLookupByLibrary.simpleMessage("Registration"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
        "remote": MessageLookupByLibrary.simpleMessage("etäisyys"),
        "rename": MessageLookupByLibrary.simpleMessage("nimetä uudelleen"),
        "renameFile": MessageLookupByLibrary.simpleMessage(
          "Nimeä tiedosto uudelleen",
        ),
        "renameFolder": MessageLookupByLibrary.simpleMessage(
          "Nimeä kansio uudelleen",
        ),
        "replyNoteHint": MessageLookupByLibrary.simpleMessage(
          "Vastaa tähän viestiin...",
        ),
        "replyNoteText":
            MessageLookupByLibrary.simpleMessage("Vastaa viestiin"),
        "saveFailed":
            MessageLookupByLibrary.simpleMessage("ei onnistu säästämään"),
        "saveImage": MessageLookupByLibrary.simpleMessage("Tallenna kuva"),
        "saveSuccess":
            MessageLookupByLibrary.simpleMessage("Tallenna onnistunut"),
        "search": MessageLookupByLibrary.simpleMessage("etsiä mitä tahansa"),
        "searchAll": MessageLookupByLibrary.simpleMessage("full"),
        "searchHost":
            MessageLookupByLibrary.simpleMessage("Määritä verkkotunnus"),
        "searchLocal": MessageLookupByLibrary.simpleMessage("tämä sivusto"),
        "searchRemote": MessageLookupByLibrary.simpleMessage("etänä"),
        "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
        "secondsAgo": m17,
        "selectHashtag": MessageLookupByLibrary.simpleMessage("Valitse Tag"),
        "selectServer": MessageLookupByLibrary.simpleMessage(
          "Please Select Your Server",
        ),
        "selectUser": MessageLookupByLibrary.simpleMessage("Valitse käyttäjä"),
        "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
          "Klikkaa näyttääksesi",
        ),
        "sensitiveContent": MessageLookupByLibrary.simpleMessage(
          "Arkaluonteinen sisältö",
        ),
        "serverAddr": MessageLookupByLibrary.simpleMessage("palvelimen osoite"),
        "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
        "settings": MessageLookupByLibrary.simpleMessage("perustaminen"),
        "share": MessageLookupByLibrary.simpleMessage(
          "jakaa (ilot, edut, etuoikeudet jne.) muiden kanssa.",
        ),
        "showConversation": MessageLookupByLibrary.simpleMessage(
          "Näytä vuoropuhelu",
        ),
        "somebodyNote": MessageLookupByLibrary.simpleMessage(" virat"),
        "timeline": MessageLookupByLibrary.simpleMessage("Aikajana"),
        "timelineGlobal": MessageLookupByLibrary.simpleMessage(
          "turvallisuustilanne",
        ),
        "timelineHome": MessageLookupByLibrary.simpleMessage("kuva alku"),
        "timelineHybrid": MessageLookupByLibrary.simpleMessage("sosialisaatio"),
        "timelineLocal":
            MessageLookupByLibrary.simpleMessage("tämä paikkakunta"),
        "translate": MessageLookupByLibrary.simpleMessage("renderointi"),
        "uncategorized":
            MessageLookupByLibrary.simpleMessage("Luokittelematon"),
        "unfollow": MessageLookupByLibrary.simpleMessage("Unfollow"),
        "updatedDate":
            MessageLookupByLibrary.simpleMessage("Päivityspäivämäärä"),
        "uploadFailed": m18,
        "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
          "Lataus verkkosivulta",
        ),
        "user": MessageLookupByLibrary.simpleMessage("käyttäjä"),
        "userAll": MessageLookupByLibrary.simpleMessage("full"),
        "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
          "Tämä käyttäjä ei ole vielä esitellyt itseään",
        ),
        "userFile": MessageLookupByLibrary.simpleMessage(
          "liitetiedosto (sähköposti)",
        ),
        "userHot": MessageLookupByLibrary.simpleMessage("käyttäjä"),
        "userNote": MessageLookupByLibrary.simpleMessage("kortti"),
        "userRegisterBy": MessageLookupByLibrary.simpleMessage("rekisteröity"),
        "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
          "Luettelo widgeteistä (keskeneräinen)",
        ),
        "username": MessageLookupByLibrary.simpleMessage("käyttäjätunnus"),
        "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
        "video": MessageLookupByLibrary.simpleMessage("video"),
        "view": MessageLookupByLibrary.simpleMessage("tsekkaa"),
        "viewMore": MessageLookupByLibrary.simpleMessage("Näytä lisää"),
        "vote": MessageLookupByLibrary.simpleMessage("kansanäänestys"),
        "voteAllCount": m19,
        "voteCount": m20,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("päättymispäivä"),
        "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
          "Useita ääniä sallittu",
        ),
        "voteExpired": MessageLookupByLibrary.simpleMessage(
          "Äänestys on päättynyt.",
        ),
        "voteNoDueDate": MessageLookupByLibrary.simpleMessage("pysyvästi"),
        "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
          "Äänimäärä ei voi olla alle kaksi.",
        ),
        "voteOptionHint": m21,
        "voteOptionNullIndex": m22,
        "voteResult": MessageLookupByLibrary.simpleMessage(
          "Äänestystulokset on luotu",
        ),
        "voteWillExpired": m23,
        "yearsAgo": m24,
      };
}
