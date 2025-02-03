// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a nl_NL locale. All the
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
  String get localeName => 'nl_NL';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Bepaal ( / )";

  static String m1(error) => "\n\n ${error}Schepping mislukt";

  static String m2(days) => "${days}dagen geleden";

  static String m3(thing) => "${thing}Wil je \" \" verwijderen?";

  static String m4(name) =>
      "${name}Wil je het \" \" bestand verwijderen? Berichten met dit bestand erbij worden ook verwijderd.";

  static String m5(name) =>
      "${name}Wilt u de map \" \" verwijderen? Als de map inhoud bevat, verwijder dan eerst de inhoud van de map.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Dagen uren minuten seconden";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Uren Minuten Seconden";

  static String m8(minute, second) => "${minute}${second}Minuten seconden";

  static String m9(second) =>
      "${second}eenheid van hoek of boog equivalent een zestigste van een graad";

  static String m10(error) => "\n\n${error}Post niet verzonden";

  static String m11(hours) => "${hours}uren geleden";

  static String m12(server) => "${server}Momenteel ingelogd";

  static String m13(minutes) => "${minutes}minuten geleden";

  static String m14(months) => "${months}maanden geleden";

  static String m15(language) => "${language} \nVertaal van naar";

  static String m16(type) => "${type}Niet-ondersteunde meldingstypes:";

  static String m17(seconds) => "${seconds}seconden geleden";

  static String m18(msg) => "\n ${msg}Uploaden mislukt";

  static String m19(count) => "${count}Totaal aantal stemmen";

  static String m20(count) => "${count}persoon vastgehouden voor losgeld";

  static String m21(index) => "${index}Opties";

  static String m22(index) => "${index}De optie kan niet leeg zijn";

  static String m23(datetime) => "${datetime}termijn na voltooiing";

  static String m24(years) => "${years}...jaren geleden";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("gebruikersnaam"),
        "add": MessageLookupByLibrary.simpleMessage("verhogen"),
        "addAccount": MessageLookupByLibrary.simpleMessage("Account toevoegen"),
        "addFile": MessageLookupByLibrary.simpleMessage("Bestand toevoegen"),
        "addTitle": MessageLookupByLibrary.simpleMessage("Titel toevoegen"),
        "all": MessageLookupByLibrary.simpleMessage("volledig"),
        "announcementActive":
            MessageLookupByLibrary.simpleMessage("Nu aankondigen"),
        "announcementExpired": MessageLookupByLibrary.simpleMessage(
            "Aankondigingen uit het verleden"),
        "announcements": MessageLookupByLibrary.simpleMessage("bulletin"),
        "back":
            MessageLookupByLibrary.simpleMessage("terugkomen (of teruggaan)"),
        "cancel": MessageLookupByLibrary.simpleMessage("annuleringen"),
        "cancelSensitive":
            MessageLookupByLibrary.simpleMessage("Gevoelige inhoud afvinken"),
        "clip": MessageLookupByLibrary.simpleMessage("memo"),
        "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
            "Weet je zeker dat je de collectie wilt annuleren?"),
        "clipCreate":
            MessageLookupByLibrary.simpleMessage("Nieuwe plakbriefjes"),
        "clipFavorite":
            MessageLookupByLibrary.simpleMessage("Toevoegen aan favorieten"),
        "clipFavoriteList":
            MessageLookupByLibrary.simpleMessage("bladwijzer (internet)"),
        "clipRemove":
            MessageLookupByLibrary.simpleMessage("Kleefnotities verwijderen"),
        "clipUpdate":
            MessageLookupByLibrary.simpleMessage("Sticky Notes bijwerken"),
        "clips": MessageLookupByLibrary.simpleMessage("memo"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "confirmSelection": m0,
        "copyContent": MessageLookupByLibrary.simpleMessage("Inhoud kopiëren"),
        "copyLink": MessageLookupByLibrary.simpleMessage("Link kopiëren"),
        "copyRSS": MessageLookupByLibrary.simpleMessage("RSS kopiëren"),
        "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
            "Kopieer het adres van de homepage van de gebruiker"),
        "copyUsername":
            MessageLookupByLibrary.simpleMessage("Gebruikersnaam kopiëren"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Nieuwe map"),
        "createNote":
            MessageLookupByLibrary.simpleMessage("Een nieuwe thread plaatsen"),
        "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
            "Een bericht maken vanuit een bestand"),
        "createNoteHint":
            MessageLookupByLibrary.simpleMessage("Wat is er gebeurd..."),
        "createdDate": MessageLookupByLibrary.simpleMessage("Datum oprichting"),
        "creationFailedDialog": m1,
        "cw": MessageLookupByLibrary.simpleMessage("verborgen inhoud"),
        "day": MessageLookupByLibrary.simpleMessage("dag"),
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("verwijderen"),
        "deleteConfirm": m3,
        "deleteFileConfirmation": m4,
        "deleteFolderConfirmation": m5,
        "description": MessageLookupByLibrary.simpleMessage("beschrijvingen"),
        "done": MessageLookupByLibrary.simpleMessage("vervullen"),
        "download": MessageLookupByLibrary.simpleMessage("downloaden"),
        "drive": MessageLookupByLibrary.simpleMessage("cloud bestandsopslag"),
        "durationDay": m6,
        "durationHour": m7,
        "durationMinute": m8,
        "durationSecond": m9,
        "edit": MessageLookupByLibrary.simpleMessage("compiler"),
        "emoji": MessageLookupByLibrary.simpleMessage("emoticon"),
        "enterNewFileName": MessageLookupByLibrary.simpleMessage(
            "Voer een nieuwe bestandsnaam in"),
        "enterNewTitle":
            MessageLookupByLibrary.simpleMessage("Voer een nieuwe titel in"),
        "enterUrl": MessageLookupByLibrary.simpleMessage("Voer de URL in"),
        "exceptionContentNull":
            MessageLookupByLibrary.simpleMessage("Inhoud kan niet leeg zijn"),
        "exceptionCwNull":
            MessageLookupByLibrary.simpleMessage("Inhoud kan niet leeg zijn"),
        "exceptionSendNote": m10,
        "explore": MessageLookupByLibrary.simpleMessage("ontdekkingen"),
        "exploreHot": MessageLookupByLibrary.simpleMessage("in zwang"),
        "exploreUserHot":
            MessageLookupByLibrary.simpleMessage("populaire gebruiker"),
        "exploreUserLast": MessageLookupByLibrary.simpleMessage(
            "Recent aangemelde gebruikers"),
        "exploreUserPined":
            MessageLookupByLibrary.simpleMessage("gebruiker bovenaan de lijst"),
        "exploreUserUpdated":
            MessageLookupByLibrary.simpleMessage("Recente medewerkers"),
        "exploreUsers": MessageLookupByLibrary.simpleMessage("gebruiker"),
        "favorite":
            MessageLookupByLibrary.simpleMessage("bladwijzer (internet)"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "folderName": MessageLookupByLibrary.simpleMessage("Mapnaam"),
        "follow": MessageLookupByLibrary.simpleMessage("focus"),
        "followed": MessageLookupByLibrary.simpleMessage("Ik heb  gevolgd."),
        "followers": MessageLookupByLibrary.simpleMessage("watcher"),
        "following": MessageLookupByLibrary.simpleMessage("Bezorgd"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("Van de netbook"),
        "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
        "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
        "hostnames": MessageLookupByLibrary.simpleMessage("domeinnaam"),
        "hour": MessageLookupByLibrary.simpleMessage("uren"),
        "hoursAgo": m11,
        "image": MessageLookupByLibrary.simpleMessage("foto"),
        "inputServer": MessageLookupByLibrary.simpleMessage(
            "Server voor handmatige invoer"),
        "insertDriverFile":
            MessageLookupByLibrary.simpleMessage("Toevoeging van accessoires"),
        "isFollowingYouNow":
            MessageLookupByLibrary.simpleMessage("Ik hou je in de gaten."),
        "justNow": MessageLookupByLibrary.simpleMessage("onlangs"),
        "keepOriginal": MessageLookupByLibrary.simpleMessage(
            "De originele afbeelding behouden"),
        "loadingServers":
            MessageLookupByLibrary.simpleMessage("Server Loading"),
        "local": MessageLookupByLibrary.simpleMessage("deze plaats"),
        "localUpload": MessageLookupByLibrary.simpleMessage("lokale upload"),
        "login": MessageLookupByLibrary.simpleMessage("aanmelden"),
        "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("Login mislukt"),
        "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
            "Inloggen mislukt: applicatiecreatie mislukt"),
        "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
            "Inloggen mislukt: tokenverwerving mislukt"),
        "loginLoading": m12,
        "loginSuccess":
            MessageLookupByLibrary.simpleMessage("Inloggen succesvol"),
        "manageAccount":
            MessageLookupByLibrary.simpleMessage("Account beheren"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage(
            "Markeer als gevoelige inhoud"),
        "mention":
            MessageLookupByLibrary.simpleMessage("opvoeden (een onderwerp)"),
        "minute": MessageLookupByLibrary.simpleMessage("minuten"),
        "minutesAgo": m13,
        "monthsAgo": m14,
        "more": MessageLookupByLibrary.simpleMessage("meer"),
        "myCLips": MessageLookupByLibrary.simpleMessage("Mijn opmerking."),
        "name": MessageLookupByLibrary.simpleMessage("naam (van een ding)"),
        "nameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Naam kan niet leeg zijn"),
        "next": MessageLookupByLibrary.simpleMessage("de volgende stap"),
        "noLists":
            MessageLookupByLibrary.simpleMessage("You don\'t have any lists"),
        "notFindServer":
            MessageLookupByLibrary.simpleMessage("Uw server niet gevonden?"),
        "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
            "Kopieer de link naar deze site"),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("opbergen"),
        "noteCwShow": MessageLookupByLibrary.simpleMessage("Inhoud weergeven"),
        "noteFormLanguageTranslation": m15,
        "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
            "Niet-deelname aan gezamenlijke"),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
            "Ga naar de hostserver om het volgende weer te geven"),
        "notePined": MessageLookupByLibrary.simpleMessage("Top berichten"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("citaat"),
        "noteReNote": MessageLookupByLibrary.simpleMessage(
            "doorsturen (e-mail, sms, datapakketten)"),
        "noteReNoteByUser":
            MessageLookupByLibrary.simpleMessage("Doorgestuurd."),
        "noteTranslate":
            MessageLookupByLibrary.simpleMessage("Vertaling van berichten"),
        "noteVisibility": MessageLookupByLibrary.simpleMessage("zichtbaarheid"),
        "noteVisibilityFollowers":
            MessageLookupByLibrary.simpleMessage("watcher"),
        "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
            "Alleen verzenden naar volgers"),
        "noteVisibilityHome":
            MessageLookupByLibrary.simpleMessage("afb. begin"),
        "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
            "Tijdlijn alleen naar startpagina gestuurd"),
        "noteVisibilityPublic":
            MessageLookupByLibrary.simpleMessage("openlijk"),
        "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
            "Je bericht verschijnt op de globale tijdlijn"),
        "noteVisibilitySpecified":
            MessageLookupByLibrary.simpleMessage("persoonlijke brief"),
        "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
            "Alleen verzenden naar opgegeven gebruikers"),
        "notes": MessageLookupByLibrary.simpleMessage("kaart"),
        "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
        "notification": MessageLookupByLibrary.simpleMessage("meldingen"),
        "notifications": MessageLookupByLibrary.simpleMessage("meldingen"),
        "notifyAll": MessageLookupByLibrary.simpleMessage("volledig"),
        "notifyFilter": MessageLookupByLibrary.simpleMessage("screening"),
        "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
            "Uw verzoek om aandacht is goedgekeurd."),
        "notifyFollowedYou":
            MessageLookupByLibrary.simpleMessage("Je hebt nieuwe volgers."),
        "notifyMarkAllRead":
            MessageLookupByLibrary.simpleMessage("Alles markeren als gelezen"),
        "notifyMention": MessageLookupByLibrary.simpleMessage("Over mijn"),
        "notifyMessage":
            MessageLookupByLibrary.simpleMessage("persoonlijke brief"),
        "notifyNotSupport": m16,
        "ok": MessageLookupByLibrary.simpleMessage("definieer"),
        "openInNewTab":
            MessageLookupByLibrary.simpleMessage("Ga naar browserweergave"),
        "overviews": MessageLookupByLibrary.simpleMessage("doorbladeren"),
        "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
            "Bezorgdheid over verzoeken die worden ingewilligd"),
        "preview": MessageLookupByLibrary.simpleMessage("voorbeschouwingen"),
        "previewNote":
            MessageLookupByLibrary.simpleMessage("Voorbeeld Berichten"),
        "processing": MessageLookupByLibrary.simpleMessage("in uitvoering"),
        "public": MessageLookupByLibrary.simpleMessage("openlijk"),
        "publish": MessageLookupByLibrary.simpleMessage("post"),
        "reNoteHint":
            MessageLookupByLibrary.simpleMessage("Deze post citeren..."),
        "reNoteText": MessageLookupByLibrary.simpleMessage("Citaat Post"),
        "reaction": MessageLookupByLibrary.simpleMessage("antwoord"),
        "reactionAccepting":
            MessageLookupByLibrary.simpleMessage("Emoji-reacties accepteren"),
        "reactionAcceptingAll":
            MessageLookupByLibrary.simpleMessage("volledig"),
        "reactionAcceptingLikeOnly":
            MessageLookupByLibrary.simpleMessage("Houdt alleen van"),
        "reactionAcceptingLikeOnlyRemote":
            MessageLookupByLibrary.simpleMessage("Alleen afstandsbediening"),
        "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
            "Alleen niet-gevoelige inhoud"),
        "reactionAcceptingNoneSensitiveOrLocal":
            MessageLookupByLibrary.simpleMessage(
                "Alleen niet-gevoelige inhoud (graag op afstand)"),
        "recipient":
            MessageLookupByLibrary.simpleMessage("Aan: (koptekst e-mail)"),
        "refresh":
            MessageLookupByLibrary.simpleMessage("verversen (computervenster)"),
        "registration": MessageLookupByLibrary.simpleMessage("Registration"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
        "remote": MessageLookupByLibrary.simpleMessage("op afstand"),
        "rename": MessageLookupByLibrary.simpleMessage("hernoemen"),
        "renameFile": MessageLookupByLibrary.simpleMessage("Bestand hernoemen"),
        "renameFolder":
            MessageLookupByLibrary.simpleMessage("Een map hernoemen"),
        "replyNoteHint":
            MessageLookupByLibrary.simpleMessage("Reageer op dit bericht..."),
        "replyNoteText":
            MessageLookupByLibrary.simpleMessage("Een bericht beantwoorden"),
        "saveFailed": MessageLookupByLibrary.simpleMessage("niet redden"),
        "saveImage": MessageLookupByLibrary.simpleMessage("Afbeelding opslaan"),
        "saveSuccess":
            MessageLookupByLibrary.simpleMessage("Succesvol opslaan"),
        "search": MessageLookupByLibrary.simpleMessage("iets verwachten"),
        "searchAll": MessageLookupByLibrary.simpleMessage("volledig"),
        "searchHost":
            MessageLookupByLibrary.simpleMessage("Domeinnaam opgeven"),
        "searchLocal": MessageLookupByLibrary.simpleMessage("deze site"),
        "searchRemote": MessageLookupByLibrary.simpleMessage("op afstand"),
        "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
        "secondsAgo": m17,
        "selectHashtag": MessageLookupByLibrary.simpleMessage("Tag selecteren"),
        "selectServer": MessageLookupByLibrary.simpleMessage(""),
        "selectUser":
            MessageLookupByLibrary.simpleMessage("Gebruiker selecteren"),
        "sensitiveClickShow":
            MessageLookupByLibrary.simpleMessage("Klik om te tonen"),
        "sensitiveContent":
            MessageLookupByLibrary.simpleMessage("Gevoelige inhoud"),
        "serverAddr": MessageLookupByLibrary.simpleMessage("serveradres"),
        "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
        "settings": MessageLookupByLibrary.simpleMessage("instellen"),
        "share": MessageLookupByLibrary.simpleMessage(
            "delen (vreugde, voordelen, privileges enz.) met anderen"),
        "showConversation":
            MessageLookupByLibrary.simpleMessage("Bekijk dialoog"),
        "somebodyNote": MessageLookupByLibrary.simpleMessage(" berichten"),
        "timeline": MessageLookupByLibrary.simpleMessage("tijdlijn"),
        "timelineGlobal":
            MessageLookupByLibrary.simpleMessage("veiligheidssituatie"),
        "timelineHome": MessageLookupByLibrary.simpleMessage("afb. begin"),
        "timelineHybrid": MessageLookupByLibrary.simpleMessage("socialisatie"),
        "timelineLocal": MessageLookupByLibrary.simpleMessage("deze plaats"),
        "translate": MessageLookupByLibrary.simpleMessage("weergave"),
        "uncategorized":
            MessageLookupByLibrary.simpleMessage("Ongecategoriseerd"),
        "unfollow": MessageLookupByLibrary.simpleMessage("niet volgen"),
        "updatedDate": MessageLookupByLibrary.simpleMessage("Datum bijwerken"),
        "uploadFailed": m18,
        "uploadFromUrl":
            MessageLookupByLibrary.simpleMessage("Uploaden vanaf de website"),
        "user": MessageLookupByLibrary.simpleMessage("gebruiker"),
        "userAll": MessageLookupByLibrary.simpleMessage("volledig"),
        "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
            "Deze gebruiker heeft zichzelf nog niet voorgesteld"),
        "userFile": MessageLookupByLibrary.simpleMessage("bijlage (e-mail)"),
        "userHot": MessageLookupByLibrary.simpleMessage("gebruiker"),
        "userNote": MessageLookupByLibrary.simpleMessage("kaart"),
        "userRegisterBy":
            MessageLookupByLibrary.simpleMessage("ingeschreven in"),
        "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
            "Lijst met widgets (niet voltooid)"),
        "username": MessageLookupByLibrary.simpleMessage("gebruikers-ID"),
        "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
        "video": MessageLookupByLibrary.simpleMessage("video"),
        "view": MessageLookupByLibrary.simpleMessage("uitchecken"),
        "viewMore": MessageLookupByLibrary.simpleMessage("Meer bekijken"),
        "vote": MessageLookupByLibrary.simpleMessage("referendum"),
        "voteAllCount": m19,
        "voteCount": m20,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("afsluitingsdatum"),
        "voteEnableMultiChoice":
            MessageLookupByLibrary.simpleMessage("Meerdere stemmen toegestaan"),
        "voteExpired":
            MessageLookupByLibrary.simpleMessage("Het stemmen is gesloten."),
        "voteNoDueDate": MessageLookupByLibrary.simpleMessage("permanent"),
        "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
            "Het aantal stemmen mag niet minder dan twee zijn"),
        "voteOptionHint": m21,
        "voteOptionNullIndex": m22,
        "voteResult": MessageLookupByLibrary.simpleMessage(
            "Stemuitslagen zijn gegenereerd"),
        "voteWillExpired": m23,
        "yearsAgo": m24
      };
}
