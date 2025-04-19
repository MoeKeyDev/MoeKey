// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a da_DK locale. All the
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
  String get localeName => 'da_DK';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Bestem ( / )";

  static String m1(error) => "\n\n ${error}Skabelsen mislykkedes";

  static String m2(days) => "${days}dage siden";

  static String m3(thing) => "${thing}Ønsker du at slette \" \"?";

  static String m4(name) =>
      "${name}Vil du slette filen \" \"? Indlæg med denne fil vedhæftet vil også blive slettet.";

  static String m5(name) =>
      "${name}Vil du slette mappen \" \"? Hvis der er indhold i mappen, skal du først slette indholdet i mappen.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Dage timer minutter sekunder";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Timer Minutter Sekunder";

  static String m8(minute, second) => "${minute}${second}Minutter sekunder";

  static String m9(second) =>
      "${second}enhed for vinkel eller bue svarende til en tresindstyvendedel af en grad";

  static String m10(error) => "\n\n${error}Kunne ikke sende post";

  static String m11(hours) => "${hours}timer siden";

  static String m12(server) => "${server}I øjeblikket logget ind";

  static String m13(minutes) => "${minutes}minutter siden";

  static String m14(months) => "${months}måneder siden";

  static String m15(language) => "${language} \nOversæt fra til";

  static String m16(type) => "${type}Meddelelsestyper, der ikke understøttes:";

  static String m17(seconds) => "${seconds}sekunder siden";

  static String m18(msg) => "\n ${msg}Upload mislykkedes";

  static String m19(count) => "${count}Stemmer i alt";

  static String m20(count) => "${count}person, der holdes fanget for løsepenge";

  static String m21(index) => "${index}Valgmuligheder";

  static String m22(index) => "${index}Indstillingen kan ikke være tom";

  static String m23(datetime) => "${datetime}Frist efter færdiggørelse";

  static String m24(years) => "${years}...år siden";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("Brugernavn"),
    "add": MessageLookupByLibrary.simpleMessage("øge"),
    "addAccount": MessageLookupByLibrary.simpleMessage("Tilføj konto"),
    "addFile": MessageLookupByLibrary.simpleMessage("Tilføj fil"),
    "addTitle": MessageLookupByLibrary.simpleMessage("Tilføj titel"),
    "all": MessageLookupByLibrary.simpleMessage("fuld"),
    "announcementActive": MessageLookupByLibrary.simpleMessage(
      "Annoncering nu",
    ),
    "announcementExpired": MessageLookupByLibrary.simpleMessage(
      "Tidligere meddelelser",
    ),
    "announcements": MessageLookupByLibrary.simpleMessage("Bulletiner"),
    "back": MessageLookupByLibrary.simpleMessage("komme (eller gå) tilbage"),
    "cancel": MessageLookupByLibrary.simpleMessage("aflysninger"),
    "cancelSensitive": MessageLookupByLibrary.simpleMessage(
      "Afflagning som følsomt indhold",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clip": MessageLookupByLibrary.simpleMessage("Notat"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "Er du sikker på, at du vil annullere indsamlingen?",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage("Nye sticky notes"),
    "clipFavorite": MessageLookupByLibrary.simpleMessage(
      "Tilføj til favoritter",
    ),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage(
      "Bogmærke (internet)",
    ),
    "clipRemove": MessageLookupByLibrary.simpleMessage("Fjern klæbende noter"),
    "clipUpdate": MessageLookupByLibrary.simpleMessage(
      "Opdatering af sticky notes",
    ),
    "clips": MessageLookupByLibrary.simpleMessage("Notat"),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage("Kopier indhold"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Kopier link"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("Kopier RSS"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "Kopier adressen på brugerens hjemmeside",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage("Kopier brugernavn"),
    "createFolder": MessageLookupByLibrary.simpleMessage("Ny mappe"),
    "createNote": MessageLookupByLibrary.simpleMessage("Opret en ny tråd"),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
      "Oprettelse af et indlæg fra en fil",
    ),
    "createNoteHint": MessageLookupByLibrary.simpleMessage("Hvad skete der?"),
    "createdDate": MessageLookupByLibrary.simpleMessage("Dato for oprettelse"),
    "creationFailedDialog": m1,
    "cw": MessageLookupByLibrary.simpleMessage("skjult indhold"),
    "day": MessageLookupByLibrary.simpleMessage("dag"),
    "daysAgo": m2,
    "delete": MessageLookupByLibrary.simpleMessage("fjerne"),
    "deleteConfirm": m3,
    "deleteFileConfirmation": m4,
    "deleteFolderConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("beskrivelser"),
    "done": MessageLookupByLibrary.simpleMessage("opfylde"),
    "download": MessageLookupByLibrary.simpleMessage("Downloading"),
    "drive": MessageLookupByLibrary.simpleMessage("Filopbevaring i skyen"),
    "durationDay": m6,
    "durationHour": m7,
    "durationMinute": m8,
    "durationSecond": m9,
    "edit": MessageLookupByLibrary.simpleMessage("kompilator"),
    "emoji": MessageLookupByLibrary.simpleMessage("humørikon"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "Indtast venligst et nyt filnavn",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage(
      "Indtast venligst en ny titel",
    ),
    "enterUrl": MessageLookupByLibrary.simpleMessage(
      "Indtast venligst URL\'en",
    ),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "Indholdet kan ikke være tomt",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
      "Indholdet kan ikke være tomt",
    ),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("opdagelser"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("på mode"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage("populær bruger"),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage(
      "Nyligt indloggede brugere",
    ),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage(
      "bruger øverst på listen",
    ),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
      "Nylige bidragydere",
    ),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("bruger"),
    "favorite": MessageLookupByLibrary.simpleMessage("Bogmærke (internet)"),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "folderName": MessageLookupByLibrary.simpleMessage("Mappens navn"),
    "follow": MessageLookupByLibrary.simpleMessage("fokus"),
    "followed": MessageLookupByLibrary.simpleMessage("Fulgte efter"),
    "followers": MessageLookupByLibrary.simpleMessage("Seer"),
    "following": MessageLookupByLibrary.simpleMessage("Bekymret"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("Fra netbook\'en"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
    "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
    "hostnames": MessageLookupByLibrary.simpleMessage("Domænenavn"),
    "hour": MessageLookupByLibrary.simpleMessage("timer"),
    "hoursAgo": m11,
    "image": MessageLookupByLibrary.simpleMessage("Foto"),
    "inputServer": MessageLookupByLibrary.simpleMessage(
      "Server med manuelt input",
    ),
    "insertDriverFile": MessageLookupByLibrary.simpleMessage(
      "Indsættelse af tilbehør",
    ),
    "isFollowingYouNow": MessageLookupByLibrary.simpleMessage(
      "Jeg holder øje med dig.",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("for nylig"),
    "keepOriginal": MessageLookupByLibrary.simpleMessage(
      "Bevar det originale billede",
    ),
    "loadingServers": MessageLookupByLibrary.simpleMessage("Server Loading"),
    "local": MessageLookupByLibrary.simpleMessage("denne lokalitet"),
    "localUpload": MessageLookupByLibrary.simpleMessage("lokal upload"),
    "login": MessageLookupByLibrary.simpleMessage("log ind"),
    "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Fejl i login"),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "Login mislykkedes: Oprettelse af applikation mislykkedes",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "Login mislykkedes: erhvervelse af token mislykkedes",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage("Login vellykket"),
    "manageAccount": MessageLookupByLibrary.simpleMessage("Administrer konto"),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage(
      "Marker som følsomt indhold",
    ),
    "mention": MessageLookupByLibrary.simpleMessage("rejse (et emne)"),
    "minute": MessageLookupByLibrary.simpleMessage("minutter"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("mere"),
    "myCLips": MessageLookupByLibrary.simpleMessage("Min bemærkning."),
    "name": MessageLookupByLibrary.simpleMessage("navn (på en ting)"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Navnet må ikke være tomt",
    ),
    "next": MessageLookupByLibrary.simpleMessage("Det næste skridt"),
    "noLists": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any lists",
    ),
    "notFindServer": MessageLookupByLibrary.simpleMessage(
      "Fandt du ikke din server?",
    ),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "Kopier linket til denne side",
    ),
    "noteCwHide": MessageLookupByLibrary.simpleMessage("lægge væk"),
    "noteCwShow": MessageLookupByLibrary.simpleMessage("Vis indhold"),
    "noteFormLanguageTranslation": m15,
    "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
      "Ikke-deltagelse i fælles",
    ),
    "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
      "Gå til værtsserveren for at vise",
    ),
    "notePined": MessageLookupByLibrary.simpleMessage("Top-indlæg"),
    "noteQuote": MessageLookupByLibrary.simpleMessage("citat"),
    "noteReNote": MessageLookupByLibrary.simpleMessage(
      "Videresendelse (mail, sms, datapakker)",
    ),
    "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Videresendt."),
    "noteTranslate": MessageLookupByLibrary.simpleMessage(
      "Oversættelse af indlæg",
    ),
    "noteVisibility": MessageLookupByLibrary.simpleMessage("synlighed"),
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage("Seer"),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "Send kun til følgere",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage(
      "fig. begyndelse",
    ),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "Tidslinjen sendes kun til startsiden",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("åbenlyst"),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "Dit indlæg vises på den globale tidslinje",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
      "privat brev",
    ),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "Send kun til bestemte brugere",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("kort"),
    "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
    "notification": MessageLookupByLibrary.simpleMessage("Meddelelser"),
    "notifications": MessageLookupByLibrary.simpleMessage("Meddelelser"),
    "notifyAll": MessageLookupByLibrary.simpleMessage("fuld"),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("screening"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "Din anmodning om opmærksomhed er blevet godkendt.",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
      "Du har fået nye følgere.",
    ),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
      "Marker alle som læst",
    ),
    "notifyMention": MessageLookupByLibrary.simpleMessage(
      "Når vi taler om min",
    ),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("privat brev"),
    "notifyNotSupport": m16,
    "ok": MessageLookupByLibrary.simpleMessage("definere"),
    "openInNewTab": MessageLookupByLibrary.simpleMessage(
      "Gå til browservisning",
    ),
    "overviews": MessageLookupByLibrary.simpleMessage("skimme igennem"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "Bekymring for, om anmodninger bliver imødekommet",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("forhåndsvisninger"),
    "previewNote": MessageLookupByLibrary.simpleMessage(
      "Forhåndsvisning af indlæg",
    ),
    "processing": MessageLookupByLibrary.simpleMessage("i gang"),
    "public": MessageLookupByLibrary.simpleMessage("åbenlyst"),
    "publish": MessageLookupByLibrary.simpleMessage("indlæg"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage(
      "Jeg citerer dette indlæg.",
    ),
    "reNoteText": MessageLookupByLibrary.simpleMessage("Citat indlæg"),
    "reaction": MessageLookupByLibrary.simpleMessage("svar"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage(
      "Accepterer Emoji-svar",
    ),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("fuld"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
      "Kan kun lide",
    ),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "Kun fjernbetjening Kudos",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "Kun ikke-følsomt indhold",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage(
          "Kun ikke-følsomt indhold (kun remote likes)",
        ),
    "recipient": MessageLookupByLibrary.simpleMessage(
      "Til: (e-mail-overskrift)",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("Opdater (computervindue)"),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
    "remote": MessageLookupByLibrary.simpleMessage("afstand"),
    "rename": MessageLookupByLibrary.simpleMessage("omdøbe"),
    "renameFile": MessageLookupByLibrary.simpleMessage("Omdøb filen"),
    "renameFolder": MessageLookupByLibrary.simpleMessage("Omdøb en mappe"),
    "replyNoteHint": MessageLookupByLibrary.simpleMessage(
      "Svar på dette indlæg...",
    ),
    "replyNoteText": MessageLookupByLibrary.simpleMessage("Svar på et indlæg"),
    "saveFailed": MessageLookupByLibrary.simpleMessage("undlader at redde"),
    "saveImage": MessageLookupByLibrary.simpleMessage("Gem billede"),
    "saveSuccess": MessageLookupByLibrary.simpleMessage("Gem succesfuld"),
    "search": MessageLookupByLibrary.simpleMessage("lede efter noget."),
    "searchAll": MessageLookupByLibrary.simpleMessage("fuld"),
    "searchHost": MessageLookupByLibrary.simpleMessage("Angiv domænenavn"),
    "searchLocal": MessageLookupByLibrary.simpleMessage("dette websted"),
    "searchRemote": MessageLookupByLibrary.simpleMessage("på afstand"),
    "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
    "secondsAgo": m17,
    "selectHashtag": MessageLookupByLibrary.simpleMessage("Vælg tag"),
    "selectServer": MessageLookupByLibrary.simpleMessage(
      "Please Select Your Server",
    ),
    "selectUser": MessageLookupByLibrary.simpleMessage("Vælg bruger"),
    "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
      "Klik for at vise",
    ),
    "sensitiveContent": MessageLookupByLibrary.simpleMessage("Følsomt indhold"),
    "serverAddr": MessageLookupByLibrary.simpleMessage("Serveradresse"),
    "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
    "settings": MessageLookupByLibrary.simpleMessage("sætte op"),
    "share": MessageLookupByLibrary.simpleMessage(
      "dele (glæder, fordele, privilegier osv.) med andre",
    ),
    "showConversation": MessageLookupByLibrary.simpleMessage("Se dialog"),
    "somebodyNote": MessageLookupByLibrary.simpleMessage(" Indlæg"),
    "timeline": MessageLookupByLibrary.simpleMessage("Tidslinje"),
    "timelineGlobal": MessageLookupByLibrary.simpleMessage(
      "Sikkerhedssituation",
    ),
    "timelineHome": MessageLookupByLibrary.simpleMessage("fig. begyndelse"),
    "timelineHybrid": MessageLookupByLibrary.simpleMessage("socialisering"),
    "timelineLocal": MessageLookupByLibrary.simpleMessage("denne lokalitet"),
    "translate": MessageLookupByLibrary.simpleMessage("gengivelse"),
    "uncategorized": MessageLookupByLibrary.simpleMessage("Ikke kategoriseret"),
    "unfollow": MessageLookupByLibrary.simpleMessage("Ikke følge"),
    "updatedDate": MessageLookupByLibrary.simpleMessage("Dato for opdatering"),
    "uploadFailed": m18,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
      "Upload fra webstedet",
    ),
    "user": MessageLookupByLibrary.simpleMessage("bruger"),
    "userAll": MessageLookupByLibrary.simpleMessage("fuld"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
      "Denne bruger har endnu ikke præsenteret sig selv",
    ),
    "userFile": MessageLookupByLibrary.simpleMessage("Vedhæftet fil (e-mail)"),
    "userHot": MessageLookupByLibrary.simpleMessage("bruger"),
    "userNote": MessageLookupByLibrary.simpleMessage("kort"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage("registreret i"),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "Liste over widgets (ufærdig)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("Bruger-ID"),
    "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
    "video": MessageLookupByLibrary.simpleMessage("video"),
    "view": MessageLookupByLibrary.simpleMessage("tjek ud"),
    "viewMore": MessageLookupByLibrary.simpleMessage("Se mere"),
    "vote": MessageLookupByLibrary.simpleMessage("folkeafstemning"),
    "voteAllCount": m19,
    "voteCount": m20,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("skæringsdato"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
      "Flere stemmer tilladt",
    ),
    "voteExpired": MessageLookupByLibrary.simpleMessage(
      "Afstemningen er afsluttet.",
    ),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("permanent"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "Antallet af stemmer kan ikke være mindre end to",
    ),
    "voteOptionHint": m21,
    "voteOptionNullIndex": m22,
    "voteResult": MessageLookupByLibrary.simpleMessage(
      "Afstemningsresultater er blevet genereret",
    ),
    "voteWillExpired": m23,
    "yearsAgo": m24,
  };
}
