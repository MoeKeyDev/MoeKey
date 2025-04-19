// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a tr_TR locale. All the
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
  String get localeName => 'tr_TR';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Belirle ( / )";

  static String m1(error) => "\n\n ${error}Yaratılış Başarısız";

  static String m2(days) => "${days}günler önce";

  static String m3(thing) => "${thing}\" \" silmek ister misiniz?";

  static String m4(name) =>
      "${name}\" \" dosyasını silmek ister misiniz? Bu dosyanın ekli olduğu gönderiler de silinecektir.";

  static String m5(name) =>
      "${name}\" \" klasörünü silmek mi istiyorsunuz? Klasörde içerik varsa, lütfen önce klasörün içeriğini silin.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Gün saat dakika saniye";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Saat Dakika Saniye";

  static String m8(minute, second) => "${minute}${second}Dakika saniye";

  static String m9(second) =>
      "${second}bir derecenin altmışta birine eşdeğer açı veya yay birimi";

  static String m10(error) => "\n\n${error}Gönderi gönderilemedi";

  static String m11(hours) => "${hours}saatler önce";

  static String m12(server) => "${server}Şu anda oturum açmış durumda";

  static String m13(minutes) => "${minutes}dakikalar önce";

  static String m14(months) => "${months}aylar önce";

  static String m15(language) => "${language}Ş \nuradan şuraya çevir";

  static String m16(type) => "${type}Desteklenmeyen bildirim türleri:";

  static String m17(seconds) => "${seconds}saniye önce";

  static String m18(msg) => "\n ${msg}Yükleme başarısız";

  static String m19(count) => "${count}Toplam oy sayısı";

  static String m20(count) => "${count}fidye için tutulan kişi";

  static String m21(index) => "${index}Seçenekler";

  static String m22(index) => "${index}Seçenek boş olamaz";

  static String m23(datetime) => "${datetime}kapanış sonrası tarih";

  static String m24(years) => "${years}yıllar önce";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("kullanıcı adı"),
    "add": MessageLookupByLibrary.simpleMessage("artış"),
    "addAccount": MessageLookupByLibrary.simpleMessage("Hesap Ekle"),
    "addFile": MessageLookupByLibrary.simpleMessage("Dosya ekle"),
    "addTitle": MessageLookupByLibrary.simpleMessage("Başlık Ekle"),
    "all": MessageLookupByLibrary.simpleMessage("Tam"),
    "announcementActive": MessageLookupByLibrary.simpleMessage("Duyuru şimdi"),
    "announcementExpired": MessageLookupByLibrary.simpleMessage(
      "Geçmiş Duyurular",
    ),
    "announcements": MessageLookupByLibrary.simpleMessage("BÜLTEN"),
    "back": MessageLookupByLibrary.simpleMessage("geri gel (veya git)"),
    "cancel": MessageLookupByLibrary.simpleMessage("İPTALLER"),
    "cancelSensitive": MessageLookupByLibrary.simpleMessage(
      "Hassas içeriğin etiketini kaldırın",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clip": MessageLookupByLibrary.simpleMessage("memo"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "Koleksiyonu iptal etmek istediğinizden emin misiniz?",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage("Yeni Yapışkan Notlar"),
    "clipFavorite": MessageLookupByLibrary.simpleMessage("Favorilere ekle"),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage(
      "yer imi (İnternet)",
    ),
    "clipRemove": MessageLookupByLibrary.simpleMessage(
      "Yapışkan Notları Kaldırma",
    ),
    "clipUpdate": MessageLookupByLibrary.simpleMessage(
      "Yapışkan Notları Güncelleyin",
    ),
    "clips": MessageLookupByLibrary.simpleMessage("memo"),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage("İçeriği kopyala"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Bağlantıyı kopyala"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("RSS Kopyala"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "Kullanıcının ana sayfasının adresini kopyalayın",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage(
      "Kullanıcı Adını Kopyala",
    ),
    "createFolder": MessageLookupByLibrary.simpleMessage("Yeni Klasör"),
    "createNote": MessageLookupByLibrary.simpleMessage("Yeni bir başlık açın"),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
      "Bir dosyadan gönderi oluşturma",
    ),
    "createNoteHint": MessageLookupByLibrary.simpleMessage("Ne oldu?"),
    "createdDate": MessageLookupByLibrary.simpleMessage("Oluşturulma tarihi"),
    "creationFailedDialog": m1,
    "cw": MessageLookupByLibrary.simpleMessage("GİZLİ İÇERİK"),
    "day": MessageLookupByLibrary.simpleMessage("gökyüzü"),
    "daysAgo": m2,
    "delete": MessageLookupByLibrary.simpleMessage("Kaldırma"),
    "deleteConfirm": m3,
    "deleteFileConfirmation": m4,
    "deleteFolderConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("AÇIKLAMALAR"),
    "done": MessageLookupByLibrary.simpleMessage("yerine getirmek"),
    "download": MessageLookupByLibrary.simpleMessage("indiriliyor"),
    "drive": MessageLookupByLibrary.simpleMessage("bulut dosya depolama"),
    "durationDay": m6,
    "durationHour": m7,
    "durationMinute": m8,
    "durationSecond": m9,
    "edit": MessageLookupByLibrary.simpleMessage("derleyici"),
    "emoji": MessageLookupByLibrary.simpleMessage("İfade"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "Lütfen yeni bir dosya adı girin",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage(
      "Lütfen yeni bir başlık girin",
    ),
    "enterUrl": MessageLookupByLibrary.simpleMessage("Lütfen URL\'yi girin"),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "İçerik boş olamaz",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
      "İçerik boş olamaz",
    ),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("keşifler"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("moda"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage("popüler kullanıcı"),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage(
      "Son giriş yapan kullanıcılar",
    ),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage(
      "listenin en üstündeki kullanıcı",
    ),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
      "Son Katkıda Bulunanlar",
    ),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("kullanıcı"),
    "favorite": MessageLookupByLibrary.simpleMessage("yer imi (İnternet)"),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "folderName": MessageLookupByLibrary.simpleMessage("Klasör adı"),
    "follow": MessageLookupByLibrary.simpleMessage("odaklanma"),
    "followed": MessageLookupByLibrary.simpleMessage("Takip edildi"),
    "followers": MessageLookupByLibrary.simpleMessage("gözlemci"),
    "following": MessageLookupByLibrary.simpleMessage("Endişeli"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("Netbook\'tan"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
    "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
    "hostnames": MessageLookupByLibrary.simpleMessage("alan adı"),
    "hour": MessageLookupByLibrary.simpleMessage("saat"),
    "hoursAgo": m11,
    "image": MessageLookupByLibrary.simpleMessage("Fotoğraf"),
    "inputServer": MessageLookupByLibrary.simpleMessage(
      "Manuel giriş sunucusu",
    ),
    "insertDriverFile": MessageLookupByLibrary.simpleMessage(
      "Aksesuarların yerleştirilmesi",
    ),
    "isFollowingYouNow": MessageLookupByLibrary.simpleMessage(
      "Seni izliyorum.",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("yakın zamanda"),
    "keepOriginal": MessageLookupByLibrary.simpleMessage(
      "Orijinal görüntüyü koruyun",
    ),
    "loadingServers": MessageLookupByLibrary.simpleMessage("Server Loading"),
    "local": MessageLookupByLibrary.simpleMessage("bu bölge"),
    "localUpload": MessageLookupByLibrary.simpleMessage("yerel yükleme"),
    "login": MessageLookupByLibrary.simpleMessage("oturum aç"),
    "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Giriş Hatası"),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "Oturum Açma Başarısız: Uygulama Oluşturma Başarısız",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "Oturum açma başarısız oldu: belirteç edinme başarısız oldu",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage("Giriş Başarılı"),
    "manageAccount": MessageLookupByLibrary.simpleMessage("Hesabı Yönet"),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage(
      "Hassas içerik olarak işaretle",
    ),
    "mention": MessageLookupByLibrary.simpleMessage("yükseltmek (bir konu)"),
    "minute": MessageLookupByLibrary.simpleMessage("dakika"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("daha fazla"),
    "myCLips": MessageLookupByLibrary.simpleMessage("Benim notum."),
    "name": MessageLookupByLibrary.simpleMessage("isim (bir şeyin)"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "İsim boş olamaz",
    ),
    "next": MessageLookupByLibrary.simpleMessage("bir sonraki adım"),
    "noLists": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any lists",
    ),
    "notFindServer": MessageLookupByLibrary.simpleMessage(
      "Sunucunuzu bulamadınız mı?",
    ),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "Bu sitenin bağlantısını kopyalayın",
    ),
    "noteCwHide": MessageLookupByLibrary.simpleMessage("bir kenara koy"),
    "noteCwShow": MessageLookupByLibrary.simpleMessage("İçeriği görüntüle"),
    "noteFormLanguageTranslation": m15,
    "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
      "Ortak çalışmalara katılmama",
    ),
    "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
      "Görüntülemek için ana sunucuya gidin",
    ),
    "notePined": MessageLookupByLibrary.simpleMessage("En İyi Mesajlar"),
    "noteQuote": MessageLookupByLibrary.simpleMessage("alıntı"),
    "noteReNote": MessageLookupByLibrary.simpleMessage(
      "yönlendirme (posta, SMS, veri paketleri)",
    ),
    "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("İletildi."),
    "noteTranslate": MessageLookupByLibrary.simpleMessage(
      "Gönderilerin çevirisi",
    ),
    "noteVisibility": MessageLookupByLibrary.simpleMessage("görünürlük"),
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage("gözlemci"),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "Yalnızca takipçilere gönder",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage(
      "şekil. başlangıç",
    ),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "Zaman çizelgesi yalnızca ana sayfaya gönderilir",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("Açıkça"),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "Gönderiniz küresel zaman akışında görünecektir",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
      "ÖZEL MEKTUP",
    ),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "Yalnızca belirtilen kullanıcılara gönder",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("kart"),
    "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
    "notification": MessageLookupByLibrary.simpleMessage("BİLDİRİMLER"),
    "notifications": MessageLookupByLibrary.simpleMessage("BİLDİRİMLER"),
    "notifyAll": MessageLookupByLibrary.simpleMessage("Tam"),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("tarama"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "İlgi talebiniz onaylanmıştır.",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
      "Yeni takipçileriniz var.",
    ),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
      "Hepsini okundu olarak işaretle",
    ),
    "notifyMention": MessageLookupByLibrary.simpleMessage(
      "Benimkinden bahsetmişken",
    ),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("ÖZEL MEKTUP"),
    "notifyNotSupport": m16,
    "ok": MessageLookupByLibrary.simpleMessage("tanımlamak"),
    "openInNewTab": MessageLookupByLibrary.simpleMessage(
      "Tarayıcı Ekranına Git",
    ),
    "overviews": MessageLookupByLibrary.simpleMessage("gözden geçirin"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "Taleplerin kabul edilmesine ilişkin endişeler",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("önizlemeler"),
    "previewNote": MessageLookupByLibrary.simpleMessage("Önizleme Gönderileri"),
    "processing": MessageLookupByLibrary.simpleMessage("devam ediyor"),
    "public": MessageLookupByLibrary.simpleMessage("Açıkça"),
    "publish": MessageLookupByLibrary.simpleMessage("POST"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage(
      "Bu yazıdan alıntı yapıyorum.",
    ),
    "reNoteText": MessageLookupByLibrary.simpleMessage("Alıntı Mesaj"),
    "reaction": MessageLookupByLibrary.simpleMessage("yanıt"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage(
      "Emoji Yanıtlarını Kabul Etme",
    ),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("Tam"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
      "Sadece seviyor",
    ),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "Sadece Uzaktan Kudos",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "Yalnızca hassas olmayan içerik",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage(
          "Yalnızca hassas olmayan içerik (yalnızca uzaktan beğeniler)",
        ),
    "recipient": MessageLookupByLibrary.simpleMessage(
      "Kime: (e-posta başlığı)",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage(
      "yenileme (bilgisayar penceresi)",
    ),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
    "remote": MessageLookupByLibrary.simpleMessage("uzaktan"),
    "rename": MessageLookupByLibrary.simpleMessage("yeniden adlandır"),
    "renameFile": MessageLookupByLibrary.simpleMessage(
      "Dosyayı yeniden adlandır",
    ),
    "renameFolder": MessageLookupByLibrary.simpleMessage(
      "Bir klasörü yeniden adlandırın",
    ),
    "replyNoteHint": MessageLookupByLibrary.simpleMessage(
      "Bu gönderiye cevap ver...",
    ),
    "replyNoteText": MessageLookupByLibrary.simpleMessage(
      "Bir gönderiye yanıt ver",
    ),
    "saveFailed": MessageLookupByLibrary.simpleMessage(
      "kurtarmak için başarısız",
    ),
    "saveImage": MessageLookupByLibrary.simpleMessage("Resmi Kaydet"),
    "saveSuccess": MessageLookupByLibrary.simpleMessage("Başarılı Kaydet"),
    "search": MessageLookupByLibrary.simpleMessage("bir şey aramak."),
    "searchAll": MessageLookupByLibrary.simpleMessage("Tam"),
    "searchHost": MessageLookupByLibrary.simpleMessage("Alan adını belirtin"),
    "searchLocal": MessageLookupByLibrary.simpleMessage("bu site"),
    "searchRemote": MessageLookupByLibrary.simpleMessage("mesafe"),
    "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
    "secondsAgo": m17,
    "selectHashtag": MessageLookupByLibrary.simpleMessage("Etiket Seçin"),
    "selectServer": MessageLookupByLibrary.simpleMessage(
      "Please Select Your Server",
    ),
    "selectUser": MessageLookupByLibrary.simpleMessage("Kullanıcı Seçin"),
    "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
      "Göstermek için tıklayın",
    ),
    "sensitiveContent": MessageLookupByLibrary.simpleMessage("Hassas içerik"),
    "serverAddr": MessageLookupByLibrary.simpleMessage("sunucu adresi"),
    "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
    "settings": MessageLookupByLibrary.simpleMessage("kurmak"),
    "share": MessageLookupByLibrary.simpleMessage(
      "(sevinçleri, faydaları, ayrıcalıkları vb.) başkalarıyla paylaşmak",
    ),
    "showConversation": MessageLookupByLibrary.simpleMessage(
      "Diyaloğu görüntüle",
    ),
    "somebodyNote": MessageLookupByLibrary.simpleMessage(" gönderiler"),
    "timeline": MessageLookupByLibrary.simpleMessage("zaman çizelgesi"),
    "timelineGlobal": MessageLookupByLibrary.simpleMessage("güvenlik durumu"),
    "timelineHome": MessageLookupByLibrary.simpleMessage("şekil. başlangıç"),
    "timelineHybrid": MessageLookupByLibrary.simpleMessage("sosyalleşme"),
    "timelineLocal": MessageLookupByLibrary.simpleMessage("bu bölge"),
    "translate": MessageLookupByLibrary.simpleMessage("işleme"),
    "uncategorized": MessageLookupByLibrary.simpleMessage(
      "Kategorize edilmemiş",
    ),
    "unfollow": MessageLookupByLibrary.simpleMessage("Takibi bırak"),
    "updatedDate": MessageLookupByLibrary.simpleMessage("Güncelleme Tarihi"),
    "uploadFailed": m18,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
      "Web sitesinden yükleme",
    ),
    "user": MessageLookupByLibrary.simpleMessage("kullanıcı"),
    "userAll": MessageLookupByLibrary.simpleMessage("Tam"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
      "Bu kullanıcı henüz kendini tanıtmadı",
    ),
    "userFile": MessageLookupByLibrary.simpleMessage("ek (e-posta)"),
    "userHot": MessageLookupByLibrary.simpleMessage("kullanıcı"),
    "userNote": MessageLookupByLibrary.simpleMessage("kart"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage("kayıtlı"),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "Widget listesi (tamamlanmamış)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("kullanıcı kimliği"),
    "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
    "video": MessageLookupByLibrary.simpleMessage("Video"),
    "view": MessageLookupByLibrary.simpleMessage("kontrol et"),
    "viewMore": MessageLookupByLibrary.simpleMessage("Daha Fazla Görüntüle"),
    "vote": MessageLookupByLibrary.simpleMessage("referandum"),
    "voteAllCount": m19,
    "voteCount": m20,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("kesme tarihi"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
      "Birden fazla oya izin verilir",
    ),
    "voteExpired": MessageLookupByLibrary.simpleMessage(
      "Oylama sona ermiştir.",
    ),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("kalıcı olarak"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "Oy sayısı ikiden az olamaz",
    ),
    "voteOptionHint": m21,
    "voteOptionNullIndex": m22,
    "voteResult": MessageLookupByLibrary.simpleMessage(
      "Oylama sonuçları oluşturuldu",
    ),
    "voteWillExpired": m23,
    "yearsAgo": m24,
  };
}
