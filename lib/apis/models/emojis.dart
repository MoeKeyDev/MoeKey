import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'emojis.freezed.dart';

part 'emojis.g.dart';

@freezed
class EmojiSimple with _$EmojiSimple {
  const factory EmojiSimple({
    required List<String> aliases,
    String? category,
    bool? isSensitive,
    bool? localOnly,
    required String name,
    List<String>? roleIdsThatCanBeUsedThisEmojiAsReaction,
    List<String>? roleIdsThatCanNotBeUsedThisEmojiAsReaction,
    required String url,
    @Default(false) bool code,
  }) = _EmojiSimple;

  factory EmojiSimple.fromJson(Map<String, dynamic> json) =>
      _$EmojiSimpleFromJson(json);
}
