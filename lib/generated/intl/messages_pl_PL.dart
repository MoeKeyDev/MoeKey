// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pl_PL locale. All the
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
  String get localeName => 'pl_PL';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Określić ( / )";

  static String m1(error) => "Tworzenie nie powiodło się\n\n ${error}";

  static String m2(days) => "${days}dni temu";

  static String m3(thing) => "${thing}Chcesz usunąć \" \"?";

  static String m4(name) =>
      "${name}Chcesz usunąć plik \" \"? Posty z załączonym plikiem również zostaną usunięte.";

  static String m5(name) =>
      "${name}Chcesz usunąć folder \" \"? Jeśli w folderze znajduje się zawartość, najpierw usuń zawartość folderu.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Dni godziny minuty sekundy";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Godziny Minuty Sekundy";

  static String m8(minute, second) => "${minute}${second}Minuty sekundy";

  static String m9(second) =>
      "${second}jednostka kąta lub łuku odpowiadająca jednej sześćdziesiątej stopnia";

  static String m10(error) => "Wysłanie posta nie powiodło się\n\n${error}";

  static String m11(hours) => "${hours}godzin temu";

  static String m12(server) => "${server}Aktualnie zalogowany";

  static String m13(minutes) => "${minutes}minut temu";

  static String m14(months) => "${months}miesięcy temu";

  static String m15(language) => "Przetłumaczono z języka ${language} \n";

  static String m16(type) => "${type}Nieobsługiwane typy powiadomień:";

  static String m17(seconds) => "${seconds}sekund temu";

  static String m18(msg) => "Przesłanie nie powiodło się\n ${msg}";

  static String m19(count) => "${count}Łączna liczba głosów";

  static String m20(count) => "${count}osoba przetrzymywana dla okupu";

  static String m21(index) => "${index}Opcje";

  static String m22(index) => "${index}Opcja nie może być pusta";

  static String m23(datetime) => "${datetime}termin zakończenia";

  static String m24(years) => "${years}...lat temu";

  final messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("nazwa użytkownika"),
        "add": MessageLookupByLibrary.simpleMessage("wzrost"),
        "addAccount": MessageLookupByLibrary.simpleMessage("Dodaj konto"),
        "addFile": MessageLookupByLibrary.simpleMessage("Dodaj plik"),
        "addTitle": MessageLookupByLibrary.simpleMessage("Dodaj tytuł"),
        "all": MessageLookupByLibrary.simpleMessage("pełny"),
        "announcementActive": MessageLookupByLibrary.simpleMessage(
          "Ogłoszenie teraz",
        ),
        "announcementExpired": MessageLookupByLibrary.simpleMessage(
          "Poprzednie ogłoszenia",
        ),
        "announcements": MessageLookupByLibrary.simpleMessage("biuletyn"),
        "back": MessageLookupByLibrary.simpleMessage("wrócić (lub wrócić)"),
        "cancel": MessageLookupByLibrary.simpleMessage("odwołania"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage(
          "Nie oflaguj wrażliwych treści",
        ),
        "clear": MessageLookupByLibrary.simpleMessage("Clear"),
        "clip": MessageLookupByLibrary.simpleMessage("notatka"),
        "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
          "Na pewno chcesz anulować kolekcję?",
        ),
        "clipCreate": MessageLookupByLibrary.simpleMessage(
          "Nowe karteczki samoprzylepne",
        ),
        "clipFavorite":
            MessageLookupByLibrary.simpleMessage("Dodaj do ulubionych"),
        "clipFavoriteList": MessageLookupByLibrary.simpleMessage(
          "zakładka (Internet)",
        ),
        "clipRemove": MessageLookupByLibrary.simpleMessage(
          "Usuwanie karteczek samoprzylepnych",
        ),
        "clipUpdate": MessageLookupByLibrary.simpleMessage(
          "Aktualizacja karteczek samoprzylepnych",
        ),
        "clips": MessageLookupByLibrary.simpleMessage("notatka"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "confirmSelection": m0,
        "copyContent": MessageLookupByLibrary.simpleMessage(
          "Kopiowanie zawartości",
        ),
        "copyLink": MessageLookupByLibrary.simpleMessage("Kopiuj link"),
        "copyRSS": MessageLookupByLibrary.simpleMessage("Kopiowanie RSS"),
        "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
          "Skopiuj adres strony głównej użytkownika",
        ),
        "copyUsername": MessageLookupByLibrary.simpleMessage(
          "Kopiuj nazwę użytkownika",
        ),
        "createFolder": MessageLookupByLibrary.simpleMessage("Nowy folder"),
        "createNote":
            MessageLookupByLibrary.simpleMessage("Opublikuj nowy wątek"),
        "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
          "Tworzenie wpisu z pliku",
        ),
        "createNoteHint":
            MessageLookupByLibrary.simpleMessage("Co się stało..."),
        "createdDate": MessageLookupByLibrary.simpleMessage("Data utworzenia"),
        "creationFailedDialog": m1,
        "cw": MessageLookupByLibrary.simpleMessage("ukryta zawartość"),
        "day": MessageLookupByLibrary.simpleMessage("niebo"),
        "daysAgo": m2,
        "delete": MessageLookupByLibrary.simpleMessage("usunięcie"),
        "deleteConfirm": m3,
        "deleteFileConfirmation": m4,
        "deleteFolderConfirmation": m5,
        "description": MessageLookupByLibrary.simpleMessage("opisy"),
        "done": MessageLookupByLibrary.simpleMessage("spełnienie"),
        "download": MessageLookupByLibrary.simpleMessage("pobieranie"),
        "drive": MessageLookupByLibrary.simpleMessage(
          "Przechowywanie plików w chmurze",
        ),
        "durationDay": m6,
        "durationHour": m7,
        "durationMinute": m8,
        "durationSecond": m9,
        "edit": MessageLookupByLibrary.simpleMessage("kompilator"),
        "emoji": MessageLookupByLibrary.simpleMessage("emotikon"),
        "enterNewFileName": MessageLookupByLibrary.simpleMessage(
          "Wprowadź nową nazwę pliku",
        ),
        "enterNewTitle": MessageLookupByLibrary.simpleMessage(
          "Wprowadź nowy tytuł",
        ),
        "enterUrl": MessageLookupByLibrary.simpleMessage("Wprowadź adres URL"),
        "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
          "Zawartość nie może być pusta",
        ),
        "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
          "Zawartość nie może być pusta",
        ),
        "exceptionSendNote": m10,
        "explore": MessageLookupByLibrary.simpleMessage("odkrycia"),
        "exploreHot": MessageLookupByLibrary.simpleMessage("w modzie"),
        "exploreUserHot": MessageLookupByLibrary.simpleMessage(
          "popularny użytkownik",
        ),
        "exploreUserLast": MessageLookupByLibrary.simpleMessage(
          "Ostatnio zalogowani użytkownicy",
        ),
        "exploreUserPined": MessageLookupByLibrary.simpleMessage(
          "użytkownik na szczycie listy",
        ),
        "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
          "Ostatni współpracownicy",
        ),
        "exploreUsers": MessageLookupByLibrary.simpleMessage("użytkownik"),
        "favorite": MessageLookupByLibrary.simpleMessage("zakładka (Internet)"),
        "filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "folderName": MessageLookupByLibrary.simpleMessage("Nazwa folderu"),
        "follow": MessageLookupByLibrary.simpleMessage("ostrość"),
        "followed": MessageLookupByLibrary.simpleMessage("Śledzony"),
        "followers": MessageLookupByLibrary.simpleMessage("obserwator"),
        "following": MessageLookupByLibrary.simpleMessage("Zaniepokojony"),
        "fromCloud": MessageLookupByLibrary.simpleMessage("Z netbooka"),
        "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
        "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
        "hostnames": MessageLookupByLibrary.simpleMessage("nazwa domeny"),
        "hour": MessageLookupByLibrary.simpleMessage("godziny"),
        "hoursAgo": m11,
        "image": MessageLookupByLibrary.simpleMessage("zdjęcie"),
        "inputServer": MessageLookupByLibrary.simpleMessage(
          "Serwer ręcznego wprowadzania danych",
        ),
        "insertDriverFile": MessageLookupByLibrary.simpleMessage(
          "Wkładanie akcesoriów",
        ),
        "isFollowingYouNow":
            MessageLookupByLibrary.simpleMessage("Obserwuję cię."),
        "justNow": MessageLookupByLibrary.simpleMessage("刚刚"),
        "keepOriginal": MessageLookupByLibrary.simpleMessage(
          "Zachowanie oryginalnego obrazu",
        ),
        "loadingServers":
            MessageLookupByLibrary.simpleMessage("Server Loading"),
        "local": MessageLookupByLibrary.simpleMessage("ta miejscowość"),
        "localUpload":
            MessageLookupByLibrary.simpleMessage("lokalne przesyłanie"),
        "login": MessageLookupByLibrary.simpleMessage("zaloguj się"),
        "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("Błąd logowania"),
        "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
          "Logowanie nie powiodło się: Tworzenie aplikacji nie powiodło się",
        ),
        "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
          "Logowanie nie powiodło się: pozyskanie tokena nie powiodło się",
        ),
        "loginLoading": m12,
        "loginSuccess": MessageLookupByLibrary.simpleMessage(
          "Logowanie powiodło się",
        ),
        "manageAccount":
            MessageLookupByLibrary.simpleMessage("Zarządzaj kontem"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage(
          "Oznacz jako zawartość wrażliwą",
        ),
        "mention": MessageLookupByLibrary.simpleMessage("podnieść (temat)"),
        "minute": MessageLookupByLibrary.simpleMessage("minuty"),
        "minutesAgo": m13,
        "monthsAgo": m14,
        "more": MessageLookupByLibrary.simpleMessage("więcej"),
        "myCLips": MessageLookupByLibrary.simpleMessage("Moje notatki."),
        "name": MessageLookupByLibrary.simpleMessage("nazwa (rzeczy)"),
        "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
          "Nazwa nie może być pusta",
        ),
        "next": MessageLookupByLibrary.simpleMessage("następny krok"),
        "noLists": MessageLookupByLibrary.simpleMessage(
          "You don\'t have any lists",
        ),
        "notFindServer": MessageLookupByLibrary.simpleMessage(
          "Nie znalazłeś swojego serwera?",
        ),
        "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
          "Skopiuj link do tej strony",
        ),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("odłożony"),
        "noteCwShow":
            MessageLookupByLibrary.simpleMessage("Wyświetlana zawartość"),
        "noteFormLanguageTranslation": m15,
        "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
          "Nieuczestniczenie we wspólnym",
        ),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
          "Przejdź do serwera hosta, aby wyświetlić",
        ),
        "notePined": MessageLookupByLibrary.simpleMessage("Najlepsze posty"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("cytat"),
        "noteReNote": MessageLookupByLibrary.simpleMessage(
          "przekazywanie (poczta, SMS, pakiety danych)",
        ),
        "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Przekazane."),
        "noteTranslate":
            MessageLookupByLibrary.simpleMessage("Tłumaczenie postów"),
        "noteVisibility": MessageLookupByLibrary.simpleMessage("widoczność"),
        "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage(
          "obserwator",
        ),
        "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
          "Wyślij tylko do obserwujących",
        ),
        "noteVisibilityHome":
            MessageLookupByLibrary.simpleMessage("rys. początek"),
        "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
          "Oś czasu wysyłana tylko na stronę główną",
        ),
        "noteVisibilityPublic":
            MessageLookupByLibrary.simpleMessage("otwarcie"),
        "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
          "Twój post pojawi się na globalnej osi czasu",
        ),
        "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
          "list prywatny",
        ),
        "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
          "Wyślij tylko do określonych użytkowników",
        ),
        "notes": MessageLookupByLibrary.simpleMessage("karta"),
        "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
        "notification": MessageLookupByLibrary.simpleMessage("powiadomienia"),
        "notifications": MessageLookupByLibrary.simpleMessage("powiadomienia"),
        "notifyAll": MessageLookupByLibrary.simpleMessage("pełny"),
        "notifyFilter": MessageLookupByLibrary.simpleMessage("projekcja"),
        "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
          "Twoja prośba o uwagę została zatwierdzona.",
        ),
        "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
          "Masz nowych obserwujących.",
        ),
        "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
          "Oznacz wszystkie jako przeczytane",
        ),
        "notifyMention": MessageLookupByLibrary.simpleMessage("Mówiąc o moim"),
        "notifyMessage": MessageLookupByLibrary.simpleMessage("list prywatny"),
        "notifyNotSupport": m16,
        "ok": MessageLookupByLibrary.simpleMessage("definiować"),
        "openInNewTab": MessageLookupByLibrary.simpleMessage(
          "Przejdź do wyświetlania przeglądarki",
        ),
        "overviews": MessageLookupByLibrary.simpleMessage("przeglądać"),
        "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
          "Obawy dotyczące przyznawania wniosków",
        ),
        "preview": MessageLookupByLibrary.simpleMessage("zapowiedzi"),
        "previewNote": MessageLookupByLibrary.simpleMessage("Podgląd postów"),
        "processing": MessageLookupByLibrary.simpleMessage("w toku"),
        "public": MessageLookupByLibrary.simpleMessage("otwarcie"),
        "publish": MessageLookupByLibrary.simpleMessage("stanowisko"),
        "reNoteHint":
            MessageLookupByLibrary.simpleMessage("Cytując ten post..."),
        "reNoteText": MessageLookupByLibrary.simpleMessage("Cytuj post"),
        "reaction": MessageLookupByLibrary.simpleMessage("odpowiedź"),
        "reactionAccepting": MessageLookupByLibrary.simpleMessage(
          "Akceptowanie odpowiedzi emoji",
        ),
        "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("pełny"),
        "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
          "Lubi tylko",
        ),
        "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
          "Tylko zdalne Kudosy",
        ),
        "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
          "Tylko zawartość niewrażliwa",
        ),
        "reactionAcceptingNoneSensitiveOrLocal":
            MessageLookupByLibrary.simpleMessage(
          "Tylko niewrażliwa zawartość (tylko zdalne polubienia)",
        ),
        "recipient":
            MessageLookupByLibrary.simpleMessage("Do: (nagłówek e-mail)"),
        "refresh": MessageLookupByLibrary.simpleMessage(
          "odświeżanie (okno komputera)",
        ),
        "registration": MessageLookupByLibrary.simpleMessage("Registration"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
        "remote": MessageLookupByLibrary.simpleMessage("zdalnie"),
        "rename": MessageLookupByLibrary.simpleMessage("zmiana nazwy"),
        "renameFile":
            MessageLookupByLibrary.simpleMessage("Zmiana nazwy pliku"),
        "renameFolder": MessageLookupByLibrary.simpleMessage(
          "Zmiana nazwy folderu",
        ),
        "replyNoteHint": MessageLookupByLibrary.simpleMessage(
          "Odpowiedz na ten post...",
        ),
        "replyNoteText":
            MessageLookupByLibrary.simpleMessage("Odpowiedz na post"),
        "saveFailed": MessageLookupByLibrary.simpleMessage("nie zapisać"),
        "saveImage": MessageLookupByLibrary.simpleMessage("Zapisz obraz"),
        "saveSuccess": MessageLookupByLibrary.simpleMessage(
          "Skuteczne oszczędzanie",
        ),
        "search": MessageLookupByLibrary.simpleMessage("szukać czegoś"),
        "searchAll": MessageLookupByLibrary.simpleMessage("pełny"),
        "searchHost":
            MessageLookupByLibrary.simpleMessage("Określ nazwę domeny"),
        "searchLocal": MessageLookupByLibrary.simpleMessage("ta strona"),
        "searchRemote": MessageLookupByLibrary.simpleMessage("zdalnie"),
        "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
        "secondsAgo": m17,
        "selectHashtag":
            MessageLookupByLibrary.simpleMessage("Wybierz znacznik"),
        "selectServer": MessageLookupByLibrary.simpleMessage(
          "Please Select Your Server",
        ),
        "selectUser":
            MessageLookupByLibrary.simpleMessage("Wybierz użytkownika"),
        "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
          "Kliknij, aby wyświetlić",
        ),
        "sensitiveContent": MessageLookupByLibrary.simpleMessage(
          "Wrażliwa zawartość",
        ),
        "serverAddr": MessageLookupByLibrary.simpleMessage("adres serwera"),
        "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
        "settings": MessageLookupByLibrary.simpleMessage("konfiguracja"),
        "share": MessageLookupByLibrary.simpleMessage(
          "dzielić się (radościami, korzyściami, przywilejami itp.) z innymi",
        ),
        "showConversation":
            MessageLookupByLibrary.simpleMessage("Wyświetl dialog"),
        "somebodyNote": MessageLookupByLibrary.simpleMessage(" stanowiska"),
        "timeline": MessageLookupByLibrary.simpleMessage("oś czasu"),
        "timelineGlobal": MessageLookupByLibrary.simpleMessage(
          "sytuacja bezpieczeństwa",
        ),
        "timelineHome": MessageLookupByLibrary.simpleMessage("rys. początek"),
        "timelineHybrid": MessageLookupByLibrary.simpleMessage("socjalizacja"),
        "timelineLocal": MessageLookupByLibrary.simpleMessage("ta miejscowość"),
        "translate": MessageLookupByLibrary.simpleMessage("renderowanie"),
        "uncategorized": MessageLookupByLibrary.simpleMessage("Bez kategorii"),
        "unfollow": MessageLookupByLibrary.simpleMessage("Nie obserwuj"),
        "updatedDate":
            MessageLookupByLibrary.simpleMessage("Data aktualizacji"),
        "uploadFailed": m18,
        "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
          "Przesyłanie ze strony internetowej",
        ),
        "user": MessageLookupByLibrary.simpleMessage("użytkownik"),
        "userAll": MessageLookupByLibrary.simpleMessage("pełny"),
        "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
          "Ten użytkownik jeszcze się nie przedstawił",
        ),
        "userFile": MessageLookupByLibrary.simpleMessage("załącznik (e-mail)"),
        "userHot": MessageLookupByLibrary.simpleMessage("użytkownik"),
        "userNote": MessageLookupByLibrary.simpleMessage("karta"),
        "userRegisterBy":
            MessageLookupByLibrary.simpleMessage("zarejestrowany w"),
        "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
          "Lista widżetów (niedokończona)",
        ),
        "username": MessageLookupByLibrary.simpleMessage(
          "identyfikator użytkownika",
        ),
        "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
        "video": MessageLookupByLibrary.simpleMessage("wideo"),
        "view": MessageLookupByLibrary.simpleMessage("sprawdź"),
        "viewMore": MessageLookupByLibrary.simpleMessage("Zobacz więcej"),
        "vote": MessageLookupByLibrary.simpleMessage("referendum"),
        "voteAllCount": m19,
        "voteCount": m20,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("data graniczna"),
        "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
          "Dozwolone jest wielokrotne głosowanie",
        ),
        "voteExpired": MessageLookupByLibrary.simpleMessage(
          "Głosowanie zostało zamknięte.",
        ),
        "voteNoDueDate": MessageLookupByLibrary.simpleMessage("na stałe"),
        "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
          "Liczba głosów nie może być mniejsza niż dwa",
        ),
        "voteOptionHint": m21,
        "voteOptionNullIndex": m22,
        "voteResult": MessageLookupByLibrary.simpleMessage(
          "Wyniki głosowania zostały wygenerowane",
        ),
        "voteWillExpired": m23,
        "yearsAgo": m24,
      };
}
