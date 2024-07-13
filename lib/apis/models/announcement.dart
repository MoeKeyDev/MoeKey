import 'dart:convert';

///Announcement
class Announcement {
  double? closeDuration;
  DateTime createdAt;
  AnnouncementDisplay display;
  double? displayOrder;
  bool forYou;
  AnnouncementIcon icon;
  String id;
  String? imageUrl;
  bool isRead;
  bool needConfirmationToRead;
  bool silence;
  String text;
  String title;
  DateTime? updatedAt;

  Announcement({
    required this.closeDuration,
    required this.createdAt,
    required this.display,
    required this.displayOrder,
    required this.forYou,
    required this.icon,
    required this.id,
    required this.imageUrl,
    required this.isRead,
    required this.needConfirmationToRead,
    required this.silence,
    required this.text,
    required this.title,
    required this.updatedAt,
  });

  Announcement copyWith({
    double? closeDuration,
    DateTime? createdAt,
    AnnouncementDisplay? display,
    double? displayOrder,
    bool? forYou,
    AnnouncementIcon? icon,
    String? id,
    String? imageUrl,
    bool? isRead,
    bool? needConfirmationToRead,
    bool? silence,
    String? text,
    String? title,
    DateTime? updatedAt,
  }) =>
      Announcement(
        closeDuration: closeDuration ?? this.closeDuration,
        createdAt: createdAt ?? this.createdAt,
        display: display ?? this.display,
        displayOrder: displayOrder ?? this.displayOrder,
        forYou: forYou ?? this.forYou,
        icon: icon ?? this.icon,
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        isRead: isRead ?? this.isRead,
        needConfirmationToRead:
            needConfirmationToRead ?? this.needConfirmationToRead,
        silence: silence ?? this.silence,
        text: text ?? this.text,
        title: title ?? this.title,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Announcement.fromJson(String str) =>
      Announcement.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Announcement.fromMap(Map<String, dynamic> json) => Announcement(
        closeDuration: json["closeDuration"]?.toDouble(),
        createdAt: DateTime.parse(json["createdAt"]),
        display: displayValues.map[json["display"]]!,
        displayOrder: json["displayOrder"]?.toDouble(),
        forYou: json["forYou"],
        icon: iconValues.map[json["icon"]]!,
        id: json["id"],
        imageUrl: json["imageUrl"],
        isRead: json["isRead"] ?? false,
        needConfirmationToRead: json["needConfirmationToRead"],
        silence: json["silence"],
        text: json["text"],
        title: json["title"],
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "closeDuration": closeDuration,
        "createdAt": createdAt.toIso8601String(),
        "display": displayValues.reverse[display],
        "displayOrder": displayOrder,
        "forYou": forYou,
        "icon": iconValues.reverse[icon],
        "id": id,
        "imageUrl": imageUrl,
        "isRead": isRead,
        "needConfirmationToRead": needConfirmationToRead,
        "silence": silence,
        "text": text,
        "title": title,
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

enum AnnouncementDisplay { BANNER, DIALOG, NORMAL }

final displayValues = EnumValues({
  "banner": AnnouncementDisplay.BANNER,
  "dialog": AnnouncementDisplay.DIALOG,
  "normal": AnnouncementDisplay.NORMAL
});

enum AnnouncementIcon { ERROR, INFO, SUCCESS, WARNING }

final iconValues = EnumValues({
  "error": AnnouncementIcon.ERROR,
  "info": AnnouncementIcon.INFO,
  "success": AnnouncementIcon.SUCCESS,
  "warning": AnnouncementIcon.WARNING
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
