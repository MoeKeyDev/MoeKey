// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a el_GR locale. All the
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
  String get localeName => 'el_GR';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Προσδιορίστε ( / )";

  static String m1(error) => "\n\n ${error}Η δημιουργία απέτυχε";

  static String m2(days) => "${days}ημέρες πριν";

  static String m3(thing) => "${thing}Θέλετε να διαγράψετε το \" \";";

  static String m4(name) =>
      "${name}Θέλετε να διαγράψετε το αρχείο \" \"; Οι αναρτήσεις με αυτό το αρχείο θα διαγραφούν επίσης.";

  static String m5(name) =>
      "${name}Θέλετε να διαγράψετε το φάκελο \" \"; Εάν υπάρχουν περιεχόμενα στο φάκελο, διαγράψτε πρώτα τα περιεχόμενα του φακέλου.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Ημέρες ώρες λεπτά δευτερόλεπτα";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Ώρες Λεπτά Δευτερόλεπτα";

  static String m8(minute, second) => "${minute}${second}Λεπτά δευτερόλεπτα";

  static String m9(second) =>
      "${second}μονάδα γωνίας ή τόξου που ισοδυναμεί με ένα εξηκοστό της μοίρας";

  static String m10(error) => "\n\n${error}Απέτυχε να στείλει μήνυμα";

  static String m11(hours) => "${hours}ώρες πριν";

  static String m12(server) => "${server}Αυτή τη στιγμή συνδεδεμένος";

  static String m13(minutes) => "${minutes}πριν από λίγα λεπτά";

  static String m14(months) => "${months}μήνες πριν";

  static String m15(language) => "${language} \nΜεταφράστε από σε";

  static String m16(type) => "${type}Μη υποστηριζόμενοι τύποι ειδοποιήσεων:";

  static String m17(seconds) => "${seconds}δευτερόλεπτα πριν";

  static String m18(msg) => "\n ${msg}Αποτυχία αποστολής";

  static String m19(count) => "${count}Σύνολο ψήφων";

  static String m20(count) => "${count}πρόσωπο που κρατείται για λύτρα";

  static String m21(index) => "${index}Επιλογές";

  static String m22(index) => "${index}Η επιλογή δεν μπορεί να είναι κενή";

  static String m23(datetime) => "${datetime}προθεσμία μετά την ολοκλήρωση";

  static String m24(years) => "${years}...χρόνια πριν";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("όνομα χρήστη"),
    "add": MessageLookupByLibrary.simpleMessage("αύξηση"),
    "addAccount": MessageLookupByLibrary.simpleMessage("Προσθήκη λογαριασμού"),
    "addFile": MessageLookupByLibrary.simpleMessage("Προσθήκη αρχείου"),
    "addTitle": MessageLookupByLibrary.simpleMessage("Προσθήκη τίτλου"),
    "all": MessageLookupByLibrary.simpleMessage("πλήρες"),
    "announcementActive": MessageLookupByLibrary.simpleMessage(
      "Ανακοίνωση τώρα",
    ),
    "announcementExpired": MessageLookupByLibrary.simpleMessage(
      "Προηγούμενες ανακοινώσεις",
    ),
    "announcements": MessageLookupByLibrary.simpleMessage("Δελτίο"),
    "back": MessageLookupByLibrary.simpleMessage(
      "να επιστρέψετε (ή να επιστρέψετε)",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("ακυρώσεις"),
    "cancelSensitive": MessageLookupByLibrary.simpleMessage(
      "Αποσυνδέστε την επισήμανση ευαίσθητου περιεχομένου",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clip": MessageLookupByLibrary.simpleMessage("σημείωμα"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "Σίγουρα θέλετε να ακυρώσετε τη συλλογή;",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage(
      "Νέες αυτοκόλλητες σημειώσεις",
    ),
    "clipFavorite": MessageLookupByLibrary.simpleMessage(
      "Προσθήκη στα αγαπημένα",
    ),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage(
      "σελιδοδείκτης (Internet)",
    ),
    "clipRemove": MessageLookupByLibrary.simpleMessage(
      "Αφαίρεση αυτοκόλλητων σημειώσεων",
    ),
    "clipUpdate": MessageLookupByLibrary.simpleMessage(
      "Ενημέρωση αυτοκόλλητων σημειώσεων",
    ),
    "clips": MessageLookupByLibrary.simpleMessage("σημείωμα"),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage(
      "Αντιγραφή περιεχομένου",
    ),
    "copyLink": MessageLookupByLibrary.simpleMessage("Αντιγραφή συνδέσμου"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("Αντιγραφή RSS"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "Αντιγράψτε τη διεύθυνση της αρχικής σελίδας του χρήστη",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage(
      "Αντιγραφή ονόματος χρήστη",
    ),
    "createFolder": MessageLookupByLibrary.simpleMessage("Νέος φάκελος"),
    "createNote": MessageLookupByLibrary.simpleMessage(
      "Δημοσιεύστε ένα νέο νήμα",
    ),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
      "Δημιουργία μιας ανάρτησης από ένα αρχείο",
    ),
    "createNoteHint": MessageLookupByLibrary.simpleMessage("Τι συνέβη..."),
    "createdDate": MessageLookupByLibrary.simpleMessage(
      "Ημερομηνία δημιουργίας",
    ),
    "creationFailedDialog": m1,
    "cw": MessageLookupByLibrary.simpleMessage("κρυφό περιεχόμενο"),
    "day": MessageLookupByLibrary.simpleMessage("ημέρα"),
    "daysAgo": m2,
    "delete": MessageLookupByLibrary.simpleMessage("αφαίρεση του"),
    "deleteConfirm": m3,
    "deleteFileConfirmation": m4,
    "deleteFolderConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("περιγραφές"),
    "done": MessageLookupByLibrary.simpleMessage("πληρούν"),
    "download": MessageLookupByLibrary.simpleMessage("Λήψη"),
    "drive": MessageLookupByLibrary.simpleMessage(
      "αποθήκευση αρχείων στο σύννεφο",
    ),
    "durationDay": m6,
    "durationHour": m7,
    "durationMinute": m8,
    "durationSecond": m9,
    "edit": MessageLookupByLibrary.simpleMessage("μεταγλωττιστής"),
    "emoji": MessageLookupByLibrary.simpleMessage("emoticon"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "Παρακαλώ εισάγετε ένα νέο όνομα αρχείου",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage(
      "Παρακαλώ εισάγετε έναν νέο τίτλο",
    ),
    "enterUrl": MessageLookupByLibrary.simpleMessage(
      "Παρακαλώ εισάγετε το URL",
    ),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "Το περιεχόμενο δεν μπορεί να είναι κενό",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
      "Το περιεχόμενο δεν μπορεί να είναι κενό",
    ),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("ανακαλύψεις"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("στη μόδα"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage("δημοφιλής χρήστης"),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage(
      "Πρόσφατα συνδεδεμένοι χρήστες",
    ),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage(
      "χρήστης στην κορυφή της λίστας",
    ),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
      "Πρόσφατοι συνεισφέροντες",
    ),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("χρήστης"),
    "favorite": MessageLookupByLibrary.simpleMessage(
      "σελιδοδείκτης (Internet)",
    ),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "folderName": MessageLookupByLibrary.simpleMessage("Όνομα φακέλου"),
    "follow": MessageLookupByLibrary.simpleMessage("εστίαση"),
    "followed": MessageLookupByLibrary.simpleMessage("Ακολούθησε το"),
    "followers": MessageLookupByLibrary.simpleMessage("παρατηρητής"),
    "following": MessageLookupByLibrary.simpleMessage("Ανήσυχο"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("Από το netbook"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
    "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
    "hostnames": MessageLookupByLibrary.simpleMessage("όνομα τομέα"),
    "hour": MessageLookupByLibrary.simpleMessage("ώρες"),
    "hoursAgo": m11,
    "image": MessageLookupByLibrary.simpleMessage("φωτογραφία"),
    "inputServer": MessageLookupByLibrary.simpleMessage(
      "Χειροκίνητος διακομιστής εισόδου",
    ),
    "insertDriverFile": MessageLookupByLibrary.simpleMessage(
      "Τοποθέτηση εξαρτημάτων",
    ),
    "isFollowingYouNow": MessageLookupByLibrary.simpleMessage(
      "Σε παρακολουθώ.",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("μόλις πρόσφατα"),
    "keepOriginal": MessageLookupByLibrary.simpleMessage(
      "Διατήρηση της αρχικής εικόνας",
    ),
    "loadingServers": MessageLookupByLibrary.simpleMessage("Server Loading"),
    "local": MessageLookupByLibrary.simpleMessage("αυτή η τοποθεσία"),
    "localUpload": MessageLookupByLibrary.simpleMessage("τοπικό ανέβασμα"),
    "login": MessageLookupByLibrary.simpleMessage("εγγραφή"),
    "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Αποτυχία σύνδεσης"),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "Αποτυχία σύνδεσης: Αποτυχία δημιουργίας εφαρμογής",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "Αποτυχία σύνδεσης: η απόκτηση του κουπονιού απέτυχε",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage("Επιτυχής σύνδεση"),
    "manageAccount": MessageLookupByLibrary.simpleMessage(
      "Διαχείριση λογαριασμού",
    ),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage(
      "Σημειώστε ως ευαίσθητο περιεχόμενο",
    ),
    "mention": MessageLookupByLibrary.simpleMessage("εγείρει (ένα θέμα)"),
    "minute": MessageLookupByLibrary.simpleMessage("λεπτά"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("περισσότερα"),
    "myCLips": MessageLookupByLibrary.simpleMessage("Η σημείωσή μου."),
    "name": MessageLookupByLibrary.simpleMessage("όνομα (ενός πράγματος)"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "Το όνομα δεν μπορεί να είναι κενό",
    ),
    "next": MessageLookupByLibrary.simpleMessage("το επόμενο βήμα"),
    "noLists": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any lists",
    ),
    "notFindServer": MessageLookupByLibrary.simpleMessage(
      "Δεν βρήκατε τον διακομιστή σας;",
    ),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "Αντιγράψτε τον σύνδεσμο σε αυτόν τον ιστότοπο",
    ),
    "noteCwHide": MessageLookupByLibrary.simpleMessage("να τακτοποιήσω"),
    "noteCwShow": MessageLookupByLibrary.simpleMessage("Εμφάνιση περιεχομένου"),
    "noteFormLanguageTranslation": m15,
    "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
      "Μη συμμετοχή σε κοινή",
    ),
    "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
      "Μεταβείτε στον κεντρικό διακομιστή για να εμφανίσετε",
    ),
    "notePined": MessageLookupByLibrary.simpleMessage("Κορυφαίες θέσεις"),
    "noteQuote": MessageLookupByLibrary.simpleMessage("απόσπασμα"),
    "noteReNote": MessageLookupByLibrary.simpleMessage(
      "προώθηση (αλληλογραφία, SMS, πακέτα δεδομένων)",
    ),
    "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Προωθείται."),
    "noteTranslate": MessageLookupByLibrary.simpleMessage(
      "Μετάφραση των αναρτήσεων",
    ),
    "noteVisibility": MessageLookupByLibrary.simpleMessage("ορατότητα"),
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage(
      "παρατηρητής",
    ),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "Στείλτε μόνο σε οπαδούς",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("εικ. αρχή"),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "Χρονολόγιο που αποστέλλεται μόνο στην αρχική σελίδα",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("ανοιχτά"),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "Η ανάρτησή σας θα εμφανιστεί στο παγκόσμιο χρονολόγιο",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
      "ιδιωτική επιστολή",
    ),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "Αποστολή μόνο σε συγκεκριμένους χρήστες",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("κάρτα"),
    "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
    "notification": MessageLookupByLibrary.simpleMessage("ειδοποιήσεις"),
    "notifications": MessageLookupByLibrary.simpleMessage("ειδοποιήσεις"),
    "notifyAll": MessageLookupByLibrary.simpleMessage("πλήρες"),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("διαλογή"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "Το αίτημά σας για προσοχή έχει εγκριθεί.",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
      "Έχετε νέους οπαδούς.",
    ),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
      "Σημειώστε τα όλα ως αναγνωσμένα",
    ),
    "notifyMention": MessageLookupByLibrary.simpleMessage("Μιλώντας για το"),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("ιδιωτική επιστολή"),
    "notifyNotSupport": m16,
    "ok": MessageLookupByLibrary.simpleMessage("define"),
    "openInNewTab": MessageLookupByLibrary.simpleMessage(
      "Μεταβείτε στην οθόνη του προγράμματος περιήγησης",
    ),
    "overviews": MessageLookupByLibrary.simpleMessage("ξεφυλλίζω"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "Ανησυχίες σχετικά με την ικανοποίηση των αιτήσεων",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("προεπισκοπήσεις"),
    "previewNote": MessageLookupByLibrary.simpleMessage(
      "Δημοσιεύσεις προεπισκόπησης",
    ),
    "processing": MessageLookupByLibrary.simpleMessage("σε εξέλιξη"),
    "public": MessageLookupByLibrary.simpleMessage("ανοιχτά"),
    "publish": MessageLookupByLibrary.simpleMessage("μετά"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage(
      "Παραθέτοντας αυτή τη θέση...",
    ),
    "reNoteText": MessageLookupByLibrary.simpleMessage("Quote Post"),
    "reaction": MessageLookupByLibrary.simpleMessage("απάντηση"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage(
      "Αποδοχή απαντήσεων Emoji",
    ),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("πλήρες"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
      "Μου αρέσει μόνο",
    ),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "Μόνο απομακρυσμένα Kudos",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "Μόνο μη ευαίσθητο περιεχόμενο",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage(
          "Μόνο μη ευαίσθητο περιεχόμενο (μόνο απομακρυσμένες συμπάθειες)",
        ),
    "recipient": MessageLookupByLibrary.simpleMessage(
      "Προς: (επικεφαλίδα ηλεκτρονικού ταχυδρομείου)",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage(
      "ανανέωση (παράθυρο υπολογιστή)",
    ),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
    "remote": MessageLookupByLibrary.simpleMessage("εξ αποστάσεως"),
    "rename": MessageLookupByLibrary.simpleMessage("μετονομασία"),
    "renameFile": MessageLookupByLibrary.simpleMessage("Μετονομασία αρχείου"),
    "renameFolder": MessageLookupByLibrary.simpleMessage("Μετονομασία φακέλου"),
    "replyNoteHint": MessageLookupByLibrary.simpleMessage(
      "Απάντηση σε αυτή τη θέση...",
    ),
    "replyNoteText": MessageLookupByLibrary.simpleMessage(
      "Απάντηση σε μια ανάρτηση",
    ),
    "saveFailed": MessageLookupByLibrary.simpleMessage("αποτυγχάνει να σώσει"),
    "saveImage": MessageLookupByLibrary.simpleMessage("Αποθήκευση εικόνας"),
    "saveSuccess": MessageLookupByLibrary.simpleMessage(
      "Αποθήκευση επιτυχημένων",
    ),
    "search": MessageLookupByLibrary.simpleMessage("ψάχνω για κάτι."),
    "searchAll": MessageLookupByLibrary.simpleMessage("πλήρες"),
    "searchHost": MessageLookupByLibrary.simpleMessage(
      "Καθορίστε το όνομα τομέα",
    ),
    "searchLocal": MessageLookupByLibrary.simpleMessage("αυτός ο ιστότοπος"),
    "searchRemote": MessageLookupByLibrary.simpleMessage("εξ αποστάσεως"),
    "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
    "secondsAgo": m17,
    "selectHashtag": MessageLookupByLibrary.simpleMessage("Επιλέξτε ετικέτα"),
    "selectServer": MessageLookupByLibrary.simpleMessage(
      "Please Select Your Server",
    ),
    "selectUser": MessageLookupByLibrary.simpleMessage("Επιλέξτε χρήστη"),
    "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
      "Κάντε κλικ για να εμφανιστεί",
    ),
    "sensitiveContent": MessageLookupByLibrary.simpleMessage(
      "Ευαίσθητο περιεχόμενο",
    ),
    "serverAddr": MessageLookupByLibrary.simpleMessage("διεύθυνση διακομιστή"),
    "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
    "settings": MessageLookupByLibrary.simpleMessage("δημιουργία"),
    "share": MessageLookupByLibrary.simpleMessage(
      "να μοιράζεστε (χαρές, οφέλη, προνόμια κ.λπ.) με άλλους",
    ),
    "showConversation": MessageLookupByLibrary.simpleMessage(
      "Προβολή διαλόγου",
    ),
    "somebodyNote": MessageLookupByLibrary.simpleMessage(" θέσεις"),
    "timeline": MessageLookupByLibrary.simpleMessage("χρονοδιάγραμμα"),
    "timelineGlobal": MessageLookupByLibrary.simpleMessage(
      "κατάσταση ασφαλείας",
    ),
    "timelineHome": MessageLookupByLibrary.simpleMessage("εικ. αρχή"),
    "timelineHybrid": MessageLookupByLibrary.simpleMessage("κοινωνικοποίηση"),
    "timelineLocal": MessageLookupByLibrary.simpleMessage("αυτή η τοποθεσία"),
    "translate": MessageLookupByLibrary.simpleMessage("rendering"),
    "uncategorized": MessageLookupByLibrary.simpleMessage(
      "Μη κατηγοριοποιημένο",
    ),
    "unfollow": MessageLookupByLibrary.simpleMessage("Ακολουθήστε το"),
    "updatedDate": MessageLookupByLibrary.simpleMessage(
      "Ημερομηνία ενημέρωσης",
    ),
    "uploadFailed": m18,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
      "Ανέβασμα από την ιστοσελίδα",
    ),
    "user": MessageLookupByLibrary.simpleMessage("χρήστης"),
    "userAll": MessageLookupByLibrary.simpleMessage("πλήρες"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
      "Αυτός ο χρήστης δεν έχει ακόμη συστηθεί",
    ),
    "userFile": MessageLookupByLibrary.simpleMessage("συνημμένο (email)"),
    "userHot": MessageLookupByLibrary.simpleMessage("χρήστης"),
    "userNote": MessageLookupByLibrary.simpleMessage("κάρτα"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage("εγγεγραμμένος στο"),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "Λίστα widgets (ημιτελής)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("αναγνωριστικό χρήστη"),
    "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
    "video": MessageLookupByLibrary.simpleMessage("βίντεο"),
    "view": MessageLookupByLibrary.simpleMessage("ελέγξτε"),
    "viewMore": MessageLookupByLibrary.simpleMessage("Προβολή περισσότερων"),
    "vote": MessageLookupByLibrary.simpleMessage("δημοψήφισμα"),
    "voteAllCount": m19,
    "voteCount": m20,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("ημερομηνία αποκοπής"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
      "Επιτρέπονται πολλαπλές ψήφοι",
    ),
    "voteExpired": MessageLookupByLibrary.simpleMessage(
      "Η ψηφοφορία ολοκληρώθηκε.",
    ),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("μόνιμα"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "Ο αριθμός των ψήφων δεν μπορεί να είναι μικρότερος από δύο",
    ),
    "voteOptionHint": m21,
    "voteOptionNullIndex": m22,
    "voteResult": MessageLookupByLibrary.simpleMessage(
      "Τα αποτελέσματα της ψηφοφορίας έχουν δημιουργηθεί",
    ),
    "voteWillExpired": m23,
    "yearsAgo": m24,
  };
}
