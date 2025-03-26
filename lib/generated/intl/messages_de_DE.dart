// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a de_DE locale. All the
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
  String get localeName => 'de_DE';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Ermitteln ( / )";

  static String m1(error) => "\n\n ${error}Erstellung fehlgeschlagen";

  static String m2(days) => "${days}vor Tagen";

  static String m3(thing) => "${thing}Möchten Sie \" \" löschen?";

  static String m4(name) =>
      "${name}Möchten Sie die Datei \" \" löschen? Beiträge, die diese Datei enthalten, werden ebenfalls gelöscht.";

  static String m5(name) =>
      "${name}Möchten Sie den Ordner \" \" löschen? Wenn sich Inhalte in dem Ordner befinden, löschen Sie bitte zuerst den Inhalt des Ordners.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Tage Stunden Minuten Sekunden";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Stunden, Minuten, Sekunden";

  static String m8(minute, second) => "${minute}${second}Minuten Sekunden";

  static String m9(second) =>
      "${second}Einheit des Winkels oder Bogens, die einem Sechzigstel eines Grades entspricht";

  static String m10(error) => "\n\n${error}Postversand fehlgeschlagen";

  static String m11(hours) => "${hours}vor Stunden";

  static String m12(server) => "${server}Derzeit eingeloggt";

  static String m13(minutes) => "${minutes}Minuten zuvor";

  static String m14(months) => "${months}vor Monaten";

  static String m15(language) => "${language} \nÜbersetzen von nach";

  static String m16(type) => "${type}Nicht unterstützte Meldungstypen:";

  static String m17(seconds) => "${seconds}vor Sekunden";

  static String m18(msg) => "\n ${msg}Upload fehlgeschlagen";

  static String m19(count) => "${count}Stimmen insgesamt";

  static String m20(count) => "${count}Lösegeldforderung";

  static String m21(index) => "${index}Optionen";

  static String m22(index) => "${index}Die Option darf nicht leer sein";

  static String m23(datetime) => "${datetime}Nacherfüllungsfrist";

  static String m24(years) => "${years}vor Jahren";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("Nutzername"),
    "add": MessageLookupByLibrary.simpleMessage("erhöhen."),
    "addAccount": MessageLookupByLibrary.simpleMessage("Konto hinzufügen"),
    "addFile": MessageLookupByLibrary.simpleMessage("Datei hinzufügen"),
    "addTitle": MessageLookupByLibrary.simpleMessage("Titel hinzufügen"),
    "all": MessageLookupByLibrary.simpleMessage("vollständig"),
    "announcementActive": MessageLookupByLibrary.simpleMessage(
      "Jetzt ankündigen",
    ),
    "announcementExpired": MessageLookupByLibrary.simpleMessage(
      "Frühere Ankündigungen",
    ),
    "announcements": MessageLookupByLibrary.simpleMessage("Bulletin"),
    "back": MessageLookupByLibrary.simpleMessage("zurückkommen (oder gehen)"),
    "cancel": MessageLookupByLibrary.simpleMessage("Stornierungen"),
    "cancelSensitive": MessageLookupByLibrary.simpleMessage(
      "Kennzeichnung sensibler Inhalte aufheben",
    ),
    "clip": MessageLookupByLibrary.simpleMessage("Memo"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "Sind Sie sicher, dass Sie die Sammlung abbrechen wollen?",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage("Neue Haftnotizen"),
    "clipFavorite": MessageLookupByLibrary.simpleMessage(
      "Zu Favoriten hinzufügen",
    ),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage(
      "Lesezeichen (Internet)",
    ),
    "clipRemove": MessageLookupByLibrary.simpleMessage("Haftnotizen entfernen"),
    "clipUpdate": MessageLookupByLibrary.simpleMessage(
      "Haftnotizen aktualisieren",
    ),
    "clips": MessageLookupByLibrary.simpleMessage("Memo"),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage("Inhalt kopieren"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Link kopieren"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("RSS kopieren"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "Kopieren Sie die Adresse der Homepage des Benutzers",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage(
      "Benutzername kopieren",
    ),
    "createFolder": MessageLookupByLibrary.simpleMessage("Neue Mappe"),
    "createNote": MessageLookupByLibrary.simpleMessage(
      "Ein neues Thema erstellen",
    ),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
      "Erstellen eines Beitrags aus einer Datei",
    ),
    "createNoteHint": MessageLookupByLibrary.simpleMessage("Was geschah..."),
    "createdDate": MessageLookupByLibrary.simpleMessage("Datum der Erstellung"),
    "creationFailedDialog": m1,
    "cw": MessageLookupByLibrary.simpleMessage("unsichtbarer Inhalt"),
    "day": MessageLookupByLibrary.simpleMessage("Himmel"),
    "daysAgo": m2,
    "delete": MessageLookupByLibrary.simpleMessage("entfernen"),
    "deleteConfirm": m3,
    "deleteFileConfirmation": m4,
    "deleteFolderConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("Beschreibungen"),
    "done": MessageLookupByLibrary.simpleMessage("erfüllen"),
    "download": MessageLookupByLibrary.simpleMessage("Herunterladen von"),
    "drive": MessageLookupByLibrary.simpleMessage("Cloud-Dateispeicher"),
    "durationDay": m6,
    "durationHour": m7,
    "durationMinute": m8,
    "durationSecond": m9,
    "edit": MessageLookupByLibrary.simpleMessage("Compiler"),
    "emoji": MessageLookupByLibrary.simpleMessage("Emoticon"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie einen neuen Dateinamen ein",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie einen neuen Titel ein",
    ),
    "enterUrl": MessageLookupByLibrary.simpleMessage(
      "Bitte geben Sie die URL ein",
    ),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "Der Inhalt darf nicht leer sein",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
      "Der Inhalt darf nicht leer sein",
    ),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("Entdeckungen"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("en vogue"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage(
      "beliebter Benutzer",
    ),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage(
      "Kürzlich eingeloggte Benutzer",
    ),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage(
      "Benutzer an der Spitze der Liste",
    ),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
      "Neueste Beiträge",
    ),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("Benutzer"),
    "favorite": MessageLookupByLibrary.simpleMessage("Lesezeichen (Internet)"),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "folderName": MessageLookupByLibrary.simpleMessage("Name des Ordners"),
    "follow": MessageLookupByLibrary.simpleMessage("Fokus"),
    "followed": MessageLookupByLibrary.simpleMessage("Gefolgt von"),
    "followers": MessageLookupByLibrary.simpleMessage("Beobachter"),
    "following": MessageLookupByLibrary.simpleMessage("Besorgt"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("Vom Netbook aus"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
    "hashtag": MessageLookupByLibrary.simpleMessage("Hashtag"),
    "hostnames": MessageLookupByLibrary.simpleMessage("Domain-Name"),
    "hour": MessageLookupByLibrary.simpleMessage("Stunden"),
    "hoursAgo": m11,
    "image": MessageLookupByLibrary.simpleMessage("Foto"),
    "inputServer": MessageLookupByLibrary.simpleMessage(
      "Manuelle Eingabe Server",
    ),
    "insertDriverFile": MessageLookupByLibrary.simpleMessage(
      "Einsetzen von Zubehör",
    ),
    "isFollowingYouNow": MessageLookupByLibrary.simpleMessage(
      "Ich beobachte dich.",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("erst kürzlich"),
    "keepOriginal": MessageLookupByLibrary.simpleMessage(
      "Bewahren Sie das Originalbild",
    ),
    "loadingServers": MessageLookupByLibrary.simpleMessage("Server Loading"),
    "local": MessageLookupByLibrary.simpleMessage("diese Ortschaft"),
    "localUpload": MessageLookupByLibrary.simpleMessage("lokaler Upload"),
    "login": MessageLookupByLibrary.simpleMessage("sich anmelden"),
    "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
    "loginFailed": MessageLookupByLibrary.simpleMessage(
      "Anmeldung fehlgeschlagen",
    ),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "Anmeldung fehlgeschlagen: Erstellung der Anwendung fehlgeschlagen",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "Anmeldung fehlgeschlagen: Token-Erwerb fehlgeschlagen",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage(
      "Anmeldung erfolgreich",
    ),
    "manageAccount": MessageLookupByLibrary.simpleMessage("Konto verwalten"),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage(
      "Als sensibler Inhalt kennzeichnen",
    ),
    "mention": MessageLookupByLibrary.simpleMessage("erheben (ein Thema)"),
    "minute": MessageLookupByLibrary.simpleMessage("Minuten"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("mehr"),
    "myCLips": MessageLookupByLibrary.simpleMessage("Meine Anmerkung."),
    "name": MessageLookupByLibrary.simpleMessage("Name (einer Sache)"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Name darf nicht leer sein",
    ),
    "next": MessageLookupByLibrary.simpleMessage("der nächste Schritt"),
    "noLists": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any lists",
    ),
    "notFindServer": MessageLookupByLibrary.simpleMessage(
      "Sie haben Ihren Server nicht gefunden?",
    ),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "Kopieren Sie den Link zu dieser Website",
    ),
    "noteCwHide": MessageLookupByLibrary.simpleMessage("einlagern"),
    "noteCwShow": MessageLookupByLibrary.simpleMessage("Inhalt anzeigen"),
    "noteFormLanguageTranslation": m15,
    "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
      "Nicht-Beteiligung an gemeinsamen",
    ),
    "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
      "Gehen Sie zum Hostserver, um Folgendes anzuzeigen",
    ),
    "notePined": MessageLookupByLibrary.simpleMessage("Top-Posten"),
    "noteQuote": MessageLookupByLibrary.simpleMessage("Zitat"),
    "noteReNote": MessageLookupByLibrary.simpleMessage(
      "Weiterleitung (Post, SMS, Datenpakete)",
    ),
    "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Weitergeleitet."),
    "noteTranslate": MessageLookupByLibrary.simpleMessage(
      "Übersetzung von Beiträgen",
    ),
    "noteVisibility": MessageLookupByLibrary.simpleMessage("Sichtbarkeit"),
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage(
      "Beobachter",
    ),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "Nur an Follower senden",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("Abb. Anfang"),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "Zeitleiste wird nur an die Startseite gesendet",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("offen"),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "Ihr Beitrag wird in der globalen Zeitleiste erscheinen",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
      "privater Brief",
    ),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "Nur an bestimmte Benutzer senden",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("Karte"),
    "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
    "notification": MessageLookupByLibrary.simpleMessage("Benachrichtigungen"),
    "notifications": MessageLookupByLibrary.simpleMessage("Benachrichtigungen"),
    "notifyAll": MessageLookupByLibrary.simpleMessage("vollständig"),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("Screening"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "Ihr Antrag auf Aufmerksamkeit wurde genehmigt.",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
      "Sie haben neue Follower.",
    ),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
      "Alle als gelesen markieren",
    ),
    "notifyMention": MessageLookupByLibrary.simpleMessage("Apropos mein"),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("privater Brief"),
    "notifyNotSupport": m16,
    "ok": MessageLookupByLibrary.simpleMessage("definieren."),
    "openInNewTab": MessageLookupByLibrary.simpleMessage(
      "Zum Browser Display gehen",
    ),
    "overviews": MessageLookupByLibrary.simpleMessage("durchblättern"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "Besorgnis über die Erteilung von Aufträgen",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Vorschauen"),
    "previewNote": MessageLookupByLibrary.simpleMessage("Vorschau Beiträge"),
    "processing": MessageLookupByLibrary.simpleMessage("in Arbeit"),
    "public": MessageLookupByLibrary.simpleMessage("offen"),
    "publish": MessageLookupByLibrary.simpleMessage("Beitrag"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage(
      "Ich zitiere diesen Beitrag...",
    ),
    "reNoteText": MessageLookupByLibrary.simpleMessage("Zitat Post"),
    "reaction": MessageLookupByLibrary.simpleMessage("Antwort"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage(
      "Akzeptieren von Emoji-Antworten",
    ),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("vollständig"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
      "Mag nur",
    ),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "Nur Remote Kudos",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "Nur nicht-sensible Inhalte",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage(
          "Nur nicht-sensible Inhalte (nur Remote-Likes)",
        ),
    "recipient": MessageLookupByLibrary.simpleMessage("An: (E-Mail-Kopfzeile)"),
    "refresh": MessageLookupByLibrary.simpleMessage(
      "Aktualisieren (Computerfenster)",
    ),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
    "remote": MessageLookupByLibrary.simpleMessage("per Fernzugriff"),
    "rename": MessageLookupByLibrary.simpleMessage("umbenennen"),
    "renameFile": MessageLookupByLibrary.simpleMessage("Datei umbenennen"),
    "renameFolder": MessageLookupByLibrary.simpleMessage(
      "Einen Ordner umbenennen",
    ),
    "replyNoteHint": MessageLookupByLibrary.simpleMessage(
      "Auf diesen Beitrag antworten...",
    ),
    "replyNoteText": MessageLookupByLibrary.simpleMessage(
      "Auf einen Beitrag antworten",
    ),
    "saveFailed": MessageLookupByLibrary.simpleMessage("nicht speichern"),
    "saveImage": MessageLookupByLibrary.simpleMessage("Bild speichern"),
    "saveSuccess": MessageLookupByLibrary.simpleMessage(
      "Erfolgreich speichern",
    ),
    "search": MessageLookupByLibrary.simpleMessage("nach etw. Ausschau halten"),
    "searchAll": MessageLookupByLibrary.simpleMessage("vollständig"),
    "searchHost": MessageLookupByLibrary.simpleMessage("Domänenname angeben"),
    "searchLocal": MessageLookupByLibrary.simpleMessage("diese Seite"),
    "searchRemote": MessageLookupByLibrary.simpleMessage("per Fernzugriff"),
    "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
    "secondsAgo": m17,
    "selectHashtag": MessageLookupByLibrary.simpleMessage("Tag auswählen"),
    "selectServer": MessageLookupByLibrary.simpleMessage(
      "Please Select Your Server",
    ),
    "selectUser": MessageLookupByLibrary.simpleMessage("Benutzer auswählen"),
    "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
      "Anklicken zum Anzeigen",
    ),
    "sensitiveContent": MessageLookupByLibrary.simpleMessage(
      "Sensibler Inhalt",
    ),
    "serverAddr": MessageLookupByLibrary.simpleMessage("Server-Adresse"),
    "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
    "settings": MessageLookupByLibrary.simpleMessage("aufstellen"),
    "share": MessageLookupByLibrary.simpleMessage(
      "(Freuden, Vorteile, Privilegien usw.) mit anderen zu teilen",
    ),
    "showConversation": MessageLookupByLibrary.simpleMessage("Dialog anzeigen"),
    "somebodyNote": MessageLookupByLibrary.simpleMessage(" Beiträge"),
    "timeline": MessageLookupByLibrary.simpleMessage("Zeitleiste"),
    "timelineGlobal": MessageLookupByLibrary.simpleMessage("Sicherheitslage"),
    "timelineHome": MessageLookupByLibrary.simpleMessage("Abb. Anfang"),
    "timelineHybrid": MessageLookupByLibrary.simpleMessage("Sozialisierung"),
    "timelineLocal": MessageLookupByLibrary.simpleMessage("diese Ortschaft"),
    "translate": MessageLookupByLibrary.simpleMessage("Rendering"),
    "uncategorized": MessageLookupByLibrary.simpleMessage(
      "Nicht kategorisiert",
    ),
    "unfollow": MessageLookupByLibrary.simpleMessage("Unfollow"),
    "updatedDate": MessageLookupByLibrary.simpleMessage(
      "Datum der Aktualisierung",
    ),
    "uploadFailed": m18,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
      "Hochladen von der Website",
    ),
    "user": MessageLookupByLibrary.simpleMessage("Benutzer"),
    "userAll": MessageLookupByLibrary.simpleMessage("vollständig"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
      "Dieser Benutzer hat sich noch nicht vorgestellt",
    ),
    "userFile": MessageLookupByLibrary.simpleMessage("Anhang (E-Mail)"),
    "userHot": MessageLookupByLibrary.simpleMessage("Benutzer"),
    "userNote": MessageLookupByLibrary.simpleMessage("Karte"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage("eingetragen in"),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "Liste der Widgets (unvollendet)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("Benutzer-ID"),
    "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
    "video": MessageLookupByLibrary.simpleMessage("Video"),
    "view": MessageLookupByLibrary.simpleMessage("auschecken"),
    "viewMore": MessageLookupByLibrary.simpleMessage("Mehr sehen"),
    "vote": MessageLookupByLibrary.simpleMessage("Referendum"),
    "voteAllCount": m19,
    "voteCount": m20,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("Stichtag"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
      "Mehrfache Abstimmungen erlaubt",
    ),
    "voteExpired": MessageLookupByLibrary.simpleMessage(
      "Die Abstimmungen sind abgeschlossen.",
    ),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("dauerhaft"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "Die Zahl der Stimmen darf nicht weniger als zwei betragen.",
    ),
    "voteOptionHint": m21,
    "voteOptionNullIndex": m22,
    "voteResult": MessageLookupByLibrary.simpleMessage(
      "Die Abstimmungsergebnisse wurden erstellt",
    ),
    "voteWillExpired": m23,
    "yearsAgo": m24,
  };
}
