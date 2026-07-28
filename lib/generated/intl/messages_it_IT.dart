// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it_IT locale. All the
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
  String get localeName => 'it_IT';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Determinare ( / )";

  static String m1(error) => "\n\n ${error}Creazione fallita";

  static String m2(days) => "${days}giorni fa";

  static String m3(thing) => "${thing}Vuoi cancellare \" \"?";

  static String m4(name) =>
      "${name}Vuoi eliminare il file \" \"? Anche i post con questo file allegato saranno eliminati.";

  static String m5(name) =>
      "${name}Si desidera eliminare la cartella \" \"? Se nella cartella sono presenti dei contenuti, eliminare prima il contenuto della cartella.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Giorni ore minuti secondi";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Ore Minuti Secondi";

  static String m8(minute, second) => "${minute}${second}Minuti secondi";

  static String m9(second) =>
      "${second}unità di angolo o arco equivalente a un sessantesimo di grado";

  static String m10(error) => "\n\n${error}Impossibile inviare la posta";

  static String m11(hours) => "${hours}ore fa";

  static String m12(server) => "${server}Attualmente si è connessi";

  static String m13(minutes) => "${minutes}minuti fa";

  static String m14(months) => "${months}mesi fa";

  static String m15(language) => "${language} \nTradurre da a";

  static String m16(type) => "${type}Tipi di notifica non supportati:";

  static String m17(count) => "${count} reazioni";

  static String m18(count) => "${count} Rinota";

  static String m19(seconds) => "${seconds}secondi fa";

  static String m20(msg) => "\n ${msg}Caricamento fallito";

  static String m21(count) => "${count}Totale voti";

  static String m22(count) => "${count}persona tenuta in ostaggio per riscatto";

  static String m23(index) => "${index}Opzioni";

  static String m24(index) => "${index}L\'opzione non può essere vuota";

  static String m25(datetime) => "${datetime}scadenza post-completamento";

  static String m26(name) =>
      "Vuoi annullare la tua richiesta di follow inviata a ${name}?";

  static String m27(years) => "${years}...anni fa";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("nome utente"),
    "add": MessageLookupByLibrary.simpleMessage("aumento"),
    "addAccount": MessageLookupByLibrary.simpleMessage("Aggiungi account"),
    "addFile": MessageLookupByLibrary.simpleMessage("Aggiungi file"),
    "addTitle": MessageLookupByLibrary.simpleMessage("Aggiungi titolo"),
    "all": MessageLookupByLibrary.simpleMessage("completo"),
    "announcementActive": MessageLookupByLibrary.simpleMessage("Annuncio ora"),
    "announcementExpired": MessageLookupByLibrary.simpleMessage(
      "Annunci passati",
    ),
    "announcements": MessageLookupByLibrary.simpleMessage("bollettino"),
    "back": MessageLookupByLibrary.simpleMessage(
      "tornare (o tornare) indietro",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("cancellazioni"),
    "cancelSensitive": MessageLookupByLibrary.simpleMessage(
      "Sbloccare i contenuti sensibili",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clip": MessageLookupByLibrary.simpleMessage("promemoria"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "Siete sicuri di voler annullare la raccolta?",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage("Nuove note adesive"),
    "clipFavorite": MessageLookupByLibrary.simpleMessage(
      "Aggiungi ai preferiti",
    ),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage(
      "segnalibro (Internet)",
    ),
    "clipRemove": MessageLookupByLibrary.simpleMessage(
      "Rimuovere le note appiccicose",
    ),
    "clipUpdate": MessageLookupByLibrary.simpleMessage(
      "Aggiornare le note adesive",
    ),
    "clips": MessageLookupByLibrary.simpleMessage("promemoria"),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage("Copiare il contenuto"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copiare il link"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("Copia RSS"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "Copiare l\'indirizzo della homepage dell\'utente",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage(
      "Copiare il nome utente",
    ),
    "createFolder": MessageLookupByLibrary.simpleMessage("Nuova cartella"),
    "createNote": MessageLookupByLibrary.simpleMessage(
      "Pubblicare una nuova discussione",
    ),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
      "Creare un post da un file",
    ),
    "createNoteHint": MessageLookupByLibrary.simpleMessage(
      "Cosa è successo...",
    ),
    "createdDate": MessageLookupByLibrary.simpleMessage("Data di creazione"),
    "creationFailedDialog": m1,
    "cw": MessageLookupByLibrary.simpleMessage("contenuto nascosto"),
    "day": MessageLookupByLibrary.simpleMessage("giorno"),
    "daysAgo": m2,
    "delete": MessageLookupByLibrary.simpleMessage("rimozione"),
    "deleteConfirm": m3,
    "deleteFileConfirmation": m4,
    "deleteFolderConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("descrizioni"),
    "done": MessageLookupByLibrary.simpleMessage("adempiere"),
    "download": MessageLookupByLibrary.simpleMessage("scaricare"),
    "drive": MessageLookupByLibrary.simpleMessage(
      "archiviazione di file nel cloud",
    ),
    "durationDay": m6,
    "durationHour": m7,
    "durationMinute": m8,
    "durationSecond": m9,
    "edit": MessageLookupByLibrary.simpleMessage("compilatore"),
    "emoji": MessageLookupByLibrary.simpleMessage("emoticon"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "Inserire un nuovo nome di file",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage(
      "Inserire un nuovo titolo",
    ),
    "enterUrl": MessageLookupByLibrary.simpleMessage("Inserire l\'URL"),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "Il contenuto non può essere vuoto",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
      "Il contenuto non può essere vuoto",
    ),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("scoperte"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("in voga"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage("utente popolare"),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage(
      "Utenti che hanno effettuato l\'accesso di recente",
    ),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage(
      "utente in cima all\'elenco",
    ),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
      "Contributori recenti",
    ),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("utente"),
    "exportEntityAntenna": MessageLookupByLibrary.simpleMessage("Antenne"),
    "exportEntityBlocking": MessageLookupByLibrary.simpleMessage(
      "Profili bloccati",
    ),
    "exportEntityClip": MessageLookupByLibrary.simpleMessage("Clip"),
    "exportEntityCustomEmoji": MessageLookupByLibrary.simpleMessage(
      "Emoji personalizzate",
    ),
    "exportEntityFavorite": MessageLookupByLibrary.simpleMessage("Preferiti"),
    "exportEntityFollowing": MessageLookupByLibrary.simpleMessage("Following"),
    "exportEntityMuting": MessageLookupByLibrary.simpleMessage(
      "Profili silenziati",
    ),
    "exportEntityNote": MessageLookupByLibrary.simpleMessage("Note"),
    "exportEntityUserList": MessageLookupByLibrary.simpleMessage("Liste"),
    "favorite": MessageLookupByLibrary.simpleMessage("segnalibro (Internet)"),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "folderName": MessageLookupByLibrary.simpleMessage("Nome della cartella"),
    "follow": MessageLookupByLibrary.simpleMessage("focus"),
    "followRequestsSent": MessageLookupByLibrary.simpleMessage(
      "Richieste in uscita",
    ),
    "followed": MessageLookupByLibrary.simpleMessage("Seguito"),
    "followers": MessageLookupByLibrary.simpleMessage("osservatore"),
    "following": MessageLookupByLibrary.simpleMessage("Preoccupato"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("Dal netbook"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
    "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
    "hostnames": MessageLookupByLibrary.simpleMessage("nome di dominio"),
    "hour": MessageLookupByLibrary.simpleMessage("ore"),
    "hoursAgo": m11,
    "image": MessageLookupByLibrary.simpleMessage("fotografia"),
    "inputServer": MessageLookupByLibrary.simpleMessage(
      "Server di input manuale",
    ),
    "insertDriverFile": MessageLookupByLibrary.simpleMessage(
      "Inserimento di accessori",
    ),
    "isFollowingYouNow": MessageLookupByLibrary.simpleMessage(
      "Ti sto osservando.",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("recentemente"),
    "keepOriginal": MessageLookupByLibrary.simpleMessage(
      "Preservare l\'immagine originale",
    ),
    "loadingServers": MessageLookupByLibrary.simpleMessage("Server Loading"),
    "local": MessageLookupByLibrary.simpleMessage("questa località"),
    "localUpload": MessageLookupByLibrary.simpleMessage("caricamento locale"),
    "login": MessageLookupByLibrary.simpleMessage("accedi"),
    "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Errore di accesso"),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "Accesso non riuscito: creazione dell\'applicazione non riuscita",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "Accesso fallito: acquisizione del token non riuscita",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage("Accesso riuscito"),
    "manageAccount": MessageLookupByLibrary.simpleMessage(
      "Gestione dell\'account",
    ),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage(
      "Segnala come contenuto sensibile",
    ),
    "mention": MessageLookupByLibrary.simpleMessage("sollevare (un soggetto)"),
    "minute": MessageLookupByLibrary.simpleMessage("minuti"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("di più"),
    "myCLips": MessageLookupByLibrary.simpleMessage("Il mio appunto."),
    "name": MessageLookupByLibrary.simpleMessage("nome (di una cosa)"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Il nome non può essere vuoto",
    ),
    "next": MessageLookupByLibrary.simpleMessage("il passo successivo"),
    "noFollowRequests": MessageLookupByLibrary.simpleMessage(
      "Non ci sono richieste di relazione",
    ),
    "noLists": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any lists",
    ),
    "notFindServer": MessageLookupByLibrary.simpleMessage(
      "Non avete trovato il vostro server?",
    ),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "Copiare il link a questo sito",
    ),
    "noteCwHide": MessageLookupByLibrary.simpleMessage("mettere via"),
    "noteCwShow": MessageLookupByLibrary.simpleMessage(
      "Visualizzazione del contenuto",
    ),
    "noteFormLanguageTranslation": m15,
    "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
      "Mancata partecipazione a un\'azione congiunta",
    ),
    "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
      "Accedere al server host per visualizzare",
    ),
    "notePined": MessageLookupByLibrary.simpleMessage("Messaggi principali"),
    "noteQuote": MessageLookupByLibrary.simpleMessage("citazione"),
    "noteReNote": MessageLookupByLibrary.simpleMessage(
      "inoltro (posta, SMS, pacchetti di dati)",
    ),
    "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Inoltrata."),
    "noteTranslate": MessageLookupByLibrary.simpleMessage(
      "Traduzione dei messaggi",
    ),
    "noteVisibility": MessageLookupByLibrary.simpleMessage("visibilità"),
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage(
      "osservatore",
    ),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "Invia solo ai follower",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("inizio fig."),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "Timeline inviata solo alla home page",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("apertamente"),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "Il vostro post apparirà nella timeline globale",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
      "lettera privata",
    ),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "Invia solo agli utenti specificati",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("scheda"),
    "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
    "notification": MessageLookupByLibrary.simpleMessage("notifiche"),
    "notifications": MessageLookupByLibrary.simpleMessage("notifiche"),
    "notifyAccept": MessageLookupByLibrary.simpleMessage("Accetta"),
    "notifyAccepted": MessageLookupByLibrary.simpleMessage(
      "La tua richiesta di follow è stata accettata",
    ),
    "notifyAchievementEarned": MessageLookupByLibrary.simpleMessage(
      "Obiettivo raggiunto",
    ),
    "notifyActionFailed": MessageLookupByLibrary.simpleMessage(
      "Action failed. Please try again",
    ),
    "notifyAll": MessageLookupByLibrary.simpleMessage("completo"),
    "notifyApp": MessageLookupByLibrary.simpleMessage(
      "Notifiche da applicazioni",
    ),
    "notifyChatRoomInvitationUnsupported": MessageLookupByLibrary.simpleMessage(
      "Chat room invitations are not supported",
    ),
    "notifyCreateToken": MessageLookupByLibrary.simpleMessage(
      "È stato creato un token di accesso",
    ),
    "notifyCreateTokenDescription": MessageLookupByLibrary.simpleMessage(
      "Se non ne sai nulla, elimina il token di accesso: API.",
    ),
    "notifyExportCompleted": MessageLookupByLibrary.simpleMessage(
      "Esportazione completata",
    ),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("screening"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "La vostra richiesta di attenzione è stata approvata.",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
      "Avete nuovi seguaci.",
    ),
    "notifyLogin": MessageLookupByLibrary.simpleMessage(
      "Autenticazione avvenuta",
    ),
    "notifyLoginDescription": MessageLookupByLibrary.simpleMessage(
      "Autenticazione avvenuta",
    ),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
      "Contrassegnare tutti come letti",
    ),
    "notifyMention": MessageLookupByLibrary.simpleMessage("Parlando del mio"),
    "notifyMentionedYou": MessageLookupByLibrary.simpleMessage("Menzioni"),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("lettera privata"),
    "notifyNewNote": MessageLookupByLibrary.simpleMessage("Nuove Note"),
    "notifyNotSupport": m16,
    "notifyPollEnded": MessageLookupByLibrary.simpleMessage(
      "Risultati del sondaggio.",
    ),
    "notifyQuoted": MessageLookupByLibrary.simpleMessage("Cita"),
    "notifyReacted": MessageLookupByLibrary.simpleMessage("Reazioni"),
    "notifyReactionGrouped": m17,
    "notifyReceiveFollowRequest": MessageLookupByLibrary.simpleMessage(
      "Hai ricevuto una richiesta di follow",
    ),
    "notifyReject": MessageLookupByLibrary.simpleMessage("Rifiuta"),
    "notifyRejected": MessageLookupByLibrary.simpleMessage("Rifiuta"),
    "notifyRenoteGrouped": m18,
    "notifyRenoted": MessageLookupByLibrary.simpleMessage("Rinota"),
    "notifyRepliedToYou": MessageLookupByLibrary.simpleMessage("Risposte"),
    "notifyRoleAssigned": MessageLookupByLibrary.simpleMessage(
      "Ruolo assegnato",
    ),
    "notifyScheduledNotePostFailed": MessageLookupByLibrary.simpleMessage(
      "Impossibile pubblicare la Nota pianificata",
    ),
    "notifyScheduledNotePostFailedDescription":
        MessageLookupByLibrary.simpleMessage(
          "Impossibile pubblicare la Nota pianificata",
        ),
    "notifyScheduledNotePosted": MessageLookupByLibrary.simpleMessage(
      "Pubblicazione Nota pianificata",
    ),
    "notifyScheduledNotePostedDescription":
        MessageLookupByLibrary.simpleMessage("Pubblicazione Nota pianificata"),
    "notifyTest": MessageLookupByLibrary.simpleMessage("Provare la notifica"),
    "notifyTestDescription": MessageLookupByLibrary.simpleMessage(
      "La notifica apparirà così",
    ),
    "ok": MessageLookupByLibrary.simpleMessage("definire"),
    "openInNewTab": MessageLookupByLibrary.simpleMessage(
      "Vai alla visualizzazione del browser",
    ),
    "overviews": MessageLookupByLibrary.simpleMessage("sfogliare"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "Preoccupazione per l\'accoglimento delle richieste",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("anteprime"),
    "previewNote": MessageLookupByLibrary.simpleMessage("Anteprima dei post"),
    "processing": MessageLookupByLibrary.simpleMessage("in corso"),
    "public": MessageLookupByLibrary.simpleMessage("apertamente"),
    "publish": MessageLookupByLibrary.simpleMessage("posta"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage(
      "Citando questo post...",
    ),
    "reNoteText": MessageLookupByLibrary.simpleMessage("Citazione Post"),
    "reaction": MessageLookupByLibrary.simpleMessage("risposta"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage(
      "Accettare le risposte Emoji",
    ),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("completo"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
      "Piace solo",
    ),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "Solo Kudos remoto",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "Solo contenuti non sensibili",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage(
          "Solo contenuti non sensibili (solo per chi ama il remoto)",
        ),
    "recipient": MessageLookupByLibrary.simpleMessage(
      "A: (intestazione dell\'e-mail)",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage(
      "Aggiorna (finestra del computer)",
    ),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
    "remote": MessageLookupByLibrary.simpleMessage("distanza"),
    "rename": MessageLookupByLibrary.simpleMessage("rinominare"),
    "renameFile": MessageLookupByLibrary.simpleMessage("Rinominare il file"),
    "renameFolder": MessageLookupByLibrary.simpleMessage(
      "Rinominare una cartella",
    ),
    "replyNoteHint": MessageLookupByLibrary.simpleMessage(
      "Rispondi a questo post...",
    ),
    "replyNoteText": MessageLookupByLibrary.simpleMessage(
      "Rispondere a un post",
    ),
    "saveFailed": MessageLookupByLibrary.simpleMessage(
      "non riescono a salvare",
    ),
    "saveImage": MessageLookupByLibrary.simpleMessage("Salva immagine"),
    "saveSuccess": MessageLookupByLibrary.simpleMessage("Salva il successo"),
    "search": MessageLookupByLibrary.simpleMessage("cercare qcs."),
    "searchAll": MessageLookupByLibrary.simpleMessage("completo"),
    "searchHost": MessageLookupByLibrary.simpleMessage(
      "Specificare il nome del dominio",
    ),
    "searchLocal": MessageLookupByLibrary.simpleMessage("questo sito"),
    "searchRemote": MessageLookupByLibrary.simpleMessage("a distanza"),
    "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
    "secondsAgo": m19,
    "selectHashtag": MessageLookupByLibrary.simpleMessage(
      "Selezionare l\'etichetta",
    ),
    "selectServer": MessageLookupByLibrary.simpleMessage(
      "Please Select Your Server",
    ),
    "selectUser": MessageLookupByLibrary.simpleMessage("Selezionare l\'utente"),
    "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
      "Fare clic per visualizzare",
    ),
    "sensitiveContent": MessageLookupByLibrary.simpleMessage(
      "Contenuti sensibili",
    ),
    "serverAddr": MessageLookupByLibrary.simpleMessage("indirizzo del server"),
    "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
    "settings": MessageLookupByLibrary.simpleMessage("allestimento"),
    "share": MessageLookupByLibrary.simpleMessage(
      "condividere (gioie, benefici, privilegi, ecc.) con gli altri",
    ),
    "showConversation": MessageLookupByLibrary.simpleMessage(
      "Visualizza il dialogo",
    ),
    "somebodyNote": MessageLookupByLibrary.simpleMessage(" posti"),
    "timeline": MessageLookupByLibrary.simpleMessage("linea del tempo"),
    "timelineGlobal": MessageLookupByLibrary.simpleMessage(
      "situazione della sicurezza",
    ),
    "timelineHome": MessageLookupByLibrary.simpleMessage("inizio fig."),
    "timelineHybrid": MessageLookupByLibrary.simpleMessage("socializzazione"),
    "timelineLocal": MessageLookupByLibrary.simpleMessage("questa località"),
    "translate": MessageLookupByLibrary.simpleMessage("rendering"),
    "uncategorized": MessageLookupByLibrary.simpleMessage("Senza categoria"),
    "unfollow": MessageLookupByLibrary.simpleMessage("Non seguire"),
    "updatedDate": MessageLookupByLibrary.simpleMessage(
      "Data di aggiornamento",
    ),
    "uploadFailed": m20,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
      "Caricare dal sito web",
    ),
    "user": MessageLookupByLibrary.simpleMessage("utente"),
    "userAll": MessageLookupByLibrary.simpleMessage("completo"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
      "Questo utente non si è ancora presentato",
    ),
    "userFile": MessageLookupByLibrary.simpleMessage("allegato (e-mail)"),
    "userHot": MessageLookupByLibrary.simpleMessage("utente"),
    "userNote": MessageLookupByLibrary.simpleMessage("scheda"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage("registrato in"),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "Elenco dei widget (non finito)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("ID utente"),
    "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
    "video": MessageLookupByLibrary.simpleMessage("video"),
    "view": MessageLookupByLibrary.simpleMessage("controllare"),
    "viewMore": MessageLookupByLibrary.simpleMessage("Per saperne di più"),
    "vote": MessageLookupByLibrary.simpleMessage("referendum"),
    "voteAllCount": m21,
    "voteCount": m22,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("data di scadenza"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
      "Sono consentiti più voti",
    ),
    "voteExpired": MessageLookupByLibrary.simpleMessage(
      "Le votazioni sono chiuse.",
    ),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("permanentemente"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "Il numero di voti non può essere inferiore a due",
    ),
    "voteOptionHint": m23,
    "voteOptionNullIndex": m24,
    "voteResult": MessageLookupByLibrary.simpleMessage(
      "I risultati delle votazioni sono stati generati",
    ),
    "voteWillExpired": m25,
    "withdrawFollowRequestConfirm": m26,
    "yearsAgo": m27,
  };
}
