import 'dart:convert';

///EmojiSimple
class EmojiSimple {
  final List<String> aliases;
  final String? category;
  final bool? isSensitive;
  final bool? localOnly;
  final String name;
  final List<String>? roleIdsThatCanBeUsedThisEmojiAsReaction;
  final List<String>? roleIdsThatCanNotBeUsedThisEmojiAsReaction;
  final String url;
  final bool code;

  EmojiSimple({
    required this.aliases,
    required this.category,
    this.isSensitive,
    this.localOnly,
    required this.name,
    this.roleIdsThatCanBeUsedThisEmojiAsReaction,
    this.roleIdsThatCanNotBeUsedThisEmojiAsReaction,
    this.code = false,
    required this.url,
  });

  EmojiSimple copyWith({
    List<String>? aliases,
    String? category,
    bool? isSensitive,
    bool? localOnly,
    String? name,
    List<String>? roleIdsThatCanBeUsedThisEmojiAsReaction,
    List<String>? roleIdsThatCanNotBeUsedThisEmojiAsReaction,
    String? url,
  }) =>
      EmojiSimple(
        aliases: aliases ?? this.aliases,
        category: category ?? this.category,
        isSensitive: isSensitive ?? this.isSensitive,
        localOnly: localOnly ?? this.localOnly,
        name: name ?? this.name,
        roleIdsThatCanBeUsedThisEmojiAsReaction:
            roleIdsThatCanBeUsedThisEmojiAsReaction ??
                this.roleIdsThatCanBeUsedThisEmojiAsReaction,
        roleIdsThatCanNotBeUsedThisEmojiAsReaction:
            roleIdsThatCanNotBeUsedThisEmojiAsReaction ??
                this.roleIdsThatCanNotBeUsedThisEmojiAsReaction,
        url: url ?? this.url,
      );

  factory EmojiSimple.fromJson(String str) =>
      EmojiSimple.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EmojiSimple.fromMap(Map<String, dynamic> json) => EmojiSimple(
        aliases: List<String>.from(json["aliases"].map((x) => x)),
        category: json["category"],
        isSensitive: json["isSensitive"],
        localOnly: json["localOnly"],
        name: json["name"],
        roleIdsThatCanBeUsedThisEmojiAsReaction:
            json["roleIdsThatCanBeUsedThisEmojiAsReaction"] == null
                ? []
                : List<String>.from(
                    json["roleIdsThatCanBeUsedThisEmojiAsReaction"]!
                        .map((x) => x)),
        roleIdsThatCanNotBeUsedThisEmojiAsReaction:
            json["roleIdsThatCanNotBeUsedThisEmojiAsReaction"] == null
                ? []
                : List<String>.from(
                    json["roleIdsThatCanNotBeUsedThisEmojiAsReaction"]!
                        .map((x) => x)),
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "aliases": List<dynamic>.from(aliases.map((x) => x)),
        "category": category,
        "isSensitive": isSensitive,
        "localOnly": localOnly,
        "name": name,
        "roleIdsThatCanBeUsedThisEmojiAsReaction":
            roleIdsThatCanBeUsedThisEmojiAsReaction == null
                ? []
                : List<dynamic>.from(
                    roleIdsThatCanBeUsedThisEmojiAsReaction!.map((x) => x)),
        "roleIdsThatCanNotBeUsedThisEmojiAsReaction":
            roleIdsThatCanNotBeUsedThisEmojiAsReaction == null
                ? []
                : List<dynamic>.from(
                    roleIdsThatCanNotBeUsedThisEmojiAsReaction!.map((x) => x)),
        "url": url,
      };
}
