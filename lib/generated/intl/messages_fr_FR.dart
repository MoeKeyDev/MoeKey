// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr_FR locale. All the
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
  String get localeName => 'fr_FR';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Déterminer ( / )";

  static String m1(error) => "创建失败\n\n ${error}";

  static String m2(days) => "${days}il y a quelques jours";

  static String m3(thing) => "${thing}Vous souhaitez supprimer \" \" ?";

  static String m4(name) =>
      "${name}Vous souhaitez supprimer le fichier \" \" ? Les messages contenant ce fichier seront également supprimés.";

  static String m5(name) =>
      "${name}Vous souhaitez supprimer le dossier \" \" ? Si le dossier contient du contenu, veuillez d\'abord supprimer le contenu du dossier.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Jours heures minutes secondes";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Heures Minutes Secondes";

  static String m8(minute, second) => "${minute}${second}Minutes secondes";

  static String m9(second) =>
      "${second}unité d\'angle ou d\'arc équivalant à un soixantième de degré";

  static String m10(error) => "\n\n${error}Échec de l\'envoi du courrier";

  static String m11(hours) => "${hours}il y a quelques heures";

  static String m12(server) => "${server}Actuellement connecté";

  static String m13(minutes) => "${minutes}il y a quelques minutes";

  static String m14(months) => "${months}il y a quelques mois";

  static String m15(language) => "${language} \nTraduire de à";

  static String m16(type) =>
      "${type}Types de notification non pris en charge :";

  static String m17(seconds) => "${seconds}secondes il y a";

  static String m18(msg) => "上传失败\n ${msg}";

  static String m19(count) => "${count}Total des votes";

  static String m20(count) => "${count}personne retenue contre rançon";

  static String m21(index) => "${index}Options";

  static String m22(index) => "${index}L\'option ne peut pas être vide";

  static String m23(datetime) => "${datetime}délai après achèvement";

  static String m24(years) => "${years}...ans plus tôt";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("nom d\'utilisateur"),
        "add": MessageLookupByLibrary.simpleMessage("augmenter"),
        "addAccount": MessageLookupByLibrary.simpleMessage("Ajouter un compte"),
        "addFile": MessageLookupByLibrary.simpleMessage("Ajouter un fichier"),
        "addTitle": MessageLookupByLibrary.simpleMessage("Ajouter un titre"),
        "all": MessageLookupByLibrary.simpleMessage("complet"),
        "announcementActive":
            MessageLookupByLibrary.simpleMessage("Annonce maintenant"),
        "announcementExpired":
            MessageLookupByLibrary.simpleMessage("Annonces passées"),
        "announcements": MessageLookupByLibrary.simpleMessage("bulletins"),
        "back": MessageLookupByLibrary.simpleMessage("revenir (ou repartir)"),
        "cancel": MessageLookupByLibrary.simpleMessage("annulations"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage(
            "Débloquer les contenus sensibles"),
        "clip": MessageLookupByLibrary.simpleMessage("mémo"),
        "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
            "Vous êtes sûr de vouloir annuler la collecte ?"),
        "clipCreate": MessageLookupByLibrary.simpleMessage(
            "Nouvelles notes autocollantes"),
        "clipFavorite":
            MessageLookupByLibrary.simpleMessage("Ajouter aux favoris"),
        "clipFavoriteList":
            MessageLookupByLibrary.simpleMessage("signet (Internet)"),
        "clipRemove": MessageLookupByLibrary.simpleMessage(
            "Supprimer les notes autocollantes"),
        "clipUpdate": MessageLookupByLibrary.simpleMessage(
            "Mise à jour des notes autocollantes"),
        "clips": MessageLookupByLibrary.simpleMessage("mémo"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "confirmSelection": m0,
        "copyContent":
            MessageLookupByLibrary.simpleMessage("Copier le contenu"),
        "copyLink": MessageLookupByLibrary.simpleMessage("Copier le lien"),
        "copyRSS": MessageLookupByLibrary.simpleMessage("Copier RSS"),
        "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
            "Copier l\'adresse de la page d\'accueil de l\'utilisateur"),
        "copyUsername": MessageLookupByLibrary.simpleMessage(
            "Copier le nom d\'utilisateur"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Nouveau dossier"),
        "createNote": MessageLookupByLibrary.simpleMessage(
            "Publier un nouveau fil de discussion"),
        "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
            "Création d\'un message à partir d\'un fichier"),
        "createNoteHint":
            MessageLookupByLibrary.simpleMessage("Ce qui s\'est passé..."),
        "createdDate": MessageLookupByLibrary.simpleMessage("Date de création"),
        "creationFailedDialog": m1,
        "cw": MessageLookupByLibrary.simpleMessage("contenu caché"),
        "day": MessageLookupByLibrary.simpleMessage("jour"),
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("supprimer"),
        "deleteConfirm": m3,
        "deleteFileConfirmation": m4,
        "deleteFolderConfirmation": m5,
        "description": MessageLookupByLibrary.simpleMessage("descriptions"),
        "done": MessageLookupByLibrary.simpleMessage("remplir"),
        "download": MessageLookupByLibrary.simpleMessage("téléchargement"),
        "drive": MessageLookupByLibrary.simpleMessage(
            "stockage de fichiers dans le nuage"),
        "durationDay": m6,
        "durationHour": m7,
        "durationMinute": m8,
        "durationSecond": m9,
        "edit": MessageLookupByLibrary.simpleMessage("compilateur"),
        "emoji": MessageLookupByLibrary.simpleMessage("émoticône"),
        "enterNewFileName": MessageLookupByLibrary.simpleMessage(
            "Veuillez saisir un nouveau nom de fichier"),
        "enterNewTitle": MessageLookupByLibrary.simpleMessage(
            "Veuillez saisir un nouveau titre"),
        "enterUrl":
            MessageLookupByLibrary.simpleMessage("Veuillez saisir l\'URL"),
        "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
            "Le contenu ne peut pas être vide"),
        "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
            "Le contenu ne peut pas être vide"),
        "exceptionSendNote": m10,
        "explore": MessageLookupByLibrary.simpleMessage("découvertes"),
        "exploreHot": MessageLookupByLibrary.simpleMessage("en vogue"),
        "exploreUserHot":
            MessageLookupByLibrary.simpleMessage("utilisateur populaire"),
        "exploreUserLast": MessageLookupByLibrary.simpleMessage(
            "Utilisateurs récemment connectés"),
        "exploreUserPined": MessageLookupByLibrary.simpleMessage(
            "utilisateur en tête de liste"),
        "exploreUserUpdated":
            MessageLookupByLibrary.simpleMessage("Contributeurs récents"),
        "exploreUsers": MessageLookupByLibrary.simpleMessage("utilisateur"),
        "favorite": MessageLookupByLibrary.simpleMessage("signet (Internet)"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "folderName": MessageLookupByLibrary.simpleMessage("Nom du dossier"),
        "follow": MessageLookupByLibrary.simpleMessage("se focaliser"),
        "followed": MessageLookupByLibrary.simpleMessage("Suivi"),
        "followers": MessageLookupByLibrary.simpleMessage("observateur"),
        "following": MessageLookupByLibrary.simpleMessage("Inquiétude"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("Depuis le netbook"),
        "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
        "hashtag": MessageLookupByLibrary.simpleMessage("Tags thématiques"),
        "hostnames": MessageLookupByLibrary.simpleMessage("nom de domaine"),
        "hour": MessageLookupByLibrary.simpleMessage("heures"),
        "hoursAgo": m11,
        "image": MessageLookupByLibrary.simpleMessage("photographie"),
        "inputServer":
            MessageLookupByLibrary.simpleMessage("Serveur de saisie manuelle"),
        "insertDriverFile":
            MessageLookupByLibrary.simpleMessage("Insertion d\'accessoires"),
        "isFollowingYouNow":
            MessageLookupByLibrary.simpleMessage("Je vous observe."),
        "justNow": MessageLookupByLibrary.simpleMessage("tout récemment"),
        "keepOriginal": MessageLookupByLibrary.simpleMessage(
            "Préserver l\'image originale"),
        "loadingServers":
            MessageLookupByLibrary.simpleMessage("Server Loading"),
        "local": MessageLookupByLibrary.simpleMessage("cette localité"),
        "localUpload":
            MessageLookupByLibrary.simpleMessage("téléchargement local"),
        "login": MessageLookupByLibrary.simpleMessage("s\'inscrire"),
        "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
        "loginFailed":
            MessageLookupByLibrary.simpleMessage("Échec de la connexion"),
        "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
            "Échec de la connexion : Échec de la création de l\'application"),
        "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
            "Échec de la connexion : l\'acquisition du jeton a échoué"),
        "loginLoading": m12,
        "loginSuccess":
            MessageLookupByLibrary.simpleMessage("Connexion réussie"),
        "manageAccount":
            MessageLookupByLibrary.simpleMessage("Gérer le compte"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage(
            "Marquer comme contenu sensible"),
        "mention": MessageLookupByLibrary.simpleMessage("élever (un sujet)"),
        "minute": MessageLookupByLibrary.simpleMessage("minutes"),
        "minutesAgo": m13,
        "monthsAgo": m14,
        "more": MessageLookupByLibrary.simpleMessage("plus"),
        "myCLips": MessageLookupByLibrary.simpleMessage("Mes notes."),
        "name": MessageLookupByLibrary.simpleMessage("nom (d\'une chose)"),
        "nameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Le nom ne peut être vide"),
        "next": MessageLookupByLibrary.simpleMessage("l\'étape suivante"),
        "noLists":
            MessageLookupByLibrary.simpleMessage("You don\'t have any lists"),
        "notFindServer": MessageLookupByLibrary.simpleMessage(
            "Vous n\'avez pas trouvé votre serveur ?"),
        "noteCopyLocalLink":
            MessageLookupByLibrary.simpleMessage("Copier le lien vers ce site"),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("mettre de côté"),
        "noteCwShow":
            MessageLookupByLibrary.simpleMessage("Afficher le contenu"),
        "noteFormLanguageTranslation": m15,
        "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
            "Non-participation à l\'action commune"),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
            "Accédez au serveur hôte pour afficher"),
        "notePined": MessageLookupByLibrary.simpleMessage("Top Posts"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("citation"),
        "noteReNote": MessageLookupByLibrary.simpleMessage(
            "le transfert (courrier, SMS, paquets de données)"),
        "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Transmis."),
        "noteTranslate":
            MessageLookupByLibrary.simpleMessage("Traduction des messages"),
        "noteVisibility": MessageLookupByLibrary.simpleMessage("visibilité"),
        "noteVisibilityFollowers":
            MessageLookupByLibrary.simpleMessage("observateur"),
        "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
            "Envoyer uniquement aux personnes qui suivent le site"),
        "noteVisibilityHome":
            MessageLookupByLibrary.simpleMessage("fig. début"),
        "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
            "La chronologie n\'est envoyée que sur la page d\'accueil"),
        "noteVisibilityPublic":
            MessageLookupByLibrary.simpleMessage("ouvertement"),
        "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
            "Votre message apparaîtra dans la chronologie globale"),
        "noteVisibilitySpecified":
            MessageLookupByLibrary.simpleMessage("lettre privée"),
        "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
            "Envoyer uniquement aux utilisateurs spécifiés"),
        "notes": MessageLookupByLibrary.simpleMessage("carte"),
        "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
        "notification": MessageLookupByLibrary.simpleMessage("notifications"),
        "notifications": MessageLookupByLibrary.simpleMessage("notifications"),
        "notifyAll": MessageLookupByLibrary.simpleMessage("complet"),
        "notifyFilter": MessageLookupByLibrary.simpleMessage("dépistage"),
        "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
            "Votre demande d\'attention a été approuvée."),
        "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
            "Vous avez de nouveaux adeptes."),
        "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
            "Marquer tous les textes comme lus"),
        "notifyMention":
            MessageLookupByLibrary.simpleMessage("En parlant de mon"),
        "notifyMessage": MessageLookupByLibrary.simpleMessage("lettre privée"),
        "notifyNotSupport": m16,
        "ok": MessageLookupByLibrary.simpleMessage("définir"),
        "openInNewTab": MessageLookupByLibrary.simpleMessage(
            "Aller à l\'affichage du navigateur"),
        "overviews": MessageLookupByLibrary.simpleMessage("parcourir"),
        "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
            "Inquiétudes quant à la suite donnée aux demandes"),
        "preview": MessageLookupByLibrary.simpleMessage("avant-premières"),
        "previewNote": MessageLookupByLibrary.simpleMessage(
            "Prévisualisation des messages"),
        "processing": MessageLookupByLibrary.simpleMessage("en cours"),
        "public": MessageLookupByLibrary.simpleMessage("ouvertement"),
        "publish": MessageLookupByLibrary.simpleMessage("poste"),
        "reNoteHint":
            MessageLookupByLibrary.simpleMessage("Citation de ce post..."),
        "reNoteText": MessageLookupByLibrary.simpleMessage("Citation Post"),
        "reaction": MessageLookupByLibrary.simpleMessage("réponse"),
        "reactionAccepting":
            MessageLookupByLibrary.simpleMessage("Accepter les réponses Emoji"),
        "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("complet"),
        "reactionAcceptingLikeOnly":
            MessageLookupByLibrary.simpleMessage("Aime seulement"),
        "reactionAcceptingLikeOnlyRemote":
            MessageLookupByLibrary.simpleMessage("Kudos à distance uniquement"),
        "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
            "Contenu non sensible uniquement"),
        "reactionAcceptingNoneSensitiveOrLocal":
            MessageLookupByLibrary.simpleMessage(
                "Contenus non sensibles uniquement (likes à distance uniquement)"),
        "recipient":
            MessageLookupByLibrary.simpleMessage("A : (en-tête de l\'email)"),
        "refresh": MessageLookupByLibrary.simpleMessage(
            "rafraîchir (fenêtre d\'ordinateur)"),
        "registration": MessageLookupByLibrary.simpleMessage("Registration"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
        "remote": MessageLookupByLibrary.simpleMessage("à distance"),
        "rename": MessageLookupByLibrary.simpleMessage("renommer"),
        "renameFile":
            MessageLookupByLibrary.simpleMessage("Renommer le fichier"),
        "renameFolder":
            MessageLookupByLibrary.simpleMessage("Renommer un dossier"),
        "replyNoteHint":
            MessageLookupByLibrary.simpleMessage("Répondre à cet article..."),
        "replyNoteText":
            MessageLookupByLibrary.simpleMessage("Répondre à un message"),
        "saveFailed": MessageLookupByLibrary.simpleMessage("ne pas sauver"),
        "saveImage":
            MessageLookupByLibrary.simpleMessage("Enregistrer l\'image"),
        "saveSuccess":
            MessageLookupByLibrary.simpleMessage("Sauvegarder le succès"),
        "search": MessageLookupByLibrary.simpleMessage("rechercher qqch."),
        "searchAll": MessageLookupByLibrary.simpleMessage("complet"),
        "searchHost":
            MessageLookupByLibrary.simpleMessage("Indiquer le nom de domaine"),
        "searchLocal": MessageLookupByLibrary.simpleMessage("ce site"),
        "searchRemote": MessageLookupByLibrary.simpleMessage("à distance"),
        "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
        "secondsAgo": m17,
        "selectHashtag":
            MessageLookupByLibrary.simpleMessage("Sélectionner une étiquette"),
        "selectServer":
            MessageLookupByLibrary.simpleMessage("Please Select Your Server"),
        "selectUser":
            MessageLookupByLibrary.simpleMessage("Sélectionner l\'utilisateur"),
        "sensitiveClickShow":
            MessageLookupByLibrary.simpleMessage("Cliquer pour afficher"),
        "sensitiveContent":
            MessageLookupByLibrary.simpleMessage("Contenu sensible"),
        "serverAddr":
            MessageLookupByLibrary.simpleMessage("adresse du serveur"),
        "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
        "settings": MessageLookupByLibrary.simpleMessage("mettre en place"),
        "share": MessageLookupByLibrary.simpleMessage(
            "partager (joies, avantages, privilèges, etc.) avec les autres"),
        "showConversation":
            MessageLookupByLibrary.simpleMessage("Voir le dialogue"),
        "somebodyNote": MessageLookupByLibrary.simpleMessage(" postes"),
        "timeline": MessageLookupByLibrary.simpleMessage("calendrier"),
        "timelineGlobal": MessageLookupByLibrary.simpleMessage(
            "situation en matière de sécurité"),
        "timelineHome": MessageLookupByLibrary.simpleMessage("fig. début"),
        "timelineHybrid": MessageLookupByLibrary.simpleMessage("socialisation"),
        "timelineLocal": MessageLookupByLibrary.simpleMessage("cette localité"),
        "translate": MessageLookupByLibrary.simpleMessage("l\'équarrissage"),
        "uncategorized": MessageLookupByLibrary.simpleMessage("Sans catégorie"),
        "unfollow": MessageLookupByLibrary.simpleMessage("Non suivi"),
        "updatedDate":
            MessageLookupByLibrary.simpleMessage("Date de mise à jour"),
        "uploadFailed": m18,
        "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
            "Téléchargement à partir du site web"),
        "user": MessageLookupByLibrary.simpleMessage("utilisateur"),
        "userAll": MessageLookupByLibrary.simpleMessage("complet"),
        "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
            "Cet utilisateur ne s\'est pas encore présenté"),
        "userFile":
            MessageLookupByLibrary.simpleMessage("pièce jointe (email)"),
        "userHot": MessageLookupByLibrary.simpleMessage("utilisateur"),
        "userNote": MessageLookupByLibrary.simpleMessage("carte"),
        "userRegisterBy": MessageLookupByLibrary.simpleMessage("enregistré en"),
        "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
            "Liste des widgets (inachevée)"),
        "username":
            MessageLookupByLibrary.simpleMessage("ID de l\'utilisateur"),
        "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
        "video": MessageLookupByLibrary.simpleMessage("vidéo"),
        "view": MessageLookupByLibrary.simpleMessage("vérifier"),
        "viewMore": MessageLookupByLibrary.simpleMessage("Voir plus"),
        "vote": MessageLookupByLibrary.simpleMessage("référendum"),
        "voteAllCount": m19,
        "voteCount": m20,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("date limite"),
        "voteEnableMultiChoice":
            MessageLookupByLibrary.simpleMessage("Votes multiples autorisés"),
        "voteExpired":
            MessageLookupByLibrary.simpleMessage("Le vote est clos."),
        "voteNoDueDate": MessageLookupByLibrary.simpleMessage("en permanence"),
        "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
            "Le nombre de voix ne peut être inférieur à deux"),
        "voteOptionHint": m21,
        "voteOptionNullIndex": m22,
        "voteResult": MessageLookupByLibrary.simpleMessage(
            "Les résultats du vote ont été générés"),
        "voteWillExpired": m23,
        "yearsAgo": m24
      };
}
